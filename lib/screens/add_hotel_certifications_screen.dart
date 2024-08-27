// ignore_for_file: prefer_is_empty, must_be_immutable, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:sohleecelest_2301028c_pc09/models/hotel.dart';
import 'package:sohleecelest_2301028c_pc09/screens/add_hotel_practices_screen.dart';
import 'package:sohleecelest_2301028c_pc09/services/theme_service.dart';

class AddHotelCertificationsScreen extends StatefulWidget {
  static String routeName = '/add-hotel-certifications';

  // Define hotel variable to store Hotel object passed into this page
  Hotel hotel;

  AddHotelCertificationsScreen({required this.hotel});

  @override
  State<AddHotelCertificationsScreen> createState() =>
      _AddHotelCertificationsScreenState();
}

class _AddHotelCertificationsScreenState
    extends State<AddHotelCertificationsScreen> {
  // Text controller to retrieve certification name entered by user for validation
  TextEditingController certificationController = TextEditingController();
  // Get the ThemeService instance as themeService to access getCurrentTheme() function
  final ThemeService themeService = GetIt.instance<ThemeService>();

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

  // Function to validate certification name entered and if valid, add the certification to hotel's list of certificates
  void addCertificate() {
    // Hide keyboard
    FocusScope.of(context).unfocus();

    // Retrieve certification name entered by user without leading and trailing white spaces
    String newCertification = certificationController.text.trim();

    // Checks if the certifcation name entered is valid
    if (!widget.hotel.certifications.contains(newCertification) &&
        newCertification.length > 9 &&
        newCertification.length < 61 &&
        widget.hotel.certifications.length < 10) {
      // Clear the text field and let the page rebuild to display the new certification after adding it
      setState(() {
        // If it is valid, add the new certificate into hotel's certifications list
        widget.hotel.certifications.add(newCertification);
        certificationController.clear();
      });
      // If the user did not enter any certification, show a banner to tell them to enter a certification name
    } else if (newCertification.length == 0) {
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
      // If 10 certifications had already been added, use a banner to notify the user that adding one more would exceed the limit
    } else if (widget.hotel.certifications.length == 10) {
      showMaterialBanner(
          'Cannot add more than 10 certifications. Delete a certification to add a new one.');
      // Else, the certificate entered is a duplicate and a banner is shown to notify the user that they cannot enter duplicates
    } else {
      showMaterialBanner(
          'Certificate already exists! Please enter a different certification.');
    }
  }

  // Function to delete certification from hotel's list of certifications
  void deleteCertificate(String certification) {
    // Remove dismissed certification from list of hotel's certifications
    widget.hotel.certifications.remove(certification);

    // Rebuild page to display changes
    setState(() {});
  }

  // Function to navigate to next page. This function is called when user clicks on the "Submit Certifications" button
  void submitCertificates() {
    // Hide keyboard
    FocusScope.of(context).unfocus();

    // Show SnackBar to inform user that the certificates have been saved successfully
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      // Set snackbar background colour based on current theme
      backgroundColor: themeService.getCurrentTheme() == "light"
          ? const Color.fromARGB(255, 185, 252, 123)
          : const Color.fromARGB(255, 80, 158, 52),
      content: Text(
        "Certificates Saved Successfully!",
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

    // Navigate to the next page to fill in hotel's sustainable practices
    // Pass in hotel object to the next page to build upon current hotel object which had basic details and certifications entered
    Navigator.of(context).pushReplacementNamed(
        AddHotelPracticesScreen.routeName,
        arguments: widget.hotel);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Set screen background colour based on current theme
      backgroundColor: themeService.getCurrentTheme() == 'light'
          ? const Color.fromARGB(255, 255, 251, 254)
          : const Color.fromARGB(255, 109, 108, 108),
      appBar: AppBar(
        // Remove back button from app bar
        automaticallyImplyLeading: false,
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
                    onPressed: () {
                      // Navigates to next page to fill in hotel's sustainable practices, passing the certifications list
                      submitCertificates();
                    },
                    style: ElevatedButton.styleFrom(
                        // Set Submit Certifications button colour based on current theme
                        backgroundColor:
                            themeService.getCurrentTheme() == "light"
                                ? const Color.fromRGBO(125, 227, 88, 1)
                                : const Color.fromARGB(255, 109, 179, 152)),
                    child: Text(
                      "Submit Certifications",
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
                // Button to validate and add the entered certificate to the hotel's list of certifications (hotel.certifications)
                Padding(
                  padding: const EdgeInsets.only(left: 170, right: 0),
                  child: ElevatedButton(
                    onPressed: () {
                      addCertificate();
                    },
                    style: ElevatedButton.styleFrom(
                        // Set Add Certificate button colour based on current theme
                        backgroundColor:
                            themeService.getCurrentTheme() == 'light'
                                ? const Color.fromARGB(219, 181, 248, 195)
                                : const Color.fromARGB(255, 120, 183, 158),
                        // Set padding for the button based on the body font set by user/default font
                        padding: EdgeInsets.symmetric(
                            horizontal:
                                themeService.getCurrentBodyFont() == 'Arial'
                                    ? 15
                                    : 10,
                            vertical: 0)),
                    child: Text(
                      'Add Certificate',
                      style: TextStyle(
                        // Set font based on body font set by user/default font
                        fontFamily: themeService.getCurrentBodyFont(),
                        // Set font size based on
                        fontSize: 23,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // List of certifications which were already entered and validated
          Expanded(
            child: ListView.builder(
              itemCount: widget.hotel.certifications.length,
              itemBuilder: (context, index) {
                var certification = widget.hotel.certifications[index];
                return Dismissible(
                  key: Key(certification),
                  // When user swipes left on a certification, it is deleted from the list of certifications
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
      ),
    );
  }
}
