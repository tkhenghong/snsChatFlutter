import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:snschat_flutter/general/functions/repeating_functions.dart';
import 'package:snschat_flutter/general/functions/validation_functions.dart';
import 'package:snschat_flutter/general/ui-component/list-view.dart';
import 'package:snschat_flutter/general/ui-component/loading.dart';
import 'package:snschat_flutter/objects/chat/conversation_group.dart';
import 'package:snschat_flutter/objects/multimedia/multimedia.dart';
import 'package:snschat_flutter/objects/user/user.dart';
import 'package:snschat_flutter/state/bloc/WholeApp/WholeAppBloc.dart';
import 'package:snschat_flutter/state/bloc/WholeApp/WholeAppEvent.dart';
import 'package:snschat_flutter/state/bloc/WholeApp/WholeAppState.dart';
import 'package:snschat_flutter/ui/pages/chats/chat_room/chat_room_page.dart';

class ChatGroupListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ChatGroupListState();
  }
}

class ChatGroupListState extends State<ChatGroupListPage> {
  RefreshController _refreshController;
  WholeAppBloc wholeAppBloc;

  @override
  initState() {
    super.initState();
    _refreshController = new RefreshController();
  }

  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  checkUserLogin() async {
    wholeAppBloc.dispatch(CheckUserLoginEvent(callback: (bool isSignedIn) {
      if (isSignedIn) {
        wholeAppBloc.dispatch(UserSignInEvent(callback: (User user) {
          print("UserSignInEvent success");
          if (isObjectEmpty(user)) {
            print("if(isObjectEmpty(user))");
          } else {
            print("if(!isObjectEmpty(user))");
          }
          print("user.id: " + user.id);
          print("user.displayName: " + user.displayName);
          print("user.mobileNo: " + user.mobileNo);
        }));
      } else {
        Navigator.of(context).pushNamedAndRemoveUntil(
            "login_page", (Route<dynamic> route) => false);
      }
    }));
  }

  @override
  Widget build(BuildContext context) {
    final WholeAppBloc _wholeAppBloc = BlocProvider.of<WholeAppBloc>(context);
    wholeAppBloc = _wholeAppBloc;

    checkUserLogin();
    return BlocBuilder(
      bloc: wholeAppBloc,
      builder: (context, WholeAppState state) {
        return StreamBuilder(
          stream: Firestore.instance
              .collection("conversation")
              .where("userId",
                  isEqualTo: wholeAppBloc.currentState.userState.id)
              .orderBy('timestamp', descending: true)
              .snapshots(),
          builder: (BuildContext context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: Text("Loading messages..."));
            } else {
              print(
                  "chat_group_list_page.dart snapshot.data.documents.length: " +
                      snapshot.data.documents.length.toString());
              if (snapshot.data.documents.length > 0) {
                return ListView.builder(
//                        scrollDirection: Axis.vertical,
//                        shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  itemCount: snapshot.data.documents.length,
//                        reverse: true,
                  itemBuilder: (context, index) {
                    DocumentSnapshot documentSnapshot =
                        snapshot.data.documents[index];
                    print("Within itemBuilder");
                    print("index: " + index.toString());
//                    mapConversationToPageListTile(state.conversationList[index], context);
                    return ListTile(
                      title: Hero(
                          tag: documentSnapshot["name"].toString(),
                          child: Text(documentSnapshot["name"].toString())),
                      subtitle: Text("Test subtitle"),
                      leading: Hero(
                          tag: documentSnapshot["id"].toString(),
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            backgroundImage:
                                AssetImage("lib/ui/images/group2013.jpg"),
                            child: Text(''),
                          )),
//                      trailing: Text(unreadMessage.count.toString() == "0" ? "" : unreadMessage.count.toString()),
                      onTap: () {
                        Conversation conversation = new Conversation(
                            id: documentSnapshot["id"].toString(),
                            name: documentSnapshot["name"].toString(),
                            description:
                                documentSnapshot["description"].toString(),
                            type: documentSnapshot["type"].toString(),
                            timestamp: documentSnapshot["timestamp"].toString(),
                            block: documentSnapshot["block"] as bool,
//                          groupPhotoId: documentSnapshot["groupPhotoId"].toString(),
                            notificationExpireDate:
                                documentSnapshot["notificationExpireDate"]
                                    as int,
//                          unreadMessageId: documentSnapshot["unreadMessageId"].toString(),
                            userId: documentSnapshot["userId"].toString());
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) =>
                                    ChatRoomPage(conversation))));
                      },
                    );
//                    return PageListTile(mapConversationToPageListTile(state.conversationList[index], context), context);
                  },
                );
              } else {
                return Center(
                    child: Text("No conversations. Tap \"+\" to create one!"));
              }
            }
          },
        );
//          new Material(
//            color: Colors.white,
//            child: new SmartRefresher(
//                // Need to add a header or else list display will not be correct
//                header: WaterDropHeader(),
//                controller: _refreshController,
//                enablePullDown: true,
//                onRefresh: () {
//                  //Delay 1 second to simulate something loading
//                  Future.delayed(Duration(seconds: 1), () {
//                    _refreshController.refreshCompleted();
//                  });
//                },
//                onOffsetChange: (result, change) {},
//                // Unable to put PageView under child properties, so have to get manual
//                child: new ListView.builder(
//                    physics: BouncingScrollPhysics(),
//                    itemCount: state.conversationList.length,
////                    physics: const AlwaysScrollableScrollPhysics(),
//                    //suggestion from https://github.com/flutter/flutter/issues/22314
//                    itemBuilder: (BuildContext content, int index) {
//                      print('chat_group_list_page.dart rendering....');
//                      print('state.conversationList.length.toString(): ' + state.conversationList.length.toString());
//                      print('conversationList:');
//                      return PageListTile(mapConversationToPageListTile(state.conversationList[index], context), context);
//                    })));
      },
    );
  }

  getConversations() async {
    print("getConversations()");

    // We need:
    // Conversation
    // UnreadMessage
    // Multimedia
    var conversationDocuments = await Firestore.instance
        .collection("conversation")
        .where("userId", isEqualTo: wholeAppBloc.currentState.userState.id)
        .orderBy('timestamp', descending: true)
        .getDocuments();
    if (conversationDocuments.documents.length == 0) {
      print("if (conversationDocuments.documents.length == 0)");
    } else {
      print("if (conversationDocuments.documents.length > 0)");
    }

    var unreadMessageDocuments = await Firestore.instance
        .collection("unread_message")
        .where("userId", isEqualTo: wholeAppBloc.currentState.userState.id)
        .getDocuments();
    if (unreadMessageDocuments.documents.length == 0) {
      print("if (unreadMessageDocuments.documents.length == 0)");
    } else {
      print("if (unreadMessageDocuments.documents.length > 0)");
    }
    var multimediaDocuments = await Firestore.instance
        .collection("multimedia")
        .where("conversationId",
            isEqualTo: wholeAppBloc.currentState.userState.id)
        .getDocuments();
    if (multimediaDocuments.documents.length == 0) {
      print("if (multimediaDocuments.documents.length == 0)");
    } else {
      print("if (multimediaDocuments.documents.length > 0)");
    }
  }

  PageListItem mapConversationToPageListTile(
      Conversation conversation, BuildContext context2) {
    print('mapConversationToPageListTile()');
    getConversations();
    // var data = await Firestore.instance.collection('users').document(widget.userId).collection('Products').getDocuments();

    // TODO: Change the whole logic here so it synchronizes the database to state and DB
//    File imageFile;
////    FileImage(conversation.groupPhoto.imageFile) || MemoryImage(conversation.groupPhoto.imageData)
//    print("wholeAppBloc.currentState.unreadMessageList.length: " + wholeAppBloc.currentState.unreadMessageList.length.toString());
//    print("wholeAppBloc.currentState.multimediaList.length: " + wholeAppBloc.currentState.multimediaList.length.toString());
//    wholeAppBloc.currentState.unreadMessageList.forEach((UnreadMessage unreadMessage) {
//      print('Got something?');
//      print("unreadMessage.id: " + unreadMessage.id);
//      print("unreadMessage.id: " + unreadMessage.lastMessage);
//      print("unreadMessage.id: " + unreadMessage.count.toString());
//    });
//    UnreadMessage unreadMessage;
//    wholeAppBloc.currentState.unreadMessageList.forEach((UnreadMessage existingUnreadMessage) {
//      if (existingUnreadMessage.id == conversation.unreadMessageId) {
//        unreadMessage = existingUnreadMessage;
//      }
//    });
//    Multimedia groupPhoto;
//
//    wholeAppBloc.currentState.multimediaList.forEach((Multimedia existingMultimedia) {
//      if (existingMultimedia.id == conversation.groupPhotoId) {
//        groupPhoto = existingMultimedia;
//      }
//    });
////    dynamic imageProvider = await loadImageHandler(groupPhoto);
//
//    imageFile = File(groupPhoto.localFullFileUrl);
//    imageFile.exists().then((fileExists) {
//      if (!fileExists) {
//        print('chat.group.list.page.dart local file not exist!');
//        loadImageHandler(groupPhoto).then((remoteDownloadedfile) {
//          setState(() {
//            imageFile = remoteDownloadedfile;
//          });
//        });
//      }
//    });
//
//    return PageListItem(
//        title: Hero(
//          tag: conversation.name,
//          child: Text(conversation.name),
//        ),
////        subtitle: Text(conversation.unreadMessage.lastMessage),
//        subtitle: Text(unreadMessage.lastMessage),
//        leading: Hero(
//          tag: conversation.id,
//          child: CircleAvatar(
//            backgroundColor: Colors.white,
////            backgroundImage: conversation.groupPhoto.imageData.length != 0 ? MemoryImage(conversation.groupPhoto.imageData) : NetworkImage(''),
//            backgroundImage: FileImage(imageFile),
////            child: conversation.groupPhoto.imageData.length == 0 ? Text(conversation.name[0]) : Text(''),
//            child: Text(''),
//          ),
//        ),
//        trailing: Text(unreadMessage.count.toString() == "0" ? "" : unreadMessage.count.toString()),
//        onTap: (BuildContext context, object) {
//          // Send argument need to use the old way
//          Navigator.push(context, MaterialPageRoute(builder: ((context) => ChatRoomPage(conversation))));
//        });
  }
}
