// ignore_for_file: use_key_in_widget_constructors, curly_braces_in_flow_control_structures, prefer_is_empty, prefer_const_constructors_in_immutables, unnecessary_cast

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:sohleecelest_2301028c_pc09/models/hotel.dart';
import 'package:sohleecelest_2301028c_pc09/screens/add_hotel_certifications_screen.dart';
import 'package:sohleecelest_2301028c_pc09/services/firebase_service.dart';
import 'package:sohleecelest_2301028c_pc09/services/theme_service.dart';

class AddHotelBasicDetailsScreen extends StatefulWidget {
  static String routeName = '/add-hotel-basic-details';

  @override
  State<AddHotelBasicDetailsScreen> createState() =>
      _AddHotelBasicDetailsScreenState();
}

class _AddHotelBasicDetailsScreenState
    extends State<AddHotelBasicDetailsScreen> {
  // form key to validate and save all form fields
  var form = GlobalKey<FormState>();

  // Get the FirebaseService instance as fbService to access updateHotel() function
  final FirebaseService fbService = GetIt.instance<FirebaseService>();
  // Get the ThemeService instance as themeService to access getCurrentTheme() function
  final ThemeService themeService = GetIt.instance<ThemeService>();

  // Define hotel variable to store all the hotel's basic details
  late Hotel hotel;

  // Function to trigger all onSaved functions for each form field, then navigate to the next page of the form
  void submitBasicDetails() {
    // Hide keyboard
    FocusScope.of(context).unfocus();

    // Trigger all validators for each form field
    bool isValid = form.currentState!.validate();

    // If the inputs were all valid
    if (isValid) {
      // Save form
      form.currentState!.save();

      // Show SnackBar to notify user that basic details was saved successfully
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        // Set snackbar background colour based on current theme
        backgroundColor: themeService.getCurrentTheme() == "light"
            ? const Color.fromARGB(255, 185, 252, 123)
            : const Color.fromARGB(255, 80, 158, 52),
        content: Text(
          "Basic Details Saved Successfully!",
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

      // Navigate to the next page to fill in hotel's certifications
      // Pass in hotel object to the next page to build upon current hotel object which had basic details entered
      Navigator.of(context).pushReplacementNamed(
          AddHotelCertificationsScreen.routeName,
          arguments: hotel);
    }
  }

  @override
  // Initialize the Hotel object with the owner's email filled in and default star rating 1
  void initState() {
    super.initState();
    hotel = Hotel(
        // Get the current user's email using firebase service as the owner of the hotel
        owner: fbService.getCurrentUser()!.email!,
        name: "",
        rating: 1,
        country: "",
        stateProvince: null,
        city: null,
        address: "",
        certifications: [],
        practices: [],
        image: "");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Set screen background colour based on current theme
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
          // Title of the page to enter basic details
          "Basic Details",
          style: TextStyle(
            // Set font based on heading set by user/default font
            fontFamily: themeService.getCurrentHeadingFont(),
            // Set font size based on heading set by user/default font so that headings are consistent
            fontSize:
                themeService.getCurrentHeadingFont() == "Nunito Sans" ? 40 : 42,
            fontWeight: FontWeight.bold,
            // Set title colour based on current theme
            color: themeService.getCurrentTheme() == 'light'
                ? Colors.black
                : Colors.white,
          ),
        ),
      ),
      body: Form(
          // Use the "form" form key for this form
          key: form,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Center(
              child: Column(
                children: [
                  const SizedBox(height: 15),
                  // Button to submit hotel's basic details
                  ElevatedButton(
                      onPressed: () {
                        // Validates all user input before saving the form and proceeding to the next page
                        submitBasicDetails();
                      },
                      style: ElevatedButton.styleFrom(
                          // Set button background colour based on current theme
                          backgroundColor:
                              themeService.getCurrentTheme() == "light"
                                  ? const Color.fromRGBO(125, 227, 88, 1)
                                  : const Color.fromARGB(255, 109, 179, 152)),
                      child: Text(
                        "Submit Basic Details",
                        style: TextStyle(
                          // Set font based on body font set by user/default font
                          fontFamily: themeService.getCurrentBodyFont(),
                          fontSize: 23,
                          color: Colors.black,
                        ),
                      )),
                  Column(
                      // Align text form fields
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        // Form field to enter Hotel name
                        TextFormField(
                          // Set cursor colour based on current theme
                          cursorColor: themeService.getCurrentTheme() == 'light'
                              ? const Color.fromARGB(255, 20, 123, 23)
                              : const Color.fromARGB(255, 255, 251, 254),
                          onSaved: (value) {
                            // Save entered hotel name to "name" attribute of hotel object as String
                            hotel.name = value as String;
                          },
                          // Validator to check if the hotel name is valid
                          validator: (value) {
                            // If the hotel name was not entered, it is invalid
                            if (value == null || value.length == 0)
                              return "Please provide your hotel's name.";
                            // If the hotel name is less than 5 characters long, it is too short and invalid
                            else if (value.length < 5)
                              return "The name seems a bit short. Please enter a name that is at least 5 characters.";
                            // If the hotel name is more than 45 characters long, it is too long and invalid
                            else if (value.length > 45)
                              return "The name is too long. Please enter name of maximum 45 characters.";
                            // Otherwise, it is valid
                            else
                              return null;
                          },
                          style: TextStyle(
                              // Set font based on body font set by user/default font
                              fontFamily: themeService.getCurrentBodyFont(),
                              fontSize:
                                  23, // Set text colour based on current theme
                              color: themeService.getCurrentTheme() == 'light'
                                  ? Colors.black
                                  : Colors.white),
                          decoration: InputDecoration(
                            // Hint text to tell user to enter a hotel name
                            hintText: "Hotel Name",
                            hintStyle: TextStyle(
                                // Set font based on body font set by user/default font
                                fontFamily: themeService.getCurrentBodyFont(),
                                fontSize: 23,
                                color:
                                    // Set hint text colour based on current theme
                                    themeService.getCurrentTheme() == 'light'
                                        ? const Color.fromARGB(
                                            255, 142, 142, 142)
                                        : const Color.fromARGB(
                                            255, 180, 175, 175)),
                            // Set Underline colour when idle based on current theme
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                              color: themeService.getCurrentTheme() == 'light'
                                  ? const Color.fromARGB(255, 0, 72, 25)
                                  : const Color.fromARGB(255, 211, 206, 210),
                            )),
                            // Set Underline colour when user is typing based on current theme
                            focusedBorder: UnderlineInputBorder(
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
                        ),
                        const SizedBox(height: 20),
                        // Heading for dropdown menu for Star Rating
                        Text(
                          "Star Rating",
                          style: TextStyle(
                              // Set font based on body font set by user/default font
                              fontFamily: themeService.getCurrentBodyFont(),
                              fontSize: 23,
                              // Set heading colour based on current theme
                              color: themeService.getCurrentTheme() == 'light'
                                  ? const Color.fromARGB(255, 142, 142, 142)
                                  : const Color.fromARGB(255, 244, 240, 244)),
                        ),
                        const SizedBox(height: 10),
                        // Dropdownmenu to select hotel's star rating
                        DropdownMenu(
                            width: 100,
                            inputDecorationTheme: InputDecorationTheme(
                              // Set border colour based on current theme
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                color:
                                    // Set border colour when idle based on current theme
                                    themeService.getCurrentTheme() == 'light'
                                        ? const Color.fromARGB(255, 0, 72, 25)
                                        : const Color.fromARGB(
                                            255, 211, 206, 210),
                              )),
                              // Set border colour when user is selecting based on current theme
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                color: themeService.getCurrentTheme() == 'light'
                                    ? const Color.fromARGB(255, 72, 72, 72)
                                    : const Color.fromARGB(255, 255, 251, 254),
                              )),
                            ),
                            textStyle: TextStyle(
                              // Set font based on body font set by user/default font
                              fontFamily: themeService.getCurrentBodyFont(),
                              fontSize: 23,
                              height: 1,
                              // Set text colour based on current theme
                              color: themeService.getCurrentTheme() == 'light'
                                  ? Colors.black
                                  : Colors.white,
                            ),
                            trailingIcon: Icon(
                              Icons.arrow_drop_down,
                              size: 50,
                              // Set icon colour when not in use based on current theme
                              color: themeService.getCurrentTheme() == 'light'
                                  ? Colors.black
                                  : Colors.white,
                            ),
                            selectedTrailingIcon: Icon(
                              Icons.arrow_drop_up,
                              size: 50,
                              // Set icon colour when in use based on current theme
                              color: themeService.getCurrentTheme() == 'light'
                                  ? Colors.black
                                  : Colors.white,
                            ),
                            menuHeight: 500,
                            menuStyle: MenuStyle(
                                // Set menu background colour to match the screen background
                                backgroundColor: MaterialStatePropertyAll<
                                    Color>(themeService.getCurrentTheme() ==
                                        'light'
                                    ? const Color.fromARGB(255, 255, 251, 254)
                                    : const Color.fromARGB(255, 109, 108, 108)),
                                // Set menu item colour based on current theme
                                surfaceTintColor: MaterialStatePropertyAll<
                                    Color>(themeService.getCurrentTheme() ==
                                        'light'
                                    ? const Color.fromARGB(255, 255, 251, 254)
                                    : const Color.fromARGB(
                                        255, 109, 108, 108))),
                            // Initial selection is 1 star
                            initialSelection: hotel.rating,
                            // List of available ratings, integers 1 to 5.
                            dropdownMenuEntries: [
                              DropdownMenuEntry(
                                  value: 1,
                                  label: "1",
                                  style: ButtonStyle(
                                      // Set rating colour based on current theme
                                      foregroundColor:
                                          MaterialStatePropertyAll<Color>(
                                              themeService.getCurrentTheme() ==
                                                      'light'
                                                  ? Colors.black
                                                  : Colors.white))),
                              DropdownMenuEntry(
                                  value: 2,
                                  label: "2",
                                  style: ButtonStyle(
                                      // Set rating colour based on current theme
                                      foregroundColor:
                                          MaterialStatePropertyAll<Color>(
                                              themeService.getCurrentTheme() ==
                                                      'light'
                                                  ? Colors.black
                                                  : Colors.white))),
                              DropdownMenuEntry(
                                  value: 3,
                                  label: "3",
                                  style: ButtonStyle(
                                      // Set rating colour based on current theme
                                      foregroundColor:
                                          MaterialStatePropertyAll<Color>(
                                              themeService.getCurrentTheme() ==
                                                      'light'
                                                  ? Colors.black
                                                  : Colors.white))),
                              DropdownMenuEntry(
                                  value: 4,
                                  label: "4",
                                  // Set rating colour based on current theme
                                  style: ButtonStyle(
                                      foregroundColor:
                                          MaterialStatePropertyAll<Color>(
                                              themeService.getCurrentTheme() ==
                                                      'light'
                                                  ? Colors.black
                                                  : Colors.white))),
                              DropdownMenuEntry(
                                  value: 5,
                                  label: "5",
                                  style: ButtonStyle(
                                      // Set rating colour based on current theme
                                      foregroundColor:
                                          MaterialStatePropertyAll<Color>(
                                              themeService.getCurrentTheme() ==
                                                      'light'
                                                  ? Colors.black
                                                  : Colors.white)))
                            ],
                            // Function to update the selected rating in "rating" attribute of hotel object and update the dropdown menu
                            onSelected: (value) {
                              setState(() {
                                hotel.rating = value!;
                              });
                            }),
                        const SizedBox(height: 20),
                        // Form field to enter Country of hotel
                        TextFormField(
                          // Set cursor colour based on current theme
                          cursorColor: themeService.getCurrentTheme() == 'light'
                              ? const Color.fromARGB(255, 20, 123, 23)
                              : const Color.fromARGB(255, 255, 251, 254),
                          onSaved: (value) {
                            // Save country the hotel is in to "country" attribute of hotel object as String
                            hotel.country = value as String;
                          },
                          // Validator to check if the country name is valid
                          validator: (value) {
                            // If the country name was not entered, it is invalid
                            if (value == null || value.length == 0)
                              return "Please provide the country your hotel is located in.";
                            // If the country name is less than 4 characters long, it is too short and invalid
                            else if (value.length < 4)
                              return "The country name seems a bit short. Please enter a full country name that is at least 4 characters.";
                            // If the country name is more than 45 characters long, it is too long and invalid
                            else if (value.length > 45)
                              return "The country name is too long. Please enter a country name of maximum 45 characters.";
                            // Otherwise, it is valid
                            else
                              return null;
                          },
                          style: TextStyle(
                              // Set font based on body font set by user/default font
                              fontFamily: themeService.getCurrentBodyFont(),
                              fontSize: 23,
                              // Set text colour based on current theme
                              color: themeService.getCurrentTheme() == 'light'
                                  ? Colors.black
                                  : Colors.white),
                          decoration: InputDecoration(
                            // Hint text to tell user to enter a country
                            hintText: "Country",
                            hintStyle: TextStyle(
                                // Set font based on body font set by user/default font
                                fontFamily: themeService.getCurrentBodyFont(),
                                fontSize: 23,
                                color:
                                    // Set hint text colour based on current theme
                                    themeService.getCurrentTheme() == 'light'
                                        ? const Color.fromARGB(
                                            255, 142, 142, 142)
                                        : const Color.fromARGB(
                                            255, 180, 175, 175)),
                            // Set Underline colour when idle based on current theme
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                              color: themeService.getCurrentTheme() == 'light'
                                  ? const Color.fromARGB(255, 0, 72, 25)
                                  : const Color.fromARGB(255, 211, 206, 210),
                            )),
                            // Set Underline colour when user is typing based on current theme
                            focusedBorder: UnderlineInputBorder(
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
                        ),
                        const SizedBox(height: 20),
                        // Form field to enter State/Province of hotel
                        TextFormField(
                          // Set cursor colour based on current theme
                          cursorColor: themeService.getCurrentTheme() == 'light'
                              ? const Color.fromARGB(255, 20, 123, 23)
                              : const Color.fromARGB(255, 255, 251, 254),
                          onSaved: (value) {
                            // If the hotel's location has no state/province, save hotel/province to "stateProvince" attribute of hotel object as null
                            if (value == null || value.length == 0) {
                              hotel.stateProvince = null;
                            } else {
                              // If it has, save hotel state/province to "stateProvince" attribute of hotel object as String
                              hotel.stateProvince = value as String;
                            }
                          },
                          // Validator to check if the state/province name is valid
                          validator: (value) {
                            // If the state/province was not entered, it is still valid
                            if (value == null || value.length == 0)
                              return null;
                            // If the state/province name is less than 4 characters long, it is too short and invalid
                            else if (value.length < 4)
                              return "The state/province name seems a bit short. Please enter a name that is at least 4 characters.";
                            // If the state/province name is more than 45 characters long, it is too long and invalid
                            else if (value.length > 45)
                              return "The state/province name is too long. Please enter name of maximum 45 characters.";
                            // Otherwise, it is valid
                            else
                              return null;
                          },
                          style: TextStyle(
                              // Set font based on body font set by user/default font
                              fontFamily: themeService.getCurrentBodyFont(),
                              fontSize: 23,
                              // Set text colour based on current theme
                              color: themeService.getCurrentTheme() == 'light'
                                  ? Colors.black
                                  : Colors.white),
                          decoration: InputDecoration(
                            // Hint text to tell user to enter a state/province, and that it is optional as well
                            hintText: "State/Province (if any)",
                            hintStyle: TextStyle(
                                // Set font based on body font set by user/default font
                                fontFamily: themeService.getCurrentBodyFont(),
                                fontSize: 23,
                                // Set hint text colour based on current theme
                                color: themeService.getCurrentTheme() == 'light'
                                    ? const Color.fromARGB(255, 142, 142, 142)
                                    : const Color.fromARGB(255, 180, 175, 175)),
                            // Set Underline colour when idle based on current theme
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                              color: themeService.getCurrentTheme() == 'light'
                                  ? const Color.fromARGB(255, 0, 72, 25)
                                  : const Color.fromARGB(255, 211, 206, 210),
                            )),
                            // Set Underline colour when user is typing based on current theme
                            focusedBorder: UnderlineInputBorder(
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
                        ),
                        const SizedBox(height: 20),
                        // Form field to enter City of hotel
                        TextFormField(
                          // Set cursor colour based on current theme
                          cursorColor: themeService.getCurrentTheme() == 'light'
                              ? const Color.fromARGB(255, 20, 123, 23)
                              : const Color.fromARGB(255, 255, 251, 254),
                          onSaved: (value) {
                            // If the hotel's location has no city, save city to "city" attribute of hotel object as null
                            if (value == null || value.length == 0) {
                              hotel.city = null;
                            } else {
                              // If it has, save the entered city name to "city" attribute of hotel object as String
                              hotel.city = value as String;
                            }
                          },
                          // Validator to check if the city name is valid
                          validator: (value) {
                            // If the city name was not entered, it is still valid
                            if (value == null || value.length == 0)
                              return null;
                            // If the city name is less than 4 characters long, it is too short and invalid
                            else if (value.length < 4)
                              return "The city name seems a bit short. Please enter a name that is at least 4 characters.";
                            // If the city name is more than 45 characters long, it is too long and invalid
                            else if (value.length > 45)
                              return "The city name is too long. Please enter name of maximum 45 characters.";
                            // Otherwise, it is valid
                            else
                              return null;
                          },
                          style: TextStyle(
                              // Set font based on body font set by user/default font
                              fontFamily: themeService.getCurrentBodyFont(),
                              fontSize: 23,
                              // Set text colour based on current theme
                              color: themeService.getCurrentTheme() == 'light'
                                  ? Colors.black
                                  : Colors.white),
                          decoration: InputDecoration(
                            // Hint text to tell user to enter a hotel name
                            hintText: "City (if necessary)",
                            hintStyle: TextStyle(
                                // Set font based on body font set by user/default font
                                fontFamily: themeService.getCurrentBodyFont(),
                                fontSize: 23,
                                // Set hint text colour based on current theme
                                color: themeService.getCurrentTheme() == 'light'
                                    ? const Color.fromARGB(255, 142, 142, 142)
                                    : const Color.fromARGB(255, 180, 175, 175)),
                            // Set Underline colour when idle based on current theme
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                              color: themeService.getCurrentTheme() == 'light'
                                  ? const Color.fromARGB(255, 0, 72, 25)
                                  : const Color.fromARGB(255, 211, 206, 210),
                            )),
                            // Set Underline colour when user is typing based on current theme
                            focusedBorder: UnderlineInputBorder(
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
                        ),
                        const SizedBox(height: 20),
                        // Form field to enter Street Address of hotel
                        TextFormField(
                          // Set cursor colour based on current theme
                          cursorColor: themeService.getCurrentTheme() == 'light'
                              ? const Color.fromARGB(255, 20, 123, 23)
                              : const Color.fromARGB(255, 255, 251, 254),
                          onSaved: (value) {
                            // Save hotel's street address to "address" attribute of hotel object as String
                            hotel.address = value as String;
                          },
                          // Validator to check if the street address is valid
                          validator: (value) {
                            // If the address was not entered, it is invalid
                            if (value == null || value.length == 0)
                              return "Please provide the street address of your hotel.";
                            // If the country name is less than 10 characters long, it is too short and invalid
                            else if (value.length < 10)
                              return "The address seems a bit short. Please enter an address of at least 10 characters .";
                            // If the country name is more than 50 characters long, it is too long and invalid
                            else if (value.length > 50)
                              return "The address is too long. Please enter an address of maximum 50 characters.";
                            // Otherwise, it is valid
                            else
                              return null;
                          },
                          // 1 line space is given by default for the address and shortest address occupies 1 line long
                          minLines: 1,
                          // Allow user to enter up to 3 lines for the address
                          maxLines: 3,
                          style: TextStyle(
                              // Set font based on body font set by user/default font
                              fontFamily: themeService.getCurrentBodyFont(),
                              fontSize: 23,
                              // Set text colour based on current theme
                              color: themeService.getCurrentTheme() == 'light'
                                  ? Colors.black
                                  : Colors.white),
                          decoration: InputDecoration(
                            // Hint text to tell user to enter a hotel name
                            hintText: "Street Address",
                            hintStyle: TextStyle(
                                // Set font based on body font set by user/default font
                                fontFamily: themeService.getCurrentBodyFont(),
                                fontSize: 23,
                                // Set hint text colour based on current theme
                                color: themeService.getCurrentTheme() == 'light'
                                    ? const Color.fromARGB(255, 142, 142, 142)
                                    : const Color.fromARGB(255, 180, 175, 175)),
                            // Set Underline colour when idle based on current theme
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                              color: themeService.getCurrentTheme() == 'light'
                                  ? const Color.fromARGB(255, 0, 72, 25)
                                  : const Color.fromARGB(255, 211, 206, 210),
                            )),
                            // Set Underline colour when user is typing based on current theme
                            focusedBorder: UnderlineInputBorder(
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
                        ),
                      ]),
                ],
              ),
            ),
          )),
    );
  }
}
