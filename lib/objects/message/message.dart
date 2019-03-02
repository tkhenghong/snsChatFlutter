import 'package:snschat_flutter/objects/multimedia/multimedia.dart';

class UnreadMessage {
  String lastMessage;
  int date;
  int count;

  UnreadMessage({this.lastMessage, this.date, this.count});
}

// system message or normal message, sticker, gifs, emojis, video, recording, photos,
class Message {
  String id;
  String conversationId;
  Recipient recipient;
  String type;
  String status; // Sent, received, unread, read
  String message;
  Multimedia multimedia;

  Message(
      {this.id,
      this.conversationId,
      this.recipient,
      this.type,
      this.status,
      this.message,
      this.multimedia});
}

class Recipient {
  Sender sender;
  Receiver receiver;

  Recipient({this.sender, this.receiver});
}

class Sender {
  String id;
  String mobileNo;
  String name;
  int time; // send time
  Sender({this.id, this.mobileNo, this.name, this.time});
}

class Receiver {
  String id;
  String mobileNo;
  String name;
  int time; // receive time
  Receiver({this.id, this.mobileNo, this.name, this.time});
}
