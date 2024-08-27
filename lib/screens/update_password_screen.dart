// ignore_for_file: use_key_in_widget_constructors, must_be_immutable, curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:sohleecelest_2301028c_pc09/screens/password_updated_screen.dart';
import 'package:sohleecelest_2301028c_pc09/services/firebase_service.dart';
import 'package:sohleecelest_2301028c_pc09/services/theme_service.dart';

class UpdatePasswordScreen extends StatelessWidget {
  static String routeName = '/update-password';

  // form key to validate and save all form fields
  var form = GlobalKey<FormState>();
  // Get the FirebaseService instance as fbService to access updatePassword() function
  final FirebaseService fbService = GetIt.instance<FirebaseService>();
  // Get the ThemeService instance as themeService to access getCurrentTheme() function
  final ThemeService themeService = GetIt.instance<ThemeService>();

  // Define variables to store the old password, new password and confirm new password
  String? oldPassword;
  String? newPassword;
  String? newPasswordConfirm;

  // Function to update the password
  updatePassword(context) {
    // Hide keyboard
    FocusScope.of(context).unfocus();

    // Trigger all validators for each form field
    bool isValid = form.currentState!.validate();

    if (isValid) {
      // Save form
      form.currentState!.save();
      // If the password and confirm password do not match, alert user and do not proceed with registration
      if (newPassword != newPasswordConfirm) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          // Set snackbar background colour based on current theme
          backgroundColor: themeService.getCurrentTheme() == "light"
              ? const Color.fromARGB(255, 185, 252, 123)
              : const Color.fromARGB(255, 80, 158, 52),
          content: Text(
            "Password and Confirm Password does not match!",
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
      } else if (newPassword == oldPassword) {
        // If the new password is the same as the old password, alert user and do not proceed with registration
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          // Set snackbar background colour based on current theme
          backgroundColor: themeService.getCurrentTheme() == "light"
              ? const Color.fromARGB(255, 185, 252, 123)
              : const Color.fromARGB(255, 80, 158, 52),
          content: Text(
            "New password cannot be the same as old password! Please enter a different password.",
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
      } else {
        fbService.updatePassword(newPassword!, oldPassword!).then((value) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            // Set snackbar background colour based on current theme
            backgroundColor: themeService.getCurrentTheme() == "light"
                ? const Color.fromARGB(255, 185, 252, 123)
                : const Color.fromARGB(255, 80, 158, 52),
            content: Text(
              "Password updated successfully!",
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
          // If password is successfully updated, navigate to PasswordUpdatedScreen
          /*
             pushReplacementNamed used to prevent user from backtracking to this page.
             When user backtracks from PasswordUpdatedScreen, they will skip to AccountContentWidget.
          */
          Navigator.of(context)
              .pushReplacementNamed(PasswordUpdatedScreen.routeName);
        }).catchError((error) {
          String message = error.toString();
          // Inform the user that they entered the wrong credentials or do not have an account
          if (message.contains(
                  "[firebase_auth/invalid-credential] The supplied auth credential is incorrect, malformed or has expired.") ||
              message.contains(
                  "[firebase_auth/wrong-password] The password is invalid or the user does not have a password."))
            message =
                "Old password is incorrect. Please enter the correct old password.";
          // Inform the user that they've entered the wrong password too many times, resulting in their account being temporarily disabled due to too many failed login attempts
          else if (message.contains(
              "[firebase_auth/too-many-requests] Access to this account has been temporarily disabled due to many failed login attempts. You can immediately restore it by resetting your password or you can try again later."))
            message =
                "You've entered the wrong old password too many times. Please reset your password or try again later.";
          // If password update fails, alert user with error message
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Set background color based on the current theme
      backgroundColor: themeService.getCurrentTheme() == 'light'
          ? const Color.fromARGB(255, 255, 251, 254)
          : const Color.fromARGB(255, 109, 108, 108),
      // Prevents the screen from resizing when the keyboard appears to avoid overflow
      resizeToAvoidBottomInset: false,
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
      body: Form(
        key: form,
        child: Column(
          children: [
            // Update password illustration
            Image.asset(
              "images/change_password.png",
              height: 225,
            ),
            // Old Password text field
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
                    hintText: "Old Password",
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
                        )), // Error text style for when input is invalid
                    errorStyle: TextStyle(
                      fontSize: 15,
                      // Set error text colour based on current theme
                      color: themeService.getCurrentTheme() == 'light'
                          ? Colors.red
                          : const Color.fromARGB(255, 255, 79, 67),
                    )),
                style: TextStyle(
                  // Set font based on body font set by user/default font
                  fontFamily: themeService.getCurrentBodyFont(),
                  fontSize: 25,
                ),
                // Validator to check if user entered their old password properly
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return "Please enter your old password for verification.";
                  else
                    return null;
                },
                onSaved: (value) {
                  oldPassword = value!.trim();
                },
              ),
            ),
            // New Password text field
            Padding(
              padding: const EdgeInsets.only(
                  top: 13, left: 15, right: 15, bottom: 20),
              child: TextFormField(
                // Set cursor colour based on current theme
                cursorColor: themeService.getCurrentTheme() == 'light'
                    ? const Color.fromARGB(255, 0, 0, 0)
                    : const Color.fromARGB(255, 255, 251, 254),
                // Obscures new password when user types it in
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
                        )), // Error text style for when input is invalid
                    errorStyle: TextStyle(
                      fontSize: 15,
                      // Set error text colour based on current theme
                      color: themeService.getCurrentTheme() == 'light'
                          ? Colors.red
                          : const Color.fromARGB(255, 255, 79, 67),
                    )),
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
                  else if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value))
                    return "Password must contain at least one special character";
                  else
                    return null;
                },
                onSaved: (value) {
                  newPassword = value!.trim();
                },
              ),
            ),
            // Confirm Password text fields
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
                    hintText: "Confirm New Password",
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
                        )), // Error text style for when input is invalid
                    errorStyle: TextStyle(
                      fontSize: 15,
                      // Set error text colour based on current theme
                      color: themeService.getCurrentTheme() == 'light'
                          ? Colors.red
                          : const Color.fromARGB(255, 255, 79, 67),
                    )),
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
                  newPasswordConfirm = value!.trim();
                },
              ),
            ),
            const SizedBox(height: 20),
            // Button to change password to the new one entered in the abive fields
            ElevatedButton(
              onPressed: () {
                updatePassword(context);
              },
              style: ElevatedButton.styleFrom(
                // Set button background color based on current theme
                backgroundColor: themeService.getCurrentTheme() == "light"
                    ? Theme.of(context).colorScheme.inversePrimary
                    : const Color.fromARGB(255, 109, 179, 152),
                padding:
                    const EdgeInsets.symmetric(horizontal: 56, vertical: 5),
              ),
              child: Text(
                "Change Password",
                style: TextStyle(
                  // Set font based on body font set by user/default font
                  fontFamily: themeService.getCurrentBodyFont(),
                  fontSize: 30,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
