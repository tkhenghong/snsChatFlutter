import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:snschat_flutter/general/functions/repeating_functions.dart';
import 'package:snschat_flutter/general/functions/validation_functions.dart';
import 'package:snschat_flutter/objects/chat/conversation_group.dart';
import 'package:snschat_flutter/objects/message/message.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:snschat_flutter/objects/multimedia/multimedia.dart';
import 'package:snschat_flutter/state/bloc/WholeApp/WholeAppBloc.dart';
import 'package:snschat_flutter/state/bloc/WholeApp/WholeAppEvent.dart';
import 'package:snschat_flutter/ui/pages/chats/chat_info/chat_info_page.dart';

class ChatRoomPage extends StatefulWidget {
  final Conversation _conversation;

  ChatRoomPage([this._conversation]);

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

  File imageFile;

  WholeAppBloc wholeAppBloc;

  @override
  void initState() {
    super.initState();
    _refreshController = new RefreshController();
    focusNode.addListener(onFocusChange);
    isLoading = false;
    isShowSticker = false;

    //    readLocal(); // TODO: Read local db for message list
  }

  @override
  void dispose() {
    listScrollController.dispose();
    textEditingController.dispose();
    super.dispose();
  }

  Future<Multimedia> getConversationPhoto() async {
    Multimedia groupPhoto;
    var multimediaDocuments = await Firestore.instance
        .collection("multimedia")
        .where("conversationId", isEqualTo: widget._conversation.id)
        .getDocuments();
    if (multimediaDocuments.documents.length == 0) {
      print("if (multimediaDocuments.documents.length == 0)");
    } else {
      print("if (multimediaDocuments.documents.length > 0)");
      DocumentSnapshot groupPhotoSnapshot = multimediaDocuments.documents[0];
      groupPhoto = new Multimedia(
        id: groupPhotoSnapshot["id"].toString(),
        conversationId: groupPhotoSnapshot["id"].toString(),
        imageDataId: groupPhotoSnapshot["imageDataId"].toString(),
        imageFileId: groupPhotoSnapshot["imageFileId"].toString(),
        localFullFileUrl: groupPhotoSnapshot["localFullFileUrl"].toString(),
        localThumbnailUrl: groupPhotoSnapshot["localThumbnailUrl"].toString(),
        messageId: groupPhotoSnapshot["messageId"].toString(),
        remoteFullFileUrl: groupPhotoSnapshot["remoteFullFileUrl"].toString(),
        remoteThumbnailUrl: groupPhotoSnapshot["remoteThumbnailUrl"].toString(),
        userContactId: groupPhotoSnapshot["userContactId"].toString(),
      );
    }
    return groupPhoto;
  }

  @override
  Widget build(BuildContext context) {
    print("chat_room_page.dart build()");
    final WholeAppBloc _wholeAppBloc = BlocProvider.of<WholeAppBloc>(context);
    wholeAppBloc = _wholeAppBloc;
    print("widget._conversation.id: " + widget._conversation.id);
    getConversationPhoto().then((Multimedia groupPhoto) {
      if (!isObjectEmpty(groupPhoto)) {
        print("if(!isObjectEmpty(groupPhoto))");
        print("groupPhoto.localFullFileUrl: " + groupPhoto.localFullFileUrl);
        if (!isStringEmpty(groupPhoto.localFullFileUrl)) {
          print("if(!isStringEmpty(groupPhoto.localFullFileUrl))");
          imageFile = File(groupPhoto.localFullFileUrl);
          imageFile.exists().then((fileExists) {
            if (!fileExists) {
              print("if(!fileExists)");
              print('chat-room.page.dart local file not exist!');
              loadImageHandler(groupPhoto).then((remoteDownloadedfile) {
                print(
                    "remoteDownloadedfile.path: " + remoteDownloadedfile.path);
                setState(() {
                  imageFile = remoteDownloadedfile;
                });
              });
            } else {
              print("if(fileExists)");
            }
          });
        }
      }
    });

    imageFile = File("lib/ui/images/group2013.jpg");

    // TODO: Get from the state after reading all stuffs from Firebase (online)
//    wholeAppBloc.currentState.multimediaList.forEach((Multimedia existingMultimedia) {
//      print("Got existing multimedia.");
//      if (existingMultimedia.id == widget._conversation.groupPhotoId) {
//        groupPhoto = existingMultimedia;
//      }
//    });

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
                    customBorder: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.arrow_back),
                        Hero(
                          tag: widget._conversation.id,
                          child: CircleAvatar(
                            radius: 20.0,
                            backgroundColor: Colors.white,
//                            backgroundImage: widget._conversation.groupPhoto.imageData != 0
//                                ? MemoryImage(widget._conversation.groupPhoto.imageData)
//                                : NetworkImage(''),
//                            child: widget._conversation.groupPhoto.imageData.length == 0 ? Text(widget._conversation.name[0]) : Text(''),
                            backgroundImage: imageFound
                                ? FileImage(imageFile)
                                : AssetImage("lib/ui/images/group2013.jpg"),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 5.0, vertical: 50.0),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Material(
                color: Colors.black,
                child: InkWell(
                    customBorder: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) =>
                              ChatInfoPage(widget._conversation)));
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 10.0, right: 250.0),
                        ),
                        Hero(
                          tag: widget._conversation.name,
                          child: Text(
                            widget._conversation.name,
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

//TODO: Read message from DB
//  readMessageListfromDB() async {
//  }

  Widget buildLoading() {
    return Positioned(
      child: isLoading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue)),
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
      decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey, width: 0.5)),
          color: Colors.white),
    );
  }

  Widget buildListMessage() {
    return StreamBuilder(
      stream: Firestore.instance
          .collection("message")
          .where("conversationId", isEqualTo: widget._conversation.id)
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (BuildContext context, snapshot) {
        if (!snapshot.hasData) {
          return Expanded(
//            flex: 1,
              child: Center(child: Text("Loading messages...")));
        } else {
          return Flexible(
              child: new SmartRefresher(
            header: ClassicHeader(),
            onRefresh: () {
              _refreshController.refreshCompleted();
            },
            controller: _refreshController,
            child: ListView.builder(
              controller: listScrollController,
              itemCount: snapshot.data.documents.length,
              reverse: true,
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) =>
                  displayChatMessage(index, snapshot.data.documents[index]),
            ),
          ));
        }
      },
    );
  }

  Widget displayChatMessage(int index, DocumentSnapshot document) {
    print("Happened here?");
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          child: Column(
            children: <Widget>[
              Text(
                document['senderName'].toString() +
                    document['message'].toString() +
                    document['timestamp'].toString(),
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
          padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
          width: 200.0,
          decoration: BoxDecoration(
              color: Colors.black, borderRadius: BorderRadius.circular(8.0)),
          margin: EdgeInsets.only(bottom: 20.0, right: 100.0),
        ),
      ],
    );

    // Data save into Message object Firestore
    // Firestore.instance.collection('message').document(newMessage.id).setData({
    //          'id': newMessage.id, // Self generated Id
    //          'conversationId': newMessage.conversationId,
    //          'message': newMessage.message,
    //          'multimediaId': newMessage.multimediaId,
    //          'receiverId': newMessage.receiverId,
    //          'receiverMobileNo': newMessage.receiverMobileNo,
    //          'receiverName': newMessage.receiverName,
    //          'senderId': newMessage.senderId,
    //          'senderMobileNo': newMessage.senderMobileNo,
    //          'senderName': newMessage.senderName,
    //          'status': newMessage.status,
    //          'type': newMessage.type,
    //          'timestamp': newMessage.timestamp,
    //        });

    // Template of Message (left):
    //                    Container(
//                      child: Text(
//                        "Test message",
//                        style: TextStyle(color: Colors.white),
//                      ),
//                      padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
//                      width: 200.0,
//                      decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(8.0)),
//                      margin: EdgeInsets.only(bottom: 20.0, right: 100.0),
//                    ),

    // wholeAppBloc.currentState.userState.id
  }

// Image.asset(
//          'lib/assets/balls.jpg',
//        ),
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
      decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey, width: 0.5)),
          color: Colors.white),
      padding: EdgeInsets.all(5.0),
      height: 180.0,
    );
  }

  void sendChatMessage(String content, int type) async {
    print("sendChatMessage()");
    // type: 0 = text, 1 = image, 2 = sticker
    if (content.trim() != '') {
      print("sendChatMessage()");
      textEditingController.clear();
      Message newMessage;
      Multimedia newMultimedia;
      if (type == 0) {
        print("if (type == 0)");
        // Text
        newMultimedia = Multimedia(
            id: generateNewId().toString(),
            conversationId: widget._conversation.id,
            messageId: "",
            // Add after message created
            userContactId: "",
            imageDataId: "",
            imageFileId: "",
            localFullFileUrl: "",
            localThumbnailUrl: "",
            remoteFullFileUrl: "",
            remoteThumbnailUrl: "");
        print("Checkpoint 2");
        newMessage = Message(
          id: generateNewId().toString(),
          conversationId: widget._conversation.id,
          message: content,
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
          timestamp: DateTime.now().millisecondsSinceEpoch.toString(),
        );
        print("Checkpoint 3");

        newMultimedia.messageId = newMessage.id;
      }
      print("Checkpoint 1");
      if (!isObjectEmpty(newMessage) && !isObjectEmpty(newMultimedia)) {
        print(
            'if(!isObjectEmpty(newMessage) && !isObjectEmpty(newMultimedia))');
        wholeAppBloc.dispatch(AddMessageEvent(
            message: newMessage, callback: (Message message) {}));

        Firestore.instance
            .collection('message')
            .document(newMessage.id)
            .setData({
          'id': newMessage.id, // Self generated Id
          'conversationId': newMessage.conversationId,
          'message': newMessage.message,
          'multimediaId': newMessage.multimediaId,
          'receiverId': newMessage.receiverId,
          'receiverMobileNo': newMessage.receiverMobileNo,
          'receiverName': newMessage.receiverName,

          'senderId': newMessage.senderId,
          'senderMobileNo': newMessage.senderMobileNo,
          'senderName': newMessage.senderName,
          'status': newMessage.status,
          'type': newMessage.type,
          'timestamp': newMessage.timestamp,
        });
        Fluttertoast.showToast(
            msg: 'Message sent!', toastLength: Toast.LENGTH_SHORT);
      } else {
        print('if(isObjectEmpty(newMessage) || isObjectEmpty(newMultimedia))');
      }

      listScrollController.animateTo(0.0,
          duration: Duration(milliseconds: 300), curve: Curves.easeOut);
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
