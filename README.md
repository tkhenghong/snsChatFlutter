# snschat_flutter

A new Flutter application.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.io/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.io/docs/cookbook)

For help getting started with Flutter, view our 
[online documentation](https://flutter.io/docs), which offers tutorials, 
samples, guidance on mobile development, and a full API reference.

Main plugins/libraries involved in this project:

Flutter BLOC

SQflite Database

Jaguar ORM

Note: To generate Bean scripts, for sqflite, you can't use "pub run build_runner build" as mentioned in the official documentation.
Due to different flutter installation location, please always execute the following command:

    flutter packages pub run build_runner build --delete-conflicting-outputs

Mainly used plugins:

1. Pull to refresh

2. Image picker

3. File management system

4. And so on... (To be continued)