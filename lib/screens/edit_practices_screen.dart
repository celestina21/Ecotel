// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors_in_immutables, prefer_is_empty

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:sohleecelest_2301028c_pc09/models/hotel.dart';
import 'package:sohleecelest_2301028c_pc09/screens/hotel_updated_screen.dart';
import 'package:sohleecelest_2301028c_pc09/services/firebase_service.dart';
import 'package:sohleecelest_2301028c_pc09/services/theme_service.dart';

class EditPracticesScreen extends StatefulWidget {
  static const String routeName = '/edit-practices';

  @override
  State<EditPracticesScreen> createState() => _EditPracticesScreenState();
}

class _EditPracticesScreenState extends State<EditPracticesScreen> {
  // Get the FirebaseService instance as fbService to access updateHotel() and getCurrentUser() functions
  final FirebaseService fbService = GetIt.instance<FirebaseService>();
  // Get the ThemeService instance as themeService to access getCurrentTheme() function
  final ThemeService themeService = GetIt.instance<ThemeService>();

  // Define email variable to retrieve current user's email
  String? email;
  // Define hotel variable to retrieve current hotel's cover image
  Hotel? hotel;
  // List of sustainable practices that will be the updated value for practices attribute in hotel object if user confirms changes
  // Used to display what practices will be updated to after the user's changes without changing the database
  List<Map<String, dynamic>> updatedPractices = [];

  // Set updatePractices to initially be the hotel's current list of practices
  @override
  void initState() {
    super.initState();
    // Get the current user's email then get the hotel object with the same owner email
    email = fbService.getCurrentUser()!.email;
    fbService.getHotelByOwner(email!).listen((value) {
      setState(() {
        hotel = value;
        updatedPractices = hotel!.practices.toList();
      });
    });
  }

  // Text controller to retrieve practice name entered by user for validation
  TextEditingController practiceNameController = TextEditingController();
  // Text controller to retrieve practice description entered by user for validation
  TextEditingController practiceDescriptionController = TextEditingController();

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

  // Function to check if any descriptions in the already added practices are similar to the new description.
  // Returns true if a similar description is found, false otherwise.
  bool hasDuplicateDescription(String newPracticeDescription) {
    for (var practice in updatedPractices) {
      var value = practice.values.first;
      if (value == newPracticeDescription) {
        return true;
      }
    }
    return false;
  }

  // Function to validate practice name and dedcription and if valid, add the practice to updatedPractices
  void addPractice() {
    // Hide keyboard
    FocusScope.of(context).unfocus();

    // Retrieve practice name entered by user without leading and trailing white spaces
    String newPracticeName = practiceNameController.text.trim();
    // Retrieve practice description entered by user without leading and trailing white spaces
    String newPracticeDescription = practiceDescriptionController.text.trim();

    // Checks if the practice entered is valid
    if (!updatedPractices
            .any((practice) => practice.containsKey(newPracticeName)) &&
        !hasDuplicateDescription(newPracticeDescription) &&
        newPracticeName.length > 9 &&
        newPracticeDescription.length > 49 &&
        newPracticeName.length < 46 &&
        newPracticeDescription.length < 301 &&
        updatedPractices.length < 10) {
      // If it is valid, add the new practice into hotel's practices list as a map
      Map<String, String> newPractice = {
        newPracticeName: newPracticeDescription
      };

      setState(() {
        // Add the new practice to the list of updated practices
        updatedPractices.add(newPractice);
        // Clear the text fields
        practiceNameController.clear();
        practiceDescriptionController.clear();
      });
    } else if (newPracticeName.length == 0) {
      showMaterialBanner('Please enter a name for this practice.');
    } else if (newPracticeName.length < 10) {
      showMaterialBanner(
          'Practice name is too short. Please enter a name with at least 10 characters.');
    } else if (newPracticeName.length > 45) {
      showMaterialBanner(
          'Practice name is too long! Please enter a name with at most 45 characters.');
    } else if (newPracticeDescription.length == 0) {
      showMaterialBanner('Please enter a description for this practice.');
    } else if (newPracticeDescription.length < 50) {
      showMaterialBanner(
          'Description is too short. Please enter a description with at least 50 characters.');
    } else if (newPracticeDescription.length > 300) {
      showMaterialBanner(
          'Description is too long! Please enter a description with at most 300 characters.');
    } else if (updatedPractices.length == 10) {
      showMaterialBanner(
          'You have reached the maximum number of sustainable practices allowed. Please delete a practice to add a new one.');
    } else {
      showMaterialBanner(
          'This practice already exists or has a similar description to an existing practice. Please enter a new practice.');
    }
  }

  // Function to delete practice from updatedPractices list
  void deletePractice(String practiceName) {
    // Remove dismissed practice using its name as the key
    updatedPractices
        .removeWhere((practice) => practice.containsKey(practiceName));

    // Trigger rebuild of page to display changes (practice gone from list of certifications)
    setState(() {});
  }

  // Function to trigger onSaved function. Saves all practices entered then updates the hotel's practices list
  void updatePractices() {
    // Hide keyboard after saving certification name
    FocusScope.of(context).unfocus();
    // Update hotel's practices list with updatedPractices list
    fbService
        .updateHotel(
            hotel!.owner,
            hotel!.name,
            hotel!.rating,
            hotel!.country,
            hotel!.stateProvince,
            hotel!.city,
            hotel!.address,
            hotel!.certifications,
            updatedPractices,
            hotel!.image)
        .then((value) {
      // Show SnackBar to notify user that practices was updated successfully
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        // Set snackbar background colour based on current theme
        backgroundColor: themeService.getCurrentTheme() == "light"
            ? const Color.fromARGB(255, 185, 252, 123)
            : const Color.fromARGB(255, 80, 158, 52),
        content: Text(
          "Sustainable Practices Updated Successfully!",
          style: TextStyle(
            // Set font based on body font set by user/default font
            fontFamily: themeService.getCurrentBodyFont(),
            fontSize: 23,
            // Set text colour based on current theme
            color: themeService.getCurrentTheme() == 'light'
                ? Colors.black
                : Colors.white,
          ),
        ),
      ));
      Navigator.of(context)
          .pushReplacementNamed(HotelUpdatedScreen.routeName, arguments: email);
    }).onError((error, stackTrace) {
      // Show SnackBar to notify user that hotel was not updated successfully
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        // Set snackbar background colour based on current theme
        backgroundColor: themeService.getCurrentTheme() == "light"
            ? const Color.fromARGB(255, 252, 123, 123)
            : const Color.fromARGB(255, 183, 42, 42),
        content: Text(
          "Sustainable practices could not be updated :( Please try again.",
          style: TextStyle(
            // Set font based on body font set by user/default font
            fontFamily: themeService.getCurrentBodyFont(),
            fontSize: 23,
            // Set text colour based on current theme
            color: themeService.getCurrentTheme() == 'light'
                ? Colors.black
                : Colors.white,
          ),
        ),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // Set screen background colour based on current theme
        backgroundColor: themeService.getCurrentTheme() == 'light'
            ? const Color.fromARGB(255, 255, 251, 254)
            : const Color.fromARGB(255, 109, 108, 108),
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          // Set app bar back button colour based on current theme
          foregroundColor: themeService.getCurrentTheme() == 'light'
              ? Colors.black
              : Colors.white,
          // Set app bar background colour based on current theme
          backgroundColor: themeService.getCurrentTheme() == 'light'
              ? Theme.of(context).colorScheme.inversePrimary
              : const Color.fromARGB(255, 34, 34, 34),
          // Title of the page to enter sustainable practices
          title: Text('Sustainable Practices',
              style: TextStyle(
                // Set font based on heading set by user/default font
                fontFamily: themeService.getCurrentHeadingFont(),
                // Set font size based on heading set by user/default font so that headings are consistent
                fontSize: themeService.getCurrentHeadingFont() == "Nunito Sans"
                    ? 29
                    : 31,
                fontWeight: FontWeight.bold,
                // Set title text colour based on current theme
                color: themeService.getCurrentTheme() == 'light'
                    ? Colors.black
                    : Colors.white,
              )),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  ElevatedButton(
                      onPressed: () {
                        // Save modified practices to hotel object
                        updatePractices();
                      },
                      style: ElevatedButton.styleFrom(
                          // Set Submit Practices button background colour based on current theme
                          backgroundColor:
                              themeService.getCurrentTheme() == "light"
                                  ? const Color.fromRGBO(125, 227, 88, 1)
                                  : const Color.fromARGB(255, 109, 179, 152)),
                      child: Text(
                        "Submit Practices",
                        style: TextStyle(
                          // Set font based on body font set by user/default font
                          fontFamily: themeService.getCurrentBodyFont(),
                          fontSize: 23,
                          color: Colors.black,
                        ),
                      )),
                  // Form field for sustainable practice's name
                  TextFormField(
                    // Set cursor colour based on current theme
                    cursorColor: themeService.getCurrentTheme() == 'light'
                        ? const Color.fromARGB(255, 20, 123, 23)
                        : const Color.fromARGB(255, 255, 251, 254),
                    controller: practiceNameController,
                    style: TextStyle(
                        // Set font based on body font set by user/default font
                        fontFamily: themeService.getCurrentBodyFont(),
                        fontSize: 23,
                        // Set text colour based on current theme
                        color: themeService.getCurrentTheme() == 'light'
                            ? Colors.black
                            : Colors.white),
                    decoration: InputDecoration(
                      // Label text to specify this is the form field for the sustainable practice's name
                      // Label used instead of hint to differentiate between which form field is for name and which is for description even after practice/description has been entered
                      labelText: "Name of Sustainable Practice",
                      labelStyle: TextStyle(
                          // Set font based on body font set by user/default font
                          fontFamily: themeService.getCurrentBodyFont(),
                          fontSize: 23,
                          // Set label text colour based on current theme
                          color: themeService.getCurrentTheme() == 'light'
                              ? const Color.fromARGB(255, 142, 142, 142)
                              : const Color.fromARGB(255, 180, 175, 175)),
                      // Set Underline colour when idle based on current theme
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                        color: themeService.getCurrentTheme() == 'light'
                            ? const Color.fromARGB(255, 0, 72, 25)
                            : const Color.fromARGB(255, 211, 206, 210),
                      )),
                      // Set Underline colour when user is typing based on current theme
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                        color: themeService.getCurrentTheme() == 'light'
                            ? const Color.fromARGB(255, 72, 72, 72)
                            : const Color.fromARGB(255, 255, 251, 254),
                      )),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Form field for sustainable practice's description
                  TextFormField(
                    // Set cursor colour based on current theme
                    cursorColor: themeService.getCurrentTheme() == 'light'
                        ? const Color.fromARGB(255, 20, 123, 23)
                        : const Color.fromARGB(255, 255, 251, 254),
                    controller: practiceDescriptionController,
                    minLines: 1,
                    maxLines: 5,
                    style: TextStyle(
                        // Set font based on body font set by user/default font
                        fontFamily: themeService.getCurrentBodyFont(),
                        fontSize: 23,
                        // Set text colour based on current theme
                        color: themeService.getCurrentTheme() == 'light'
                            ? Colors.black
                            : Colors.white),
                    decoration: InputDecoration(
                      // Label text to specify this is the form field for the sustainable practice's description
                      // Label used instead of hint to differentiate between which form field is for name and which is for description even after practice/description has been entered
                      labelText: "Description",
                      labelStyle: TextStyle(
                          // Set font based on body font set by user/default font
                          fontFamily: themeService.getCurrentBodyFont(),
                          fontSize: 23,
                          // Set label text colour based on current theme
                          color: themeService.getCurrentTheme() == 'light'
                              ? const Color.fromARGB(255, 142, 142, 142)
                              : const Color.fromARGB(255, 180, 175, 175)),
                      // Set Underline colour when idle based on current theme
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                        color: themeService.getCurrentTheme() == 'light'
                            ? const Color.fromARGB(255, 0, 72, 25)
                            : const Color.fromARGB(255, 211, 206, 210),
                      )),
                      // Set Underline colour when user is typing based on current theme
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                        color: themeService.getCurrentTheme() == 'light'
                            ? const Color.fromARGB(255, 72, 72, 72)
                            : const Color.fromARGB(255, 255, 251, 254),
                      )),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.only(left: 170, right: 0),
                    // Button to validate and add the entered practice to updatedPractices list
                    child: ElevatedButton(
                      onPressed: () {
                        addPractice();
                      },
                      style: ElevatedButton.styleFrom(
                          // Set Add Practice button background colour based on current theme
                          backgroundColor:
                              themeService.getCurrentTheme() == 'light'
                                  ? const Color.fromARGB(219, 181, 248, 195)
                                  : const Color.fromARGB(255, 120, 183, 158),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 0)),
                      child: Text(
                        'Add Practice',
                        style: TextStyle(
                          // Set font based on body font set by user/default font
                          fontFamily: themeService.getCurrentBodyFont(),
                          fontSize: 23,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // List of practices which were already entered and validated
            // Displays updatedPractices list that will reflect what the hotel's practices list looks like after update
            Expanded(
              child: ListView.builder(
                itemCount: updatedPractices.length,
                itemBuilder: (context, index) {
                  var practice = updatedPractices[index];
                  // Retrieve practice name (key of practice map) and description (value of practice map) from hotel's list of practices
                  var practiceName = practice.keys.first;
                  var practiceDescription = practice[practiceName];

                  return Dismissible(
                    // Key to uniquely identify each practice will be the practice name
                    key: Key(practiceName),
                    // When user swipes left on a practice, it is deleted from updatedPractices
                    onDismissed: (direction) {
                      deletePractice(practiceName);
                    },
                    // Background of the practice expansion tile when swiped left with trash icon to indicate that the practice will be deleted
                    background: Container(
                      color: Colors.red,
                      padding: const EdgeInsets.only(left: 340),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    // Each practice is displayed as an expansion tile with practice name as title and practice description as children
                    // For easier viewing. User can also expand the tile to check the description.
                    child: ExpansionTile(
                      // Set expand icon colour based on current theme
                      iconColor: themeService.getCurrentTheme() == 'light'
                          ? Colors.black
                          : Colors.white,
                      // Set expand icon colour when tile is expanded based on current theme
                      collapsedIconColor:
                          themeService.getCurrentTheme() == 'light'
                              ? Colors.black
                              : Colors.white,
                      title: Text(
                        practiceName,
                        style: TextStyle(
                          // Set font based on body font set by user/default font
                          fontFamily: themeService.getCurrentBodyFont(),
                          fontSize: 23,
                          // Set practice name text colour based on current theme
                          color: themeService.getCurrentTheme() == 'light'
                              ? Colors.black
                              : Colors.white,
                        ),
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            practiceDescription!,
                            style: TextStyle(
                              // Set font based on body font set by user/default font
                              fontFamily: themeService.getCurrentBodyFont(),
                              fontSize: 20,
                              // Set practice description text colour based on current theme
                              color: themeService.getCurrentTheme() == 'light'
                                  ? Colors.black
                                  : Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ));
  }
}
