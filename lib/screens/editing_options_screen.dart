// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:sohleecelest_2301028c_pc09/screens/edit_basic_details_screen.dart';
import 'package:sohleecelest_2301028c_pc09/screens/edit_certifications_screen.dart';
import 'package:sohleecelest_2301028c_pc09/screens/edit_cover_screen.dart';
import 'package:sohleecelest_2301028c_pc09/screens/edit_practices_screen.dart';
import 'package:sohleecelest_2301028c_pc09/services/theme_service.dart';

class EditingOptionsScreen extends StatelessWidget {
  static const String routeName = '/editing-options';

  // Initialise ThemeService object to access getThemeStream() and loadTheme() functions
  final ThemeService themeService = GetIt.instance<ThemeService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // Set background color of the screen based on the current theme
        backgroundColor: themeService.getCurrentTheme() == 'light'
            ? const Color.fromARGB(255, 255, 251, 254)
            : const Color.fromARGB(255, 109, 108, 108),
        appBar: AppBar(
          // Set app bar back button colour based on the current theme
          foregroundColor: themeService.getCurrentTheme() == 'light'
              ? Colors.black
              : Colors.white,
          // Set app bar background colour based on the current theme
          backgroundColor: themeService.getCurrentTheme() == 'light'
              ? Theme.of(context).colorScheme.inversePrimary
              : const Color.fromARGB(255, 34, 34, 34),
          title: Text(
            "Editing",
            style: TextStyle(
              // Set font based on heading set by user/default font
              fontFamily: themeService.getCurrentHeadingFont(),
              // Set font size based on heading set by user/default font so that headings are consistent
              fontSize: themeService.getCurrentHeadingFont() == "Nunito Sans"
                  ? 40
                  : 42,
              fontWeight: FontWeight.bold,
              // Set app bar title text colour based on the current theme
              color: themeService.getCurrentTheme() == 'light'
                  ? Colors.black
                  : Colors.white,
            ),
          ),
        ),
        body: Column(
          children: [
            const SizedBox(height: 20),
            Text(
              "Which set of details would \nyou like to change?",
              textAlign: TextAlign.center,
              style: TextStyle(
                // Set font based on body font set by user/default font
                fontFamily: themeService.getCurrentBodyFont(),
                fontSize: 30,
                // Set text colour based on the current theme
                color: themeService.getCurrentTheme() == 'light'
                    ? Colors.black
                    : Colors.white,
                height: 1.2,
              ),
            ),
            // List view of every set of details that can be changed: Basic Details, Certifications, Sustainability Practices and Cover Image
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  // If Basic Details card is tapped, navigates to EditBasicDetailsScreen to edit hotel's basic details
                  GestureDetector(
                    onTap: () => Navigator.of(context).pushNamed(
                      EditBasicDetailsScreen.routeName,
                    ),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                      ),
                      // Set card colour based on the current theme
                      color: themeService.getCurrentTheme() == 'light'
                          ? const Color.fromARGB(219, 181, 248, 195)
                          : const Color.fromARGB(255, 120, 183, 158),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 20, horizontal: 15),
                            // Basic Details icon
                            child: Image.asset(
                              "images/basic_details.png",
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Basic Details",
                                    style: TextStyle(
                                      // Set font based on body font set by user/default font
                                      fontFamily:
                                          themeService.getCurrentBodyFont(),
                                      fontSize: 25,
                                    ),
                                  ),
                                  // List of information under Basic Details
                                  Text(
                                    "- Name",
                                    style: TextStyle(
                                      // Set font based on body font set by user/default font
                                      fontFamily:
                                          themeService.getCurrentBodyFont(),
                                      fontSize: 18,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    "- Star Rating",
                                    style: TextStyle(
                                      // Set font based on body font set by user/default font
                                      fontFamily:
                                          themeService.getCurrentBodyFont(),
                                      fontSize: 18,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    "- Location Details",
                                    style: TextStyle(
                                      // Set font based on body font set by user/default font
                                      fontFamily:
                                          themeService.getCurrentBodyFont(),
                                      fontSize: 18,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  // If Certifications card is tapped, navigates to EditCertificationssScreen to edit hotel's certifications
                  GestureDetector(
                    onTap: () => Navigator.of(context).pushNamed(
                      EditCertificationsScreen.routeName,
                    ),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                      ),
                      // Set card colour based on the current theme
                      color: themeService.getCurrentTheme() == 'light'
                          ? const Color.fromARGB(219, 181, 248, 195)
                          : const Color.fromARGB(255, 120, 183, 158),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 15, right: 15, top: 20, bottom: 20),
                            // Certifications icon
                            child: Image.asset(
                              "images/certifications.png",
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Certifications",
                                    style: TextStyle(
                                      // Set font based on body font set by user/default font
                                      fontFamily:
                                          themeService.getCurrentBodyFont(),
                                      fontSize: 25,
                                    ),
                                  ),
                                  // List of information under Certifications
                                  Text(
                                    "- Certification Name",
                                    style: TextStyle(
                                      // Set font based on body font set by user/default font
                                      fontFamily:
                                          themeService.getCurrentBodyFont(),
                                      fontSize: 18,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  // If Sustainability Practices card is tapped, navigates to EditPracticessScreen to edit hotel's sustainability practices
                  GestureDetector(
                    onTap: () => Navigator.of(context).pushNamed(
                      EditPracticesScreen.routeName,
                    ),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                      ),
                      // Set card colour based on the current theme
                      color: themeService.getCurrentTheme() == 'light'
                          ? const Color.fromARGB(219, 181, 248, 195)
                          : const Color.fromARGB(255, 120, 183, 158),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 15, right: 0, top: 30),
                            // Sustainable Practices icon
                            child: Image.asset(
                              "images/sustainable_practices.png",
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Sustainability Practices",
                                    style: TextStyle(
                                      // Set font based on body font set by user/default font
                                      fontFamily:
                                          themeService.getCurrentBodyFont(),
                                      fontSize: 25,
                                    ),
                                  ),
                                  // List of information under Sustainability Practices
                                  Text(
                                    "- Name of Practice",
                                    style: TextStyle(
                                      // Set font based on body font set by user/default font
                                      fontFamily:
                                          themeService.getCurrentBodyFont(),
                                      fontSize: 18,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    "- Description",
                                    style: TextStyle(
                                      // Set font based on body font set by user/default font
                                      fontFamily:
                                          themeService.getCurrentBodyFont(),
                                      fontSize: 18,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  // If Cover Image card is tapped, navigates to EditCoverScreen to edit hotel's cover image
                  GestureDetector(
                    onTap: () => Navigator.of(context)
                        .pushNamed(EditCoverScreen.routeName),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                      ),
                      // Set card colour based on the current theme
                      color: themeService.getCurrentTheme() == 'light'
                          ? const Color.fromARGB(219, 181, 248, 195)
                          : const Color.fromARGB(255, 120, 183, 158),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 20, horizontal: 15),
                            // Cover Image icon
                            child: Image.asset(
                              "images/cover_image.png",
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Cover Image",
                                    style: TextStyle(
                                      // Set font based on body font set by user/default font
                                      fontFamily:
                                          themeService.getCurrentBodyFont(),
                                      fontSize: 25,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
