import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:snschat_flutter/general/functions/repeating_functions.dart';
import 'package:snschat_flutter/objects/chat/conversation_group.dart';
import 'package:snschat_flutter/objects/message/message.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:snschat_flutter/objects/multimedia/multimedia.dart';
import 'package:snschat_flutter/state/bloc/WholeApp/WholeAppBloc.dart';
import 'package:snschat_flutter/ui/pages/chats/chat_info/chat_info_page.dart';

class ChatRoomPage extends StatefulWidget {
  final Conversation _conversation;

  ChatRoomPage([this._conversation]); //do not final

  @override
  State<StatefulWidget> createState() {
    return new ChatRoomPageState();
  }
}

class ChatRoomPageState extends State<ChatRoomPage> {
  bool isShowSticker = false;
  TextEditingController textEditingController = new TextEditingController();
  ScrollController listScrollController = new ScrollController();
  RefreshController _refreshController;
  FocusNode focusNode = new FocusNode();
  bool isLoading;
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

  @override
  Widget build(BuildContext context) {
    final WholeAppBloc _wholeAppBloc = BlocProvider.of<WholeAppBloc>(context);
    wholeAppBloc = _wholeAppBloc;
    Multimedia groupPhoto;
    wholeAppBloc.currentState.multimediaList.forEach((Multimedia existingMultimedia) {
      if (existingMultimedia.id == widget._conversation.groupPhotoId) {
        groupPhoto = existingMultimedia;
      }
    });
    // Load local file first
    imageFile = File(groupPhoto.localFullFileUrl);
    imageFile.exists().then((fileExists) {
      if (!fileExists) {
        print("if(!fileExists)");
        print('local file not exist!');
        loadImageHandler(groupPhoto).then((remoteDownloadedfile) {
          setState(() {
            imageFile = remoteDownloadedfile;
          });
        });
      } else {
        print("if(fileExists)");
      }
    });

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
                          tag: widget._conversation.id,
                          child: CircleAvatar(
                            radius: 20.0,
                            backgroundColor: Colors.white,
//                            backgroundImage: widget._conversation.groupPhoto.imageData != 0
//                                ? MemoryImage(widget._conversation.groupPhoto.imageData)
//                                : NetworkImage(''),
//                            child: widget._conversation.groupPhoto.imageData.length == 0 ? Text(widget._conversation.name[0]) : Text(''),
                            backgroundImage: FileImage(imageFile),
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
                      Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => ChatInfoPage(widget._conversation)));
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
//                                fontSize: 20.0,
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
                  buildListMessage(),
                  //UI for message list
                  (isShowSticker ? buildSticker() : Container()),
                  // UI for stickers, gifs
                  buildInput(), // UI for text field
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
                onPressed: () => onSendMessage(textEditingController.text, 0),
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
    return Flexible(
        child: new SmartRefresher(
      header: ClassicHeader(),
      onRefresh: () {
        _refreshController.refreshCompleted();
      },
      enableOverScroll: true,
      enablePullUp: false,
      enablePullDown: false,
      controller: _refreshController,
      child: ListView(
        controller: listScrollController,
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 10.0),
          ),
          Container(
            child: Text(
              "Test message",
              style: TextStyle(color: Colors.white),
            ),
            padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
            width: 200.0,
            decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(8.0)),
            margin: EdgeInsets.only(bottom: 20.0, right: 100.0),
          ),
          Container(
            child: Text(
              "Test message 2",
              style: TextStyle(color: Colors.white),
            ),
            padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
            width: 200.0,
            decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(8.0)),
            margin: EdgeInsets.only(bottom: 20.0, right: 100.0),
          ),
          Container(
            child: Text(
              "Test message 3",
              style: TextStyle(color: Colors.white),
            ),
            padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
            width: 200.0,
            decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(8.0)),
            margin: EdgeInsets.only(bottom: 20.0, right: 100.0),
          ),
        ],
      ),
    ));
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
                  onPressed: () => onSendMessage('mimi1', 2),
                  child: Image(
                    image: AssetImage("lib/ui/images/mimi1.gif"),
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  )),
              FlatButton(
                  onPressed: () => onSendMessage('mimi2', 2),
                  child: Image(
                    image: AssetImage("lib/ui/images/mimi2.gif"),
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  )),
              FlatButton(
                  onPressed: () => onSendMessage('mimi3', 2),
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
                  onPressed: () => onSendMessage('mimi4', 2),
                  child: Image(
                    image: AssetImage("lib/ui/images/mimi4.gif"),
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  )),
              FlatButton(
                  onPressed: () => onSendMessage('mimi5', 2),
                  child: Image(
                    image: AssetImage("lib/ui/images/mimi5.gif"),
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  )),
              FlatButton(
                  onPressed: () => onSendMessage('mimi6', 2),
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
                  onPressed: () => onSendMessage('mimi7', 2),
                  child: Image(
                    image: AssetImage("lib/ui/images/mimi7.gif"),
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  )),
              FlatButton(
                  onPressed: () => onSendMessage('mimi8', 2),
                  child: Image(
                    image: AssetImage("lib/ui/images/mimi8.gif"),
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  )),
              FlatButton(
                  onPressed: () => onSendMessage('mimi9', 2),
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

  void onSendMessage(String content, int type) {
    // type: 0 = text, 1 = image, 2 = sticker
    if (content.trim() != '') {
      textEditingController.clear();

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
