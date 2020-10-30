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