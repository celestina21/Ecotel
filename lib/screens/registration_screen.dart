// ignore_for_file: use_key_in_widget_constructors, must_be_immutable, curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:sohleecelest_2301028c_pc09/screens/home_screen.dart';
import 'package:sohleecelest_2301028c_pc09/services/firebase_service.dart';
import 'package:sohleecelest_2301028c_pc09/services/theme_service.dart';

class RegistrationScreen extends StatelessWidget {
  static String routeName = '/registration';

  // Define variables for email, password and confirm password
  String? email;
  String? password;
  String? confirmPassword;
  // Define form key for value extraction and validation
  var form = GlobalKey<FormState>();

  // Initialise FirebaseService object to access getAuthUser() and googleLogin() functions
  final FirebaseService fbService = GetIt.instance<FirebaseService>();
  // Initialise ThemeService object to access getThemeStream() and loadTheme() functions
  final ThemeService themeService = GetIt.instance<ThemeService>();

  // Function to register user to Firebase
  register(context) {
    // Hide keyboard
    FocusScope.of(context).unfocus();

    // Trigger all validators for each form field
    bool isValid = form.currentState!.validate();

    // If the inputs were all valid
    if (isValid) {
      // Save form
      form.currentState!.save();

      // If the password and confirm password do not match, alert user and do not proceed with registration
      if (password != confirmPassword) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          // Set snackbar background colour based on current theme
          backgroundColor: themeService.getCurrentTheme() == "light"
              ? const Color.fromARGB(255, 185, 252, 123)
              : const Color.fromARGB(255, 80, 158, 52),
          content: Text(
            "Password and Confirm Password does not match!",
            style: TextStyle(
              fontFamily: "Arial",
              fontSize: 23,
              // Set text colour based on current theme
              color: themeService.getCurrentTheme() == 'light'
                  ? Colors.black
                  : Colors.white,
            ),
          ),
        ));
      } else {
        // Register user to Firebase
        fbService.register(email, password).then((value) {
          fbService.addUser(email!);
        }).then((value) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            // Set snackbar background colour based on current theme
            backgroundColor: themeService.getCurrentTheme() == "light"
                ? const Color.fromARGB(255, 185, 252, 123)
                : const Color.fromARGB(255, 80, 158, 52),
            content: Text(
              "Registration Successfu!",
              style: TextStyle(
                fontFamily: "Arial",
                fontSize: 23,
                // Set text colour based on current theme
                color: themeService.getCurrentTheme() == 'light'
                    ? Colors.black
                    : Colors.white,
              ),
            ),
          ));
          // Navigate to Home page upon success registration
          Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
        }).catchError((error) {
          error = error.toString();
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          if (error.contains(
              "[firebase_auth/email-already-in-use] The email address is already in use by another account.")) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              // Set snackbar background colour based on current theme
              backgroundColor: themeService.getCurrentTheme() == "light"
                  ? const Color.fromARGB(255, 185, 252, 123)
                  : const Color.fromARGB(255, 80, 158, 52),
              content: Text(
                "Email is already in use by another account. Please use another email.",
                style: TextStyle(
                  // Set font based on body font set by user/default font
                  fontFamily: themeService.getCurrentBodyFont(),
                  fontSize: 23,
                  color: themeService.getCurrentTheme() == 'light'
                      ? Colors.black
                      : Colors.white,
                ),
              ),
            ));
          } else if (error.contains("firebase_auth")) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              // Set snackbar background colour based on current theme
              backgroundColor: themeService.getCurrentTheme() == "light"
                  ? const Color.fromARGB(255, 185, 252, 123)
                  : const Color.fromARGB(255, 80, 158, 52),
              content: Text(
                error.toString(),
                style: TextStyle(
                  // Set font based on body font set by user/default font
                  fontFamily: themeService.getCurrentBodyFont(),
                  fontSize: 23,
                  color: themeService.getCurrentTheme() == 'light'
                      ? Colors.black
                      : Colors.white,
                ),
              ),
            ));
          } else {
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
                  color: themeService.getCurrentTheme() == 'light'
                      ? Colors.black
                      : Colors.white,
                ),
              ),
            ));
          }
        });
      }
    }
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
          // Set app bar back button based on current theme
          foregroundColor: themeService.getCurrentTheme() == 'light'
              ? Colors.black
              : Colors.white,
          // App bar to have same colour as scaffold background
          backgroundColor: themeService.getCurrentTheme() == 'light'
              ? const Color.fromARGB(255, 255, 251, 254)
              : const Color.fromARGB(255, 109, 108, 108),
          title: Text(
            "Ecotel",
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
        body: Column(
          children: [
            const SizedBox(height: 50),
            // Welcome message for new users who are registering
            Text(
              // Text is separated into two lines "Start Your Journey" and "With Us" to fit inot phone screen
              "Start Your Journey\nWith Us",
              // Center-align text
              textAlign: TextAlign.center,
              // Space in between lines adjusted
              style: TextStyle(
                  // Set font based on body font set by user/default font
                  fontFamily: themeService.getCurrentBodyFont(),
                  fontSize: 40,
                  // Set text colour based on current theme
                  color: themeService.getCurrentTheme() == 'light'
                      ? Colors.black
                      : Colors.white,
                  height: 1.2),
            ),
            // Email, Password and Confirm Password text fields
            Form(
              key: form,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                // Email text field
                children: [
                  Padding(
                      padding: const EdgeInsets.only(
                          top: 13, left: 15, right: 15, bottom: 20),
                      child: TextFormField(
                        // Set cursor colour based on current theme
                        cursorColor: themeService.getCurrentTheme() == 'light'
                            ? const Color.fromARGB(255, 0, 0, 0)
                            : const Color.fromARGB(255, 255, 251, 254),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(10),
                          // Hint text to tell user to enter their email
                          hintText: "Email",
                          hintStyle: TextStyle(
                              color:
                                  // Set hint text colour based on current theme
                                  themeService.getCurrentTheme() == 'light'
                                      ? const Color.fromARGB(255, 142, 142, 142)
                                      : const Color.fromARGB(255, 74, 73, 73)),
                          // TextFormField is filled with background colour if the current theme is light, else it is filled with lighter grey colour
                          filled: true,
                          fillColor: themeService.getCurrentTheme() == 'light'
                              ? const Color.fromARGB(255, 255, 251, 254)
                              : const Color.fromARGB(255, 192, 192, 192),
                          // Set border colour based on current theme and add circular edges
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: themeService.getCurrentTheme() == 'light'
                                    ? const Color.fromARGB(255, 0, 72, 25)
                                    : const Color.fromARGB(255, 211, 206, 210),
                              )),
                          // Set border colour when user is selecting based on current theme and add circular edges
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: themeService.getCurrentTheme() == 'light'
                                    ? const Color.fromARGB(255, 72, 72, 72)
                                    : const Color.fromARGB(255, 255, 251, 254),
                              )),
                          // Error text style for when input is invalid
                          errorStyle: TextStyle(
                              fontSize: 15,
                              // Set error text colour based on current theme
                              color: themeService.getCurrentTheme() == 'light'
                                  ? Colors.red
                                  : const Color.fromARGB(255, 254, 212, 209)),
                        ),
                        style: TextStyle(
                          // Set font based on body font set by user/default font
                          fontFamily: themeService.getCurrentBodyFont(),
                          fontSize: 25,
                        ),
                        // Keyboard type is email address for user to enter their email
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty)
                            return "Please enter your email";
                          else if (!value.contains("@"))
                            return "Email should have the '@' symbol. eg: @gmail.com";
                          else if (!value.contains("."))
                            return "Email should have the domain name. eg: .com";
                          else if (value.trim().length < 15)
                            return "Email must be at least 15 characters long";
                          else if (value.trim().length > 45)
                            return "Email can only be maximum 45 characters long";
                          else
                            return null;
                        },
                        onSaved: (value) {
                          email = value!.trim();
                        },
                      )),
                  // Password text field
                  Padding(
                      padding: const EdgeInsets.only(
                          top: 13, left: 15, right: 15, bottom: 20),
                      child: TextFormField(
                        // Obscure password when user types it in
                        obscureText: true,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(10),
                          // Hint text to tell user to confirm their password
                          hintText: "Password",
                          hintStyle: TextStyle(
                              color:
                                  // Set hint text colour based on current theme
                                  themeService.getCurrentTheme() == 'light'
                                      ? const Color.fromARGB(255, 142, 142, 142)
                                      : const Color.fromARGB(255, 74, 73, 73)),
                          // TextFormField is filled with background colour if the current theme is light, else it is filled with lighter grey colour
                          filled: true,
                          fillColor: themeService.getCurrentTheme() == 'light'
                              ? const Color.fromARGB(255, 255, 251, 254)
                              : const Color.fromARGB(255, 192, 192, 192),
                          // Set border colour based on current theme and add circular edges
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: themeService.getCurrentTheme() == 'light'
                                    ? const Color.fromARGB(255, 0, 72, 25)
                                    : const Color.fromARGB(255, 211, 206, 210),
                              )),
                          // Set border colour when user is selecting based on current theme and add circular edges
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: themeService.getCurrentTheme() == 'light'
                                    ? const Color.fromARGB(255, 72, 72, 72)
                                    : const Color.fromARGB(255, 255, 251, 254),
                              )),
                          // Error text style for when input is invalid
                          errorStyle: TextStyle(
                              fontSize: 15,
                              // Set error text colour based on current theme
                              color: themeService.getCurrentTheme() == 'light'
                                  ? Colors.red
                                  : const Color.fromARGB(255, 254, 212, 209)),
                        ),
                        style: TextStyle(
                          // Set font based on body font set by user/default font
                          fontFamily: themeService.getCurrentBodyFont(),
                          fontSize: 25,
                        ),
                        // Validator to check if user has entered a valid password which contains at least one number, one lowercase letter, one uppercase letter and one special character
                        validator: (value) {
                          if (value == null || value.isEmpty)
                            return "Please enter your password";
                          else if (value.trim().length < 12)
                            return "Password must be at least 12 characters long";
                          else if (value.trim().length > 40)
                            return "Password can only be maximum 40 characters long";
                          else if (!RegExp(r'[0-9]').hasMatch(value))
                            return "Password must contain at least one number";
                          else if (!RegExp(r'[a-z]').hasMatch(value))
                            return "Password must contain at least one lowercase letter";
                          else if (!RegExp(r'[A-Z]').hasMatch(value))
                            return "Password must contain at least one uppercase letter";
                          else if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]')
                              .hasMatch(value))
                            return "Password must contain at least one special character";
                          else
                            return null;
                        },
                        onSaved: (value) {
                          password = value!.trim();
                        },
                      )),
                  // Confirm Password text field
                  Padding(
                      padding: const EdgeInsets.only(
                          top: 13, left: 15, right: 15, bottom: 30),
                      child: TextFormField(
                        // Obscure user's input when retyping their password
                        obscureText: true,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(10),
                          // Hint text to tell user to confirm their password
                          hintText: "Confirm Password",
                          hintStyle: TextStyle(
                              color:
                                  // Set hint text colour based on current theme
                                  themeService.getCurrentTheme() == 'light'
                                      ? const Color.fromARGB(255, 142, 142, 142)
                                      : const Color.fromARGB(255, 74, 73, 73)),
                          // TextFormField is filled with background colour if the current theme is light, else it is filled with lighter grey colour
                          filled: true,
                          fillColor: themeService.getCurrentTheme() == 'light'
                              ? const Color.fromARGB(255, 255, 251, 254)
                              : const Color.fromARGB(255, 192, 192, 192),
                          // Set border colour based on current theme and add circular edges
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: themeService.getCurrentTheme() == 'light'
                                    ? const Color.fromARGB(255, 0, 72, 25)
                                    : const Color.fromARGB(255, 211, 206, 210),
                              )),
                          // Set border colour when user is selecting based on current theme and add circular edges
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: themeService.getCurrentTheme() == 'light'
                                    ? const Color.fromARGB(255, 72, 72, 72)
                                    : const Color.fromARGB(255, 255, 251, 254),
                              )),
                          // Error text style for when input is invalid
                          errorStyle: TextStyle(
                              fontSize: 15,
                              // Set error text colour based on current theme
                              color: themeService.getCurrentTheme() == 'light'
                                  ? Colors.red
                                  : const Color.fromARGB(255, 254, 212, 209)),
                        ),
                        style: TextStyle(
                          // Set font based on body font set by user/default font
                          fontFamily: themeService.getCurrentBodyFont(),
                          fontSize: 25,
                        ),
                        // Validator to check if user has re-entered the password properly
                        validator: (value) {
                          if (value == null || value.isEmpty)
                            return "Please enter your password for confirmation.";
                          else
                            return null;
                        },
                        onSaved: (value) {
                          confirmPassword = value!.trim();
                        },
                      )),
                  // Button to register an account with Ecotel. When pressed, navigates to Home page.
                  Center(
                      child: ElevatedButton(
                    onPressed: () {
                      register(context);
                    },
                    style: ElevatedButton.styleFrom(
                      // Set button background color based on current theme
                      backgroundColor: themeService.getCurrentTheme() == "light"
                          ? Theme.of(context).colorScheme.inversePrimary
                          : const Color.fromARGB(255, 109, 179, 152),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 125, vertical: 5),
                    ),
                    child: Text(
                      "Register",
                      style: TextStyle(
                        // Set font based on body font set by user/default font
                        fontFamily: themeService.getCurrentBodyFont(),
                        fontSize: 30,
                        color: Colors.black,
                      ),
                    ),
                  )),
                ],
              ),
            )
          ],
        ));
  }
}
