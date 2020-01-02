import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:snschat_flutter/general/functions/validation_functions.dart';
import 'package:snschat_flutter/objects/conversationGroup/conversation_group.dart';
import 'package:snschat_flutter/objects/index.dart';
import 'package:snschat_flutter/objects/message/message.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:snschat_flutter/objects/multimedia/multimedia.dart';
import 'package:snschat_flutter/service/file/FileService.dart';
import 'package:snschat_flutter/service/firebaseStorage/FirebaseStorageService.dart';
import 'package:snschat_flutter/service/image/ImageService.dart';
import 'package:snschat_flutter/state/bloc/bloc.dart';
import 'package:snschat_flutter/ui/pages/chats/chat_info/chat_info_page.dart';

import 'package:snschat_flutter/environments/development/variables.dart' as globals;

class ChatRoomPage extends StatefulWidget {
  final ConversationGroup _conversationGroup;

  ChatRoomPage([this._conversationGroup]);

  @override
  State<StatefulWidget> createState() {
    return new ChatRoomPageState();
  }
}

class ChatRoomPageState extends State<ChatRoomPage> {
  bool isShowSticker = false;
  bool isLoading;
  bool imageFound = false;
  double deviceWidth;
  double deviceHeight;

  Color appBarTextTitleColor;
  Color appBarThemeColor;

  // This is used to get batch send multiple multimedia in one go, like multiple image and video
  List<File> fileList = [];

  String WEBSOCKET_URL = globals.WEBSOCKET_URL;
  int imagePickerQuality = globals.imagePickerQuality;

  TextEditingController textEditingController = new TextEditingController();
  ScrollController listScrollController = new ScrollController();
  FocusNode focusNode = new FocusNode();

  FileService fileService = FileService();
  ImageService imageService = ImageService();
  FirebaseStorageService firebaseStorageService = FirebaseStorageService();

  @override
  void initState() {
    super.initState();
    focusNode.addListener(onFocusChange);
    isLoading = false;
    isShowSticker = false;
  }

  @override
  void dispose() {
    listScrollController.dispose();
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("widget._conversation.id: " + widget._conversationGroup.id);

    appBarTextTitleColor = Theme.of(context).appBarTheme.textTheme.title.color;
    appBarThemeColor = Theme.of(context).appBarTheme.color;

    deviceWidth = MediaQuery.of(context).size.width;
    deviceHeight = MediaQuery.of(context).size.height;

    // TODO: Send message using WebSocket
    // Do in this order (To allow resend message if anything goes wrong [Send timeout, websocket down, Internet down situations])
    // 1. Send to DB
    // 2. Send to State
    // 3. Send to API
    // 4. Retrieve through WebSocket

    return MultiBlocListener(
      listeners: [],
      child: BlocBuilder<UserBloc, UserState>(
        builder: (context, userState) {
          if (userState is UserLoading) {
            return Center(
              child: Text('Loading...'),
            );
          }

          if (userState is UserNotLoaded) {
            goToLoginPage();
            return Center(
              child: Text('Unable to load user.'),
            );
          }

          if (userState is UserLoaded) {
            return BlocBuilder<ConversationGroupBloc, ConversationGroupState>(
              builder: (context, conversationGroupState) {
                if (conversationGroupState is ConversationGroupsLoaded) {
                  ConversationGroup conversationGroup = conversationGroupState.conversationGroupList.firstWhere(
                      (ConversationGroup conversationGroup) => conversationGroup.id == widget._conversationGroup.id,
                      orElse: () => null);
                  if (!isObjectEmpty(conversationGroup)) {
                    return chatRoomMainBody(context, conversationGroup, userState.user);
                  } else {
                    Fluttertoast.showToast(msg: 'Error. Conversation Group not found.', toastLength: Toast.LENGTH_LONG);
                    Navigator.pop(context);
                  }
                }

                return chatRoomMainBody(context, null, userState.user);
              },
            );
          }

          return Center(
            child: Text('Error. Unable to load user'),
          );
        },
      ),
    );
  }

  Widget chatRoomMainBody(BuildContext context, ConversationGroup selectedConversationGroup, User user) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          titleSpacing: 0.0,
          title: BlocBuilder<MultimediaBloc, MultimediaState>(
            builder: (context, multimediaState) {
              if (multimediaState is MultimediaLoaded) {
                Multimedia multimedia = multimediaState.multimediaList.firstWhere(
                    (Multimedia existingMultimedia) => existingMultimedia.conversationId == selectedConversationGroup.id,
                    orElse: () => null);

                return chatRoomPageTopBar(context, selectedConversationGroup, multimedia);
              }

              return chatRoomPageTopBar(context, selectedConversationGroup, null);
            },
          ),
        ),
        body: WillPopScope(
          // To handle event when user press back button when sticker screen is on, dismiss sticker if keyboard is shown
          child: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  //UI for message list
                  buildListMessage(context, user),
                  // UI for stickers, gifs
                  (isShowSticker ? buildSticker(context, user, selectedConversationGroup) : Container()),
                  // UI for text field
                  buildInput(context, user, selectedConversationGroup),
                ],
              ),
              buildLoading(),
            ],
          ),
          onWillPop: onBackPress,
        ),
      ),
    );
  }

  Widget chatRoomPageTopBar(BuildContext context, ConversationGroup conversationGroup, Multimedia multimedia) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Tooltip(
          message: "Back",
          child: Material(
            color: appBarThemeColor,
            child: InkWell(
              customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Row(
                children: <Widget>[
                  Icon(Icons.arrow_back),
                  Hero(
                    tag: conversationGroup.id + "1",
                    child: imageService.loadImageThumbnailCircleAvatar(multimedia, conversationGroup.type, context),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 30.0),
                  ),
                ],
              ),
            ),
          ),
        ),
        Material(
          color: appBarThemeColor,
          child: InkWell(
              customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => ChatInfoPage(conversationGroup)));
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 10.0, right: 250.0),
                  ),
                  Hero(
                    tag: conversationGroup.id,
                    child: Text(
                      conversationGroup.name,
                      style: TextStyle(color: appBarTextTitleColor, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(
                    "Tap here for more details",
                    style: TextStyle(color: appBarTextTitleColor, fontSize: 13.0),
                  )
                ],
              )),
        ),
      ],
    );
  }

  Widget buildLoading() {
    return Positioned(
      child: isLoading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.blue)),
              ),
              color: Colors.white.withOpacity(0.8),
            )
          : Container(),
    );
  }

  Widget buildInput(BuildContext context, User user, ConversationGroup conversationGroup) {
    return Container(
      child: Row(
        children: <Widget>[
          // Button send image
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 1.0),
              child: IconButton(
                icon: Icon(Icons.image),
                onPressed: () => getImage(),
              ),
            ),
            color: Colors.white,
          ),
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 1.0),
              child: IconButton(
                icon: Icon(Icons.face),
                onPressed: () => getSticker(),
              ),
            ),
            color: Colors.white,
          ),

          // Edit text
          Flexible(
            child: Container(
              child: TextField(
                style: TextStyle(fontSize: 17.0),
                controller: textEditingController,
                decoration: InputDecoration.collapsed(
                  hintText: 'Type your message...',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                focusNode: focusNode,
              ),
            ),
          ),

          // Button send message
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 8.0),
              child: IconButton(
                icon: Icon(Icons.send),
                onPressed: () => sendChatMessage(context, textEditingController.text, 0, user, conversationGroup),
              ),
            ),
            color: Colors.white,
          ),
        ],
      ),
      width: double.infinity,
      height: 50.0,
      decoration: BoxDecoration(border: Border(top: BorderSide(color: Colors.grey, width: 0.5)), color: Colors.white),
    );
  }

  Widget buildListMessage(BuildContext context, User user) {
    return BlocBuilder<WebSocketBloc, WebSocketState>(
      builder: (context, webSocketState) {
        print('chat_room_page.dart BlocBuilder<WebSocketBloc, WebSocketState>');
        if (webSocketState is WebSocketNotLoaded) {
          BlocProvider.of<WebSocketBloc>(context).add(ReconnectWebSocketEvent(callback: (bool done) {}));
        }

        if (webSocketState is WebSocketLoaded) {
          print('chat_room_page.dart if (webSocketState is WebSocketLoaded)');
          return loadMessageList(context, user);
        }
        return loadMessageList(context, user);
      },
    );
  }

  Widget loadMessageList(BuildContext context, User user) {
    return BlocBuilder<MessageBloc, MessageState>(
      builder: (context, messageState) {
        print('chat_room_page.dart BlocBuilder<MessageBloc, MessageState>');
        if (messageState is MessageLoading) {
          return showSingleMessagePage('Loading...');
        }

        if (messageState is MessagesLoaded) {
          print('if (messageState is MessagesLoaded) RUN HERE?');
          // Get current conversation messages and sort them.
          List<Message> conversationGroupMessageList =
              messageState.messageList.where((Message message) => message.conversationId == widget._conversationGroup.id).toList();
          conversationGroupMessageList.sort((message1, message2) => message2.timestamp.compareTo(message1.timestamp));
          print("conversationGroupMessageList.length: " + conversationGroupMessageList.length.toString());

          return Flexible(
            child: ListView.builder(
              controller: listScrollController,
              itemCount: conversationGroupMessageList.length,
              reverse: true,
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) => displayChatMessage(index, conversationGroupMessageList[index], user),
            ),
          );
        }

        return showSingleMessagePage('No messages.');
      },
    );
  }

  Widget showSingleMessagePage(String message) {
    return Material(
      color: Colors.white,
      child: Flexible(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                message,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget displayChatMessage(int index, Message message, User user) {
    bool isSenderMessage = message.senderId == user.id;
    double lrPadding = 15.0;
    double tbPadding = 10.0;
    return Column(
      children: <Widget>[
        isSenderMessage
            ? Text("")
            : Row(
                crossAxisAlignment: isSenderMessage ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                mainAxisAlignment: isSenderMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(left: lrPadding),
                  ),
                  Text(
              message.senderName + ", " + messageTimeDisplay(message.timestamp),
//                    message.senderName,
                    style: TextStyle(fontSize: 10.0, color: Colors.black38),
                  ),
                ],
              ),
        Container(
          padding: EdgeInsets.only(left: 5.0),
          child: Row(
            crossAxisAlignment: isSenderMessage ? CrossAxisAlignment.start : CrossAxisAlignment.end,
            mainAxisAlignment: isSenderMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(lrPadding, tbPadding, lrPadding, tbPadding),
                decoration: BoxDecoration(color: appBarThemeColor, borderRadius: BorderRadius.circular(32.0)),
                margin: EdgeInsets.only(
                    bottom: 20.0, right: isSenderMessage ? deviceWidth * 0.01 : 0.0, left: isSenderMessage ? deviceWidth * 0.01 : 0.0),
                child: Row(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Text(
//                           message.senderName + message.messageContent + messageTimeDisplay(message.timestamp),
                          message.messageContent,
                          style: TextStyle(color: appBarTextTitleColor),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String messageTimeDisplay(int timestamp) {
    print("timestamp: " + timestamp.toString());
    DateTime now = DateTime.now();
    String formattedDate = DateFormat("dd-MM-yyyy").format(now);
    print("now: " + formattedDate);
    DateFormat dateFormat = DateFormat("dd-MM-yyyy");
    DateTime today = dateFormat.parse(formattedDate);
    String formattedDate2 = DateFormat("dd-MM-yyyy hh:mm:ss").format(today);
//    print("today: " + formattedDate2);
    DateTime messageTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    String formattedDate3 = DateFormat("hh:mm").format(messageTime);
    return formattedDate3;
  }

  Widget buildSticker(BuildContext context, User user, ConversationGroup conversationGroup) {
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              FlatButton(
                  onPressed: () => sendChatMessage(context, 'mimi1', 2, user, conversationGroup),
                  child: Image(
                    image: AssetImage("lib/ui/images/mimi1.gif"),
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  )),
              FlatButton(
                  onPressed: () => sendChatMessage(context, 'mimi2', 2, user, conversationGroup),
                  child: Image(
                    image: AssetImage("lib/ui/images/mimi2.gif"),
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  )),
              FlatButton(
                  onPressed: () => sendChatMessage(context, 'mimi3', 2, user, conversationGroup),
                  child: Image(
                    image: AssetImage("lib/ui/images/mimi3.gif"),
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  ))
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),
          Row(
            children: <Widget>[
              FlatButton(
                  onPressed: () => sendChatMessage(context, 'mimi4', 2, user, conversationGroup),
                  child: Image(
                    image: AssetImage("lib/ui/images/mimi4.gif"),
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  )),
              FlatButton(
                  onPressed: () => sendChatMessage(context, 'mimi5', 2, user, conversationGroup),
                  child: Image(
                    image: AssetImage("lib/ui/images/mimi5.gif"),
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  )),
              FlatButton(
                  onPressed: () => sendChatMessage(context, 'mimi6', 2, user, conversationGroup),
                  child: Image(
                    image: AssetImage("lib/ui/images/mimi6.gif"),
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  ))
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),
          Row(
            children: <Widget>[
              FlatButton(
                  onPressed: () => sendChatMessage(context, 'mimi7', 2, user, conversationGroup),
                  child: Image(
                    image: AssetImage("lib/ui/images/mimi7.gif"),
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  )),
              FlatButton(
                  onPressed: () => sendChatMessage(context, 'mimi8', 2, user, conversationGroup),
                  child: Image(
                    image: AssetImage("lib/ui/images/mimi8.gif"),
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  )),
              FlatButton(
                  onPressed: () => sendChatMessage(context, 'mimi9', 2, user, conversationGroup),
                  child: Image(
                    image: AssetImage("lib/ui/images/mimi9.gif"),
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  ))
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          )
        ],
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      ),
      decoration: BoxDecoration(border: Border(top: BorderSide(color: Colors.grey, width: 0.5)), color: Colors.white),
      padding: EdgeInsets.all(5.0),
      height: 180.0,
    );
  }

  sendChatMessage(BuildContext context, String content, int type, User user, ConversationGroup conversationGroup) {
    print("sendChatMessage()");
    // type: 0 = text,
    // 1 = image,
    // 2 = sticker
    if (content.trim() != '') {
      print("if (content.trim() != '')");
      textEditingController.clear();

      Message newMessage;

      newMessage = Message(
        id: null,
        conversationId: widget._conversationGroup.id,
        messageContent: content,
        multimediaId: "",
        // Send to group will not need receiver
        receiverId: "",
        receiverMobileNo: "",
        receiverName: "",
        senderId: user.id,
        senderMobileNo: user.mobileNo,
        senderName: user.displayName,
        status: "Sent",
        type: "Text",
        timestamp: DateTime.now().millisecondsSinceEpoch,
      );
//      // Text doesn't need multimedia, so others other than Text needs multimedia
//      if (type != 0) {
//        newMultimedia = Multimedia(
//            id: null,
//            conversationId: widget._conversationGroup.id,
//            messageId: "",
//            // Add after message created
//            userContactId: "",
//            localFullFileUrl: "",
//            localThumbnailUrl: "",
//            remoteFullFileUrl: "",
//            remoteThumbnailUrl: "");
//      }
      print("Checkpoint 1");
      if (!isObjectEmpty(newMessage)) {
        print('if(!isObjectEmpty(newMessage)');
        // Image
        if (type == 1) {
          uploadMultimediaFiles(context, user, conversationGroup);
        }
        BlocProvider.of<MessageBloc>(context).add(AddMessageEvent(
            message: newMessage,
            callback: (Message message) {
              if (isObjectEmpty(message)) {
                Fluttertoast.showToast(msg: 'Message not sent. Please try again.', toastLength: Toast.LENGTH_SHORT);
              } else {
                print('if(!isObjectEmpty(message)');
                WebSocketMessage webSocketMessage = WebSocketMessage(message: message);
                BlocProvider.of<WebSocketBloc>(context)
                    .add(SendWebSocketMessageEvent(webSocketMessage: webSocketMessage, callback: (bool done) {}));
              }
            }));

//        wholeAppBloc.dispatch(SendMessageEvent(
//            message: newMessage,
//            multimedia: newMultimedia,
//            callback: (Message message) {
//              if (isObjectEmpty(message)) {
//                Fluttertoast.showToast(msg: 'Message not sent. Please try again.', toastLength: Toast.LENGTH_SHORT);
//              } else {
//                WebSocketMessage webSocketMessage = WebSocketMessage(message: message);
//                wholeAppBloc.dispatch(
//                    SendWebSocketMessageEvent(webSocketMessage: webSocketMessage, callback: (WebSocketMessage websocketMessage) {}));
//                Fluttertoast.showToast(msg: 'Message sent!', toastLength: Toast.LENGTH_SHORT);
//                // Need to do this,or else the message list won't refresh
//                setState(() {
//                  // Do nothing
//                });
//              }
//            }));
      } else {
        print('if(isObjectEmpty(newMessage)');
      }
    } else {
      Fluttertoast.showToast(msg: 'Nothing to send');
    }
  }

  Future getImage() async {
    File imageFile = await ImagePicker.pickImage(source: ImageSource.gallery, imageQuality: imagePickerQuality);
    if (await imageFile.exists()) {
      fileList.add(imageFile);
    }
  }

  uploadMultimediaFiles(BuildContext context, User user, ConversationGroup conversationGroup) {
    if (fileList.length > 0) {
      fileList.forEach((File file) {
        Message message = Message(
          id: null,
          conversationId: widget._conversationGroup.id,
          messageContent: "",
          multimediaId: "",
          // Send to group will not need receiver
          receiverId: "",
          receiverMobileNo: "",
          receiverName: "",
          senderId: user.id,
          senderMobileNo: user.mobileNo,
          senderName: user.displayName,
          status: "Sent",
          type: "Image",
          timestamp: DateTime.now().millisecondsSinceEpoch,
        );
        BlocProvider.of<MessageBloc>(context).add(AddMessageEvent(message: message, callback: (Message message2) async {
          if(!isObjectEmpty(message2)) {
            Multimedia messageMultimedia = Multimedia(
                id: null,
                localFullFileUrl: isObjectEmpty(file) ? null : file.path,
                localThumbnailUrl: null,
                remoteThumbnailUrl: null,
                remoteFullFileUrl: null,
                userContactId: null,
                conversationId: conversationGroup.id,
                // Add later
                messageId: message.id,
                userId: null);

            // Create thumbnail
            File thumbnailImageFile;
            if (!isStringEmpty(messageMultimedia.localFullFileUrl) && !isObjectEmpty(file)) {
              thumbnailImageFile = await imageService.getImageThumbnail(file);
            }

            if (!isObjectEmpty(thumbnailImageFile)) {
              messageMultimedia.localThumbnailUrl = thumbnailImageFile.path;
            }

            BlocProvider.of<MultimediaBloc>(context).add(AddMultimediaEvent(
                multimedia: messageMultimedia,
                callback: (Multimedia multimedia2) async {
                  updateMultimediaContent(context, multimedia2, message2, conversationGroup);
                }));
          }
        }));
      });
    }
  }

  updateMultimediaContent(BuildContext context, Multimedia multimedia, Message message, ConversationGroup conversationGroup) async {
    String remoteUrl = await firebaseStorageService.uploadFile(multimedia.localFullFileUrl, conversationGroup.type, conversationGroup.id);
    print("chat_room_page.dart remoteUrl: " + remoteUrl.toString());
    String remoteThumbnailUrl =
    await firebaseStorageService.uploadFile(multimedia.localThumbnailUrl, conversationGroup.type, conversationGroup.id);
    print("chat_room_page.dart remoteThumbnailUrl: " + remoteThumbnailUrl.toString());

    if (!isStringEmpty(remoteUrl)) {
      multimedia.remoteFullFileUrl = remoteUrl;
    }

    if (!isStringEmpty(remoteThumbnailUrl)) {
      multimedia.remoteThumbnailUrl = remoteThumbnailUrl;
    }

    BlocProvider.of<MultimediaBloc>(context).add(EditMultimediaEvent(
        multimedia: multimedia,
        callback: (Multimedia multimedia2) {
          if (!isObjectEmpty(multimedia2)) {
            print('chat_room_page.dart EditMultimediaEvent success');
            print('chat_room_page.dart multimedia2.remoteFullFileUrl == multimedia.remoteFullFileUrl: ' + multimedia2.remoteFullFileUrl ==
                multimedia.remoteFullFileUrl);
            print(
                'chat_room_page.dart multimedia2.remoteThumbnailUrl == multimedia.remoteThumbnailUrl: ' + multimedia2.remoteThumbnailUrl ==
                    multimedia.remoteThumbnailUrl);
            WebSocketMessage webSocketMessage = WebSocketMessage(message: message, multimedia: multimedia);
            BlocProvider.of<WebSocketBloc>(context)
                .add(SendWebSocketMessageEvent(webSocketMessage: webSocketMessage, callback: (bool done) {}));
          } else {
            print('chat_room_page.dart EditMultimediaEvent failed.');
          }
        }));
  }

  // TODO: Will think about last message is left or right to determine bottom margin between last message and textfield
//  isLastMessage(int index) {
//    if ((index > 0 && messageList != null &&
//        messageList[index - 1]['idFrom'] != id) || index == 0) {
//      return true;
//    } else {
//      return false;
//    }
//  }

  // Hide sticker or back
  Future<bool> onBackPress() {
    if (isShowSticker) {
      setState(() {
        isShowSticker = false;
      });
    } else {
      Navigator.pop(context);
    }
    return Future.value(false);
  }

  void getSticker() {
    // Hide keyboard when sticker appear
    focusNode.unfocus();
    setState(() {
      isShowSticker = !isShowSticker;
    });
  }

  void onFocusChange() {
    if (focusNode.hasFocus) {
      // Hide sticker when keyboard appear
      setState(() {
        isShowSticker = false;
      });
    }
  }

  goToLoginPage() {
    BlocProvider.of<GoogleInfoBloc>(context).add(RemoveGoogleInfoEvent());
    Navigator.of(context).pushNamedAndRemoveUntil("login_page", (Route<dynamic> route) => false);
  }
}
