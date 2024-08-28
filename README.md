# Ecotel - Multi-Platform (Web, Mobile) Hotel Discovery Application
## An application working on mobile phone and web browser that enables users to add a hotel with its sustainability details and/or view hotels submitted to the application. 
### The application was proposed to encourage sustainable tourism by making hotels' sustainability details accessible to and upfront for travellers.   
#### Created for Mobile Application Development module

Video demonstration of application (mobile version) [here](https://youtu.be/9-Whs3eluCM) 
# Table of Contents 
- [Features](#features)
- [Tools Used](#tools-used)
- [Additional Sources](#additional-notes)
- [Image Sources](#image-sources)

## Features
1. Authentication
  - Register
    - Receive email and password credentials to register a new user.  
  - Login
    - Receive email and password credentials to log a user in. 
  - Login with Gmail
    - Log (new and existing) users into the app using Gmail credentials. 
  - Reset Password
    - Resets a user’s password if they click a “Forgot Password” button at the login page.  
  - Change Password
    - Option given at Account page. The function changes the user’s current password to a new one that they will fill in and submit at a form for changing passwords. 
2. Database-Related
  - Display All Hotels 
    - Gathers all hotels to displays a preview of them containing some basic information (name, location, star rating).
  - Search
    - User enters a hotel name into a search bar and a hotel of the same name will be retrieved from the database and displayed. 
  - Filter Hotels (on Home page) by location attributes (Country, City)
    - Filters the hotels displayed to only those in the specified country and/or city.  
  - Sort Hotels (on Home page) by star rating
    - Sorts the order in which hotels appear according to star rating.   
  - Display Hotel’s Details
    - Gets all details of a selected hotel to display them on Hotel Details page (name, star rating, location, street address, sustainability certifications, sustainability practices)
    - Specific details (eg: sustainability certifications) of a certain hotel are also retrieved to be displayed in the respective editing pages. 
  - Add Hotel
    - User goes through a form to enter the hotel's details and cover image to add the hotel.
  - Update Hotel's Details
    - User selects which details to change to go to their respective editing pages.
    - Basic details: name, star rating, location, street address
    - Sustainability certifications
    - Sustainability Practices
    - Cover image 
  - Delete Hotel
    - Removes the hotel from the database.
3. Additional
  - Text to Speech for Hotel Details
    - Reads a description of the hotel’s details.  
  - Share Hotel
    - Allows user to share a hotel’s details to social apps such as WhatsApp and X.
    - This information is sent with a link to Google Play for the recipient to download the app if they would like more. (App is not published, however, so it does not lead to this app) 
  - Contact Owner
    - Launches email from the app for user to contact the hotel owner regarding any queries.
    - The recipient and subject of the email would be filled in automatically for the user.  

## Tools Used 
- Flutter framework (Dart)
- Flutter packages:
  - firebase_core ^3.2.0
  - get_it ^7.6.7
  - cloud_firestore ^5.1.0
  - image_picker ^1.1.2
  - firebase_storage ^12.1.1
  - file_picker ^8.0.5
  - firebase_auth ^5.1.2
  - google_sign_in ^6.2.1
  - flutter_launcher_icons ^0.13.1
  - shared_preferences ^2.2.2
  - flutter_tts ^4.0.2
  - custom_social_share ^1.0.9
  - url_launcher ^6.3.0
  - clipboard ^0.1.3
- Google Cloud Firebase (Storage, Authentication)
- Google Cloud Firestore (Database)
  
## Additional Notes
*To recreate, set `multiDexEnabled true` in defaultConfig within android/app/build.gradle to be able to use Firebase functionalities 
Eg (can also be seen in repo's android/app/build.gradle line 46): 
```
    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId "com.example.sohleecelest_2301028c_pc09"
        // You can update the following values to match your application needs.
        // For more information, see: https://docs.flutter.dev/deployment/android#reviewing-the-gradle-build-configuration.
        minSdkVersion 23
        targetSdkVersion flutter.targetSdkVersion
        versionCode flutterVersionCode.toInteger()
        versionName flutterVersionName
        multiDexEnabled true
    }
```

## Image Sources 
The following illustrations were retrieved from [unDraw](https://undraw.co/illustrations):
- add_hotel_success.png
- change_password.png
- forgot_password.png
- hotel_deleted.png
- log_out.png
- password_updated.png
- start_page.png
- update_hotel_success.png

The following icons were retrieved from Flaticon:
- basic_details.png ([Google](https://www.flaticon.com/authors/google))
- dark_pause.png, pause.png ([Kiranshastry](https://www.flaticon.com/authors/kiranshastry))
- dark_play.png, play.png ([Pixel perfect](https://www.flaticon.com/authors/pixel-perfect))
- dark_stop.png, stop.png ([See icons](https://www.flaticon.com/authors/see-icons))
- gmail.png([Freepik](https://www.flaticon.com/authors/freepik))
- icon.png([Freepik](https://www.flaticon.com/authors/freepik))
- star.png ([Pixel perfect](https://www.flaticon.com/authors/pixel-perfect))
- whatsapp.png ([cobynecz](https://www.flaticon.com/authors/cobynecz))
- x.png ([Freepik](https://www.flaticon.com/authors/freepik))

The following icosn were retrieved from Google Fonts:
- certifications.png ([Workspace Premium icon, modified to fill ribbon section with black](https://fonts.google.com/icons?selected=Material+Symbols+Outlined:workspace_premium:FILL@0;wght@400;GRAD@0;opsz@48&icon.query=certification&icon.size=200&icon.color=%23434343&icon.platform=web))
- others.png ([Share icon](https://fonts.google.com/icons?selected=Material+Symbols+Outlined:share:FILL@0;wght@400;GRAD@0;opsz@48&icon.query=share&icon.size=200&icon.color=%23000000&icon.platform=web))
- sustainable_practices.png([Compost icon](https://fonts.google.com/icons?selected=Material+Symbols+Outlined:compost:FILL@0;wght@400;GRAD@0;opsz@48&icon.query=sust&icon.size=200&icon.color=%23000000&icon.platform=web))

The following icon was retrieved from Shutterstock:
- cover_image.png ([Purlo Punk](https://www.shutterstock.com/image-vector/panorama-icon-flat-style-design-isolated-2079296275))
