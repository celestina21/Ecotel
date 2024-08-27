// ignore_for_file: prefer_const_constructors_in_immutables, use_key_in_widget_constructors, prefer_is_empty

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:sohleecelest_2301028c_pc09/models/hotel.dart';
import 'package:sohleecelest_2301028c_pc09/screens/hotel_updated_screen.dart';
import 'package:sohleecelest_2301028c_pc09/services/firebase_service.dart';
import 'package:sohleecelest_2301028c_pc09/services/theme_service.dart';

class EditCertificationsScreen extends StatefulWidget {
  static const String routeName = '/edit-certifications';

  @override
  State<EditCertificationsScreen> createState() =>
      _EditCertificationsScreenState();
}

class _EditCertificationsScreenState extends State<EditCertificationsScreen> {
  // Get the FirebaseService instance as fbService to access updateHotel() and getCurrentUser() functions
  final FirebaseService fbService = GetIt.instance<FirebaseService>();
  // Get the ThemeService instance as themeService to access getCurrentTheme() function
  final ThemeService themeService = GetIt.instance<ThemeService>();

  // Define email variable to retrieve current user's email
  String? email;
  // Define hotel variable to retrieve current hotel certifications
  Hotel? hotel;
  // List of certifications that will be the updated value for certifications attribute in hotel object if user confirms changes
  // Used to display what certifications will be updated to after the user's changes without changing the database
  List<String> updatedCertifications = [];

  // Set updatedCertifications to initially be the hotel's current list of certifications
  @override
  void initState() {
    super.initState();
    // Get the current user's email then get the hotel object with the same owner email
    email = fbService.getCurrentUser()!.email;
    fbService.getHotelByOwner(email!).listen((value) {
      setState(() {
        hotel = value;
        updatedCertifications = hotel!.certifications.toList();
      });
    });
  }

  // Text controller to retrieve certification name entered by user for validation
  TextEditingController certificationController = TextEditingController();

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

  // Function to validate certification name entered and if valid, add the certification to updatedCertifications for display
  void addCertificate() {
    // Hide keyboard
    FocusScope.of(context).unfocus();

    // Retrieve certification name entered by user without leading and trailing white spaces
    String newCertification = certificationController.text.trim();

    // Checks if the certifcation name entered is valid
    if (!updatedCertifications.contains(newCertification) &&
        newCertification.length > 9 &&
        newCertification.length < 61 &&
        updatedCertifications.length < 10) {
      // If it is valid, add the new certificate into updatedCertifications list and clear the text field
      setState(() {
        updatedCertifications.add(newCertification);
        certificationController.clear();
      });
    } // If the user did not enter any certification, show a banner to tell them to enter a certification name
    else if (newCertification.length == 0) {
      showMaterialBanner('Please enter a certification name.');
      // If the certification name is less than 10 characters long, it is too short and invalid
      // Show a banner to let user know that the certification name they entered was too short
    } else if (newCertification.length < 10) {
      showMaterialBanner(
          'Name entered is too short! Enter a certification name with at least 10 characters');
      // If the certification name is more than 60 characters long, it is too long and invalid
      // Show a banner to let user know that the certification name they entered was too long
    } else if (newCertification.length > 60) {
      showMaterialBanner(
          'Name entered is too long! Enter a certification name with at most 60 characters');
      // If there are 10 certifications in updatedCertifications, use a banner to notify the user that adding one more would exceed the limit
    } else if (updatedCertifications.length == 10) {
      showMaterialBanner(
          'Cannot add more than 10 certifications. Delete a certification to add a new one.');
      // If the certification name entered already exists in the list of certifications, show a banner to let the user know that they cannot add a duplicate
    } else {
      showMaterialBanner(
          'Certification already exists! Please enter a different certification name.');
    }
  }

  // Function to delete certification from updatedCertifications
  void deleteCertificate(String certification) {
    setState(() {
      // Remove dismissed certification from list of hotel's certifications
      updatedCertifications.remove(certification);
    });
    // Notify user that they can undo all changes by going out of the edit page and coming back in
    showMaterialBanner(
        'You can undo changes by clicking on the back button and re-entering the certifications section!');
  }

  // Function to trigger onSaved function. Saves all certifications entered then navigates to the next page of the form
  void updateCertificates() {
    // Hide keyboard after saving certification name
    FocusScope.of(context).unfocus();
    // Update hotel's list of certifications with updatedCertifications
    fbService
        .updateHotel(
            hotel!.owner,
            hotel!.name,
            hotel!.rating,
            hotel!.country,
            hotel!.stateProvince,
            hotel!.city,
            hotel!.address,
            updatedCertifications,
            hotel!.practices,
            hotel!.image)
        .then((value) {
      // Show SnackBar to notify user that certifications were updated successfully
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        // Set snackbar background colour based on current theme
        backgroundColor: themeService.getCurrentTheme() == "light"
            ? const Color.fromARGB(255, 185, 252, 123)
            : const Color.fromARGB(255, 80, 158, 52),
        content: Text(
          "Certifications Updated Successfully!",
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
          "Certifications could not be updated :( Please try again.",
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
        appBar: AppBar(
          // Set app bar back button based on current theme
          foregroundColor: themeService.getCurrentTheme() == 'light'
              ? Colors.black
              : Colors.white,
          // Set app bar background colour based on current theme
          backgroundColor: themeService.getCurrentTheme() == 'light'
              ? Theme.of(context).colorScheme.inversePrimary
              : const Color.fromARGB(255, 34, 34, 34),
          // Title of the page to enter certifications
          title: Text('Certifications',
              style: TextStyle(
                // Set font based on heading set by user/default font
                fontFamily: themeService.getCurrentHeadingFont(),
                // Set font size based on heading set by user/default font so that headings are consistent
                fontSize: themeService.getCurrentHeadingFont() == "Nunito Sans"
                    ? 40
                    : 42,
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
                      // Button to make changes to certifications
                      onPressed: () {
                        updateCertificates();
                      },
                      style: ElevatedButton.styleFrom(
                          // Set Confirm Changes button colour based on current theme
                          backgroundColor:
                              themeService.getCurrentTheme() == "light"
                                  ? const Color.fromRGBO(125, 227, 88, 1)
                                  : const Color.fromARGB(255, 109, 179, 152)),
                      child: Text(
                        "Confirm Changes",
                        style: TextStyle(
                          // Set font based on body font set by user/default font
                          fontFamily: themeService.getCurrentBodyFont(),
                          fontSize: 23,
                          color: Colors.black,
                        ),
                      )),
                  // Form field to enter certification name
                  TextFormField(
                    // Set colour of cursor based on current theme
                    cursorColor: themeService.getCurrentTheme() == 'light'
                        ? const Color.fromARGB(255, 20, 123, 23)
                        : const Color.fromARGB(255, 255, 251, 254),
                    controller: certificationController,
                    style: TextStyle(
                        // Set font based on body font set by user/default font
                        fontFamily: themeService.getCurrentBodyFont(),
                        fontSize: 23,
                        // Set text colour based on current theme
                        color: themeService.getCurrentTheme() == 'light'
                            ? Colors.black
                            : Colors.white),
                    decoration: InputDecoration(
                      // Hint text to tell user to enter a certification name
                      hintText: "Name of Certification",
                      hintStyle: TextStyle(
                          // Set font based on body font set by user/default font
                          fontFamily: themeService.getCurrentBodyFont(),
                          fontSize: 23,
                          // Set hint text colour based on current theme
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
                    child: ElevatedButton(
                      // Button to validate and add the entered certificate to updatedCertifications
                      onPressed: () {
                        addCertificate();
                      },
                      style: ElevatedButton.styleFrom(
                          // Set Add Certificate button colour based on current theme
                          backgroundColor:
                              themeService.getCurrentTheme() == 'light'
                                  ? const Color.fromARGB(219, 181, 248, 195)
                                  : const Color.fromARGB(255, 120, 183, 158),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 0)),
                      child: Text(
                        'Add Certificate',
                        style: TextStyle(
                          // Set font based on body font set by user/default font
                          fontFamily: themeService.getCurrentBodyFont(),
                          fontSize: themeService.getCurrentBodyFont() == "Arial"
                              ? 23
                              : 22,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // List of certifications which were already entered and validated
            // Displays updatedCertifications list that will reflect what the hotel's certifications list looks like after update
            Expanded(
              child: ListView.builder(
                itemCount: updatedCertifications.length,
                itemBuilder: (context, index) {
                  var certification = updatedCertifications[index];
                  return Dismissible(
                    key: Key(certification),
                    // When user swipes left on a certification, it is deleted from the list of updatedCertifications
                    onDismissed: (direction) {
                      deleteCertificate(certification);
                    },
                    // Background of the certification tile when swiped left with trash icon to indicate that the certification will be deleted
                    background: Container(
                      color: Colors.red,
                      padding: const EdgeInsets.only(left: 340),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    // Tile representing each certification by displaying certification name
                    child: ListTile(
                      title: Text(
                        certification,
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
                    ),
                  );
                },
              ),
            ),
          ],
        ));
  }
}
