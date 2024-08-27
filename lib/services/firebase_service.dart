import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sohleecelest_2301028c_pc09/models/hotel.dart';

class FirebaseService {
  // Registers a new user with the provided email and password
  Future<UserCredential> register(email, password) {
    return FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
  }

  // Function to add a user to the Firestore database
  Future<void> addUser(String email) {
    // Add the hotel object to the Firestore database in "hotels" collection
    return FirebaseFirestore.instance.collection('users').add({
      'email': email.toLowerCase(),
      'hotel': null,
    });
  }

  // Logs in an existing user with the provided email and password
  Future<UserCredential> login(email, password) {
    return FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
  }

  // Logs in a user with Google Sign In
  Future<UserCredential> googleLogin() async {
    // Trigger the Google Sign In process and store the user's credentials
    // Pass in clientID for web. For mobile, the clientID is automatically detected.
    GoogleSignInAccount? googleUser = await GoogleSignIn(
            clientId:
                "638917452083-ub6o5k33gcnuub8ntt6k896m1nvtn1jv.apps.googleusercontent.com")
        .signIn();
    // Get the authentication details from the Google Sign In process to retrieve the user's credentials
    GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
    // Register user in Firebase with the Google Sign In credentials
    AuthCredential credential = GoogleAuthProvider.credential(
      idToken: googleAuth?.idToken,
      accessToken: googleAuth?.accessToken,
    );
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  // Sends a password reset email to the provided email for users who forgot their password
  Future<void> resetPassword(email) {
    return FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  // Function to get the current authenticated user as a stream to monitor user authentication state
  // If the user is signed out, the stream will emit a null value
  Stream<User?> getAuthUser() {
    return FirebaseAuth.instance.authStateChanges();
  }

  // Get current authenticated user's details
  User? getCurrentUser() {
    return FirebaseAuth.instance.currentUser;
  }

  // Function to log out the current user
  Future<void> logOut() {
    return FirebaseAuth.instance.signOut();
  }

  // Updates the user's password after reauthenticating the user with their old password
  Future<void> updatePassword(String newPassword, String oldPassword) async {
    // Get the current authenticated user
    User? currentUser = getCurrentUser();
    // Reauthenticate the user with their old password before updating the password. The email is filled in with currentUser's email by default.
    await currentUser!.reauthenticateWithCredential(
        EmailAuthProvider.credential(
            email: currentUser.email!, password: oldPassword));
    // Update the password
    return currentUser.updatePassword(newPassword);
  }

  // Function to get all hotels as a stream of a list of hotel objects
  Stream<List<Hotel>?> getHotels() {
    return FirebaseFirestore.instance
        .collection('hotels')
        .snapshots()
        .map((snapshot) => snapshot.docs
            // Convert the snapshot to a list of hotel objects
            .map((doc) => Hotel(
                  owner: doc['owner'],
                  name: doc['name'],
                  rating: doc['rating'],
                  country: doc['country'],
                  stateProvince: doc['stateProvince'],
                  city: doc['city'],
                  address: doc['address'],
                  certifications: List<String>.from(doc['certifications']),
                  practices: List<Map<String, dynamic>>.from(doc['practices']),
                  image: doc['image'],
                ))
            .toList());
  }

  // Function to get hotels with matching city and/or country as a stream of a list of hotel objects
  Stream<List<Hotel>?> getHotelsByLocation(String? country, String? city) {
    // If the city null, perform the query based on country only
    Query query = FirebaseFirestore.instance
        .collection('hotels')
        .where('country', isEqualTo: country);
    // If the city is not null, perform the query based on both country and city by adding a clause for city
    if (city != null) {
      query = query.where('city', isEqualTo: city);
    }
    return query.snapshots().map((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs
            // Convert the snapshot to a list of hotel objects
            .map((doc) => Hotel(
                  owner: doc['owner'],
                  name: doc['name'],
                  rating: doc['rating'],
                  country: doc['country'],
                  stateProvince: doc['stateProvince'],
                  city: doc['city'],
                  address: doc['address'],
                  certifications: List<String>.from(doc['certifications']),
                  practices: List<Map<String, dynamic>>.from(doc['practices']),
                  image: doc['image'],
                ))
            .toList();
      } else {
        // If no matching document is found, return an empty list
        return <Hotel>[];
      }
    });
  }

  // Function to get all hotels sorted by rating (highest to lowest) as a stream of a list of hotel objects
  Stream<List<Hotel>?> getHotelsSortedByRating() {
    return FirebaseFirestore.instance
        .collection('hotels')
        // Sort by rating in descending order
        .orderBy('rating', descending: true)
        .snapshots()
        // Convert the snapshot to a list of hotel objects
        .map((snapshot) => snapshot.docs
            .map((doc) => Hotel(
                  owner: doc['owner'],
                  name: doc['name'],
                  rating: doc['rating'],
                  country: doc['country'],
                  stateProvince: doc['stateProvince'],
                  city: doc['city'],
                  address: doc['address'],
                  certifications: List<String>.from(doc['certifications']),
                  practices: List<Map<String, dynamic>>.from(doc['practices']),
                  image: doc['image'],
                ))
            .toList());
  }

  // Function to get all hotels with a matching name as a stream of a list of hotel objects
  Stream<List<Hotel>?> getHotelsByName(String name) {
    return FirebaseFirestore.instance
        .collection('hotels')
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        // Convert the snapshot to a list of hotel objects
        return snapshot.docs
            .map((doc) => Hotel(
                  owner: doc['owner'],
                  name: doc['name'],
                  rating: doc['rating'],
                  country: doc['country'],
                  stateProvince: doc['stateProvince'],
                  city: doc['city'],
                  address: doc['address'],
                  certifications: List<String>.from(doc['certifications']),
                  practices: List<Map<String, dynamic>>.from(doc['practices']),
                  image: doc['image'],
                ))
            // Filter the hotels based on the name where the name contains the search query
            .where((hotel) =>
                hotel.name.toLowerCase().contains(name.toLowerCase()))
            .toList();
      } else {
        // If no matching document is found, return an empty list
        return <Hotel>[];
      }
    });
  }

  // Function to get a hotel by its owner's email. Mainly used for displaying the user's hotel, editing the hotel, and deleting the hotel.
  Stream<Hotel?> getHotelByOwner(String email) {
    return FirebaseFirestore.instance
        .collection('hotels')
        .where('owner', isEqualTo: email)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        // Create a Hotel object from the document data
        return Hotel(
          owner: snapshot.docs.first['owner'],
          name: snapshot.docs.first['name'],
          rating: snapshot.docs.first['rating'],
          country: snapshot.docs.first['country'],
          stateProvince: snapshot.docs.first['stateProvince'],
          city: snapshot.docs.first['city'],
          address: snapshot.docs.first['address'],
          certifications:
              List<String>.from(snapshot.docs.first['certifications']),
          practices:
              List<Map<String, dynamic>>.from(snapshot.docs.first['practices']),
          image: snapshot.docs.first['image'],
        );
      } else {
        // If no matching document is found, return null
        return null;
      }
    });
  }

  // Function to store an image in Firebase Storage and return the image URL.
  // It takes in both mobileImage and webImage as it determines the source of the image (mobile or web) according to which is not null and uploads it accordingly.
  Future<String> storeImage(
      String? hotelOwner, File? mobileImage, Uint8List? webImage) async {
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceCoverImages = referenceRoot.child('hotel_cover_images');
    Reference referenceCurrentImage =
        referenceCoverImages.child("$hotelOwner's hotel cover");

    if (webImage != null) {
      // Await the putData operation
      await referenceCurrentImage.putData(
          webImage, SettableMetadata(contentType: 'image/jpeg'));
    } else if (mobileImage != null) {
      // Await the putFile operation
      await referenceCurrentImage.putFile(mobileImage);
    }

    // Now that the upload is complete, get the download URL
    String coverURL = await referenceCurrentImage.getDownloadURL();
    return coverURL;
  }

  // Function to add a hotel to the Firestore database
  Future<void> addHotel(
      String owner,
      String name,
      int rating,
      String country,
      String? stateProvince,
      String? city,
      String address,
      List<String> certifications,
      List<Map<String, dynamic>> practices,
      String image) {
    // Add the hotel object to the Firestore database in "hotels" collection
    return FirebaseFirestore.instance.collection('hotels').add({
      'owner': owner,
      'name': name,
      'rating': rating,
      'country': country,
      'stateProvince': stateProvince,
      'city': city,
      'address': address,
      'certifications': certifications,
      'practices': practices,
      'image': image,
    });
  }

  // Function to link a hotel to its user by changing hotel attribute of user from null to hotel's name
  Future<void> addHotelToUser(String email, String hotelName) async {
    // Query the users collection for the document with the user's email
    QuerySnapshot currentUser = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get();

    // Check if a document with the specified email exists
    if (currentUser.docs.isNotEmpty) {
      // Get the document ID to update the user's hotel attribute
      String id = currentUser.docs.first.id;

      // Add the hotel name to the user's hotel attribute in the Firestore database
      return FirebaseFirestore.instance
          .collection('users')
          .doc(id)
          .update({'hotel': hotelName});
    }
  }

  // Function to update a hotel's details
  Future<void> updateHotel(
      String owner,
      String name,
      int rating,
      String country,
      String? stateProvince,
      String? city,
      String address,
      List<String> certifications,
      List<Map<String, dynamic>> practices,
      String image) async {
    // Query the hotels collection for the hotel to be deleted according to the owner's email
    QuerySnapshot hotel = await FirebaseFirestore.instance
        .collection('hotels')
        .where('owner', isEqualTo: owner)
        .get();

    if (hotel.docs.isNotEmpty) {
      // Get the document ID of the hotel
      String id = hotel.docs.first.id;

      // Update the hotel object in the Firestore database in "hotels" collection using its id
      return FirebaseFirestore.instance.collection('hotels').doc(id).update({
        'owner': owner,
        'name': name,
        'rating': rating,
        'country': country,
        'stateProvince': stateProvince,
        'city': city,
        'address': address,
        'certifications': certifications,
        'practices': practices,
        'image': image,
      });
    }
  }

  // Delete the hotel after finding it using current user's email
  Future<void> deleteHotel(String owner) {
    return FirebaseFirestore.instance
        .collection('hotels')
        .where('owner', isEqualTo: owner)
        .get()
        .then((snapshot) async {
      DocumentSnapshot hotel = snapshot.docs.first;
      // Store the hotel's cover image URL
      String imageUrl = hotel['image'];
      // Get a reference to the Firebase Storage instance using the image URL for deletion
      Reference imageRef = FirebaseStorage.instance.refFromURL(imageUrl);
      // Delete the image from Firebase Storage before deleting the hotel document
      await imageRef.delete();
      // Delete the hotel document from the Firestore database
      hotel.reference.delete();
    });
  }

  // Function to update owner's hotel data to null when hotel is deleted
  Future<void> removeHotelFromUser(String email) async {
    // Query the users collection for the document with the user's email
    QuerySnapshot currentUser = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get();

    // Check if a document with the specified email exists
    if (currentUser.docs.isNotEmpty) {
      // Get the document ID
      String id = currentUser.docs.first.id;

      // Change the hotel to null in the user's hotel attribute in the Firestore database
      return FirebaseFirestore.instance
          .collection('users')
          .doc(id)
          .update({'hotel': null});
    }
  }
}
