# PocketChat

A real-time chat application using Spring Boot with Websocket (Currently in progress). 

Backend currently using Spring Boot with MongoDB as NoSQL database.

## Things that must have between frontend & backend:
Message broker such as RabbitMQ, Kafka to transform messages to send it to front end user. (Still deciding)
Websocket: Need to set it up to send message real time to fron end users. (DONE, but still in progress to perfect it)
Offline events and auto async: So you can behave like Firebase auto sync and offline caching DB records between frontend and backend. (Done except the messages)
Notification providers: To send notification to the front end user's device to notify them. (Not yet done)
SMS provider: To send SMS verfication code to the front end user's device. (Not yet done)
JWT device token: So you can login the front end user device with sessions securely. (with Auto refresh token) (Not yet done)
API with CRUD: All objects involved must have these main four function. (DONE)
Backup: Chat backups and essentially important for front end users. (Not yet done)
Logging: Logging important information to check in case of failure and help in diagnose. (Not yet done)
Test: Check all the code is working correctly or not. (Half way done)

## Main plugins/libraries involved in this project:

State and Database Management Solutions:

1. Flutter BLOC

2. Sembast DB

Used plugins:

1. Pull to refresh

2. Image picker

3. File management system

4. Network service (to detect network failure)

5. PIN text fields (Just found out in online Flutter libraries, some developers have ready solution already)

4. Country pickers

5. Barcode scanner

6. http

7. Network to file image

8. Web Socket Channel

9. Video Player

10. Time formatter

11. Flutter Downloader

12. JSON Annotation and JSON Serializable (For convert between object and JSON strings)
Refer to tutorial: https://www.thedroidsonroids.com/blog/how-to-build-an-app-with-flutter-networking-and-connecting-to-api
NOTE: When created the object, please run `flutter packages pub run build_runner build --delete-conflicting-outputs` to generate proper files for the objects. 

13. Flutter Display Mode
Unable to determine Swift version for flutter_displaymode related to SWIFT_VERSION:
https://github.com/ajinasokan/flutter_displaymode/issues/4

14. And some other plugins but not yet implemented...

Step to build for Android:
1. Place your keystore file in the directory.
2. Go to android/ directory, and itendify key.properties, key.profile.properties, key.release.properties files. Edit the content of the files(storeFile, keyAlias, keyPassword, storePassword)
3. Go to app level build.grable(PROJECT_ROOT/android/app/build.gradle).
4. View the TODOs in signingConfigs {...} and buildTypes {...}. You may decide which keystore to use for different environnments.

Step to build for iOS:
1. At project directory, type 'flutter build ios' (To build Podfile and Podfile.lock files for iOS)
2. cd /ios
3. Type 'pod install'
4. Open XCode, at top bar, select Product > Clean Build Folder
5. Select Product > Build (To check whether the plugins can build successfully for running in iOS or not)
6a. Sign in/up with your Apple Developer Account. (https://developer.apple.com/)
6b. Create an app with App ID.
6c. Create development team. Link devices by using their UDID. (https://www.sourcefuse.com/blog/how-to-find-udid-in-the-new-iphone-xs-iphone-xr-and-iphone-xs-max/)
6d. Go to XCode, get the app info and download it's provisioining profile.
6e. At left side menu, go to Project Navigator button(1st button in a list of horizontal synbols), and select Runner.
6f. Middle content will appear. At top of the middle content buttons, select Singing & Capabilities.
6g. Select Team and your preferred Provisioning Profile.
6h. Select Capabilities(Optional)
7. Press Play button to start running the app in simulator/real device.

Remember, 3 types of mode is available for Android development of Flutter, which are debug, profile and release.

Build app icons for Android & iOS:
Requirement:
1. Have a app icon with resolution of 1024 x 1024 (1:1) with PNG file format.

Steps:
1. At project root directory, put the file into app_icon directory.
1a. NOTE: You may put different icons for different types of environments. The APK built with different environments will show different type of icons.
2. Duplicate your app icon into 3 icons named app_icon_dev.png, app_icon_integration.png and app_icon_production.png to overwrite the defaults.
3. Then, you can start build the APK files with different icons and environments. Normally, the app can be built using

Execute the following command to build app icon into Android & iOS projects:
1. flutter pub run flutter_launcher_icons:main -f flutter_launcher_icons-development.yaml (Build app icon with app_icon_dev.png file)
2. flutter pub run flutter_launcher_icons:main -f flutter_launcher_icons-integration.yaml (Build app icon with app_icon_integration.png file)
3. flutter pub run flutter_launcher_icons:main -f flutter_launcher_icons-production.yaml (Build app icon with app_icon_production.png file)

Available Arguments for --flavor command:
1. development
2. integration
3. production

NOTE: These arguments are accepted by the tool by reading flutter_launcher_icons-<ARGUMENT_OF_FLAVOR>.yaml file.

Flutter Deployment Commands:
flutter run (Default)

flutter run --flavor development (Use development app icon in debug mode)
flutter run --flavor development --profile (Use development app icon in profile mode)
flutter run --flavor development --release (Use development app icon in release mode)

flutter run --flavor integration (Use integration app icon in debug mode)
flutter run --flavor integration --profile (Use integration app icon in profile mode)
flutter run --flavor integration --release (Use integration app icon in release mode)

flutter run --flavor production (Use production app icon in debug mode)
flutter run --flavor production --profile (Use production app icon in profile mode)
flutter run --flavor production --release (Use production app icon in release mode)

Build APK/App Bundle for Android, with splitting different architecture for different types of Android:

flutter build apk --target-platform android-arm,android-arm64,android-x64 --split-per-abi --flavor production --release

flutter build appbundle --target-platform android-arm,android-arm64,android-x64 --flavor production --release
