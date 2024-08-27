// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:sohleecelest_2301028c_pc09/screens/home_screen.dart';
import 'package:sohleecelest_2301028c_pc09/services/theme_service.dart';

class HotelDeletedScreen extends StatelessWidget {
  static const String routeName = '/hotel-deleted';

  // Get the ThemeService instance as themeService to access getCurrentTheme() function
  final ThemeService themeService = GetIt.instance<ThemeService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // Set screen background colour based on current theme
        backgroundColor: themeService.getCurrentTheme() == 'light'
            ? const Color.fromARGB(255, 255, 251, 254)
            : const Color.fromARGB(255, 109, 108, 108),
        appBar: AppBar(
          // Set app bar background colour based on current theme
          backgroundColor: themeService.getCurrentTheme() == 'light'
              ? Theme.of(context).colorScheme.inversePrimary
              : const Color.fromARGB(255, 34, 34, 34),
          automaticallyImplyLeading: false,
          title: Text(
            "Hotel Deleted",
            style: TextStyle(
              // Set font based on heading set by user/default font
              fontFamily: themeService.getCurrentHeadingFont(),
              // Set font size based on heading set by user/default font so that headings are consistent
              fontSize: themeService.getCurrentHeadingFont() == "Nunito Sans"
                  ? 40
                  : 42,
              fontWeight: FontWeight.bold,
              // Set text colour based on current theme
              color: themeService.getCurrentTheme() == 'light'
                  ? Colors.black
                  : Colors.white,
            ),
          ),
        ),
        body: Center(
          child: Column(children: [
            const SizedBox(height: 20),
            Text(
              "We're sad to see this property go",
              textAlign: TextAlign.center,
              style: TextStyle(
                // Set font based on body font set by user/default font
                fontFamily: themeService.getCurrentBodyFont(),
                fontSize: 30,
                // Set text colour based on current theme
                color: themeService.getCurrentTheme() == 'light'
                    ? Colors.black
                    : Colors.white,
                // Adjust space between lines
                height: 1.2,
              ),
            ),
            Image.asset("images/hotel_deleted.png", width: 400),
            const SizedBox(height: 20),
            Text(
              // Split text into three lines: "We hope to see another", "sustainable property" and "of yours again!"
              "We hope to see another\nsustainable property \nof yours again!",
              textAlign: TextAlign.center,
              style: TextStyle(
                // Set font based on body font set by user/default font
                fontFamily: themeService.getCurrentBodyFont(),
                fontSize: 30,
                // Set text colour based on current theme
                color: themeService.getCurrentTheme() == 'light'
                    ? Colors.black
                    : Colors.white,
                // Adjust space between lines
                height: 1.2,
              ),
            ),
            const SizedBox(height: 20),
            // Button to go back to Home screen
            ElevatedButton(
                onPressed: () => Navigator.of(context)
                    .pushReplacementNamed(HomeScreen.routeName),
                style: ElevatedButton.styleFrom(
                    // Set Back to Home button colour based on current theme
                    backgroundColor: themeService.getCurrentTheme() == "light"
                        ? const Color.fromRGBO(125, 227, 88, 1)
                        : const Color.fromARGB(255, 109, 179, 152)),
                child: Text(
                  "Back to Home",
                  style: TextStyle(
                    // Set font based on body font set by user/default font
                    fontFamily: themeService.getCurrentBodyFont(),
                    fontSize: 23,
                    color: Colors.black,
                  ),
                )),
          ]),
        ));
  }
}
