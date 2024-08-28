# Ecotel - Multi-Platform (Web, Mobile) Hotel Discovery Application
## An application working on mobile phone and web browser that enables users to add a hotel with its sustainability details and/or view hotels submitted to the application. 
### The application was proposed to encourage sustainable tourism by making hotels' sustainability details accessible to and upfront for travellers.   
#### Created for Mobile Application Development module

# Table of Contents 
- [Features](#features)
- [Tools Used](#tools-used)
- [Additional Sources](#additional-notes)
- [Image Sources](#image-sources)

## Features
- TBA 

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
- Google Cloud Firestore
  
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
