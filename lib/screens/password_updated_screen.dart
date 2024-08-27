// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:sohleecelest_2301028c_pc09/services/theme_service.dart';

class PasswordUpdatedScreen extends StatelessWidget {
  static String routeName = '/password-updated';

  // Get the ThemeService instance as themeService to access getCurrentTheme() function
  final ThemeService themeService = GetIt.instance<ThemeService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Set background color based on the current theme
      backgroundColor: themeService.getCurrentTheme() == 'light'
          ? const Color.fromARGB(255, 255, 251, 254)
          : const Color.fromARGB(255, 109, 108, 108),
      appBar: AppBar(
        // Set back arrow colour based on current theme
        foregroundColor: themeService.getCurrentTheme() == 'light'
            ? Colors.black
            : Colors.white,
        // Set app bar background colour based on current theme
        backgroundColor: themeService.getCurrentTheme() == 'light'
            ? Theme.of(context).colorScheme.inversePrimary
            : const Color.fromARGB(255, 34, 34, 34),
        title: Text(
          "Change Password",
          style: TextStyle(
            // Set font based on heading set by user/default font
            fontFamily: themeService.getCurrentHeadingFont(),
            // Set font size based on heading set by user/default font so that headings are consistent
            fontSize:
                themeService.getCurrentHeadingFont() == "Nunito Sans" ? 35 : 37,
            fontWeight: FontWeight.bold,
            // Set text color based on current theme
            color: themeService.getCurrentTheme() == 'light'
                ? Colors.black
                : Colors.white,
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            // Illustration for Updated Password screen
            Image.asset(
              "images/password_updated.png",
              height: 290,
            ),
            // Text to inform user that password has been updated
            Text(
              "Password updated!",
              style: TextStyle(
                // Set font based on body font set by user/default font
                fontFamily: themeService.getCurrentBodyFont(),
                fontSize: 35,
                // Set text color based on current theme
                color: themeService.getCurrentTheme() == 'light'
                    ? Colors.black
                    : Colors.white,
              ),
            ),
            // Instruction for user to backtrack to Account page
            Text(
              "You may now return to Account",
              style: TextStyle(
                // Set font based on body font set by user/default font
                fontFamily: themeService.getCurrentBodyFont(),
                fontSize: 27,
                // Set text color based on current theme
                color: themeService.getCurrentTheme() == 'light'
                    ? Colors.black
                    : Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
