// ignore_for_file: prefer_const_constructors_in_immutables, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:sohleecelest_2301028c_pc09/services/theme_service.dart';

class HotelUpdatedScreen extends StatelessWidget {
  static const String routeName = '/hotel-updated';

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
            "Congratulations!",
            style: TextStyle(
              // Set font based on heading set by user/default font
              fontFamily: themeService.getCurrentHeadingFont(),
              // Set font size based on heading set by user/default font so that headings are consistent
              fontSize: themeService.getCurrentHeadingFont() == "Nunito Sans"
                  ? 40
                  : 42,
              fontWeight: FontWeight.bold,
              // Set title colour based on current theme
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
              // Split text into three lines: "Thanks for contributing", "to our efforts for", and "sustainable travel!""
              "Thanks for keeping \nfellow users up to date! ",
              textAlign: TextAlign.center,
              style: TextStyle(
                // Set font based on body font set by user/default font
                fontFamily: themeService.getCurrentBodyFont(),
                fontSize: 30,
                // Set title colour based on current theme
                color: themeService.getCurrentTheme() == 'light'
                    ? Colors.black
                    : Colors.white,
                // Adjust space between lines
                height: 1.2,
              ),
            ),
            Image.asset("images/update_hotel_success.png", width: 400),
            const SizedBox(height: 10),
            // Button to go back to Editing screen
            ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                    // Set Back To Editing button background colour based on current theme
                    backgroundColor: themeService.getCurrentTheme() == "light"
                        ? Theme.of(context).colorScheme.inversePrimary
                        : const Color.fromARGB(255, 109, 179, 152)),
                child: Text(
                  "Back to Editing",
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
