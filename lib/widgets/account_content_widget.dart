// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, prefer_const_literals_to_create_immutables, must_be_immutable, override_on_non_overriding_member

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:sohleecelest_2301028c_pc09/screens/add_hotel_basic_details_screen.dart';
import 'package:sohleecelest_2301028c_pc09/screens/editing_options_screen.dart';
import 'package:sohleecelest_2301028c_pc09/screens/hotel_deleted_screen.dart';
import 'package:sohleecelest_2301028c_pc09/screens/hotel_details_screen.dart';
import 'package:sohleecelest_2301028c_pc09/screens/logged_out_screen.dart';
import 'package:sohleecelest_2301028c_pc09/screens/update_password_screen.dart';
import 'package:sohleecelest_2301028c_pc09/services/firebase_service.dart';
import 'package:sohleecelest_2301028c_pc09/services/theme_service.dart';

import '../models/hotel.dart';

class AccountContentWidget extends StatefulWidget {
  @override
  State<AccountContentWidget> createState() => _AccountContentWidgetState();
}

class _AccountContentWidgetState extends State<AccountContentWidget> {
  // Define hotel variable to store hotel details
  Hotel? hotel;

  // Initialise FirebaseService object to access getHotelByOwner(), deleteHotel() functions
  final FirebaseService fbService = GetIt.instance<FirebaseService>();
  // Initialise ThemeService object to access getCurrentTheme() function
  final ThemeService themeService = GetIt.instance<ThemeService>();

  // Boolean to manage whether or not delete button is loading. Delete button is not loading by default.
  late bool deleteLoading;

  // Define email variable to store user's email
  String? email = "";
  // Define user variable to store current user information
  User? user;

  @override
  void initState() {
    super.initState();
    // Set deleteLoading to false by default
    deleteLoading = false;
    // Get current user information and store email in email variable
    user = fbService.getCurrentUser();
    email = user!.email;
  }

  // Log out the user and navigate to Logged Out page
  logOut(context) {
    return fbService.logOut().then((value) {
      // Show snackbar to inform user that logout was successful before navigating to Logged Out page
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        // Set snackbar background colour based on current theme
        backgroundColor: themeService.getCurrentTheme() == "light"
            ? const Color.fromARGB(255, 185, 252, 123)
            : const Color.fromARGB(255, 80, 158, 52),
        content: Text(
          "Logout Successful!",
          style: TextStyle(
            // Set font based on body font set by user/default font
            fontFamily: themeService.getCurrentBodyFont(),
            fontSize: 23,
            // Set snackbar text colour based on current theme
            color: themeService.getCurrentTheme() == "light"
                ? Colors.black
                : Colors.white,
          ),
        ),
      ));
      Navigator.of(context).pushReplacementNamed(LoggedOutScreen.routeName);
      // Display error if logout is unsuccessful
    }).catchError((error) {
      String message = error.toString();
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        // Set snackbar background colour based on current theme
        backgroundColor: themeService.getCurrentTheme() == "light"
            ? const Color.fromARGB(255, 185, 252, 123)
            : const Color.fromARGB(255, 80, 158, 52),
        content: Text(
          message,
          style: TextStyle(
            // Set font based on body font set by user/default font
            fontFamily: themeService.getCurrentBodyFont(),
            fontSize: 23,
            // Set snackbar text colour based on current theme
            color: themeService.getCurrentTheme() == "light"
                ? Colors.black
                : Colors.white,
          ),
        ),
      ));
    });
  }

  // Function to show user a dialog to confirm if they want to delete their hotel, then delete the hotel if they confirm
  void deleteHotel(String owner) {
    showDialog<Null>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              // Set dialog background colour based on current theme
              backgroundColor: themeService.getCurrentTheme() == 'light'
                  ? const Color.fromARGB(255, 196, 251, 207)
                  : const Color.fromARGB(255, 100, 173, 114),
              contentPadding: const EdgeInsets.only(
                  right: 10, left: 10, top: 60, bottom: 30),
              content: deleteLoading
                  ? Center(
                      child: Column(children: [
                        CircularProgressIndicator(),
                        Text(
                          "Deleting...",
                          style: TextStyle(
                            // Set font based on body font set by user/default font
                            fontFamily: themeService.getCurrentBodyFont(),
                            fontSize: 27,
                            // Set text colour based on current theme
                            color: themeService.getCurrentTheme() == "light"
                                ? Colors.black
                                : Colors.white,
                          ),
                        )
                      ]),
                    )
                  : Text(
                      'Are you sure you want to DELETE your hotel?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        // Set font based on body font set by user/default font
                        fontFamily: themeService.getCurrentBodyFont(),
                        fontSize: 27,
                        // Set text colour based on current theme
                        color: themeService.getCurrentTheme() == "light"
                            ? Colors.black
                            : Colors.white,
                      ),
                    ),
              actionsPadding: EdgeInsets.only(right: 50, left: 50, bottom: 60),
              actions: [
                // Remove the dialog when user presses "No" button
                Padding(
                  padding: const EdgeInsets.only(right: 30),
                  child: ElevatedButton(
                    onPressed: deleteLoading
                        ? null
                        : () {
                            Navigator.of(context).pop();
                          },
                    style: ButtonStyle(
                      // Set No button background colour based on current theme
                      backgroundColor: MaterialStateProperty.all<Color>(
                        themeService.getCurrentTheme() == 'light'
                            ? Color.fromARGB(255, 125, 227, 88)
                            : Color.fromARGB(255, 100, 199, 65),
                      ),
                    ),
                    child: Text(
                      'No',
                      style: TextStyle(
                        // Set font based on body font set by user/default font
                        fontFamily: themeService.getCurrentBodyFont(),
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                // Delete hotel when user presses "Yes" button and set deleteLoading to true as the hotel deletes
                ElevatedButton(
                  onPressed: deleteLoading
                      ? null
                      : () {
                          setState(() {
                            deleteLoading = true;
                          });
                          // Delete hotel and handle errors
                          fbService.deleteHotel(owner).then((value) {
                            // Remove hotel from user info and handle errors
                            fbService.removeHotelFromUser(owner).then((value) {
                              setState(() {
                                deleteLoading = false;
                              });
                              // Close dialog and navigate to HotelDeletedScreen to inform user that hotel has been successfully deleted
                              Navigator.of(context).pop();
                              Navigator.of(context).pushReplacementNamed(
                                  HotelDeletedScreen.routeName);
                            }).onError((error, stackTrace) {
                              // If there is an error removing hotel from user info, display a snackbar to inform user that something went wrong
                              setState(() {
                                deleteLoading = false;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  // Set snackbar background colour based on current theme
                                  backgroundColor: themeService
                                              .getCurrentTheme() ==
                                          "light"
                                      ? const Color.fromARGB(255, 185, 252, 123)
                                      : const Color.fromARGB(255, 80, 158, 52),
                                  content: Text(
                                    'Something went wrong with deleting the hotel from your user information :( Please try again.',
                                    style: TextStyle(
                                      // Set font based on body font set by user/default font
                                      fontFamily:
                                          themeService.getCurrentBodyFont(),
                                      fontSize: 23,
                                      // Set text colour based on current theme
                                      color: themeService.getCurrentTheme() ==
                                              'light'
                                          ? Colors.black
                                          : Colors.white,
                                    ),
                                  ),
                                ),
                              );
                            });
                          }).onError((error, stackTrace) {
                            // If there is an error deleting hotel, display a snackbar to inform user that something went wrong
                            setState(() {
                              deleteLoading = false;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                // Set snackbar background colour based on current theme
                                backgroundColor: themeService
                                            .getCurrentTheme() ==
                                        "light"
                                    ? const Color.fromARGB(255, 185, 252, 123)
                                    : const Color.fromARGB(255, 80, 158, 52),
                                content: Text(
                                  'Something went wrong with deleting the hotel :( Please try again.',
                                  style: TextStyle(
                                    // Set font based on body font set by user/default font
                                    fontFamily:
                                        themeService.getCurrentBodyFont(),
                                    fontSize: 23,
                                    // Set text colour based on current theme
                                    color: themeService.getCurrentTheme() ==
                                            'light'
                                        ? Colors.black
                                        : Colors.white,
                                  ),
                                ),
                              ),
                            );
                          });
                        },
                  style: ElevatedButton.styleFrom(
                    // Set Yes button background colour based on current theme
                    backgroundColor: themeService.getCurrentTheme() == 'light'
                        ? Colors.red
                        : Color.fromARGB(255, 198, 17, 17),
                  ),
                  child: Text(
                    'Yes',
                    style: TextStyle(
                      // Set font based on body font set by user/default font
                      fontFamily: themeService.getCurrentBodyFont(),
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 15),
        child: SingleChildScrollView(
            child: Column(
          children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // Heading for email details
              Text(
                "Email",
                style: TextStyle(
                  // Set font based on body font set by user/default font
                  fontFamily: themeService.getCurrentBodyFont(),
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  // Set text colour based on current theme
                  color: themeService.getCurrentTheme() == "light"
                      ? Colors.black
                      : Colors.white,
                ),
              ),
              // User's email
              Text(
                email!,
                style: TextStyle(
                  // Set font based on body font set by user/default font
                  fontFamily: themeService.getCurrentBodyFont(),
                  fontSize: 25,
                  // Set text colour based on current theme
                  color: themeService.getCurrentTheme() == "light"
                      ? Colors.black
                      : Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              // Check if user is logged in using email and password
              user!.providerData[0].providerId == "password"
                  // Button to change password
                  ? ElevatedButton(
                      // Navigates to Update Password page when pressed for user to change password
                      // pushNamed is used so that when user can backtrack from Update Password page, or return to Account page from Password Updated page once they changed their password
                      onPressed: () {
                        debugPrint(user!.providerData[0].providerId);
                        Navigator.of(context)
                            .pushNamed(UpdatePasswordScreen.routeName);
                      },
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          backgroundColor:
                              // Set Change Password button background colour based on current theme
                              themeService.getCurrentTheme() == "light"
                                  ? const Color.fromARGB(255, 176, 252, 179)
                                  : const Color.fromARGB(255, 127, 188, 168),
                          // Button is a rectangle
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0),
                          )),
                      // Prompt for user to click on this button if they want to change their password
                      child: Text(
                        "Change password",
                        style: TextStyle(
                            color: Colors.black,
                            // Set font based on body font set by user/default font
                            fontFamily: themeService.getCurrentBodyFont(),
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  // If the user is not logged in using email and password they are logged in using gmail
                  // Do not give the option to change password as they are using their gmail password
                  : const SizedBox(),
              const SizedBox(height: 15),
              // Log out button
              Center(
                  child: ElevatedButton(
                      // pushReplacementNamed used to navigate to Logged Out page to preevent user from re-entering Account page once logged out
                      onPressed: () {
                        logOut(context);
                      },
                      style: ElevatedButton.styleFrom(
                          // Set Log Out button background colour based on current theme
                          backgroundColor:
                              themeService.getCurrentTheme() == "light"
                                  ? Theme.of(context).colorScheme.inversePrimary
                                  : const Color.fromARGB(255, 109, 179, 152),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50))),
                      // Prompt for user to click on this button if they want to change their password
                      child: Text(
                        "Log Out",
                        style: TextStyle(
                          // Set font based on body font set by user/default font
                          fontFamily: themeService.getCurrentBodyFont(),
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ))),
              const SizedBox(height: 30),
              // Heading for user's property details
              Text(
                "Property",
                style: TextStyle(
                  // Set font based on body font set by user/default font
                  fontFamily: themeService.getCurrentBodyFont(),
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  // Set text colour based on current theme
                  color: themeService.getCurrentTheme() == "light"
                      ? Colors.black
                      : Colors.white,
                ),
              ),
            ]),
            // StreamBuilder to display user's hotel details if they own a hotel, or prompt to add a property if they do not
            StreamBuilder<dynamic>(
              stream: fbService.getHotelByOwner(email!),
              builder: (context, snapshot) {
                // If the connection is waiting, show a circular progress indicator to indicate loading
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                  // If there is an error, show a text to inform user that there was an error and what the error was
                } else if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      children: [
                        Text("Error :( \n",
                            style: TextStyle(
                              // Set font based on heading set by user/default font
                              fontFamily: themeService.getCurrentHeadingFont(),
                              // Set font size based on heading set by user/default font so that headings are consistent
                              fontSize: themeService.getCurrentHeadingFont() ==
                                      "Nunito Sans"
                                  ? 40
                                  : 42,
                              fontWeight: FontWeight.bold,
                              // Set error text colour based on current theme
                              color: themeService.getCurrentTheme() == "light"
                                  ? Colors.black
                                  : Colors.white,
                            )),
                        Text(
                          snapshot.error.toString(),
                          style: TextStyle(
                            // Set font based on body font set by user/default font
                            fontFamily: themeService.getCurrentBodyFont(),
                            fontSize: 25,
                            // Set error text colour based on current theme
                            color: themeService.getCurrentTheme() == "light"
                                ? Colors.black
                                : Colors.white,
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  // Store hotel details in hotel variable
                  hotel = snapshot.data;
                  // Check if the hotel is not null, meaning if the user has a hotel
                  if (hotel != null) {
                    // If the user has a hotel, display the hotel details in a card on top of a Delete and Edit button
                    return Column(
                      children: [
                        Column(
                          children: [
                            // If hotel card is clicked, navigate to the hotel's details page
                            Padding(
                              padding: const EdgeInsets.only(right: 11),
                              child: GestureDetector(
                                onTap: () => Navigator.of(context).pushNamed(
                                  HotelDetailsScreen.routeName,
                                  arguments: email,
                                ),
                                // Hotel's details represented in a cards
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(7),
                                  ),
                                  // Set card background colour based on current theme
                                  color: themeService.getCurrentTheme() ==
                                          'light'
                                      ? const Color.fromARGB(219, 181, 248, 195)
                                      : const Color.fromARGB(
                                          255, 120, 183, 158),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Hotel cover image
                                      ClipRRect(
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(7),
                                          bottomLeft: Radius.circular(7),
                                        ),
                                        child: Image.network(
                                          hotel!.image,
                                          width: 150,
                                          height: 120,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      // Hotel information (name, location, rating)
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(height: 5),
                                            // Hotel name as title
                                            Text(
                                              hotel!.name,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                // Set font based on body font set by user/default font
                                                fontFamily: themeService
                                                    .getCurrentBodyFont(),
                                                fontSize: 25,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
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
                                                fontFamily: themeService
                                                    .getCurrentBodyFont(),
                                                fontSize: 18,
                                                fontStyle: FontStyle.italic,
                                                color: Colors.black,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            //  Star rating represented as the number of stars in a row
                                            Row(
                                              children: [
                                                for (int i = 0;
                                                    i < hotel!.rating;
                                                    i++)
                                                  Image.asset("images/star.png",
                                                      width: 25),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            // Delete and Edit buttons in a row for user to delete their property or modify its details
                            Row(
                              children: [
                                // Delete button
                                ElevatedButton(
                                    // Show dialog to confirm if user wants to delete hotel when pressed
                                    onPressed: () {
                                      deleteHotel(email!);
                                    },
                                    style: ElevatedButton.styleFrom(
                                        // Set Delete button background colour based on current theme
                                        backgroundColor: themeService
                                                    .getCurrentTheme() ==
                                                "light"
                                            ? Color.fromARGB(255, 219, 10, 10)
                                            : Color.fromARGB(255, 181, 15, 15),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 40),
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(0),
                                                bottomRight: Radius.circular(0),
                                                topLeft: Radius.circular(30),
                                                bottomLeft:
                                                    Radius.circular(30)))),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.delete,
                                            color: Colors.white, size: 30),
                                        const SizedBox(width: 5),
                                        Text(
                                          "Delete",
                                          style: TextStyle(
                                            // Set font based on body font set by user/default font
                                            fontFamily: themeService
                                                .getCurrentBodyFont(),
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    )),
                                // Edit button
                                ElevatedButton(
                                    // Navigate to Editing Options page when pressed to allow user to edit their property details
                                    onPressed: () =>
                                        Navigator.of(context).pushNamed(
                                          EditingOptionsScreen.routeName,
                                          arguments: email,
                                        ),
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            // Set Edit button background colour based on current theme
                                            themeService.getCurrentTheme() ==
                                                    "light"
                                                ? const Color.fromRGBO(
                                                    125, 227, 88, 1)
                                                : const Color.fromARGB(
                                                    255, 109, 179, 152),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 50),
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(0),
                                                bottomLeft: Radius.circular(0),
                                                topRight: Radius.circular(30),
                                                bottomRight:
                                                    Radius.circular(30)))),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.edit,
                                            color: Colors.black, size: 30),
                                        const SizedBox(width: 5),
                                        Text(
                                          "Edit",
                                          style: TextStyle(
                                            // Set font based on body font set by user/default font
                                            fontFamily: themeService
                                                .getCurrentBodyFont(),
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    )),
                              ],
                            )
                          ],
                        ),
                      ],
                    );
                  } else {
                    // If the user has no hotel, display "No hotels owned" and a button to add a property
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Text indicating user has no property
                        Padding(
                          // Align "No hotels owned" text with heading
                          padding: EdgeInsets.only(
                              right:
                                  themeService.getCurrentBodyFont() == 'Arial'
                                      ? 187
                                      : 170),
                          child: Text(
                            "No hotels owned",
                            style: TextStyle(
                              // Set font based on body font set by user/default font
                              fontFamily: themeService.getCurrentBodyFont(),
                              fontSize: 25,
                              // Set text colour based on current theme
                              color: themeService.getCurrentTheme() == "light"
                                  ? Colors.black
                                  : Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Button for user to add a property if they have none
                        ElevatedButton(
                          onPressed: () => Navigator.of(context).pushNamed(
                              AddHotelBasicDetailsScreen.routeName,
                              arguments: email),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            // Set Add Your Property button background colour based on current theme
                            backgroundColor:
                                themeService.getCurrentTheme() == "light"
                                    ? const Color.fromARGB(255, 176, 252, 179)
                                    : const Color.fromARGB(255, 127, 188, 168),
                            // Button is a rectangle
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0)),
                          ),
                          // Prompt for user to click on this button if they want to add a property
                          child: Text(
                            "Add Your Property",
                            style: TextStyle(
                              // Set font based on body font set by user/default font
                              fontFamily: themeService.getCurrentBodyFont(),
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                }
              },
            ),
          ],
        )));
  }
}
