import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:snschat_flutter/general/functions/repeating_functions.dart';
import 'package:snschat_flutter/general/functions/validation_functions.dart';
import 'package:snschat_flutter/objects/chat/conversation_group.dart';
import 'package:snschat_flutter/objects/message/message.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:snschat_flutter/objects/multimedia/multimedia.dart';
import 'package:snschat_flutter/service/file/FileService.dart';
import 'package:snschat_flutter/state/bloc/WholeApp/WholeAppBloc.dart';
import 'package:snschat_flutter/state/bloc/WholeApp/WholeAppEvent.dart';
import 'package:snschat_flutter/ui/pages/chats/chat_info/chat_info_page.dart';
import 'package:snschat_flutter/state/bloc/WholeApp/WholeAppState.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

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

  TextEditingController textEditingController = new TextEditingController();
  ScrollController listScrollController = new ScrollController();
  RefreshController _refreshController;
  FocusNode focusNode = new FocusNode();
  FileService fileService = FileService();

  File imageFile;

  WholeAppBloc wholeAppBloc;

  String WEBSOCKET_URL = globals.WEBSOCKET_URL;
  WebSocketChannel webSocketChannel;
  Stream<dynamic> webSocketStream;

  @override
  void initState() {
    super.initState();
    _refreshController = new RefreshController();
    focusNode.addListener(onFocusChange);
    isLoading = false;
    isShowSticker = false;
    final WholeAppBloc _wholeAppBloc = BlocProvider.of<WholeAppBloc>(context);
    wholeAppBloc = _wholeAppBloc;
    webSocketChannel = IOWebSocketChannel.connect(WEBSOCKET_URL);
    webSocketStream = webSocketChannel.stream.asBroadcastStream();

    webSocketStream.listen((onData) {
      print("onData listener is working.");
      print("onData: " + onData.toString());
      Message receivedMessage = Message.fromJson(json.decode(onData));
      print("receivedMessage.id" + receivedMessage.id);
      print("receivedMessage.messageContent" + receivedMessage.messageContent);
    }, onError: (onError) {
      print("onError listener is working.");
      print("onError: " + onError.toString());
    }, onDone: () {
      print("onDone listener is working.");
    }, cancelOnError: false);
  }

  // TODO: Add message to DB and State and display it into this Chat Room Page
  addMessageToDbAndState() async {
//    wholeAppBloc.dispatch(AddMessageEvent(message: ))
  }

  @override
  void dispose() {
    listScrollController.dispose();
    textEditingController.dispose();
    webSocketChannel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("chat_room_page.dart build()");

    print("widget._conversation.id: " + widget._conversationGroup.id);

    // TODO: Send message using websocket
    // Do in this order (To allow resend message if anything goes wrong [Send timeout, websocket down, Internet down situations])
    // 1. Send to DB
    // 2. Send to State
    // 3. Send to API
    // 4. Retrieve through WebSocket

    // Chat Room page UI
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          titleSpacing: 0.0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Tooltip(
                message: "Back",
                child: Material(
                  color: Colors.black,
                  child: InkWell(
                    customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.arrow_back),
                        Hero(
                          tag: widget._conversationGroup.id,
                          child: CircleAvatar(
                            radius: 20.0,
                            backgroundColor: Colors.white,
                            child: Image.asset(
                              fileService.getDefaultImagePath(widget._conversationGroup.type),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 50.0),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Material(
                color: Colors.black,
                child: InkWell(
                    customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (BuildContext context) => ChatInfoPage(widget._conversationGroup)));
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 10.0, right: 250.0),
                        ),
                        Hero(
                          tag: widget._conversationGroup.name,
                          child: Text(
                            widget._conversationGroup.name,
                            style: TextStyle(
                                color: Colors.white,
                                // fontSize: 20.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Text(
                          "Tap here for more details",
                          style: TextStyle(color: Colors.white, fontSize: 13.0),
                        )
                      ],
                    )),
              ),
            ],
          ),
        ),
        body: WillPopScope(
          // To handle event when user press back button when sticker screen is on, dismiss sticker if keyboard is shown
          child: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  //UI for message list
                  buildListMessage(),
                  // UI for stickers, gifs
                  (isShowSticker ? buildSticker() : Container()),
                  // UI for text field
                  buildInput(),
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

  Widget buildInput() {
    return Container(
      child: Row(
        children: <Widget>[
          // Button send image
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 1.0),
              child: IconButton(
                icon: Icon(Icons.image),
                onPressed: getImage,
                color: Colors.black,
              ),
            ),
            color: Colors.white,
          ),
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 1.0),
              child: IconButton(
                icon: Icon(Icons.face),
                onPressed: getSticker,
                color: Colors.black,
              ),
            ),
            color: Colors.white,
          ),

          // Edit text
          Flexible(
            child: Container(
              child: TextField(
                cursorColor: Colors.black,
                style: TextStyle(color: Colors.black, fontSize: 17.0),
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
                onPressed: () => sendChatMessage(textEditingController.text, 0),
                color: Colors.black,
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

  Widget buildListMessage() {
    return BlocBuilder(
      bloc: wholeAppBloc,
      builder: (BuildContext context, WholeAppState state) {
        if (!messagesAreReady(state)) {
          return Expanded(child: Center(child: Text("Loading messages...")));
        } else {
          // Doing traditional due to not mature knowledge on map()
          List<Message> messageList = [];
          state.messageList.forEach((message) {
            if (message.conversationId == widget._conversationGroup.id) {
              messageList.add(message);
            }
          });
          if (messageList.length > 0) {
            messageList.sort((message1, message2) {
              // Sorts based on number
              return message1.timestamp.compareTo(message2.timestamp);
            });
          }

          return Flexible(
              child: new SmartRefresher(
            header: ClassicHeader(),
            onRefresh: () {
              _refreshController.refreshCompleted();
            },
            controller: _refreshController,
            child: ListView.builder(
              controller: listScrollController,
              itemCount: messageList.length,
              reverse: true,
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) => displayChatMessage(index, messageList[index]),
            ),
          ));
        }
      },
    );
  }

  bool messagesAreReady(WholeAppState state) {
    return !isObjectEmpty(state.messageList) && state.messageList.length > 0;
  }

  Widget displayChatMessage(int index, Message message) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          child: Column(
            children: <Widget>[
              Text(
                message.senderName + message.messageContent + messageTimeDisplay(message.timestamp),
                // TODO: Solve time,
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
          padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
          width: 200.0,
          decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(8.0)),
          margin: EdgeInsets.only(bottom: 20.0, right: 100.0),
        ),
      ],
    );
  }

  String messageTimeDisplay(int timestamp) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat("dd-mm-yyyy").format(now);
    print("now: " + formattedDate);
    DateTime today = DateTime.parse(formattedDate);
    String formattedDate2 = DateFormat("dd-mm-yyyy hh:mm:ss").format(today);
    print("today: " + formattedDate2);
    DateTime messageTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    String formattedDate3 = DateFormat("dd-mm-yyyy").format(messageTime);
    return formattedDate3;
  }

  Widget buildSticker() {
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              FlatButton(
                  onPressed: () => sendChatMessage('mimi1', 2),
                  child: Image(
                    image: AssetImage("lib/ui/images/mimi1.gif"),
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  )),
              FlatButton(
                  onPressed: () => sendChatMessage('mimi2', 2),
                  child: Image(
                    image: AssetImage("lib/ui/images/mimi2.gif"),
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  )),
              FlatButton(
                  onPressed: () => sendChatMessage('mimi3', 2),
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
                  onPressed: () => sendChatMessage('mimi4', 2),
                  child: Image(
                    image: AssetImage("lib/ui/images/mimi4.gif"),
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  )),
              FlatButton(
                  onPressed: () => sendChatMessage('mimi5', 2),
                  child: Image(
                    image: AssetImage("lib/ui/images/mimi5.gif"),
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  )),
              FlatButton(
                  onPressed: () => sendChatMessage('mimi6', 2),
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
                  onPressed: () => sendChatMessage('mimi7', 2),
                  child: Image(
                    image: AssetImage("lib/ui/images/mimi7.gif"),
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  )),
              FlatButton(
                  onPressed: () => sendChatMessage('mimi8', 2),
                  child: Image(
                    image: AssetImage("lib/ui/images/mimi8.gif"),
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  )),
              FlatButton(
                  onPressed: () => sendChatMessage('mimi9', 2),
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

  void sendChatMessage(String content, int type) async {
    print("sendChatMessage()");
    // type: 0 = text, 1 = image, 2 = sticker
    if (content.trim() != '') {
      print("if (content.trim() != '')");
      textEditingController.clear();

      Message newMessage;
      Multimedia newMultimedia;

      switch(type) {
        case 0:
          print("if (type == 0)");
          // Text
          print("Checkpoint 2");
          newMessage = Message(
            id: null,
            conversationId: widget._conversationGroup.id,
            messageContent: content,
            multimediaId: newMultimedia.id,
            // Send to group will not need receiver
            receiverId: "",
            receiverMobileNo: "",
            receiverName: "",
            senderId: wholeAppBloc.currentState.userState.id,
            senderMobileNo: wholeAppBloc.currentState.userState.mobileNo,
            senderName: wholeAppBloc.currentState.userState.displayName,
            status: "Sent",
            type: "Text",
            timestamp: DateTime.now().millisecondsSinceEpoch,
          );
          print("Checkpoint 3");
          break;
        case 1:
          // Image
          break;
        case 2:
          break;
        default:
          Fluttertoast.showToast(msg: 'Error. Unable to determine message type.', toastLength: Toast.LENGTH_SHORT);
          break;
      }
      // Text doesn't need multimedia, so others other than Text needs multimedia
      if (type != 0) {
        newMultimedia = Multimedia(
            id: null,
            conversationId: widget._conversationGroup.id,
            messageId: "",
            // Add after message created
            userContactId: "",
            imageDataId: "",
            imageFileId: "",
            localFullFileUrl: "",
            localThumbnailUrl: "",
            remoteFullFileUrl: "",
            remoteThumbnailUrl: "");
      }
      print("Checkpoint 1");
      if (!isObjectEmpty(newMessage)) {
        print('if(!isObjectEmpty(newMessage) && !isObjectEmpty(newMultimedia))');

        wholeAppBloc.dispatch(SendMessageEvent(
            message: newMessage,
            multimedia: newMultimedia,
            callback: (Message message) {
              if (isObjectEmpty(message)) {
                Fluttertoast.showToast(msg: 'Message not sent. Please try again.', toastLength: Toast.LENGTH_SHORT);
              } else {
                webSocketChannel.sink.add(json.encode(message.toJson()));
                Fluttertoast.showToast(msg: 'Message sent!', toastLength: Toast.LENGTH_SHORT);
              }
            }));
      } else {
        print('if(isObjectEmpty(newMessage) || isObjectEmpty(newMultimedia))');
      }

      listScrollController.animateTo(0.0, duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    } else {
      Fluttertoast.showToast(msg: 'Nothing to send');
    }
  }

  Future getImage() async {
    imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (imageFile != null) {
      setState(() {
        isLoading = true;
      });

      // TODO: Will handle image file upload
      //uploadFile();
    }
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

  List<Message> messageList = [];
}
