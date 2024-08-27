// ignore_for_file: use_key_in_widget_constructors, must_be_immutable, curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:sohleecelest_2301028c_pc09/screens/home_screen.dart';
import 'package:sohleecelest_2301028c_pc09/screens/reset_password_screen.dart';
import 'package:sohleecelest_2301028c_pc09/services/firebase_service.dart';
import 'package:sohleecelest_2301028c_pc09/services/theme_service.dart';

class LoginScreen extends StatelessWidget {
  static String routeName = '/login';

  // Define variables for email and password
  String? email;
  String? password;
  // Define form key for value extraction and validation
  var form = GlobalKey<FormState>();

  // Initialise FirebaseService object to access getAuthUser() and googleLogin() functions
  final FirebaseService fbService = GetIt.instance<FirebaseService>();
  // Initialise ThemeService object to access getThemeStream() and loadTheme() functions
  final ThemeService themeService = GetIt.instance<ThemeService>();

  // Function to log user in with email and password
  login(context) {
    // Hide keyboard
    FocusScope.of(context).unfocus();

    // Trigger all validators for each form field
    bool isValid = form.currentState!.validate();

    // If the inputs were all valid
    if (isValid) {
      // Save form
      form.currentState!.save();
      // Log user in with email and password
      fbService.login(email, password).then((value) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          // Set snackbar background colour based on current theme
          backgroundColor: themeService.getCurrentTheme() == "light"
              ? const Color.fromARGB(255, 185, 252, 123)
              : const Color.fromARGB(255, 80, 158, 52),
          content: Text(
            "Login Successfu!",
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
        // If unsuccessful, show error message
      }).catchError((error) {
        String message = error.toString();
        // Inform the user that they entered the wrong credentials or do not have an account
        if (message.contains("[firebase_auth/invalid-credential] The supplied auth credential is incorrect, malformed or has expired.") ||
            message.contains(
                "[firebase_auth/wrong-password] The password is invalid or the user does not have a password.") ||
            message.contains(
                "[firebase_auth/user-not-found] There is no user record corresponding to this identifier. The user may have been deleted."))
          message =
              "User not found. Have you entered your email/password incorrectly? Or do you not have an account?";
        // Inform the user that they've entered the wrong credentials too many times, resulting in their account being temporarily disabled due to too many failed login attempts
        else if (message.contains(
            "[firebase_auth/too-many-requests] Access to this account has been temporarily disabled due to many failed login attempts. You can immediately restore it by resetting your password or you can try again later."))
          message =
              "You've entered the incorrect credentials too many times. Please reset your password or try again later.";
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
              // Set text colour based on current theme
              color: themeService.getCurrentTheme() == 'light'
                  ? Colors.black
                  : Colors.white,
            ),
          ),
        ));
      });
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
            // Welcome message for returning users who are logging in
            Text(
              "Welcome Back",
              style: TextStyle(
                // Set font based on body font set by user/default font
                fontFamily: themeService.getCurrentBodyFont(),
                fontSize: 40,
                // Set text colour based on current theme
                color: themeService.getCurrentTheme() == 'light'
                    ? Colors.black
                    : Colors.white,
              ),
            ),
            Form(
              key: form,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Email text field
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
                    ),
                  ),
                  // Password text field
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 13, left: 15, right: 15, bottom: 20),
                    child: TextFormField(
                      // Set cursor colour based on current theme
                      cursorColor: themeService.getCurrentTheme() == 'light'
                          ? const Color.fromARGB(255, 0, 0, 0)
                          : const Color.fromARGB(255, 255, 251, 254),
                      // Obscure password when user types it in
                      obscureText: true,
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(10),
                          // Hint text to tell user to enter their password
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
                                  : const Color.fromARGB(255, 254, 212, 209))),
                      style: TextStyle(
                        // Set font based on body font set by user/default font
                        fontFamily: themeService.getCurrentBodyFont(),
                        fontSize: 25,
                      ),
                      // Validator to check if user has entered a password
                      // No other checks implemented as the password only needs to match the one entered during registration which has already been validated
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return "Please enter your password";
                        else
                          return null;
                      },
                      onSaved: (value) {
                        password = value!.trim();
                      },
                    ),
                  ),
                  // TextButton to navigate to reset password page if user forgot their password
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: TextButton(
                      onPressed: () => Navigator.of(context)
                          .pushNamed(ResetPasswordScreen.routeName),
                      child: RichText(
                        text: TextSpan(
                          text: "I forgot my password!",
                          style: TextStyle(
                            // Set font based on body font set by user/default font
                            fontFamily: themeService.getCurrentBodyFont(),
                            fontSize: 20,
                            //  Set text colour based on current theme
                            color: themeService.getCurrentTheme() == 'light'
                                ? Colors.black
                                : Colors.white,
                            decoration: TextDecoration.underline,
                            // Set underline colour based on current theme
                            decorationColor: themeService.getCurrentTheme() ==
                                    'light'
                                ? Colors.black
                                : Colors.white, // Set your underline color here
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  // Button to log in with filled in credentials. Navigates to Home page.
                  Center(
                      child: ElevatedButton(
                    onPressed: () {
                      login(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          // Set button background color based on current theme
                          themeService.getCurrentTheme() == "light"
                              ? Theme.of(context).colorScheme.inversePrimary
                              : const Color.fromARGB(255, 109, 179, 152),
                      padding: const EdgeInsets.symmetric(horizontal: 140),
                    ),
                    child: Text(
                      "Log in",
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
