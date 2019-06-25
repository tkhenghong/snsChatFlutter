# PocketChat

A real time chat application using Firebase. A real well code implementation with litle to none bugs will be made with using high performance, good looking UI materials Flutter as frontend. 

Backend currently using Firebase to hold up the frontend to settle down the full logic of PocketChat app. After all current functionalities are settled down, Firebase backend will be replaced by open source enterprise solution backend framework called SPRING Boot with MongoDB as NoSQL database.

## Things that must have between frontend & backend:
Message broker such as RabbitMQ, Kafka to transform messages to send it to front end user.
Websocket: Need to set it up to send message real time to fron end users.
Offline events and auto async: So you can behave like Firebase auto sync and offline caching DB records between frontend and backend
Notification providers: To send notification to the front end user's device to notify them.
SMS provider: To send SMS verfication code to the front end user's device.
JWT device token: So you can login the front end user device with sessions securely. (with Auto refresh token)
API with CRUD: All objects involved must have these main four function.
Backup: Chat backups and essentially important for front end users.
Logging: Logging important information to check in case of failure and help in diagnose.
Test: Check all the code is working correctly or not.

## Main plugins/libraries involved in this project:

Flutter BLOC

SQflite Database

Jaguar ORM

Note: To generate Bean scripts, for sqflite, you can't use "pub run build_runner build" as mentioned in the official documentation.
Due to different flutter installation location, please always execute the following command:

    flutter packages pub run build_runner build --delete-conflicting-outputs

Firebase (Will replace later with SPRING)

Mainly used plugins:

1. Pull to refresh

2. Image picker

3. File management system

4. Network service (to detect network failure)

5. PIN text fields (Just found out in online Flutter libraries, some developers have ready solution already)

4. And so on... (To be continued)
