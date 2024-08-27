// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:sohleecelest_2301028c_pc09/screens/home_screen.dart';
import 'package:sohleecelest_2301028c_pc09/screens/login_screen.dart';
import 'package:sohleecelest_2301028c_pc09/screens/registration_screen.dart';
import 'package:sohleecelest_2301028c_pc09/services/firebase_service.dart';
import 'package:sohleecelest_2301028c_pc09/services/theme_service.dart';

class LoggedOutScreen extends StatelessWidget {
  static String routeName = '/logged-out';
  // Initialise FirebaseService object to access googleLogin() function
  final FirebaseService fbService = GetIt.instance<FirebaseService>();
  // Initialise FirebaseService object to access getCurrentTheme() function
  final ThemeService themeService = GetIt.instance<ThemeService>();

  // Function to log in using Gmail account
  loginWithGoogle(context) {
    fbService.googleLogin().then((userInfo) {
      // Add user profile to database if user is new
      if (userInfo.additionalUserInfo!.isNewUser) {
        // Notify user of error adding them to the database if it occurs
        fbService.addUser(userInfo.user!.email!).onError((error, stackTrace) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            // Set snackbar background colour based on current theme
            backgroundColor: themeService.getCurrentTheme() == "light"
                ? const Color.fromARGB(255, 185, 252, 123)
                : const Color.fromARGB(255, 80, 158, 52),
            content: Text(
              "Error occured when adding your profile to our database. Please try again.",
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
      // If there is no error, show snack bar of success
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        // Set snackbar background colour based on current theme
        backgroundColor: themeService.getCurrentTheme() == "light"
            ? const Color.fromARGB(255, 185, 252, 123)
            : const Color.fromARGB(255, 80, 158, 52),
        content: Text(
          "Login successful!",
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
      // Navigate to Home page upon success login
      Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
      // Notify user of error in Google login if it occurs
    }).onError((error, stackTrace) {
      String message = error.toString();
      // If the error was actually just the popup being closed, do nothing
      if (message.contains("popup_closed")) {
        return;
      }
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
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Farewell text
            Text(
              // Split text into two lines: "We hope to" and "see you again"
              "We hope to\nsee you again",
              textAlign: TextAlign.center,
              style: TextStyle(
                // Set font based on body font set by user/default font
                fontFamily: themeService.getCurrentBodyFont(),
                fontSize: 35,
                // Set text colour based on current theme
                color: themeService.getCurrentTheme() == 'light'
                    ? Colors.black
                    : Colors.white,
                // Adjust space between lines
                height: 1.2,
              ),
            ),
            // Illustration for Logged Out screen
            Image.asset(
              "images/log_out.png",
              height: 270,
              width: 400,
            ),
            const SizedBox(height: 10),
            // Instructions for user to log in or use Gmail to log in if they want to re-enter the app
            Text("Need to return?",
                style: TextStyle(
                  // Set font based on body font set by user/default font
                  fontFamily: themeService.getCurrentBodyFont(),
                  fontSize: 30,
                  // Set text colour based on current theme
                  color: themeService.getCurrentTheme() == 'light'
                      ? Colors.black
                      : Colors.white,
                )),
            const SizedBox(height: 20),
            // Button to log in
            ElevatedButton(
              onPressed: () {
                // Enter login screen when button is pressed with option to backtrack to Logged Out screen if user changes their mind
                Navigator.of(context).pushNamed(LoginScreen.routeName);
              },
              style: ElevatedButton.styleFrom(
                  // Set Login button background colour based on current theme
                  backgroundColor: themeService.getCurrentTheme() == "light"
                      ? const Color.fromRGBO(125, 227, 88, 1)
                      : const Color.fromARGB(255, 109, 179, 152)),
              // Text specifying to user that this is the button to click if they want to log back in to the app
              child: Text(
                "Log in",
                style: TextStyle(
                  color: Colors.black,
                  // Set font based on body font set by user/default font
                  fontFamily: themeService.getCurrentBodyFont(),
                  fontSize: 30,
                ),
              ),
            ),
            const SizedBox(height: 15),
            // Button to register an account with Ecotel without option to backtrack
            ElevatedButton(
              // Enter register screen when button is pressed
              onPressed: () =>
                  Navigator.of(context).pushNamed(RegistrationScreen.routeName),
              style: ElevatedButton.styleFrom(
                  // Set Registering button background colour based on current theme
                  backgroundColor: themeService.getCurrentTheme() == "light"
                      ? const Color.fromRGBO(125, 227, 88, 1)
                      : const Color.fromARGB(255, 109, 179, 152)),
              child: Text(
                "Registering",
                style: TextStyle(
                  // Set font based on body font set by user/default font
                  fontFamily: themeService.getCurrentBodyFont(),
                  fontSize: 30,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            // Button to log in using Gmail account
            kIsWeb
                ? // Button to log in to Ecotel using Gmail account
                ElevatedButton(
                    onPressed: () {
                      loginWithGoogle(context);
                    },
                    style: ElevatedButton.styleFrom(
                      maximumSize: const Size.fromWidth(500),
                      // Set login by gmail button background colour based on current theme
                      backgroundColor: themeService.getCurrentTheme() == "light"
                          ? const Color.fromRGBO(125, 227, 88, 1)
                          : const Color.fromARGB(255, 109, 179, 152),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Gmail icon
                        Image.asset(
                          "images/gmail.png",
                          height: 50,
                          width: 50,
                        ),
                        const SizedBox(
                            width: 10), // Adjust space between icon and text
                        Flexible(
                          child: Text(
                            "Log in with gmail",
                            style: TextStyle(
                              // Set font based on body font set by user/default font
                              fontFamily: themeService.getCurrentBodyFont(),
                              fontSize: 30,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ))
                : ElevatedButton(
                    onPressed: () {
                      loginWithGoogle(context);
                    },
                    style: ElevatedButton.styleFrom(
                      // Set login by gmail button background colour based on current theme
                      backgroundColor: themeService.getCurrentTheme() == "light"
                          ? const Color.fromRGBO(125, 227, 88, 1)
                          : const Color.fromARGB(255, 109, 179, 152),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 1, horizontal: 1),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Gmail icon
                          Image.asset(
                            "images/gmail.png",
                            height: 50,
                            width: 50,
                          ),
                          const SizedBox(
                              width: 10), // Adjust space between icon and text
                          Flexible(
                            child: Text(
                              "Logging in with gmail",
                              style: TextStyle(
                                // Set font based on body font set by user/default font
                                fontFamily: themeService.getCurrentBodyFont(),
                                // Set font size based on body font set by user/default font so that text fits in button
                                fontSize:
                                    themeService.getCurrentBodyFont() == 'Arial'
                                        ? 30
                                        : 26,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
          ],
        ),
      ),
    );
  }
}
