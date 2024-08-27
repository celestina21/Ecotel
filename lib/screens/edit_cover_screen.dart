// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors_in_immutables, use_build_context_synchronously, body_might_complete_normally_nullable, avoid_web_libraries_in_flutter

import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sohleecelest_2301028c_pc09/models/hotel.dart';
import 'package:sohleecelest_2301028c_pc09/screens/hotel_updated_screen.dart';
import 'package:sohleecelest_2301028c_pc09/services/firebase_service.dart';
import 'package:sohleecelest_2301028c_pc09/services/theme_service.dart';

class EditCoverScreen extends StatefulWidget {
  static const String routeName = '/edit-cover';

  @override
  State<EditCoverScreen> createState() => _EditCoverScreenState();
}

class _EditCoverScreenState extends State<EditCoverScreen> {
  // Get the FirebaseService instance as fbService to access storeImage(), updateHotel() and getCurrentUser() functions
  final FirebaseService fbService = GetIt.instance<FirebaseService>();
  // Get the ThemeService instance as themeService to access getCurrentTheme() function
  final ThemeService themeService = GetIt.instance<ThemeService>();

  // Define hotel variable to retrieve current hotel's cover image
  Hotel? hotel;

  // Define a variable to track loading state
  bool isLoading = false;
  // Define variable to store the image file picked from mobile for preview
  File? pickedMobileImage;
  // Define variable to store the image in web format for preview
  Uint8List? pickedWebImage;
  // Define array of valid image file extensions
  final List<String> validExtensions = ['jpg', 'jpeg', 'png', 'webp'];

  // Function to display material banner with defined text
  void showMaterialBanner(String text) {
    ScaffoldMessenger.of(context).showMaterialBanner(MaterialBanner(
      content: Text(text,
          style: TextStyle(
            // Set font based on body font set by user/default font
            fontFamily: themeService.getCurrentBodyFont(),
            fontSize: 23,
            // Set text colour based on current theme
            color: themeService.getCurrentTheme() == 'light'
                ? Colors.black
                : Colors.white,
          )),
      // Set banner colour based on current theme
      backgroundColor: themeService.getCurrentTheme() == 'light'
          ? const Color.fromARGB(255, 255, 252, 244)
          : const Color.fromARGB(255, 140, 140, 140),
      // Dismiss button to hide the banner
      actions: [
        TextButton(
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
          },
          child: Text(
            'Dismiss',
            style: TextStyle(
              // Set font based on body font set by user/default font
              fontFamily: themeService.getCurrentBodyFont(),
              fontSize: 23,
              // Set Dismiss colour based on current theme
              color: themeService.getCurrentTheme() == 'light'
                  ? Colors.black
                  : const Color.fromARGB(255, 255, 251, 254),
            ),
          ),
        ),
      ],
    ));
  }

  // Function to pick an image from gallery
  Future<void> pickImage() async {
    // If the platform is web, use the FilePicker plugin to pick an image
    if (kIsWeb) {
      FilePickerResult? result = await FilePicker.platform
          .pickFiles(type: FileType.image) // Pick only image files
          .onError((error, stackTrace) {
        showMaterialBanner(
            "Something went wrong with selecting the image! Please try again, sorry.");
        return null;
      });
      // If a file is picked, check if it is a valid image file
      if (result != null) {
        // Get the extension of the picked file to check if it is a valid image file
        String fileName = result.files.first.name;
        String? fileExtension = fileName.split('.').last.toLowerCase();
        if (validExtensions.contains(fileExtension)) {
          // Show material banner to notify user that the image has been received successfully and so they can submit it.
          showMaterialBanner(
              "Your image has been received and is ready for submission. If you do not see it, please wait a while for it to be displayed.");
          // Assign the picked image to the pickedWebImage variable for display and rebuild page to display the picked image
          setState(() {
            // Save the uploaded image to pickedWebImage for display
            pickedWebImage = result.files.first.bytes;
          });
        } else {
          // If the file is not a valid image file, show a material banner to inform user to upload a valid image file
          showMaterialBanner("Please upload a valid image file.");
        }
      }
    } else {
      // If the platform is mobile, use the ImagePicker plugin to pick an image
      XFile? pickedImage = await ImagePicker()
          .pickImage(source: ImageSource.gallery) // Pick an image from gallery
          .onError((error, stackTrace) {
        showMaterialBanner(
            "Something went wrong with selecting the image! Please try again, sorry.");
        return null;
      });
      // If an image is picked, check if it is a valid image file
      if (pickedImage != null) {
        String fileName = pickedImage.name;
        String? fileExtension = fileName.split('.').last.toLowerCase();
        if (validExtensions.contains(fileExtension)) {
          // Show material banner to notify user that the image has been received successfully and so they can submit it.
          showMaterialBanner(
              "Your image has been received and is ready for submission. If you do not see it, please wait a while for it to be displayed.");
          // Assign the picked image to the pickedMobileImage variable for display and rebuild page to display the picked image
          setState(() {
            pickedMobileImage = File(pickedImage.path);
          });
        } else {
          // If the file is not a valid image file, show a material banner to inform user to upload a valid image file
          showMaterialBanner("Please upload a valid image file.");
        }
      }
    }
  }

  // Function to replace the image in firebase storage with the new one and retrieve its URL to update the hotel object (image attribute) in firestore
  void updateImageAndHotel() {
    // If an image has not been picked, show a banner to tell user to pick an image before uploading
    if (pickedMobileImage == null && pickedWebImage == null) {
      showMaterialBanner("Please pick an image.");
    } else {
      // Set loading state to true to show circular progress indicator as the image and hotel are being updated
      setState(() {
        isLoading = true;
      });
      // Replace the previous cover image in Firebase storage with the new one
      fbService
          .storeImage(hotel!.owner, pickedMobileImage, pickedWebImage)
          .then((image) {
        // Update the hotel object in the Firestore database with the new cover image URL
        fbService
            .updateHotel(
                hotel!.owner,
                hotel!.name,
                hotel!.rating,
                hotel!.country,
                hotel!.stateProvince,
                hotel!.city,
                hotel!.address,
                hotel!.certifications,
                hotel!.practices,
                image)
            .then((value) {
          // Once successful, loading is finished and navigate to the hotel updated screen to show success message
          setState(() {
            isLoading = false;
          });
          // Show SnackBar to notify user that the hotel's cover image was updated successfully
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            // Set snackbar background colour based on current theme
            backgroundColor: themeService.getCurrentTheme() == "light"
                ? const Color.fromARGB(255, 185, 252, 123)
                : const Color.fromARGB(255, 80, 158, 52),
            content: Text(
              "Cover Image Updated Successfully!",
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
          Navigator.of(context).pushReplacementNamed(
              HotelUpdatedScreen.routeName,
              arguments: fbService.getCurrentUser()!.email);
        }).onError((error, stackTrace) {
          // If there is an error in updating the hotel object in Firestore, show a material banner to inform user that something went wrong
          setState(() {
            isLoading = false;
          });
          showMaterialBanner(
              "Something went wrong with updating the hotel details :(");
        });
      }).onError((error, stackTrace) {
        setState(() {
          isLoading = false;
        });
        // If there is an error in updating the image in Firebase storage, show a material banner to inform user that something went wrong
        showMaterialBanner(
            "Something went wrong with updating the cover image.");
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
      appBar: AppBar(
        // Set app bar back button colour based on current theme
        foregroundColor: themeService.getCurrentTheme() == 'light'
            ? Colors.black
            : Colors.white,
        // Set app bar background colour based on current theme
        backgroundColor: themeService.getCurrentTheme() == 'light'
            ? Theme.of(context).colorScheme.inversePrimary
            : const Color.fromARGB(255, 34, 34, 34),
        title: Text('Cover Image',
            style: TextStyle(
              // Set font based on heading set by user/default font
              fontFamily: themeService.getCurrentHeadingFont(),
              // Set font size based on heading set by user/default font so that headings are consistent
              fontSize: themeService.getCurrentHeadingFont() == "Nunito Sans"
                  ? 34
                  : 36,
              fontWeight: FontWeight.bold,
              // Set title colour based on current theme
              color: themeService.getCurrentTheme() == 'light'
                  ? Colors.black
                  : Colors.white,
            )),
      ),
      // StreamBuilder to get the hotel details of the owner from Firestore to get the current cover image
      body: StreamBuilder<dynamic>(
          stream: fbService.getHotelByOwner(fbService.getCurrentUser()!.email!),
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
                          fontFamily: "Nunito Sans",
                          fontSize: 40,
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
                  child: Text("No hotel details found :(",
                      style: TextStyle(
                        // Set font based on body font set by user/default font
                        fontFamily: themeService.getCurrentBodyFont(),
                        fontSize: 25,
                        // Set text colour based on current theme
                        color: themeService.getCurrentTheme() == 'light'
                            ? Colors.black
                            : Colors.white,
                      )));
            } else {
              // If there is data, get the hotel object from the snapshot, storing it in hotel variable
              hotel = snapshot.data;
              return isLoading == false
                  // If the page is not loading, show the image/file picker and submit button
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Column(children: [
                          const SizedBox(height: 20),
                          // Submit button to update the image in Firebase storage and hotel object in Firestore
                          ElevatedButton(
                              onPressed: () {
                                updateImageAndHotel();
                              },
                              style: ElevatedButton.styleFrom(
                                  // Set Submit Image button colour based on current theme
                                  backgroundColor: themeService
                                              .getCurrentTheme() ==
                                          "light"
                                      ? const Color.fromRGBO(125, 227, 88, 1)
                                      : const Color.fromARGB(
                                          255, 109, 179, 152)),
                              child: Text(
                                "Submit Image",
                                style: TextStyle(
                                  // Set font based on body font set by user/default font
                                  fontFamily: themeService.getCurrentBodyFont(),
                                  fontSize: 23,
                                  color: Colors.black,
                                ),
                              )),
                          const SizedBox(height: 25),
                          // Button to pick an image from gallery
                          ElevatedButton(
                              onPressed: () {
                                pickImage();
                              },
                              style: ElevatedButton.styleFrom(
                                // Set Pick Image button colour based on current theme
                                backgroundColor: themeService
                                            .getCurrentTheme() ==
                                        'light'
                                    ? const Color.fromARGB(219, 181, 248, 195)
                                    : const Color.fromARGB(255, 120, 183, 158),
                              ),
                              child: Text(
                                "Pick Image from Gallery",
                                style: TextStyle(
                                  // Set font based on body font set by user/default font
                                  fontFamily: themeService.getCurrentBodyFont(),
                                  // Set font size based on body font set by user/default font
                                  fontSize: themeService.getCurrentBodyFont() ==
                                          'Arial'
                                      ? 23
                                      : 22,
                                  color: Colors.black,
                                ),
                              )),
                          const SizedBox(height: 20),
                          kIsWeb
                              // If the platform is web, display the image in web format
                              ? pickedWebImage != null
                                  ? SizedBox(
                                      height: 400,
                                      width: 600,
                                      child: Image.memory(pickedWebImage!),
                                    )
                                  // If no image is picked, display the current cover image of the hotel
                                  : SizedBox(
                                      height: 400,
                                      width: 600,
                                      child: Image.network(hotel!.image),
                                    )
                              :
                              // If the platform is mobile, display the image in mobile format
                              pickedMobileImage != null
                                  ? SizedBox(
                                      height: 200,
                                      width: 300,
                                      child: Image.file(pickedMobileImage!),
                                    )
                                  // If no image is picked, display the current cover image of the hotel
                                  : SizedBox(
                                      height: 200,
                                      width: 300,
                                      child: Image.network(hotel!.image),
                                    )
                        ]),
                      ),
                    )
                  // If the page is loading, show a circular progress indicator to indicate loading
                  : const Center(
                      child: CircularProgressIndicator(
                          backgroundColor: Color.fromARGB(255, 25, 231, 42)),
                    );
            }
          }),
    );
  }
}
