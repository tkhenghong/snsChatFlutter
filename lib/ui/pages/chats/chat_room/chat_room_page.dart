import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
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
import 'package:snschat_flutter/ui/pages/photo_view/photo_view_page.dart';

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
  List<File> imageThumbnailFileList = [];

  String WEBSOCKET_URL = globals.WEBSOCKET_URL;
  int imagePickerQuality = globals.imagePickerQuality;

  TextEditingController textEditingController = new TextEditingController();
  ScrollController listScrollController = new ScrollController();
  ScrollController imageViewScrollController = new ScrollController();
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
    print('fileList.length: ' + fileList.length.toString());
    // fileList.add(null);
    return Container(
      child: Column(
        children: <Widget>[
          // Use Visibility to control to show widget easily. https://stackoverflow.com/questions/44489804/show-hide-widgets-in-flutter-programmatically
          Visibility(
            visible: fileList.length > 0,
            child: Row(
              children: <Widget>[
                Container(
                  height: 150,
                  width: deviceWidth,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    controller: imageViewScrollController,
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    reverse: true,
                    itemCount: fileList.length,
                    itemBuilder: (BuildContext buildContext2, int index) {
                      File currentFile = fileList[index];
                      return Stack(
                        alignment: AlignmentDirectional.topEnd,
                        children: <Widget>[
                          Card(
                            elevation: 2.0,
                            color: appBarTextTitleColor,
                            child: Image.file(currentFile),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: Container(
                              padding: EdgeInsets.only(
                                right: 5.0,
                                top: 5.0,
                              ),
                              child: InkWell(
                                onTap: () => removeFile(currentFile),
                                child: Material(
                                  color: Colors.black,
                                  child: Icon(
                                    Icons.clear,
                                    color: Colors.white,
                                  ),
                                  elevation: 2.0,
                                  type: MaterialType.circle,
                                ),
                                radius: 15.0,
                              ),
                            ),
                          )
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Row(
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
          )
        ],
      ),
      width: double.infinity,
//      height: fileList.length > 0 ? deviceHeight * 0.2 : deviceHeight * 0.1,
      decoration: BoxDecoration(border: Border(top: BorderSide(color: Colors.grey, width: 0.5)), color: Colors.white),
    );
  }

  removeFile(File file) {
    print('chat_room_page.dart removeFile()');
    setState(() {
      bool deleted = fileList.remove(file);
      print('chat_room_page.dart deleted: ' + deleted.toString());
      print('chat_room_page.dart after that, fileList.length: ' + fileList.length.toString());
    });
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
              itemBuilder: (context, index) => displayChatMessage(context, index, conversationGroupMessageList[index], user),
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

  Widget displayChatMessage(BuildContext context, int index, Message message, User user) {
    bool isSenderMessage = message.senderId == user.id;
    double lrPadding = 15.0;
    bool isText = message.type == 'Text';
    bool isImage = message.type == 'Image';
    return Column(
      children: <Widget>[
        Row(
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
        isText
            ? showMessageText(context, message, isSenderMessage)
            : isImage
                ? showMessageImage(context, message, isSenderMessage)
                : showUnidentifiedMessageText(context, message, isSenderMessage),
      ],
    );
  }

  Widget showMessageText(BuildContext context, Message message, bool isSenderMessage) {
    double lrPadding = 15.0;
    double tbPadding = 10.0;

    return Row(
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
                    // message.senderName + message.messageContent + messageTimeDisplay(message.timestamp),
                    message.messageContent,
                    style: TextStyle(color: appBarTextTitleColor),
                  )
                ],
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget showMessageImage(BuildContext context, Message message, bool isSenderMessage) {
    return BlocBuilder<MultimediaBloc, MultimediaState>(builder: (context, multimediaState) {
      if (multimediaState is MultimediaLoaded) {
        List<Multimedia> multimediaList = multimediaState.multimediaList;
        Multimedia messageMultimedia =
            multimediaList.firstWhere((Multimedia multimedia) => multimedia.messageId == message.id, orElse: () => null);
        if (!isObjectEmpty(messageMultimedia)) {
          return Row(
            crossAxisAlignment: isSenderMessage ? CrossAxisAlignment.start : CrossAxisAlignment.end,
            mainAxisAlignment: isSenderMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(
                    bottom: 20.0, right: isSenderMessage ? deviceWidth * 0.01 : 0.0, left: isSenderMessage ? deviceWidth * 0.01 : 0.0),
                child: Row(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Hero(
                          tag: messageMultimedia.id,
                          child: InkWell(
                            child: imageService.loadFullImage(context, messageMultimedia, 'ConversationGroupMessage'),
                            onTap: () => {
                              // View photo
                              Navigator.push(context, MaterialPageRoute(builder: ((context) => PhotoViewPage(messageMultimedia))))
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        } else {
          print('chat_room_page.dart if(isObjectEmpty(messageMultimedia))');
        }
      }

      return Row(
        crossAxisAlignment: isSenderMessage ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        mainAxisAlignment: isSenderMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(
                bottom: 20.0, right: isSenderMessage ? deviceWidth * 0.01 : 0.0, left: isSenderMessage ? deviceWidth * 0.01 : 0.0),
            child: Row(
              children: <Widget>[
                Column(
                  children: <Widget>[imageService.loadFullImage(context, null, 'ConversationGroupMessage')],
                ),
              ],
            ),
          ),
        ],
      );
      ;
    });
  }

  Widget showUnidentifiedMessageText(BuildContext context, Message message, bool isSenderMessage) {
    double lrPadding = 15.0;
    double tbPadding = 10.0;

    return Container(
      padding: EdgeInsets.fromLTRB(lrPadding, tbPadding, lrPadding, tbPadding),
      decoration: BoxDecoration(color: appBarThemeColor, borderRadius: BorderRadius.circular(32.0)),
      margin: EdgeInsets.only(
          bottom: 20.0, right: isSenderMessage ? deviceWidth * 0.01 : 0.0, left: isSenderMessage ? deviceWidth * 0.01 : 0.0),
      child: Row(
        children: <Widget>[
          Column(
            children: <Widget>[
              Text(
                'Unindentified message.',
                style: TextStyle(color: appBarTextTitleColor),
              )
            ],
          ),
        ],
      ),
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
    // Types:
    // 0 = text,
    // 1 = image,
    // 2 = sticker
    if (type == 0 && content.trim() != '') {
      print("if (content.trim() != '')");
      textEditingController.clear();

      Message newMessage = Message(
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
    } else {
      Fluttertoast.showToast(msg: 'Nothing to send');
    }

    // Got files to send (Images, Video, Audio, Files)
    if (fileList.length > 0) {
      uploadMultimediaFiles(context, user, conversationGroup);
    }
  }

  Future getImage() async {
    File imageFile = await ImagePicker.pickImage(source: ImageSource.gallery, imageQuality: imagePickerQuality);
    if (await imageFile.exists()) {
      print('chat_room_page.dart if (await imageFile.exists())');
      setState(() {
        fileList.add(imageFile);
      });
      scrollToTheEnd();
    } else {
      print('chat_room_page.dart if (!await imageFile.exists())');
    }
  }

  scrollToTheEnd() {
    // 2 timers. First to delay scrolling, 2nd is the given time to animate scrolling effect
    Timer(
        Duration(milliseconds: 1000),
        () => imageViewScrollController.animateTo(imageViewScrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 300), curve: Curves.easeOut));
  }

  uploadMultimediaFiles(BuildContext context, User user, ConversationGroup conversationGroup) {
    if (fileList.length > 0) {
      fileList.forEach((File file) {
        Message message = Message(
          id: null,
          conversationId: widget._conversationGroup.id,
          messageContent: "Test",
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
        BlocProvider.of<MessageBloc>(context).add(AddMessageEvent(
            message: message,
            callback: (Message message2) async {
              if (!isObjectEmpty(message2)) {
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
        setState(() {
          fileList.remove(file);
        });
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
