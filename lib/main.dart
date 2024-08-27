// ignore_for_file: use_key_in_widget_constructors, no_wildcard_variable_uses

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:sohleecelest_2301028c_pc09/firebase_options.dart';
import 'package:sohleecelest_2301028c_pc09/models/hotel.dart';
import 'package:sohleecelest_2301028c_pc09/screens/add_hotel_basic_details_screen.dart';
import 'package:sohleecelest_2301028c_pc09/screens/add_hotel_certifications_screen.dart';
import 'package:sohleecelest_2301028c_pc09/screens/add_hotel_cover_screen.dart';
import 'package:sohleecelest_2301028c_pc09/screens/add_hotel_practices_screen.dart';
import 'package:sohleecelest_2301028c_pc09/screens/edit_basic_details_screen.dart';
import 'package:sohleecelest_2301028c_pc09/screens/edit_certifications_screen.dart';
import 'package:sohleecelest_2301028c_pc09/screens/edit_cover_screen.dart';
import 'package:sohleecelest_2301028c_pc09/screens/edit_practices_screen.dart';
import 'package:sohleecelest_2301028c_pc09/screens/editing_options_screen.dart';
import 'package:sohleecelest_2301028c_pc09/screens/home_screen.dart';
import 'package:sohleecelest_2301028c_pc09/screens/hotel_added_screen.dart';
import 'package:sohleecelest_2301028c_pc09/screens/hotel_deleted_screen.dart';
import 'package:sohleecelest_2301028c_pc09/screens/hotel_details_screen.dart';
import 'package:sohleecelest_2301028c_pc09/screens/hotel_updated_screen.dart';
import 'package:sohleecelest_2301028c_pc09/screens/logged_out_screen.dart';
import 'package:sohleecelest_2301028c_pc09/screens/login_screen.dart';
import 'package:sohleecelest_2301028c_pc09/screens/password_updated_screen.dart';
import 'package:sohleecelest_2301028c_pc09/screens/registration_screen.dart';
import 'package:sohleecelest_2301028c_pc09/screens/reset_password_screen.dart';
import 'package:sohleecelest_2301028c_pc09/screens/update_password_screen.dart';
import 'package:sohleecelest_2301028c_pc09/services/firebase_service.dart';
import 'package:sohleecelest_2301028c_pc09/services/theme_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  GetIt.instance.registerLazySingleton(() => FirebaseService());
  GetIt.instance.registerLazySingleton(() => ThemeService());
  runApp(MyApp());
}

// Initialise FirebaseService object to access getAuthUser() and googleLogin() functions
final FirebaseService fbService = GetIt.instance<FirebaseService>();
// Initialise ThemeService object to access functions determining UI styles
final ThemeService themeService = GetIt.instance<ThemeService>();

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Load theme from shared preferences
    themeService.loadTheme();
    themeService.loadheadingFont();
    themeService.loadBodyFont();
    return StreamBuilder<User?>(
        // Get the current user's authentication status to determine if user is logged in
        stream: fbService.getAuthUser(),
        builder: (context, snapshot) {
          return StreamBuilder<Color>(
              // Get the current theme to determine the color scheme of the app
              stream: themeService.getThemeStream(),
              builder: (contextTheme, snapshotTheme) {
                return StreamBuilder<String>(
                    // Get the current heading font
                    stream: themeService.getHeadingFontStream(),
                    builder: (contextHeading, snapshotHeading) {
                      return StreamBuilder<String>(
                          // Get the current body font
                          stream: themeService.getBodyFontStream(),
                          builder: (contextBody, snapshotBody) {
                            return MaterialApp(
                              theme: ThemeData(
                                // Set the color scheme for the app based on the current theme. If no theme is set, use the default light theme
                                colorScheme: ColorScheme.fromSeed(
                                    seedColor: snapshotTheme.data ??
                                        const Color.fromARGB(
                                            255, 255, 251, 254)),
                                useMaterial3: true,
                              ),
                              // If user is logged in, show the home screen, else show the main screen for logging in or registering
                              home: snapshot.connectionState !=
                                          ConnectionState.waiting &&
                                      snapshot.hasData
                                  ? HomeScreen()
                                  : MainScreen(),
                              // Define routes for the app
                              routes: {
                                LoginScreen.routeName: (_) {
                                  return LoginScreen();
                                },
                                RegistrationScreen.routeName: (_) {
                                  return RegistrationScreen();
                                },
                                ResetPasswordScreen.routeName: (_) {
                                  return ResetPasswordScreen();
                                },
                                HomeScreen.routeName: (_) {
                                  return HomeScreen();
                                },
                                UpdatePasswordScreen.routeName: (_) {
                                  return UpdatePasswordScreen();
                                },
                                PasswordUpdatedScreen.routeName: (_) {
                                  return PasswordUpdatedScreen();
                                },
                                LoggedOutScreen.routeName: (_) {
                                  return LoggedOutScreen();
                                },
                                HotelDetailsScreen.routeName: (_) {
                                  // Get owner's email passed as an argument
                                  final email = ModalRoute.of(_)
                                      ?.settings
                                      .arguments as String;

                                  return HotelDetailsScreen(owner: email);
                                },
                                AddHotelBasicDetailsScreen.routeName: (_) {
                                  return AddHotelBasicDetailsScreen();
                                },
                                AddHotelCertificationsScreen.routeName: (_) {
                                  // Get hotel object passed as an argument
                                  var hotel = ModalRoute.of(_)
                                      ?.settings
                                      .arguments as Hotel;

                                  return AddHotelCertificationsScreen(
                                      hotel: hotel);
                                },
                                AddHotelPracticesScreen.routeName: (_) {
                                  // Get hotel object passed as an argument
                                  var hotel = ModalRoute.of(_)
                                      ?.settings
                                      .arguments as Hotel;

                                  return AddHotelPracticesScreen(hotel: hotel);
                                },
                                AddHotelCoverScreen.routeName: (_) {
                                  // Get hotel object passed as an argument
                                  var hotel = ModalRoute.of(_)
                                      ?.settings
                                      .arguments as Hotel;

                                  return AddHotelCoverScreen(hotel: hotel);
                                },
                                HotelAddedScreen.routeName: (_) {
                                  return HotelAddedScreen();
                                },
                                HotelDeletedScreen.routeName: (_) {
                                  return HotelDeletedScreen();
                                },
                                EditingOptionsScreen.routeName: (_) {
                                  return EditingOptionsScreen();
                                },
                                EditBasicDetailsScreen.routeName: (_) {
                                  return EditBasicDetailsScreen();
                                },
                                EditCertificationsScreen.routeName: (_) {
                                  return EditCertificationsScreen();
                                },
                                EditPracticesScreen.routeName: (_) {
                                  return EditPracticesScreen();
                                },
                                EditCoverScreen.routeName: (_) {
                                  return EditCoverScreen();
                                },
                                HotelUpdatedScreen.routeName: (_) {
                                  return HotelUpdatedScreen();
                                },
                              },
                            );
                          });
                    });
              });
        });
  }
}

// Main screen to show up when app is opened
class MainScreen extends StatelessWidget {
  static String routeName = '/';

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
        // Set background color based on the current theme
        backgroundColor: themeService.getCurrentTheme() == 'light'
            ? const Color.fromARGB(255, 255, 251, 254)
            : const Color.fromARGB(255, 109, 108, 108),
        appBar: AppBar(
          // Set app bar background colour based on current theme
          backgroundColor: themeService.getCurrentTheme() == 'light'
              ? Theme.of(context).colorScheme.inversePrimary
              : const Color.fromARGB(255, 34, 34, 34),
          // Welcome message as app bar title
          title: Text(
            "Welcome to Ecotel",
            style: TextStyle(
              // Set font based on heading set by user/default font
              fontFamily: themeService.getCurrentHeadingFont(),
              // Set font size based on heading set by user/default font so that headings are consistent
              fontSize: themeService.getCurrentHeadingFont() == "Nunito Sans"
                  ? 40
                  : 42,
              fontWeight: FontWeight.bold,
              // Set text color based on current theme
              color: themeService.getCurrentTheme() == 'light'
                  ? Colors.black
                  : Colors.white,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Center(
              child: Column(children: [
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 0),
              child: Text(
                "Plan Your Sustainable Stay",
                style: TextStyle(
                  // Set font based on body font set by user/default font
                  fontFamily: themeService.getCurrentBodyFont(),
                  fontSize: 30,
                  // Set text color based on current theme
                  color: themeService.getCurrentTheme() == 'light'
                      ? Colors.black
                      : Colors.white,
                ),
              ),
            ),
            // If app is running on web, display illustration with shorter height so it fits the screen
            kIsWeb
                ? Padding(
                    padding: const EdgeInsets.only(top: 0),
                    // Main page illustration
                    child: Image.asset(
                      "images/start_page.png",
                      height: 380,
                    ))
                : Padding(
                    padding: const EdgeInsets.only(top: 0),
                    // Main page illustration
                    child: Image.asset(
                      "images/start_page.png",
                      width: 800,
                    )),
            Text(
              "Are you...",
              style: TextStyle(
                // Set font based on body font set by user/default font
                fontFamily: themeService.getCurrentBodyFont(),
                fontSize: 30,
                // Set text color based on current theme
                color: themeService.getCurrentTheme() == 'light'
                    ? Colors.black
                    : Colors.white,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            // Button to log in to Ecotel
            ElevatedButton(
              // Enter login screen when button is pressed with option to backtrack
              onPressed: () =>
                  Navigator.of(context).pushNamed(LoginScreen.routeName),
              style: ElevatedButton.styleFrom(
                  // Set button background color based on current theme
                  backgroundColor: themeService.getCurrentTheme() == "light"
                      ? Theme.of(context).colorScheme.inversePrimary
                      : const Color.fromARGB(255, 109, 179, 152)),
              child: Text(
                "Logging in",
                style: TextStyle(
                  // Set font based on body font set by user/default font
                  fontFamily: themeService.getCurrentBodyFont(),
                  fontSize: 30,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            // Button to register an account with Ecotel without option to backtrack
            ElevatedButton(
              // Enter register screen when button is pressed
              onPressed: () =>
                  Navigator.of(context).pushNamed(RegistrationScreen.routeName),
              style: ElevatedButton.styleFrom(
                  // Set button background color based on current theme
                  backgroundColor: themeService.getCurrentTheme() == "light"
                      ? Theme.of(context).colorScheme.inversePrimary
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
              height: 20,
            ),
            // If app is running on web, display "Log in with Gmail" button with maximum width so it fits the screen
            kIsWeb
                ? // Button to log in to Ecotel using Gmail account
                ElevatedButton(
                    onPressed: () {
                      loginWithGoogle(context);
                    },
                    style: ElevatedButton.styleFrom(
                        maximumSize: const Size.fromWidth(500),
                        backgroundColor:
                            // Set button background color based on current theme
                            themeService.getCurrentTheme() == "light"
                                ? Theme.of(context).colorScheme.inversePrimary
                                : const Color.fromARGB(255, 109, 179, 152)),
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
                    ))
                : ElevatedButton(
                    onPressed: () {
                      loginWithGoogle(context);
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor:
                            // Set button background color based on current theme
                            themeService.getCurrentTheme() == "light"
                                ? Theme.of(context).colorScheme.inversePrimary
                                : const Color.fromARGB(255, 109, 179, 152)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 1),
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
          ])),
        ));
  }
}
