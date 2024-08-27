// ignore_for_file: use_key_in_widget_constructors, prefer_is_empty, curly_braces_in_flow_control_structures

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:sohleecelest_2301028c_pc09/models/hotel.dart';
import 'package:sohleecelest_2301028c_pc09/screens/hotel_details_screen.dart';
import 'package:sohleecelest_2301028c_pc09/services/firebase_service.dart';
import 'package:sohleecelest_2301028c_pc09/services/theme_service.dart';
import 'package:sohleecelest_2301028c_pc09/widgets/account_content_widget.dart';

class HomeScreen extends StatefulWidget {
  static String routeName = '/home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Initialise FirebaseService object to access getHotels(), getHotelsByName(), getHotelsByLocation(), and getHotelsSortedByRating() functions
  final FirebaseService fbService = GetIt.instance<FirebaseService>();
  // Initialise ThemeService object to access getCurrentTheme() functions
  final ThemeService themeService = GetIt.instance<ThemeService>();

  // Define variable to store current theme for colour management
  late String currentTheme;
  // Define ValueNotifier to store whether dark mode is enabled for switch state
  late ValueNotifier<bool> isDarkMode;

  @override
  void initState() {
    super.initState();
    // Determine initial dark mode status based on current theme
    currentTheme = themeService.getCurrentTheme();
    isDarkMode = ValueNotifier<bool>(currentTheme == "dark");
  }

  // Index to manage which screen is shown. Default is 1 (Home Screen)
  int selectedIndex = 1;

  // Variable to manage whether search bar is shown or not. Default is false (search bar hidden)
  bool showSearchBar = false;

  // Controller for TextFormField representing the search bar
  TextEditingController searchController = TextEditingController();

  // Variable to track whether filter is used
  bool isFiltering = false;

  // Define list of filtered hotels for when search function is used
  List<Hotel>? nameFilteredHotels;

  // Key to manage form state for filtering by location
  var form = GlobalKey<FormState>();

  // Define country variable to store country name for filtering
  String country = "";

  // Define city variable to store city name for filtering
  String? city;

  // Define list of filtered (by location) hotels for when filter function is used
  List<Hotel>? locationFilteredHotels;

  // Variable to track whether sort is used
  bool isSorting = false;

  // Define list of sorted hotels for when sort function is used
  List<Hotel>? sortedHotels;

  // Function to hide the search bar when 'X' button is pressed by setting showSearchbar to false.
  // It clears the TextFormField's contents before hiding it if user was entering a query.
  void hideSearchBar() {
    setState(() {
      searchController.clear();
      showSearchBar = false;
      nameFilteredHotels = null;
    });
  }

  // A function to validate then submit locations details for filtering hotels
  void filterByLocation() {
    // AlertDialog to get filter criteria
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          // Set background colour of the dialog based on the current theme
          backgroundColor: themeService.getCurrentTheme() == 'light'
              ? const Color.fromARGB(255, 196, 251, 207)
              : const Color.fromARGB(255, 100, 173, 114),
          title: Text(
            'Filter to only hotels from:',
            textAlign: TextAlign.center,
            style: TextStyle(
              // Set font based on body font set by user/default font
              fontFamily: themeService.getCurrentBodyFont(),
              fontSize: 25,
              color: Colors.black,
            ),
          ),
          // Form to get country and city names for filtering
          content: Form(
            key: form,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // TextFormField for country name
                TextFormField(
                    // Set colour of cursor based on current theme
                    cursorColor: themeService.getCurrentTheme() == 'light'
                        ? const Color.fromARGB(255, 20, 123, 23)
                        : const Color.fromARGB(255, 255, 251, 254),
                    onSaved: (value) {
                      // Save hotel name as String
                      country = value as String;
                    },
                    // Validator to check if the country name is valid
                    validator: (value) {
                      // If the country name was not entered, it is invalid
                      if (value == null || value.length == 0)
                        return "Please provide the country.";
                      // If the country name is less than 4 characters long, it is too short and invalid
                      else if (value.length < 4)
                        return "Enter a country that is at least 4 characters.";
                      // If the country name is more than 45 characters long, it is too long and invalid
                      else if (value.length > 45)
                        return "Enter a country of maximum 45 characters.";
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
                    // Hint text telling user to enter country name
                    decoration: InputDecoration(
                      hintText: 'Country',
                      hintStyle: TextStyle(
                          // Set font based on body font set by user/default font
                          fontFamily: themeService.getCurrentBodyFont(),
                          fontSize: 20,
                          // Set hint text colour based on current theme
                          color: themeService.getCurrentTheme() == 'light'
                              ? const Color.fromARGB(255, 142, 142, 142)
                              : const Color.fromARGB(255, 196, 190, 190)),
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
                    )),
                const SizedBox(height: 15),
                // TextFormField for city name
                TextFormField(
                    // Set colour of cursor based on current theme
                    cursorColor: themeService.getCurrentTheme() == 'light'
                        ? const Color.fromARGB(255, 20, 123, 23)
                        : const Color.fromARGB(255, 255, 251, 254),
                    onSaved: (value) {
                      // Checks if a city name was entered
                      if (value == null || value.length == 0) {
                        // If it was not, save city as null
                        city = null;
                      } else {
                        // If it was, save the city name entered
                        city = value;
                      }
                    },
                    // Validator to check if the city name is valid
                    validator: (value) {
                      // If the city was not entered, it is still valid
                      if (value == null || value.length == 0)
                        return null;
                      // If the city name is less than 4 characters long, it is too short and invalid
                      else if (value.length < 4)
                        return "Enter a city that is at least 4 characters.";
                      // If the city name is more than 45 characters long, it is too long and invalid
                      else if (value.length > 45)
                        return "Enter city of maximum 45 characters.";
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
                    // Hint text telling user to enter city name (optional)
                    decoration: InputDecoration(
                      hintText: 'City (Optional)',
                      hintStyle: TextStyle(
                          // Set font based on body font set by user/default font
                          fontFamily: themeService.getCurrentBodyFont(),
                          fontSize: 20,
                          // Set hint text colour based on current theme
                          color: themeService.getCurrentTheme() == 'light'
                              ? const Color.fromARGB(255, 142, 142, 142)
                              : const Color.fromARGB(255, 196, 190, 190)),
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
                    )),
              ],
            ),
          ),
          actions: [
            // Cancel button to close the dialog when clicked and not filter
            Padding(
              // Set padding based on font set by user/default font so that UI placement is consistent
              padding: EdgeInsets.only(
                  right: themeService.getCurrentBodyFont() == 'Arial' ? 20 : 0),
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Cancel',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    // Set font based on body font set by user/default font
                    fontFamily: themeService.getCurrentBodyFont(),
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            // Apply Filters button to validate and save the form values, then filter hotels based on the location details entered
            ElevatedButton(
              onPressed: () {
                // Trigger all validators for each form field
                bool isValid = form.currentState!.validate();

                // If the inputs were all valid
                if (isValid) {
                  // Save the form values
                  form.currentState!.save();

                  // Get hotels with matching location details
                  fbService.getHotelsByLocation(country, city).listen((hotels) {
                    // Update the list of hotels to display the filtered hotels by rebuilding the screen with locationFilteredHotels used to build the stream
                    setState(() {
                      locationFilteredHotels = hotels;
                      // Set isFiltering to true to indicate that the filter is active
                      isFiltering = true;
                    });
                  });
                  // Hide keyboard after saving values
                  FocusScope.of(context).unfocus();

                  // Close the dialog
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                // Set background colour of Apply Filters button based on the current theme
                backgroundColor: themeService.getCurrentTheme() == "light"
                    ? Theme.of(context).colorScheme.inversePrimary
                    : const Color.fromARGB(255, 27, 207, 138),
                padding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
              ),
              child: Text('Apply Filters',
                  style: TextStyle(
                    // Set font based on body font set by user/default font
                    fontFamily: themeService.getCurrentBodyFont(),
                    fontSize: 20,
                    color: Colors.black,
                  )),
            ),
          ],
        );
      },
    );
  }

  // Function to sort hotels by star rating
  void sortHotels() {
    // Get hotels sorted by rating
    fbService.getHotelsSortedByRating().listen((hotels) {
      // Update the list of hotels to display the sorted hotels by rebuilding the screen with sortedHotels used to build the stream
      setState(() {
        sortedHotels = hotels;
        // Set isSorting to true to indicate that the sort is active
        isSorting = true;
      });
    });
  }

  // Function to build the body of the screen based on the selected index.
  Widget buildBody(selectedIndex) {
    // if the selected index is 1 (Home page selected), build the Home Screen body
    if (selectedIndex == 1) {
      return Column(
        children: [
          // showSearchBar = true, show the search bar containing the following UI elements
          if (showSearchBar)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextFormField(
                // Set colour of cursor based on current theme
                cursorColor: themeService.getCurrentTheme() == 'light'
                    ? const Color.fromARGB(255, 20, 123, 23)
                    : const Color.fromARGB(255, 255, 251, 254),
                // Specify searchController as this TextFormField's controller
                controller: searchController,
                style: TextStyle(
                    // Set font based on body font set by user/default font
                    fontFamily: themeService.getCurrentBodyFont(),
                    fontSize: 25,
                    // Set text colour based on current theme
                    color: themeService.getCurrentTheme() == 'light'
                        ? Colors.black
                        : Colors.white),
                decoration: InputDecoration(
                  // Hint text to tell user to enter a hotel name
                  hintText: "Hotel Name",
                  hintStyle: TextStyle(
                      // Set font based on body font set by user/default font
                      fontFamily: themeService.getCurrentBodyFont(),
                      fontSize: 25,
                      // Set hint text colour based on current theme
                      color: themeService.getCurrentTheme() == 'light'
                          ? const Color.fromARGB(255, 142, 142, 142)
                          : const Color.fromARGB(255, 244, 240, 244)),
                  // 'X' button to hide search bar when pressed
                  suffixIcon: IconButton(
                    onPressed: () {
                      hideSearchBar();
                    },
                    icon: Icon(
                      Icons.clear,
                      size: 30,
                      // Set clear icon colour based on current theme
                      color: themeService.getCurrentTheme() == 'light'
                          ? const Color.fromARGB(255, 72, 72, 72)
                          : const Color.fromARGB(255, 255, 251, 254),
                    ),
                  ),
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
                ),
                onChanged: (value) {
                  if (value.length > 0) {
                    fbService.getHotelsByName(value).listen((hotels) {
                      setState(() {
                        nameFilteredHotels = hotels;
                      });
                    });
                  }
                },
              ),
            ),
          const SizedBox(height: 10),
          // Section for filter and Sort buttons
          Row(
            children: [
              // Filter button
              Expanded(
                // If isFiltering is true, show a button to stop filtering
                child: isFiltering
                    ? ElevatedButton(
                        // When pressed, stop filtering by setting isFiltering to false and locationFilteredHotels to null
                        // Rebuild screen to show all hotels again
                        onPressed: () {
                          setState(() {
                            isFiltering = false;
                            locationFilteredHotels = null;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              // Set background colour of Stop Filter button based on the current theme
                              themeService.getCurrentTheme() == 'light'
                                  ? const Color.fromARGB(255, 145, 255, 167)
                                  : const Color.fromARGB(255, 119, 193, 164),
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                        child: Text(
                          "Stop Filter",
                          style: TextStyle(
                            // Set font based on body font set by user/default font
                            fontFamily: themeService.getCurrentBodyFont(),
                            fontSize: 28,
                            color: Colors.black,
                          ),
                        ),
                      )
                    // If isFiltering is false, show a button to filter hotels by location
                    : ElevatedButton(
                        onPressed: () {
                          // AlertDialog to confirm the desire to filter, warning user it will override other queries
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  // Set background colour of the dialog based on the current theme
                                  backgroundColor: themeService
                                              .getCurrentTheme() ==
                                          'light'
                                      ? const Color.fromARGB(255, 196, 251, 207)
                                      : const Color.fromARGB(
                                          255, 100, 173, 114),
                                  title: Text(
                                    'Are You Sure?',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      // Set font based on body font set by user/default font
                                      fontFamily:
                                          themeService.getCurrentBodyFont(),
                                      fontSize: 25,
                                      color: Colors.black,
                                    ),
                                  ),
                                  content: Text(
                                      'If you filter, other queries will be removed (search, sort).',
                                      style: TextStyle(
                                        // Set font based on body font set by user/default font
                                        fontFamily:
                                            themeService.getCurrentBodyFont(),
                                        fontSize: 20,
                                        color: Colors.black,
                                      )),
                                  actions: [
                                    // Cancel button to close the dialog when clicked and not proceed with filter and not override other queries
                                    Padding(
                                      padding: const EdgeInsets.only(right: 28),
                                      child: TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          'Cancel',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            // Set font based on body font set by user/default font
                                            fontFamily: themeService
                                                .getCurrentBodyFont(),
                                            fontSize: 20,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Yes button to proceed with filtering and overriding other queries before proceeding with filter
                                    ElevatedButton(
                                      onPressed: () {
                                        if (isSorting) {
                                          setState(() {
                                            isSorting = false;
                                            sortedHotels = null;
                                          });
                                        }
                                        if (showSearchBar) {
                                          hideSearchBar();
                                        }
                                        Navigator.pop(context);
                                        filterByLocation();
                                      },
                                      style: ElevatedButton.styleFrom(
                                        // Set background colour of Yes button based on the current theme
                                        backgroundColor:
                                            themeService.getCurrentTheme() ==
                                                    "light"
                                                ? Theme.of(context)
                                                    .colorScheme
                                                    .inversePrimary
                                                : const Color.fromARGB(
                                                    255, 27, 207, 138),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 0, horizontal: 15),
                                      ),
                                      child: Text('Yes',
                                          style: TextStyle(
                                            // Set font based on body font set by user/default font
                                            fontFamily: themeService
                                                .getCurrentBodyFont(),
                                            fontSize: 20,
                                            color: Colors.black,
                                          )),
                                    ),
                                  ],
                                );
                              });
                        },
                        style: ElevatedButton.styleFrom(
                          // Set background colour of Filter button based on the current theme
                          backgroundColor:
                              themeService.getCurrentTheme() == 'light'
                                  ? const Color.fromARGB(255, 145, 255, 167)
                                  : const Color.fromARGB(255, 119, 193, 164),
                          padding: EdgeInsets.symmetric(
                              vertical:
                                  themeService.getCurrentBodyFont() == 'Arial'
                                      ? 5
                                      : 6),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                        child: Text(
                          "Filter (Location)",
                          style: TextStyle(
                            // Set font based on body font set by user/default font
                            fontFamily: themeService.getCurrentBodyFont(),
                            // Set font size based on body font set by user/default font so that text is consistent
                            fontSize:
                                themeService.getCurrentBodyFont() == 'Arial'
                                    ? 27.8
                                    : 25.6,
                            color: Colors.black,
                          ),
                        ),
                      ),
              ),
              // If the screen is web, use a different height for the divider
              kIsWeb
                  ?
                  // Divider to separate Filter and Sort buttons
                  Container(
                      color: const Color.fromARGB(208, 112, 112, 112),
                      width: 2,
                      height: 42,
                    )
                  : Container(
                      color: const Color.fromARGB(208, 112, 112, 112),
                      width: 2,
                      height: 50,
                    ),
              // Sort button
              Expanded(
                // If isSorting is true, show a button to stop sorting
                child: isSorting
                    ? ElevatedButton(
                        onPressed: () {
                          setState(() {
                            isSorting = false;
                            sortedHotels = null;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          // Set background colour of Stop Sort button based on the current theme
                          backgroundColor:
                              themeService.getCurrentTheme() == 'light'
                                  ? const Color.fromARGB(255, 145, 255, 167)
                                  : const Color.fromARGB(255, 119, 193, 164),
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                        child: Text(
                          "Stop Sort",
                          style: TextStyle(
                            // Set font based on body font set by user/default font
                            fontFamily: themeService.getCurrentBodyFont(),
                            fontSize: 28,
                            color: Colors.black,
                          ),
                        ),
                      )
                    // If isSorting is false, show a button to sort hotels by rating
                    : ElevatedButton(
                        onPressed: () {
                          // AlertDialog to confirm sort function, warning user it will override other queries
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  // Set background colour of the dialog based on the current theme
                                  backgroundColor: themeService
                                              .getCurrentTheme() ==
                                          'light'
                                      ? const Color.fromARGB(255, 196, 251, 207)
                                      : const Color.fromARGB(
                                          255, 100, 173, 114),
                                  title: Text(
                                    'Are You Sure?',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      // Set font based on body font set by user/default font
                                      fontFamily:
                                          themeService.getCurrentBodyFont(),
                                      fontSize: 25,
                                      color: Colors.black,
                                    ),
                                  ),
                                  content: const Text(
                                      'If you sort, other queries will be removed (search, filter).'),
                                  actions: [
                                    // Cancel button to close the dialog when clicked and not proceed with sort and not override other queries
                                    Padding(
                                      padding: const EdgeInsets.only(right: 28),
                                      child: TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          'Cancel',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            // Set font based on body font set by user/default font
                                            fontFamily: themeService
                                                .getCurrentBodyFont(),
                                            fontSize: 20,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Yes button to proceed with sorting and overriding of other queries before proceeding with sort
                                    ElevatedButton(
                                      onPressed: () {
                                        if (isFiltering) {
                                          setState(() {
                                            isFiltering = false;
                                            locationFilteredHotels = null;
                                          });
                                        }
                                        if (showSearchBar) {
                                          hideSearchBar();
                                        }
                                        Navigator.pop(context);
                                        sortHotels();
                                      },
                                      style: ElevatedButton.styleFrom(
                                        // Set background colour of Yes button based on the current theme
                                        backgroundColor:
                                            themeService.getCurrentTheme() ==
                                                    "light"
                                                ? Theme.of(context)
                                                    .colorScheme
                                                    .inversePrimary
                                                : const Color.fromARGB(
                                                    255, 27, 207, 138),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 0, horizontal: 15),
                                      ),
                                      child: Text('Yes',
                                          style: TextStyle(
                                            // Set font based on body font set by user/default font
                                            fontFamily: themeService
                                                .getCurrentBodyFont(),
                                            fontSize: 20,
                                            color: Colors.black,
                                          )),
                                    ),
                                  ],
                                );
                              });
                        },
                        style: ElevatedButton.styleFrom(
                          // Set background colour of Sort button based on the current theme
                          backgroundColor:
                              themeService.getCurrentTheme() == 'light'
                                  ? const Color.fromARGB(255, 145, 255, 167)
                                  : const Color.fromARGB(255, 119, 193, 164),
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                        child: Text(
                          "Sort (Rating)",
                          style: TextStyle(
                            // Set font based on body font set by user/default font
                            fontFamily: themeService.getCurrentBodyFont(),
                            fontSize: 28,
                            color: Colors.black,
                          ),
                        ),
                      ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Section displaying all hotels from database in a ListView
          Expanded(
            child: StreamBuilder<List<Hotel>?>(
                stream: fbService.getHotels(),
                builder: (context, snapshot) {
                  // If the connection is waiting, show a circular progress indicator to indicate loading
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                    // If there is an error, show a text to inform user that there was an error and what the error was
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        children: [
                          Text(
                            "Error :( \n",
                            style: TextStyle(
                                // Set font family based on current/default font
                                fontFamily:
                                    themeService.getCurrentHeadingFont(),
                                // Set font size based on heading set by user/default font so that headings are consistent
                                fontSize:
                                    themeService.getCurrentHeadingFont() ==
                                            'Nunito Sans'
                                        ? 40
                                        : 42,
                                fontWeight: FontWeight.bold,
                                // Set error text colour based on current theme
                                color: themeService.getCurrentTheme() == 'light'
                                    ? Colors.black
                                    : Colors.white),
                          ),
                          Text(
                            snapshot.error.toString(),
                            style: TextStyle(
                              // Set font based on body font set by user/default font
                              fontFamily: themeService.getCurrentBodyFont(),
                              fontSize: 25,
                              // Set error text colour based on current theme
                              color: themeService.getCurrentTheme() == 'light'
                                  ? Colors.black
                                  : Colors.white,
                            ),
                          ),
                        ],
                      ),
                    );
                    // If there is no data or the data is null, show a text to inform user that there are no hotel details found
                  } else if (!snapshot.hasData || snapshot.data == null) {
                    return Center(
                        child: Text("No hotels found :(",
                            style: TextStyle(
                              // Set font based on body font set by user/default font
                              fontFamily: themeService.getCurrentBodyFont(),
                              fontSize: 25,
                              // Set text colour based on current theme
                              color: themeService.getCurrentTheme() == 'light'
                                  ? Colors.black
                                  : Colors.white,
                            )));
                    // If the search function is used and no hotels with matching names are found, show a text to inform user that there are no matching hotels found
                  } else if (nameFilteredHotels != null &&
                      nameFilteredHotels!.isEmpty) {
                    return Center(
                        child: Text(
                      "No matching hotels found :(",
                      style: TextStyle(
                        // Set font based on body font set by user/default font
                        fontFamily: themeService.getCurrentBodyFont(),
                        fontSize: 25,
                        // Set text colour based on current theme
                        color: themeService.getCurrentTheme() == 'light'
                            ? Colors.black
                            : Colors.white,
                      ),
                    ));
                    // If the filter function is used and no hotels with matching location details are found, show a text to inform user that there are no matching hotels found
                  } else if (locationFilteredHotels != null &&
                      locationFilteredHotels!.isEmpty) {
                    return Center(
                        child: Text(
                      "No matching hotels found :(",
                      style: TextStyle(
                        // Set font based on body font set by user/default font
                        fontFamily: themeService.getCurrentBodyFont(),
                        fontSize: 25,
                        color: themeService.getCurrentTheme() == 'light'
                            ? Colors.black
                            : Colors.white,
                      ),
                    ));
                  } else {
                    /* 
                    Checks if search function, filter function, or sort function is used before displaying hotels.
                    If search function is used and nameFilteredHotels as a result is not empty, display the hotels with matching names.
                    If filter function is used and locationFilteredHotels as a result is not empty, display the hotels with matching location details.
                    If sort function is used and sortedHotels as a result is not empty, display the sorted hotels.
                    Else, display all hotels from the database in default order. 
                    */
                    List<Hotel>? hotels = nameFilteredHotels ??
                        locationFilteredHotels ??
                        sortedHotels ??
                        snapshot.data!;
                    // If nameFilteredHotels is not empty, display the hotels in a ListView
                    return ListView.builder(
                      itemCount: hotels.length,
                      itemBuilder: (context, index) {
                        Hotel hotel = hotels[index];
                        // If a hotel Card is tapped, it will lead to Hotel Details page for that specific hotel
                        return GestureDetector(
                          onTap: () => Navigator.of(context).pushNamed(
                            HotelDetailsScreen.routeName,
                            arguments: hotel.owner,
                          ),
                          // Each hotel to be represented in a card
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7),
                            ),
                            // Set background colour of hotel card based on the current theme
                            color: themeService.getCurrentTheme() == 'light'
                                ? const Color.fromARGB(219, 181, 248, 195)
                                : const Color.fromARGB(255, 120, 183, 158),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Hotel cover image
                                ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(7),
                                    bottomLeft: Radius.circular(7),
                                  ),
                                  child: Image.network(
                                    hotel.image,
                                    width: 150,
                                    height: 120,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                // Hotel information (name, location, rating)
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 5),
                                      // Hotel name as title
                                      Text(
                                        hotel.name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          // Set font based on body font set by user/default font
                                          fontFamily:
                                              themeService.getCurrentBodyFont(),
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      // Hotel location
                                      Text(
                                        // Check if hotel has a city in location details
                                        hotel.city != null
                                            // If hotel has a city, check if it has a state/province in location details
                                            ? hotel.stateProvince != null
                                                // If it has both city and state/province, display hotel location in this format: city, state/province, country
                                                ? "${hotel.city}, ${hotel.stateProvince}, ${hotel.country}"
                                                // If hotel does not have state/province, display hotel location in this format: city, country
                                                : "${hotel.city}, ${hotel.country}"
                                            // if hotel does not have city, check if it has a state/province in location details
                                            : hotel.stateProvince != null
                                                // If it has state/province, display hotel location in this format: state/province, country
                                                ? "${hotel.stateProvince}, ${hotel.country}"
                                                // If hotel has neither a city nor a state/province, display hotel location as just the country
                                                : hotel.country,
                                        // Location details should be confined within 1 line
                                        maxLines: 1,
                                        // If location details are too long, cut it off with an ellipsis to indicate more information is available
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          // Set font based on body font set by user/default font
                                          fontFamily:
                                              themeService.getCurrentBodyFont(),
                                          fontSize: 18,
                                          fontStyle: FontStyle.italic,
                                          color: Colors.black,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      //  Star rating represented as the number of stars in a row
                                      Row(
                                        children: [
                                          for (int i = 0; i < hotel.rating; i++)
                                            Image.asset("images/star.png",
                                                width: 25),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                }),
          ),
        ],
      );
      // If the selected index is not 1 (Account page selected), build the Account Screen body
      /* 
      The selected index being 2 (Account page) is not specified in the else statement.
      This is because selected index 0 (Settings page) is a bottom modal sheet and overlays another screen.
      Thus, the body is either the Home Screen or the Account Screen, so a selectedIndex other than 1 implicitly means Account screen for this function
      */
    } else {
      return AccountContentWidget();
    }
  }

  // Build Home/Account screen using Scaffold
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Set background colour of the screen based on the current theme
      backgroundColor: themeService.getCurrentTheme() == 'light'
          ? const Color.fromARGB(255, 255, 251, 254)
          : const Color.fromARGB(255, 109, 108, 108),
      // Bottom navigation bar to navigate between Home, Account, and Settings
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 30,
        // The selected screen will be indicated in the bottom navigation bar using a larger and black text
        selectedLabelStyle: TextStyle(
          // Set font based on body font set by user/default font
          fontFamily: themeService.getCurrentBodyFont(),
          fontSize: 17,
          // Set text colour based on the current theme
          color: themeService.getCurrentTheme() == 'light'
              ? Colors.black
              : Colors.white,
        ),
        // Set the colour of the selected screen's icon to black
        selectedItemColor: themeService.getCurrentTheme() == "light"
            ? Colors.black
            : Colors.white,
        // The unselected screens will be displayed in the bottom navigation bar with smaller text
        // Set text style for unselected screens based on the current theme
        unselectedLabelStyle: TextStyle(
          // Set font based on body font set by user/default font
          fontFamily: themeService.getCurrentBodyFont(),
          fontSize: 15,
        ),
        // Set the colour of the unselected screens' icons based on the current theme
        unselectedItemColor: themeService.getCurrentTheme() == 'light'
            ? const Color.fromARGB(255, 81, 81, 81)
            : const Color.fromARGB(255, 188, 188, 188),
        // Set background colour of the bottom navigation bar based on the current theme
        backgroundColor: themeService.getCurrentTheme() == 'light'
            ? const Color.fromARGB(255, 128, 220, 84)
            : const Color.fromARGB(255, 68, 68, 68),
        // Items in the navigation bar
        /* 
        Item at index 0: Settings screen (bottom modal sheet overlaying either Home or Account Screen)
        Item at index 1: Home screen
        Item at index 2: Account screen
        */
        items: const [
          // Settings page
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
          ),
          // Home page
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          // Account page
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: "Account",
          ),
        ],
        // Use selectedIndex to keep track of current index for navigation
        currentIndex: selectedIndex,
        // When user taps on an item in the bottom navigation bar, screen will change according to index
        onTap: (index) {
          // If the selected index is 0, the Settings bottom modal sheet will overlay the previous screen
          if (index == 0) {
            // Settings bottom modal sheet for customisation
            showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return Container(
                  // Set background colour of the bottom modal sheet based on the current theme
                  color: themeService.getCurrentTheme() == 'light'
                      ? const Color.fromARGB(255, 73, 193, 101)
                      : const Color.fromARGB(255, 117, 117, 117),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      // Row used to place cancel button at the top right corner of the bottom modal sheet
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // Cancel button to close the bottom modal sheet when clicked
                          IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: const Icon(
                              Icons.close,
                              size: 30,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Change to Light/Dark Mode",
                        style: TextStyle(
                          // Set font based on body font set by user/default font
                          fontFamily: themeService.getCurrentBodyFont(),
                          fontSize: 27,
                          // Set text colour based on the current theme
                          color: themeService.getCurrentTheme() == 'light'
                              ? Colors.black
                              : Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Switch button with a sun and moon on either end to indicate which mode is selected
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Sun icon to indicate light mode
                          const Icon(
                            Icons.wb_sunny,
                            color: Colors.yellow,
                            size: 40,
                          ),
                          const SizedBox(width: 10),
                          // use ValueListenableBuilder to change the switch button based on the current mode
                          ValueListenableBuilder<bool>(
                            // Specify the valueListenable as isDarkMode defined earlier
                            valueListenable: isDarkMode,
                            // Build the switch button based on the current mode selected (Light/Dark) using ValueListenableBuilder
                            builder: (context, value, child) {
                              return Switch(
                                value: value,
                                // When dark mode is selected, button is active. The active colour is black to indicate dark mode
                                activeColor: Colors.black,
                                // Change the isDarkMode's value when switch button is toggled
                                onChanged: (value) {
                                  setState(() {
                                    isDarkMode.value = value;
                                    // Update theme based on switch state
                                    if (value) {
                                      themeService.setTheme(
                                        const Color.fromARGB(255, 69, 69, 69),
                                        'dark',
                                      );
                                    } else {
                                      themeService.setTheme(
                                        const Color.fromRGBO(125, 227, 88, 1),
                                        'light',
                                      );
                                    }
                                  });
                                },
                              );
                            },
                          ),
                          const SizedBox(width: 10),
                          // Moon icon to indicate dark mode
                          const Icon(
                            Icons.nightlight_round,
                            color: Colors.black,
                            size: 40,
                          )
                        ],
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.only(left: kIsWeb ? 100 : 0),
                        child: Row(
                          children: [
                            Text(
                              "Heading fonts",
                              style: TextStyle(
                                  // Set font based on body font set by user/default font
                                  fontFamily: themeService.getCurrentBodyFont(),
                                  fontSize: 27,
                                  // Set heading colour based on current theme
                                  color:
                                      themeService.getCurrentTheme() == 'light'
                                          ? Colors.black
                                          : const Color.fromARGB(
                                              255, 244, 240, 244)),
                            ),
                            SizedBox(
                                width:
                                    themeService.getCurrentBodyFont() == 'Arial'
                                        ? 10
                                        : 0),
                            // Dropdownmenu to select font used for headings
                            DropdownMenu(
                                width: kIsWeb ? 220 : 210,
                                inputDecorationTheme: InputDecorationTheme(
                                  // Set border colour based on current theme
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                    color:
                                        // Set border colour when idle based on current theme
                                        themeService.getCurrentTheme() ==
                                                'light'
                                            ? const Color.fromARGB(
                                                255, 0, 72, 25)
                                            : const Color.fromARGB(
                                                255, 211, 206, 210),
                                  )),
                                  // Set border colour when user is selecting based on current theme
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                    color: themeService.getCurrentTheme() ==
                                            'light'
                                        ? const Color.fromARGB(255, 72, 72, 72)
                                        : const Color.fromARGB(
                                            255, 255, 251, 254),
                                  )),
                                ),
                                textStyle: TextStyle(
                                  // Set font based on body font set by user/default font
                                  fontFamily: themeService.getCurrentBodyFont(),
                                  fontSize: themeService.getCurrentBodyFont() ==
                                          'Arial'
                                      ? 23
                                      : 21,
                                  height: 1,
                                  // Set text colour based on current theme
                                  color:
                                      themeService.getCurrentTheme() == 'light'
                                          ? Colors.black
                                          : Colors.white,
                                ),
                                trailingIcon: Icon(
                                  Icons.arrow_drop_down,
                                  size: 45,
                                  // Set icon colour when not in use based on current theme
                                  color:
                                      themeService.getCurrentTheme() == 'light'
                                          ? Colors.black
                                          : Colors.white,
                                ),
                                selectedTrailingIcon: Icon(
                                  Icons.arrow_drop_up,
                                  size: 45,
                                  // Set icon colour when in use based on current theme
                                  color:
                                      themeService.getCurrentTheme() == 'light'
                                          ? Colors.black
                                          : Colors.white,
                                ),
                                menuStyle: MenuStyle(
                                    // Set menu background colour based on current theme
                                    backgroundColor:
                                        MaterialStatePropertyAll<Color>(
                                            themeService.getCurrentTheme() ==
                                                    'light'
                                                ? const Color.fromARGB(
                                                    255, 255, 251, 254)
                                                : const Color.fromARGB(
                                                    255, 109, 108, 108)),
                                    // Set menu item colour based on current theme
                                    surfaceTintColor: MaterialStatePropertyAll<
                                        Color>(themeService.getCurrentTheme() ==
                                            'light'
                                        ? const Color.fromARGB(
                                            255, 255, 251, 254)
                                        : const Color.fromARGB(
                                            255, 109, 108, 108))),
                                // Initial selection is the current/default heading font
                                initialSelection:
                                    themeService.getCurrentHeadingFont(),
                                // List of available headihg fonts
                                dropdownMenuEntries: [
                                  DropdownMenuEntry(
                                      value: "Nunito Sans",
                                      label: "Nunito Sans",
                                      style: ButtonStyle(
                                          // Use text style to preview what the font looks like
                                          textStyle:
                                              const MaterialStatePropertyAll<
                                                  TextStyle>(TextStyle(
                                            fontFamily: "Nunito Sans",
                                            fontSize: 23,
                                          )),
                                          // Set text colour based on current theme
                                          foregroundColor:
                                              MaterialStatePropertyAll<
                                                  Color>(themeService
                                                          .getCurrentTheme() ==
                                                      'light'
                                                  ? Colors.black
                                                  : Colors.white))),
                                  DropdownMenuEntry(
                                      value: "Arsenal SC",
                                      label: "Arsenal SC",
                                      style: ButtonStyle(
                                          // Use text style to preview what the font looks like
                                          textStyle:
                                              const MaterialStatePropertyAll<
                                                  TextStyle>(TextStyle(
                                            fontFamily: "Arsenal SC",
                                            fontSize: 25,
                                          )),
                                          // Set text colour based on current theme
                                          foregroundColor:
                                              MaterialStatePropertyAll<
                                                  Color>(themeService
                                                          .getCurrentTheme() ==
                                                      'light'
                                                  ? Colors.black
                                                  : Colors.white))),
                                ],
                                // Function to update the UI to display the selected font
                                onSelected: (value) {
                                  setState(() {
                                    themeService
                                        .setHeadingFont(value.toString());
                                  });
                                }),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.only(left: kIsWeb ? 140 : 20),
                        child: Row(
                          children: [
                            Text(
                              "Body fonts",
                              style: TextStyle(
                                  // Set font based on body font set by user/default font
                                  fontFamily: themeService.getCurrentBodyFont(),
                                  fontSize: 27,
                                  // Set heading colour based on current theme
                                  color:
                                      themeService.getCurrentTheme() == 'light'
                                          ? Colors.black
                                          : const Color.fromARGB(
                                              255, 244, 240, 244)),
                            ),
                            const SizedBox(width: 10),
                            // Dropdownmenu to select font used for body
                            DropdownMenu(
                                width: 217,
                                inputDecorationTheme: InputDecorationTheme(
                                  // Set border colour based on current theme
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                    color:
                                        // Set border colour when idle based on current theme
                                        themeService.getCurrentTheme() ==
                                                'light'
                                            ? const Color.fromARGB(
                                                255, 0, 72, 25)
                                            : const Color.fromARGB(
                                                255, 211, 206, 210),
                                  )),
                                  // Set border colour when user is selecting based on current theme
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                    color: themeService.getCurrentTheme() ==
                                            'light'
                                        ? const Color.fromARGB(255, 72, 72, 72)
                                        : const Color.fromARGB(
                                            255, 255, 251, 254),
                                  )),
                                ),
                                textStyle: TextStyle(
                                  // Set font based on body font set by user/default font
                                  fontFamily: themeService.getCurrentBodyFont(),
                                  fontSize: 23,
                                  height: 1,
                                  // Set text colour based on current theme
                                  color:
                                      themeService.getCurrentTheme() == 'light'
                                          ? Colors.black
                                          : Colors.white,
                                ),
                                trailingIcon: Icon(
                                  Icons.arrow_drop_down,
                                  size: 50,
                                  // Set icon colour when not in use based on current theme
                                  color:
                                      themeService.getCurrentTheme() == 'light'
                                          ? Colors.black
                                          : Colors.white,
                                ),
                                selectedTrailingIcon: Icon(
                                  Icons.arrow_drop_up,
                                  size: 50,
                                  // Set icon colour when in use based on current theme
                                  color:
                                      themeService.getCurrentTheme() == 'light'
                                          ? Colors.black
                                          : Colors.white,
                                ),
                                menuStyle: MenuStyle(
                                    // Set menu background colour based on current theme
                                    backgroundColor:
                                        MaterialStatePropertyAll<Color>(
                                            themeService.getCurrentTheme() ==
                                                    'light'
                                                ? const Color.fromARGB(
                                                    255, 255, 251, 254)
                                                : const Color.fromARGB(
                                                    255, 109, 108, 108)),
                                    // Set menu item colour based on current theme
                                    surfaceTintColor: MaterialStatePropertyAll<
                                        Color>(themeService.getCurrentTheme() ==
                                            'light'
                                        ? const Color.fromARGB(
                                            255, 255, 251, 254)
                                        : const Color.fromARGB(
                                            255, 109, 108, 108))),
                                // Initial selection is the current/default body font
                                initialSelection:
                                    themeService.getCurrentBodyFont(),
                                // List of available body fonts
                                dropdownMenuEntries: [
                                  DropdownMenuEntry(
                                      value: "Arial",
                                      label: "Arial",
                                      style: ButtonStyle(
                                          // Use text style to preview what the font looks like
                                          textStyle:
                                              const MaterialStatePropertyAll<
                                                  TextStyle>(TextStyle(
                                            fontFamily: "Arial",
                                            fontSize: 23,
                                          )),
                                          // Set text colour based on current theme
                                          foregroundColor:
                                              MaterialStatePropertyAll<
                                                  Color>(themeService
                                                          .getCurrentTheme() ==
                                                      'light'
                                                  ? Colors.black
                                                  : Colors.white))),
                                  DropdownMenuEntry(
                                      value: "Roboto Slab",
                                      label: "Roboto Slab",
                                      style: ButtonStyle(
                                          // Use text style to preview what the font looks like
                                          textStyle:
                                              const MaterialStatePropertyAll<
                                                  TextStyle>(TextStyle(
                                            fontFamily: "Roboto Slab",
                                            fontSize: 23,
                                          )),
                                          // Set text colour based on current theme
                                          foregroundColor:
                                              MaterialStatePropertyAll<
                                                  Color>(themeService
                                                          .getCurrentTheme() ==
                                                      'light'
                                                  ? Colors.black
                                                  : Colors.white))),
                                ],
                                // Function to update the UI to display the selected font
                                onSelected: (value) {
                                  setState(() {
                                    themeService.setBodyFont(value.toString());
                                  });
                                }),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
            );
            // If the selected index is not 0, assign index to selectedIndex for buildBody function to handle screen change
          } else {
            setState(() {
              selectedIndex = index;
            });
          }
        },
      ),
      appBar: selectedIndex == 1
          // If the selectedIndex is 1 (Home page), show the Home screen's app bar
          ? AppBar(
              // Increase height of app bar to fit the enlarged search icon.
              toolbarHeight: 55,
              // Remove back button
              automaticallyImplyLeading: false,
              // App bar to have same colour as scaffold
              backgroundColor: themeService.getCurrentTheme() == 'light'
                  ? const Color.fromARGB(255, 255, 251, 254)
                  : const Color.fromARGB(255, 109, 108, 108),
              // Remove tint over the app bar
              surfaceTintColor: Colors.transparent,
              title: Text(
                "Ecotel",
                style: TextStyle(
                  // Set font based on heading set by user/default font
                  fontFamily: themeService.getCurrentHeadingFont(),
                  // Set font size based on heading set by user/default font so that headings are consistent
                  fontSize:
                      themeService.getCurrentHeadingFont() == "Nunito Sans"
                          ? 40
                          : 42,
                  fontWeight: FontWeight.bold,
                  // Set text colour based on current theme
                  color: themeService.getCurrentTheme() == "light"
                      ? Colors.black
                      : Colors.white,
                ),
              ),
              actions: [
                // Search button
                IconButton(
                  // When pressed, shows the search bar by setting showSearchBar to true
                  onPressed: () {
                    // AlertDialog to use search function
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          // Set background colour of the dialog based on the current theme
                          backgroundColor:
                              themeService.getCurrentTheme() == 'light'
                                  ? const Color.fromARGB(255, 196, 251, 207)
                                  : const Color.fromARGB(255, 100, 173, 114),
                          title: Text(
                            'Search overrides other methods (sort, filter)\nProceed?',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              // Set font based on body font set by user/default font
                              fontFamily: themeService.getCurrentBodyFont(),
                              fontSize: 25,
                              color: Colors.black,
                            ),
                          ),
                          actions: [
                            Padding(
                              padding: const EdgeInsets.only(right: 28),
                              child: TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  'Cancel',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    // Set font based on body font set by user/default font
                                    fontFamily:
                                        themeService.getCurrentBodyFont(),
                                    fontSize: 20,
                                    color: Colors.black,
                                    height: 2,
                                  ),
                                ),
                              ),
                            ),
                            // Button to cancel filtering and sorting to proceed with search
                            ElevatedButton(
                              onPressed: () {
                                if (isFiltering) {
                                  setState(() {
                                    isFiltering = false;
                                    locationFilteredHotels = null;
                                  });
                                }
                                if (isSorting) {
                                  setState(() {
                                    isSorting = false;
                                    sortedHotels = null;
                                  });
                                }
                                // Open the search bar
                                setState(() {
                                  showSearchBar = true;
                                });
                                // Close the dialog
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    //  Set background colour of Proceed button based on the current theme
                                    themeService.getCurrentTheme() == "light"
                                        ? Theme.of(context)
                                            .colorScheme
                                            .inversePrimary
                                        : const Color.fromARGB(
                                            255, 27, 207, 138),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 15),
                              ),
                              child: Text('Proceed',
                                  style: TextStyle(
                                    // Set font based on body font set by user/default font
                                    fontFamily:
                                        themeService.getCurrentBodyFont(),
                                    fontSize: 20,
                                    color: Colors.black,
                                  )),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  icon: Icon(
                    Icons.search,
                    size: 55,
                    // Set search icon colour based on current theme
                    color: themeService.getCurrentTheme() == 'light'
                        ? const Color.fromARGB(255, 84, 84, 84)
                        : const Color.fromARGB(255, 239, 237, 237),
                  ),
                )
              ],
            )
          // If the selectedIndex is not 1, show the Account screen's app bar
          : AppBar(
              // Remove back button
              automaticallyImplyLeading: false,
              // Set app bar background colour based on current theme
              backgroundColor: themeService.getCurrentTheme() == 'light'
                  ? Theme.of(context).colorScheme.inversePrimary
                  : const Color.fromARGB(255, 34, 34, 34),
              title: Text(
                "Account Details",
                style: TextStyle(
                  // Set font based on heading set by user/default font
                  fontFamily: themeService.getCurrentHeadingFont(),
                  // Set font size based on heading set by user/default font so that headings are consistent
                  fontSize:
                      themeService.getCurrentHeadingFont() == "Nunito Sans"
                          ? 40
                          : 42,
                  fontWeight: FontWeight.bold,
                  // Set text colour based on current theme
                  color: themeService.getCurrentTheme() == "light"
                      ? Colors.black
                      : Colors.white,
                ),
              ),
            ),
      // Uses buildBody function to build the body of the screen based on the selected index
      body: buildBody(selectedIndex),
    );
  }
}
