// ignore_for_file: use_key_in_widget_constructors, must_be_immutable, curly_braces_in_flow_control_structures
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:sohleecelest_2301028c_pc09/services/firebase_service.dart';
import 'package:sohleecelest_2301028c_pc09/services/theme_service.dart';

class ResetPasswordScreen extends StatelessWidget {
  static String routeName = '/reset-password';

  // Define variable to store email
  String? email;
  // form key to validate and save input
  var form = GlobalKey<FormState>();
  // Get the FirebaseService instance as fbService to access resetPassword() function
  FirebaseService fbService = GetIt.instance<FirebaseService>();
  // Get the ThemeService instance as themeService to access getCurrentTheme() function
  final ThemeService themeService = GetIt.instance<ThemeService>();

  resetPassword(context) {
    // Hide keyboard
    FocusScope.of(context).unfocus();

    // Trigger all validators for each form field
    bool isValid = form.currentState!.validate();

    // If the inputs were all valid
    if (isValid) {
      // Save form
      form.currentState!.save();
      // Send email to user to reset password
      fbService.resetPassword(email!).then((value) {
        // Show dialog to user
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                // Set background colour of the dialog based on the current theme
                backgroundColor: themeService.getCurrentTheme() == 'light'
                    ? const Color.fromARGB(255, 196, 251, 207)
                    : const Color.fromARGB(255, 100, 173, 114),
                content: Text(
                  "Look out for our email \nto \nreset your password!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    // Set font based on body font set by user/default font
                    fontFamily: themeService.getCurrentBodyFont(),
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "Noted!",
                      style: TextStyle(
                        // Set font based on body font set by user/default font
                        fontFamily: themeService.getCurrentBodyFont(),
                        fontSize: 25,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              );
            });
      }).catchError((error) {
        String message = error.toString();
        if (message.contains(
            "[firebase_auth/user-not-found] There is no user record corresponding to this identifier. The user may have been deleted."))
          message = error = "User not found. Please check your email.";
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: const Color.fromARGB(255, 185, 252, 123),
          content: Text(
            error.toString(),
            style: TextStyle(
              // Set font based on body font set by user/default font
              fontFamily: themeService.getCurrentBodyFont(),
              fontSize: 23,
              color: Colors.black,
            ),
          ),
        ));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Set screen background color based on the current theme
      backgroundColor: themeService.getCurrentTheme() == 'light'
          ? const Color.fromARGB(255, 255, 251, 254)
          : const Color.fromARGB(255, 109, 108, 108),
      appBar: AppBar(
        // Set background color to be the same as screen background
        backgroundColor: themeService.getCurrentTheme() == 'light'
            ? const Color.fromARGB(255, 255, 251, 254)
            : const Color.fromARGB(255, 109, 108, 108),
        // Set back arrow colour based on current theme
        foregroundColor: themeService.getCurrentTheme() == 'light'
            ? Colors.black
            : Colors.white,
      ),
      // Set screen to not resize when keyboard is shown
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          // Forgot password illustration
          Image.asset(
            "images/forgot_password.png",
            height: 225,
          ),
          Text(
            "Don't Worry",
            style: TextStyle(
              // Set font based on body font set by user/default font
              fontFamily: themeService.getCurrentBodyFont(),
              fontSize: 40, // Set text colour based on current theme
              color: themeService.getCurrentTheme() == "light"
                  ? Colors.black
                  : Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          // Instruction to user for resetting password
          Text(
            // Text is separated into two lines "Submit your email to" and "reset your password" to fit into phone screen
            "Submit your email to\nreset your password",
            // Center-align text
            textAlign: TextAlign.center,
            // Adjust between lines
            style: TextStyle(
                // Set font based on body font set by user/default font
                fontFamily: themeService.getCurrentBodyFont(),
                fontSize: 30, // Set text colour based on current theme
                color: themeService.getCurrentTheme() == "light"
                    ? Colors.black
                    : Colors.white,
                height: 1),
          ),
          // Email text field
          Form(
            key: form,
            child: Padding(
                padding: const EdgeInsets.only(top: 13, left: 15, right: 15),
                child: TextFormField(
                  // Set cursor colour based on current theme
                  cursorColor: themeService.getCurrentTheme() == 'light'
                      ? const Color.fromARGB(255, 20, 123, 23)
                      : const Color.fromARGB(255, 255, 251, 254),
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(10),
                      // Hint text to tell user to enter their password
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
                              : const Color.fromARGB(255, 254, 212, 209))),
                  style: TextStyle(
                    // Set font based on body font set by user/default font
                    fontFamily: themeService.getCurrentBodyFont(),
                    fontSize: 25,
                  ),
                  // Keyboard type is email address for user to enter their email
                  keyboardType: TextInputType.emailAddress,
                  // Validator to check if user has entered an email
                  // No other checks implemented as the password only needs to match the one entered during registration which has already been validated
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return "Please enter your email";
                    else if (!value.contains("@"))
                      return "Email should have the '@' symbol. eg: @gmail.com";
                    else if (!value.contains("."))
                      return "Email should have the domain name. eg: .com";
                    else
                      return null;
                  },
                  onSaved: (value) {
                    email = value!.trim();
                  },
                )),
          ),
          const SizedBox(height: 30),
          // Button to reset password
          ElevatedButton(
            onPressed: () {
              resetPassword(context);
            },
            style: ElevatedButton.styleFrom(
              // Set button background color based on current theme
              backgroundColor: themeService.getCurrentTheme() == "light"
                  ? Theme.of(context).colorScheme.inversePrimary
                  : const Color.fromARGB(255, 109, 179, 152),
              padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 5),
            ),
            child: Text(
              "Reset my password",
              style: TextStyle(
                color: Colors
                    .black, // Set font based on body font set by user/default font
                fontFamily: themeService.getCurrentBodyFont(), fontSize: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
