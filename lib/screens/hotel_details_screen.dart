// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors_in_immutables, prefer_is_empty
import 'package:clipboard/clipboard.dart';
import 'package:custom_social_share/custom_social_share.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get_it/get_it.dart';
import 'package:sohleecelest_2301028c_pc09/models/hotel.dart';
import 'package:sohleecelest_2301028c_pc09/services/firebase_service.dart';
import 'package:sohleecelest_2301028c_pc09/services/theme_service.dart';
import 'package:url_launcher/url_launcher.dart';

class HotelDetailsScreen extends StatefulWidget {
  static String routeName = '/hotel-details';

  final String owner;

  HotelDetailsScreen({required this.owner});

  @override
  State<HotelDetailsScreen> createState() => _HotelDetailsScreenState();
}

// Define enum TtsState with constants to keep track of the state of the text to speech engine
enum TtsState {
  // Engine is currently speaking
  playing,
  // Engine is stopped
  stopped,
  // Engine is paused
  paused,
  // Engine is continued from where it was paused
  continued
}

class _HotelDetailsScreenState extends State<HotelDetailsScreen> {
  // Define hotel variable to store the hotel details fetched from Firestore
  Hotel? hotel;

  // Initialise boolean list to keep track of which sustainable practice is expanded since each sustainable practice is displayed using an ExpansionTile.
  // The index of the boolen representing whether the practice is expanded or nor corresponds to the index of the practice in sustainable practices list
  List<bool> whichPracticeExpanded = [];

  // Initialise FirebaseService object to access getHotelByOwner() function to fetch hotel details from Firestore
  final FirebaseService fbService = GetIt.instance<FirebaseService>();
  // Initialise ThemeService object to access functions determining UI styles
  final ThemeService themeService = GetIt.instance<ThemeService>();

  // Define variable to store the FlutterTts object to access text to speech functionality
  late FlutterTts flutterTts;
  // Define variables to store the current engine and rate of the text to speech engine
  String? engine;

  // The state of the text to speech engine is initially set to stopped
  TtsState ttsState = TtsState.stopped;

  // Define getters to determine the state of the text to speech engine
  // The engine is considered to be playing if the state is playing
  bool get isPlaying => ttsState == TtsState.playing;
  // The engine is considered to be stopped if the state is stopped
  bool get isStopped => ttsState == TtsState.stopped;
  // The engine is considered to be paused if the state is paused
  bool get isPaused => ttsState == TtsState.paused;
  // The engine is considered to be continued if the state is continued
  bool get isContinued => ttsState == TtsState.continued;

  // Define variable store message to share with social sharing platforms
  String message = "";

  // Function to display material banner with defined text
  void showMaterialBanner(String text) {
    ScaffoldMessenger.of(context).showMaterialBanner(MaterialBanner(
      content: Text(text,
          style: TextStyle(
            // Set font based on body font set by user/default font
            fontFamily: themeService.getCurrentBodyFont(),
            fontSize: 23,
            // Set text colour based on current theme
            color: themeService.getCurrentTheme() == 'light'
                ? Colors.black
                : Colors.white,
          )),
      // Set banner colour based on current theme
      backgroundColor: themeService.getCurrentTheme() == 'light'
          ? const Color.fromARGB(255, 255, 252, 244)
          : const Color.fromARGB(255, 140, 140, 140),
      // Dismiss button to hide the banner
      actions: [
        TextButton(
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
          },
          child: Text(
            'Dismiss',
            style: TextStyle(
              // Set font based on body font set by user/default font
              fontFamily: themeService.getCurrentBodyFont(),
              fontSize: 23,
              // Set Dismiss colour based on current theme
              color: themeService.getCurrentTheme() == 'light'
                  ? Colors.black
                  : const Color.fromARGB(255, 255, 251, 254),
            ),
          ),
        ),
      ],
    ));
  }

  // Build the location of the hotel based on which location details are available
  String buildLocation(Hotel hotel) {
    String location;
    // Check if hotel has a city in location details
    if (hotel.city != null) {
      // If hotel has a city, check if it has a state/province in location details
      if (hotel.stateProvince != null) {
        // If it has both city and state/province, use hotel location in this format: city, state/province, country
        location = "${hotel.city}, ${hotel.stateProvince}, ${hotel.country}";
      } else {
        // If hotel does not have state/province, use hotel location in this format: city, country
        location = "${hotel.city}, ${hotel.country}";
      }
    } else {
      // if hotel does not have city, check if it has a state/province in location details
      if (hotel.stateProvince != null) {
        // If it has state/province, use hotel location in this format: state/province, country
        location = "${hotel.stateProvince}, ${hotel.country}";
      } else {
        // If hotel has neither a city nor a state/province, use hotel location as just the country
        location = hotel.country;
      }
    }
    return location;
  }

  // Construct and return the description of the hotel for text to speech
  String buildDescription(Hotel hotel) {
    // Initialize a variable to store the location details of the hotel
    String? location = buildLocation(hotel);
    // Initialize an empty String to store text to be spoken for certificaions
    String certifications = "";
    // Initialize an empty list to accumulate text to be spoken for practices and their descriptions
    List<String> hotelPractices = [];
    // Initialize an empty String to store text to be spoken for practice
    String practices = "";

    // If hotel has no certifications, inform user that they have no certifications
    if (hotel.certifications.length == 0) {
      certifications = "They have no environmental certifications.";
    } else {
      // If hotel has certifications, list them out
      certifications =
          "Their certifications include${hotel.certifications.join(', ')}";
    }

    // If hotel has no sustainable practices, inform user that they have no sustainable practices
    if (hotel.practices.length == 0) {
      practices = "They have no sustainable practices.";
    } else {
      // Iterate through each practice and construct the text to be spoken for each practice
      for (int practiceIndex = 0;
          practiceIndex < hotel.practices.length;
          practiceIndex++) {
        var practice = hotel.practices[practiceIndex];

        String practiceDescription =
            "${practice.keys.first}: ${practice.values.first}";

        // Add the constructed description to the list
        hotelPractices.add(practiceDescription);
      }
      // Combine all the constructed descriptions into a single string for the text to be spoken
      practices =
          "Their sustainable practices include${hotelPractices.join('. ')}";
    }

    // Construct the text to be spoken by combining the hotel name, rating, location, certifications and practices
    return "This is ${hotel.name}, a ${hotel.rating}-star hotel located in $location. Their street address is ${hotel.address}. $certifications. $practices.";
  }

  // Crafts a text for hotel information then plays text to speech
  Future<void> speak(hotel) async {
    // Define variable store hotel description for text to speech
    String description = buildDescription(hotel);
    // Set volume to maximum
    await flutterTts.setVolume(1);
    // Set speech rate to 0.4, which is a moderate pace
    await flutterTts.setSpeechRate(0.4);
    // Set pitch to 1, which is the default pitch
    await flutterTts.setPitch(1);
    // Have the text to speech engine speak the constructed text
    await flutterTts.speak(description);
  }

  // Stops text to speech and updates the state of the text to speech engine to stopped
  Future<void> stop() async {
    var result = await flutterTts.stop();
    if (result == 1) setState(() => ttsState = TtsState.stopped);
  }

  // Pauses text to speech and updates the state of the text to speech engine to paused
  Future<void> pause() async {
    var result = await flutterTts.pause();
    if (result == 1) setState(() => ttsState = TtsState.paused);
  }

  // Initialises the text to speech engine and sets handlers for its various states
  dynamic initTts() {
    // Initialise FlutterTts object
    flutterTts = FlutterTts();

    // Update state of text to speech engine to playing when engine starts speaking
    flutterTts.setStartHandler(() {
      setState(() {
        ttsState = TtsState.playing;
      });
    });

    // Update state of text to speech engine to stopped when engine stops speaking
    flutterTts.setCompletionHandler(() {
      setState(() {
        ttsState = TtsState.stopped;
      });
    });

    // Update state of text to speech engine to stopped when engine is cancelled
    flutterTts.setCancelHandler(() {
      setState(() {
        ttsState = TtsState.stopped;
      });
    });

    // Update state of text to speech engine to paused when engine is paused
    flutterTts.setPauseHandler(() {
      setState(() {
        ttsState = TtsState.paused;
      });
    });

    // Update state of text to speech engine to continued when engine is continued
    flutterTts.setContinueHandler(() {
      setState(() {
        ttsState = TtsState.continued;
      });
    });

    // Update state of text to speech engine to stopped when an error occurs
    // Stop the text to speech engine if an error occurs and notify the user using a material banner
    flutterTts.setErrorHandler((msg) {
      setState(() {
        if (msg == "interrupted") {
          ttsState = TtsState.stopped;
        } else {
          ttsState = TtsState.stopped;
          showMaterialBanner(
              "An error occurred with the text to speech engine. Sorry : (");
        }
      });
    });
  }

  // Construct and return a message to be shared with social sharing platforms of the hotel summary and link to Google Play Store with app name
  String buildMessage(Hotel hotel) {
    String hotelLocation = buildLocation(hotel);
    // Define variable to store the list of certifications to display
    List<String> firstThreeCertifications = [];
    // Define variable to store representation of certifications
    String hotelCertifications;
    // Define variable to store the list of sustainable practices to display
    List<String> hotelPracticesList = [];
    // Define variable to store representation of sustainable practices
    String hotelPractices;

    // If the hotel has no certifications, the certifications section will inform the user that the hotel has no certifications
    if (hotel.certifications.length == 0) {
      hotelCertifications = "They have no environmental certifications.";
      // If they have 3 or fewer certifications, iterate through all certifications and construct the text to be spoken for each certification
    } else if (hotel.certifications.length <= 3) {
      // List out all certifications
      hotelCertifications =
          "They have environmental certifications: ${hotel.certifications.join(', ')}.";
    } else {
      // If the hotel has certifications, list out the first 3
      for (int certificationIndex = 0;
          certificationIndex < 3;
          certificationIndex++) {
        var currentCertification = hotel.certifications[certificationIndex];

        // Add the constructed description to the list
        firstThreeCertifications.add(currentCertification);
      }

      hotelCertifications =
          "They have environmental certifications including ${firstThreeCertifications.join(', ')} and more!";
    }

    // If hotel has no sustainable practices, the practices section will inform the user that the hotel has no sustainable practices
    if (hotel.practices.length == 0) {
      hotelPractices = "They have no sustainable practices.";
    } else if (hotel.practices.length <= 3) {
      // If they have 3 or fewer practices, iterate through all practices and construct the text to be spoken for each practice
      for (int practiceIndex = 0;
          practiceIndex < hotel.practices.length;
          practiceIndex++) {
        var practice = hotel.practices[practiceIndex];

        String practiceDescription =
            "${practice.keys.first}: ${practice.values.first}";

        // Add the constructed description to the list
        hotelPracticesList.add(practiceDescription);
      }
      // Combine all the constructed descriptions into a single string for the text to be spoken
      hotelPractices =
          "And they practice sustainable procedures such as\n${hotelPracticesList.join('\n')}";
    } else {
      // If they have more than 3 practices, iterate until the third practice and construct the text to be spoken for each practice
      for (int practiceIndex = 0; practiceIndex < 3; practiceIndex++) {
        var practice = hotel.practices[practiceIndex];

        String practiceDescription =
            "${practice.keys.first} -- ${practice.values.first}";

        // Add the constructed description to the list
        hotelPracticesList.add(practiceDescription);
      }
      // Combine all the constructed descriptions into a single string for the text to be spoken
      hotelPractices =
          "Their sustainable practices include, but are not limited to:\n${hotelPracticesList.join('\n')}";
    }

    return "Looking for somewhere to stay on your next trip?\n\nCheck out ${hotel.name} located in $hotelLocation.\n\n$hotelCertifications\n\n$hotelPractices\n\nGet Ecotel on the Google Play Store to know more: https://play.google.com/store/search?q=%3CEcotel%3E";
  }

  // Show an alert dialog informing the user that social sharing is unavailable for web and giving the user the option to launch the desired app (unless they chose Others) or to cancel
  // The dialog also provides the text to share if the user wants to proceed with sharing the text manually
  void webSharingDialog(String? appUrl, String? appName, String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            // Set background colour of the dialog based on the current theme
            backgroundColor: themeService.getCurrentTheme() == 'light'
                ? const Color.fromARGB(255, 196, 251, 207)
                : const Color.fromARGB(255, 100, 173, 114),
            title: Text(
              'Social Sharing Unavailable on Web',
              textAlign: TextAlign.center,
              style: TextStyle(
                // Set font based on body font set by user/default font
                fontFamily: themeService.getCurrentBodyFont(),
                fontSize: 25,
                color: Colors.black,
              ),
            ),
            content: Text(
                "We're sorry.\nHowever, you can use our mobile app instead\nOR\nshare the text manually by pasting the description\nwe've copied for you in your desired app!",
                style: TextStyle(
                  // Set font based on body font set by user/default font
                  fontFamily: themeService.getCurrentBodyFont(),
                  fontSize: 20,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center),
            actions: [
              // Cancel button to close the dialog when clicked and not proceed with filter and not override other queries
              Padding(
                padding: const EdgeInsets.only(right: 28),
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Ok',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      // Set font based on body font set by user/default font
                      fontFamily: themeService.getCurrentBodyFont(),
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              // If the user clicked on the WhatsApp or X button, appUrl would have been passed in
              // Show a button to proceed to the select app
              appUrl != null
                  // If the user clicked on the WhatsApp or X button, show a button to proceed to the select app
                  ? ElevatedButton(
                      onPressed: () {
                        launchUrl(Uri.parse(appUrl));
                      },
                      style: ElevatedButton.styleFrom(
                        // Set background colour of Yes button based on the current theme
                        backgroundColor:
                            themeService.getCurrentTheme() == "light"
                                ? Theme.of(context).colorScheme.inversePrimary
                                : const Color.fromARGB(255, 27, 207, 138),
                        padding: const EdgeInsets.symmetric(
                            vertical: 0, horizontal: 15),
                      ),
                      child: Text('Proceed to $appName',
                          style: TextStyle(
                            // Set font based on body font set by user/default font
                            fontFamily: themeService.getCurrentBodyFont(),
                            fontSize: 20,
                            color: Colors.black,
                          )),
                    )
                  :
                  // If the user clicked on Others, do not show a button to proceed anywhere as the user can choose any app to share
                  const SizedBox(),
            ],
          );
        });
  }

  // Encode query parameters for email so that text is formatted correctly in email
  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((MapEntry<String, String> e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  // Launches email with the owner's email as the recipient and a pre-defoned subject for user to contact hotel owner regarding queries
  sendEmail(hotelOwner) {
    // Construct the email launch URI with the hotel owner's email as the recipient and an encoded, pre-defined subject for the email
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: hotelOwner,
      query: encodeQueryParameters(<String, String>{
        'subject': 'Query Regarding ${hotel!.name}',
      }),
    );
    // Launch email with the constructed URI
    launchUrl(emailLaunchUri);
  }

  @override
  void initState() {
    super.initState();
    // Initialise text to speech engine
    initTts();
    // Fetch hotel details from Firestore database using the owner's email
    fbService.getHotelByOwner(widget.owner).listen((Hotel? data) {
      if (data != null) {
        // Once retrieved, set the hotel variable to the fetched hotel details
        setState(() {
          hotel = data;
          // Boolean list will be filled with false values for each sustainable practice by default
          // Sustainable practices are minimised by default.
          whichPracticeExpanded = List.filled(hotel!.practices.length, false);
        });
        // Construct the message to be shared with social sharing platforms once hotel details are fetched
        message = buildMessage(hotel!);
      }
    });
  }

  // Dispose of the text to speech engine to stop text to speech when the screen is closed/exited
  @override
  void dispose() {
    super.dispose();
    flutterTts.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // Set background color based on the current theme
        backgroundColor: themeService.getCurrentTheme() == 'light'
            ? const Color.fromARGB(255, 255, 251, 254)
            : const Color.fromARGB(255, 109, 108, 108),
        body: hotel == null
            // If hotel is not loaded yet, display a circular progress indicator
            ? const Center(child: CircularProgressIndicator())
            // Once hotel is loaded, display the hotel details screen
            : CustomScrollView(slivers: [
                SliverAppBar(
                  // Remove default back button to create custom back button
                  automaticallyImplyLeading: false,
                  // Keep the collapsed and expanded height of the app bar the same to prevent the app bar from minimising when user scrolls up
                  collapsedHeight: 185,
                  expandedHeight: 185,
                  // Prevent the app bar from floating and keep it pinned to the top of the screen
                  floating: false,
                  pinned: true,
                  // Fit the cover image of the hotel into the app bar
                  flexibleSpace: FlexibleSpaceBar(
                      background:
                          // Stack used to place the back button on top of the cover image
                          Stack(fit: StackFit.expand, children: [
                    // Hotel's cover image
                    Image.network(
                      hotel!.image,
                      // Fill up width of screen
                      width: double.infinity,
                      // Fill up height of app bar
                      fit: BoxFit.cover,
                    ),
                    // Custom back button at top left corner of app bar.
                    Positioned(
                      top: -3,
                      left: -2,
                      // SizedBox to dictate the size of the back button's background
                      child: SizedBox(
                        height: 50,
                        width: 40,
                        // Back button
                        child: ElevatedButton(
                          // Navigates back to the previous screen upon press
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            // Set back button background based on the current theme
                            backgroundColor:
                                themeService.getCurrentTheme() == 'light'
                                    ? const Color.fromARGB(255, 181, 248, 195)
                                    : const Color.fromARGB(255, 109, 108, 108),
                            // Back button background is a rectangle
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0),
                            ),
                            // Back button has no padding to make it fit the size of the SizedBox
                            padding: const EdgeInsets.all(0),
                          ),
                          child: Padding(
                            // Top padding for the arrow icon so that it won't overlap with the phone status bar (the section that contains the time, battery, etc)
                            padding: const EdgeInsets.only(top: 5),
                            // Back arrow icon is used for the back button
                            child: Icon(
                              Icons.arrow_back,
                              // Set back arrow icon color based on the current theme
                              color: themeService.getCurrentTheme() == 'light'
                                  ? Colors.black
                                  : Colors.white,
                              size: 35,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ])),
                ),
                // Body of hotel details screen is a SliverList containing all the details of the hotel
                SliverList(
                  delegate: SliverChildListDelegate([
                    const SizedBox(height: 5),
                    Column(
                      children: [
                        const SizedBox(height: 5),
                        Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Text to speech
                              isStopped
                                  ?
                                  // Instruction for user to tap the button to play text to speech
                                  Row(
                                      children: [
                                        Text(
                                          "Tap to play text to speech",
                                          style: TextStyle(
                                              // Set font based on body font set by user/default font
                                              fontFamily: themeService
                                                  .getCurrentBodyFont(),
                                              fontSize: 22,
                                              // Set text color based on the current theme
                                              color: themeService
                                                          .getCurrentTheme() ==
                                                      'light'
                                                  ? Colors.black
                                                  : Colors.white),
                                        ),
                                        const SizedBox(width: 10),
                                        // Play button
                                        GestureDetector(
                                          onTap: () {
                                            speak(hotel);
                                          },
                                          // Play button icon
                                          child: Image.asset(
                                            // Set play button icon based on the current theme
                                            themeService.getCurrentTheme() ==
                                                    'light'
                                                ? "images/play.png"
                                                : "images/dark_play.png",
                                            height: 30,
                                          ),
                                        )
                                      ],
                                    )
                                  // If text to speech is paused, display the play button
                                  : isPaused
                                      ?
                                      // Instruction for user to tap the button to continue text to speech
                                      Row(
                                          children: [
                                            Text(
                                              "Tap to resume text to speech",
                                              style: TextStyle(
                                                  // Set font based on body font set by user/default font
                                                  fontFamily: themeService
                                                      .getCurrentBodyFont(),
                                                  fontSize: 22,
                                                  // Set text color based on the current theme
                                                  color: themeService
                                                              .getCurrentTheme() ==
                                                          'light'
                                                      ? Colors.black
                                                      : Colors.white),
                                            ),
                                            const SizedBox(width: 10),
                                            // Play button
                                            GestureDetector(
                                              onTap: () {
                                                speak(hotel);
                                              },
                                              // Play button icon
                                              child: Image.asset(
                                                // Set play button icon based on the current theme
                                                themeService.getCurrentTheme() ==
                                                        'light'
                                                    ? "images/play.png"
                                                    : "images/dark_play.png",
                                                height: 30,
                                              ),
                                            )
                                          ],
                                        )
                                      :
                                      // If text to speech is still playing, show buttons for user to pause or stop text to speech
                                      Column(
                                          children: [
                                            Row(
                                              children: [
                                                // Instruction for user to tap the button to pause text to speech
                                                Text(
                                                  "Tap to pause text to speech",
                                                  style: TextStyle(
                                                      // Set font based on body font set by user/default font
                                                      fontFamily: themeService
                                                          .getCurrentBodyFont(),
                                                      fontSize: 22,
                                                      // Set text color based on the current theme
                                                      color: themeService
                                                                  .getCurrentTheme() ==
                                                              'light'
                                                          ? Colors.black
                                                          : Colors.white),
                                                ),
                                                const SizedBox(width: 10),
                                                // Pause button
                                                GestureDetector(
                                                  onTap: () {
                                                    pause();
                                                  },
                                                  // Pause button icon
                                                  child: Image.asset(
                                                    // Set play button icon based on the current theme
                                                    themeService.getCurrentTheme() ==
                                                            'light'
                                                        ? "images/pause.png"
                                                        : "images/dark_pause.png",
                                                    height: 30,
                                                  ),
                                                )
                                              ],
                                            ),
                                            const SizedBox(height: 10),
                                            // Instruction for user to tap the button to end text to speech
                                            Row(children: [
                                              Text(
                                                "Tap to end text to speech",
                                                style: TextStyle(
                                                    // Set font based on body font set by user/default font
                                                    fontFamily: themeService
                                                        .getCurrentBodyFont(),
                                                    fontSize: 22,
                                                    // Set text color based on the current theme
                                                    color: themeService
                                                                .getCurrentTheme() ==
                                                            'light'
                                                        ? Colors.black
                                                        : Colors.white),
                                              ),
                                              const SizedBox(width: 10),
                                              // Stop button
                                              GestureDetector(
                                                onTap: () {
                                                  stop();
                                                },
                                                // Play button icon
                                                child: Image.asset(
                                                  // Set play button icon based on the current theme
                                                  themeService.getCurrentTheme() ==
                                                          'light'
                                                      ? "images/stop.png"
                                                      : "images/dark_stop.png",
                                                  height: 40,
                                                ),
                                              ),
                                            ])
                                          ],
                                        ),
                              const SizedBox(height: 8),
                              // Hotel name
                              Text(
                                hotel!.name,
                                style: TextStyle(
                                    // Set font based on body font set by user/default font
                                    fontFamily:
                                        themeService.getCurrentBodyFont(),
                                    fontSize: 35,
                                    fontWeight: FontWeight.bold,
                                    // Set text color based on the current theme
                                    color: themeService.getCurrentTheme() ==
                                            'light'
                                        ? Colors.black
                                        : Colors.white,
                                    letterSpacing: 1.5),
                              ),
                              const SizedBox(height: 10),
                              //  Star rating represented as the number of stars in a row
                              Row(
                                children: [
                                  for (int i = 0; i < hotel!.rating; i++)
                                    Image.asset("images/star.png", width: 25),
                                ],
                              ),
                              const SizedBox(height: 10),
                              // Hotel location
                              Text(
                                // Check if hotel has a city in location details
                                hotel!.city != null
                                    // If hotel has a city, check if it has a state/province in location details
                                    ? hotel!.stateProvince != null
                                        // If it has both city and state/province, display hotel location in this format: city, state/province, country
                                        ? "${hotel!.city}, ${hotel!.stateProvince}, ${hotel!.country}"
                                        // If hotel does not have state/province, display hotel location in this format: city, country
                                        : "${hotel!.city}, ${hotel!.country}"
                                    // if hotel does not have city, check if it has a state/province in location details
                                    : hotel!.stateProvince != null
                                        // If it has state/province, display hotel location in this format: state/province, country
                                        ? "${hotel!.stateProvince}, ${hotel!.country}"
                                        // If hotel has neither a city nor a state/province, display hotel location as just the country
                                        : hotel!.country,
                                // Location details should be confined within 1 line
                                maxLines: 1,
                                // If location details are too long, cut it off with an ellipsis to indicate more information is available
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    // Set font based on body font set by user/default font
                                    fontFamily:
                                        themeService.getCurrentBodyFont(),
                                    fontSize: 18,
                                    fontStyle: FontStyle.italic,
                                    // Set text color based on the current theme
                                    color: themeService.getCurrentTheme() ==
                                            'light'
                                        ? Colors.black
                                        : Colors.white),
                              ),
                              const SizedBox(height: 5),
                              // Street address
                              Text(
                                hotel!.address,
                                style: TextStyle(
                                    // Set font based on body font set by user/default font
                                    fontFamily:
                                        themeService.getCurrentBodyFont(),
                                    fontSize: 18,
                                    fontStyle: FontStyle.italic,
                                    // Set text color based on the current theme
                                    color: themeService.getCurrentTheme() ==
                                            'light'
                                        ? Colors.black
                                        : Colors.white),
                              ),
                              const SizedBox(height: 20),
                              // Certifications heading
                              Text(
                                "Certifications",
                                style: TextStyle(
                                    // Set font based on heading set by user/default font
                                    fontFamily:
                                        themeService.getCurrentHeadingFont(),
                                    // Set font size based on heading set by user/default font so that headings are consistent
                                    fontSize:
                                        themeService.getCurrentHeadingFont() ==
                                                "Nunito Sans"
                                            ? 30
                                            : 32,
                                    // Set text color based on the current theme
                                    color: themeService.getCurrentTheme() ==
                                            'light'
                                        ? Colors.black
                                        : Colors.white),
                              ),
                              // Loop to generate text widgets representing each certification the hotel has
                              for (int certIndex = 0;
                                  certIndex < hotel!.certifications.length;
                                  certIndex++)
                                Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: Text(
                                    hotel!.certifications[certIndex],
                                    style: TextStyle(
                                        // Set font based on body font set by user/default font
                                        fontFamily:
                                            themeService.getCurrentBodyFont(),
                                        fontSize: 22,
                                        // Set text color based on the current theme
                                        color: themeService.getCurrentTheme() ==
                                                'light'
                                            ? Colors.black
                                            : Colors.white),
                                  ),
                                ),
                              const SizedBox(height: 20),
                              // Sustainable Practices heading
                              Text(
                                "Sustainable Practices",
                                style: TextStyle(
                                    // Set font based on heading set by user/default font
                                    fontFamily:
                                        themeService.getCurrentHeadingFont(),
                                    // Set font size based on heading set by user/default font so that headings are consistent
                                    fontSize:
                                        themeService.getCurrentHeadingFont() ==
                                                "Nunito Sans"
                                            ? 30
                                            : 32,
                                    // Set text color based on the current theme
                                    color: themeService.getCurrentTheme() ==
                                            'light'
                                        ? Colors.black
                                        : Colors.white),
                              ),
                              // loop to generate ExpansionTile widgets representing each sustainable practice the hotel has
                              for (int practiceIndex = 0;
                                  practiceIndex < hotel!.practices.length;
                                  practiceIndex++)
                                ExpansionTile(
                                  // Title is the name of the sustainable practice
                                  title: Text(
                                    hotel!.practices[practiceIndex].keys.first,
                                    style: TextStyle(
                                        // Set font based on body font set by user/default font
                                        fontFamily:
                                            themeService.getCurrentBodyFont(),
                                        fontSize:
                                            22, // Set text color based on the current theme
                                        color: themeService.getCurrentTheme() ==
                                                'light'
                                            ? Colors.black
                                            : Colors.white),
                                  ),
                                  // Place an icon at the end of the sustainable practice's name to expand or minimise the practice
                                  trailing: Icon(
                                      // Use whichPracticeExpanded at the index of the current practice to determine whether the practice is expanded or not
                                      whichPracticeExpanded[practiceIndex]
                                          // If expanded, display the minimise icon
                                          ? Icons.expand_less_rounded
                                          // If minimised, display the expand icon
                                          : Icons.expand_more_rounded,
                                      size: 60,
                                      // Set icon color based on the current theme
                                      color: themeService.getCurrentTheme() ==
                                              'light'
                                          ? Colors.black
                                          : Colors.white),
                                  // Content of the ExpansionTile is the description of the sustainable practice.
                                  // It is only displayed when the trailing icon is pressed to expand the tile
                                  children: [
                                    kIsWeb
                                        ? Padding(
                                            padding: const EdgeInsets.only(
                                                right: 500),
                                            child: Text(
                                              hotel!.practices[practiceIndex]
                                                  .values.first,
                                              style: TextStyle(
                                                  // Set font based on body font set by user/default font
                                                  fontFamily: themeService
                                                      .getCurrentBodyFont(),
                                                  fontSize: 20,
                                                  // Set text color based on the current theme
                                                  color: themeService
                                                              .getCurrentTheme() ==
                                                          'light'
                                                      ? Colors.black
                                                      : Colors.white),
                                            ),
                                          )
                                        : Padding(
                                            padding:
                                                const EdgeInsets.only(left: 25),
                                            child: Text(
                                              hotel!.practices[practiceIndex]
                                                  .values.first,
                                              style: TextStyle(
                                                  // Set font based on body font set by user/default font
                                                  fontFamily: themeService
                                                      .getCurrentBodyFont(),
                                                  fontSize: 18,
                                                  // Set text color based on the current theme
                                                  color: themeService
                                                              .getCurrentTheme() ==
                                                          'light'
                                                      ? Colors.black
                                                      : Colors.white),
                                            ),
                                          ),
                                  ],
                                  // When the trailing icon is pressed, the value of whichPracticeExpanded at the index of the current practice is toggled
                                  onExpansionChanged: (value) {
                                    setState(() {
                                      whichPracticeExpanded[practiceIndex] =
                                          value;
                                    });
                                  },
                                ),
                              const SizedBox(height: 20),
                              // Share heading
                              Text(
                                "Share",
                                style: TextStyle(
                                    // Set font based on heading set by user/default font
                                    fontFamily:
                                        themeService.getCurrentHeadingFont(),
                                    // Set font size based on heading set by user/default font so that headings are consistent
                                    fontSize:
                                        themeService.getCurrentHeadingFont() ==
                                                "Nunito Sans"
                                            ? 30
                                            : 32,
                                    // Set text color based on the current theme
                                    color: themeService.getCurrentTheme() ==
                                            'light'
                                        ? Colors.black
                                        : Colors.white),
                              ),
                              // Display options for social sharing: WhatsApp, X and Others
                              // Each is represented as a row containing an image and name of the social sharing platform
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 10, left: 20),
                                child: Wrap(
                                  // Spacing between each social sharing option
                                  spacing: 30,
                                  // Spacing between each row of social sharing options
                                  runSpacing: 10,
                                  // Social sharing options
                                  children: [
                                    // WhatsApp
                                    GestureDetector(
                                      onTap: () async {
                                        // If the app is running on the web, copy the message to be sent and notify the user that social sharing is not available on the web and that they can paste the copied text to share manually
                                        if (kIsWeb) {
                                          FlutterClipboard.copy(message)
                                              .then((value) {
                                            // Show the dialog informing user that social sharing is not available on the web and that they can paste the copied text to share manually
                                            // Also pass in the link to X website to redirect them to it if they want
                                            webSharingDialog(
                                                "https://web.whatsapp.com/",
                                                "WhatsApp",
                                                message);
                                          });
                                        } else {
                                          // Share the message to WhatsApp on the device
                                          // Store the success of the sharing in whatsAppShareSuccess
                                          bool whatsAppShareSuccess =
                                              await CustomSocialShare().to(
                                                  ShareWith.whatsapp, message);
                                          // If sharing is successful, do nothing
                                          whatsAppShareSuccess
                                              ? null
                                              :
                                              // If sharing is unsuccessful, it may be because Whatsapp is not installed on the device, so notify user
                                              showMaterialBanner(
                                                  "WhatsApp is not installed on your device. If it is, there may be another error. Sorry : (");
                                        }
                                      },
                                      child: Row(
                                        // Minimise free space in row
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          // WhatsApp icon
                                          Image.asset(
                                            "images/whatsapp.png",
                                            height: 55,
                                          ),
                                          const SizedBox(width: 8),
                                          // WhatsApp name
                                          Text(
                                            "WhatsApp",
                                            style: TextStyle(
                                                // Set font based on body font set by user/default font
                                                fontFamily: themeService
                                                    .getCurrentBodyFont(),
                                                fontSize:
                                                    20, // Set text color based on the current theme
                                                color: themeService
                                                            .getCurrentTheme() ==
                                                        'light'
                                                    ? Colors.black
                                                    : Colors.white),
                                          )
                                        ],
                                      ),
                                    ),
                                    // X
                                    GestureDetector(
                                      onTap: () async {
                                        // If the app is running on the web, copy the message to be sent and notify the user that social sharing is not available on the web and that they can paste the copied text to share manually
                                        if (kIsWeb) {
                                          FlutterClipboard.copy(message)
                                              .then((value) {
                                            // Show the dialog informing user that social sharing is not available on the web and that they can paste the copied text to share manually
                                            // Also pass in the link to X website to redirect them to it if they want
                                            webSharingDialog(
                                                "https://x.com/", "X", message);
                                          });
                                        } else {
                                          // Share the message to X on the device
                                          // Store the success of the sharing in xShareSuccess
                                          bool xShareSuccess =
                                              await CustomSocialShare()
                                                  .to(ShareWith.x, message);
                                          // If sharing is successful, do nothing
                                          xShareSuccess
                                              ? null
                                              :
                                              // If sharing is unsuccessful, it may be because X is not installed on the device, so notify user
                                              showMaterialBanner(
                                                  "X is not installed on your device. If it is, there may be another error. Sorry : (");
                                        }
                                      },
                                      child: Row(
                                        // Minimise free space in row
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          // X icon
                                          Image.asset(
                                            "images/x.png",
                                            height: 50,
                                          ),
                                          const SizedBox(width: 8),
                                          // X name
                                          Text("X",
                                              style: TextStyle(
                                                  // Set font based on body font set by user/default font
                                                  fontFamily: themeService
                                                      .getCurrentBodyFont(),
                                                  fontSize:
                                                      20, // Set text color based on the current theme
                                                  color: themeService
                                                              .getCurrentTheme() ==
                                                          'light'
                                                      ? Colors.black
                                                      : Colors.white))
                                        ],
                                      ),
                                    ),
                                    // Others
                                    GestureDetector(
                                      onTap: () async {
                                        // If the app is running on the web, copy the message to be sent and notify the user that social sharing is not available on the web and that they can paste the copied text to share manually
                                        if (kIsWeb) {
                                          FlutterClipboard.copy(message)
                                              .then((value) {
                                            webSharingDialog(
                                                null, null, message);
                                          });
                                        } else {
                                          // Share the message to all available social sharing platforms on the device
                                          // Store the success of the sharing in othersShareSuccess
                                          bool othersShareSuccess =
                                              await CustomSocialShare()
                                                  .toAll(message);
                                          // If sharing is successful, do nothing
                                          othersShareSuccess
                                              ? null
                                              // If sharing is unsuccessful, notify user
                                              : showMaterialBanner(
                                                  "Could not share. Sorry : (");
                                        }
                                      },
                                      child: Row(
                                        // Minimise free space in row
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          // Others icon
                                          Image.asset("images/others.png",
                                              height: 55),
                                          const SizedBox(width: 8),
                                          // Others label
                                          Text("Others",
                                              style: TextStyle(
                                                  // Set font based on body font set by user/default font
                                                  fontFamily: themeService
                                                      .getCurrentBodyFont(),
                                                  fontSize:
                                                      20, // Set text color based on the current theme
                                                  color: themeService
                                                              .getCurrentTheme() ==
                                                          'light'
                                                      ? Colors.black
                                                      : Colors.white))
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                              // Questions heading
                              Text(
                                "Questions?",
                                style: TextStyle(
                                    // Set font based on heading set by user/default font
                                    fontFamily:
                                        themeService.getCurrentHeadingFont(),
                                    // Set font size based on heading set by user/default font so that headings are consistent
                                    fontSize:
                                        themeService.getCurrentHeadingFont() ==
                                                "Nunito Sans"
                                            ? 30
                                            : 32,
                                    // Set text color based on the current theme
                                    color: themeService.getCurrentTheme() ==
                                            'light'
                                        ? Colors.black
                                        : Colors.white),
                              ),
                              // Contact the owner Textbutton
                              // User clicks on the "Contact the owner here!" text to be sent to an email draft to contact the owner of the hotel
                              Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: TextButton(
                                      onPressed: () {
                                        sendEmail(hotel!.owner);
                                      },
                                      child: Text(
                                        // Instruction to click on this text to contact owner
                                        "Contact the owner here!",
                                        style: TextStyle(
                                            // Set font based on body font set by user/default font
                                            fontFamily: themeService
                                                .getCurrentBodyFont(),
                                            fontSize: 25,
                                            color: const Color.fromARGB(
                                                255, 125, 227, 88)),
                                      ))),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ]),
                )
              ]));
  }
}
