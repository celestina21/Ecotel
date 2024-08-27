// ignore_for_file: must_be_immutable, use_build_context_synchronously, use_key_in_widget_constructors, body_might_complete_normally_nullable
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:sohleecelest_2301028c_pc09/models/hotel.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:sohleecelest_2301028c_pc09/screens/hotel_added_screen.dart';
import 'package:sohleecelest_2301028c_pc09/services/firebase_service.dart';
import 'package:sohleecelest_2301028c_pc09/services/theme_service.dart';

class AddHotelCoverScreen extends StatefulWidget {
  static String routeName = '/add-hotel-cover';

  // Define hotel variable to store Hotel object passed into this page
  Hotel hotel;

  AddHotelCoverScreen({required this.hotel});

  @override
  State<AddHotelCoverScreen> createState() => _AddHotelCoverScreenState();
}

class _AddHotelCoverScreenState extends State<AddHotelCoverScreen> {
  // Get the FirebaseService instance as fbService to access storeImage() and addHotel() functions
  final FirebaseService fbService = GetIt.instance<FirebaseService>();
  // Get the ThemeService instance as themeService to access getCurrentTheme() function
  final ThemeService themeService = GetIt.instance<ThemeService>();

  // Define variable to track loading state
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

  // Function to upload the image to firebase storage and retrieve its URL to store in hotel object (image attribute) before storing hotel in firestore
  Future<void> uploadImageAndHotel() async {
    // If an image has not been picked, show a banner to tell user to pick an image before uploading
    if (pickedMobileImage == null && pickedWebImage == null) {
      showMaterialBanner("Please pick an image.");
    } else {
      // Set loading state to true to show circular progress indicator as the image and hotel are being updated
      setState(() {
        isLoading = true;
      });
      // Store the cover image in Firebase storage to get the URL of the image
      await fbService
          .storeImage(widget.hotel.owner, pickedMobileImage, pickedWebImage)
          .then((image) async {
        // Add the hotel to Firestore database with the cover image URL
        await fbService
            .addHotel(
                widget.hotel.owner,
                widget.hotel.name,
                widget.hotel.rating,
                widget.hotel.country,
                widget.hotel.stateProvince,
                widget.hotel.city,
                widget.hotel.address,
                widget.hotel.certifications,
                widget.hotel.practices,
                image)
            .then((value) {
          fbService
              .addHotelToUser(widget.hotel.owner, widget.hotel.name)
              .then((value) {
            // Once successful, loading is finished and navigate to the hotel added screen to show success message
            setState(() {
              isLoading = false;
            });
            // Show SnackBar to notify user that the hotel's cover image was added successfully
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: const Color.fromARGB(255, 185, 252, 123),
              content: Text(
                "Cover Image Added Successfully!",
                style: TextStyle(
                  // Set font based on body font set by user/default font
                  fontFamily: themeService.getCurrentBodyFont(),
                  fontSize: 23,
                  color: Colors.black,
                ),
              ),
            ));
            Navigator.of(context)
                .pushReplacementNamed(HotelAddedScreen.routeName);
          }).onError((error, stackTrace) {
            // If there is an error in adding the hotel to the user, show a material banner to inform user that something went wrong
            setState(() {
              isLoading = false;
            });
            showMaterialBanner(
                "Something went wrong with adding the hotel to your account. Please try again, sorry.");
          });
        }).onError((error, stackTrace) {
          // If there is an error in adding the hotel object in Firestore, show a material banner to inform user that something went wrong
          setState(() {
            isLoading = false;
          });
          showMaterialBanner(
              "Something went wrong with adding the hotel details :(");
        });
      }).onError((error, stackTrace) {
        setState(() {
          isLoading = false;
        });
        // If there is an error in storing the image in Firebase storage, show a material banner to inform user that something went wrong
        showMaterialBanner(
            "Something went wrong with storing the cover image. Please try again, sorry.");
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
        // Set app bar background colour based on current theme
        backgroundColor: themeService.getCurrentTheme() == 'light'
            ? Theme.of(context).colorScheme.inversePrimary
            : const Color.fromARGB(255, 34, 34, 34),
        // Remove back button from app bar
        automaticallyImplyLeading: false,
        // Title of the page to upload hotel's cover image
        title: Text(
          "Upload Cover Image",
          style: TextStyle(
            // Set font based on heading set by user/default font
            fontFamily: themeService.getCurrentHeadingFont(),
            // Set font size based on heading set by user/default font so that headings are consistent
            fontSize:
                themeService.getCurrentHeadingFont() == "Nunito Sans" ? 35 : 37,
            fontWeight: FontWeight.bold,
            // Set title colour based on current theme
            color: themeService.getCurrentTheme() == 'light'
                ? Colors.black
                : Colors.white,
          ),
        ),
      ),
      // If isLoading is false, display the page with buttons to pick an image and submit the image
      // Else, display a circular progress indicator to show that the image is being uploaded
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                  backgroundColor: Color.fromARGB(255, 25, 231, 42)),
            )
          : Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    // Button to submit image. Will also upload hotel to Firestore database
                    ElevatedButton(
                      onPressed: () {
                        uploadImageAndHotel();
                      },
                      style: ElevatedButton.styleFrom(
                        // Set Submit Image button colour based on current theme
                        backgroundColor:
                            themeService.getCurrentTheme() == "light"
                                ? const Color.fromRGBO(125, 227, 88, 1)
                                : const Color.fromARGB(255, 109, 179, 152),
                      ),
                      child: Text(
                        "Submit Image",
                        style: TextStyle(
                          // Set font based on body font set by user/default font
                          fontFamily: themeService.getCurrentBodyFont(),
                          fontSize: 23,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    // Button to pick an image from gallery
                    ElevatedButton(
                      onPressed: () {
                        pickImage();
                      },
                      style: ElevatedButton.styleFrom(
                        // Set Pick Image button colour based on current theme
                        backgroundColor:
                            themeService.getCurrentTheme() == 'light'
                                ? const Color.fromARGB(219, 181, 248, 195)
                                : const Color.fromARGB(255, 120, 183, 158),
                      ),
                      child: Text(
                        "Pick Image from Gallery",
                        style: TextStyle(
                          // Set font based on body font set by user/default font
                          fontFamily: themeService.getCurrentBodyFont(),
                          // Set font size based on body font set by user/default font
                          fontSize: themeService.getCurrentBodyFont() == 'Arial'
                              ? 23
                              : 22,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    kIsWeb
                        // If the platform is web, display the image in web format
                        ? pickedWebImage != null
                            ? SizedBox(
                                height: 400,
                                width: 600,
                                child: Image.memory(pickedWebImage!),
                              )
                            // If no image is picked, display a text to inform user that no image was picked
                            : SizedBox(
                                height: 400,
                                width: 600,
                                child: Center(
                                  child: Text(
                                    "No image selected",
                                    style: TextStyle(
                                      // Set font based on body font set by user/default font
                                      fontFamily:
                                          themeService.getCurrentBodyFont(),
                                      fontSize: 25,
                                      color: themeService.getCurrentTheme() ==
                                              'light'
                                          ? Colors.black
                                          : Colors.white,
                                    ),
                                  ),
                                ),
                              )
                        :
                        // If the platform is mobile, display the image in mobile format
                        pickedMobileImage != null
                            ? SizedBox(
                                height: 200,
                                width: 300,
                                child: Image.file(pickedMobileImage!),
                              )
                            // If no image is picked, display a text to inform user that no image was picked
                            : SizedBox(
                                height: 200,
                                width: 300,
                                child: Center(
                                  child: Text(
                                    "No image selected",
                                    style: TextStyle(
                                      // Set font based on body font set by user/default font
                                      fontFamily:
                                          themeService.getCurrentBodyFont(),
                                      fontSize: 25,
                                      color: themeService.getCurrentTheme() ==
                                              'light'
                                          ? Colors.black
                                          : Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                  ],
                ),
              ),
            ),
    );
  }
}
