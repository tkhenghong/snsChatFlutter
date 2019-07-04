import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:snschat_flutter/general/functions/validation_functions.dart';
import 'package:snschat_flutter/general/ui-component/list-view.dart';
import 'package:snschat_flutter/objects/chat/conversation_group.dart';
import 'package:snschat_flutter/objects/user/user.dart';
import 'package:snschat_flutter/state/bloc/WholeApp/WholeAppBloc.dart';
import 'package:snschat_flutter/state/bloc/WholeApp/WholeAppEvent.dart';
import 'package:snschat_flutter/state/bloc/WholeApp/WholeAppState.dart';
import 'package:snschat_flutter/ui/pages/chats/chat_room/chat_room_page.dart';
import 'package:intl/intl.dart';

class ChatGroupListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ChatGroupListState();
  }
}

class ChatGroupListState extends State<ChatGroupListPage> {
  RefreshController _refreshController;
  WholeAppBloc wholeAppBloc;
  bool getListDone = false;

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
        print("if (isSignedIn)");
        wholeAppBloc.dispatch(UserSignInEvent(callback: (bool isSignedIn) {
          print("UserSignInEvent success");
          if (isSignedIn) {
            print("sign in success");
//            test();
          } else {
            print("sign in failed");
            goToLoginPage();
          }
        })); // Mobile no is not entered here
      } else {
        print("if (!isSignedIn)");
        goToLoginPage();
      }
    }));
  }

  goToLoginPage() {
    print("goToLoginPage()");
    Navigator.of(context).pushNamedAndRemoveUntil("login_page", (Route<dynamic> route) => false);
  }

  Future<bool> getConversations() async {
    print("getConversations()");
//    QuerySnapshot userContactSnapshot = await Firestore.instance
//        .collection("user_contact")
//        .where("userId", isEqualTo: wholeAppBloc.currentState.userState.id)
//        .getDocuments();
//    List<DocumentSnapshot> userContactDocuments = userContactSnapshot.documents;
//    print("Got userContactDocuments.");
//    for (int i = 0; i < userContactDocuments.length; i++) {
//      DocumentSnapshot userContactDocument = userContactDocuments[i];
//      QuerySnapshot conversationSnapshot = await Firestore.instance
//          .collection("conversation")
//          .where("id", isEqualTo: userContactDocument['conversationId'].toString())
//          .getDocuments();
//
//      List<DocumentSnapshot> conversationDocuments = conversationSnapshot.documents;
//      print("conversationDocuments.length: " + conversationDocuments.length.toString());
//      if (conversationDocuments.length > 0) {
//        print("if (conversationDocuments.length > 0)");
//        DocumentSnapshot conversationDocument = conversationDocuments[0];
//
//        Conversation conversation = new Conversation(
//          id: conversationDocument["id"].toString(),
//          name: conversationDocument["name"].toString(),
//          description: conversationDocument["description"].toString(),
//          type: conversationDocument["type"].toString(),
//          timestamp: conversationDocument["timestamp"].toString(),
//          block: conversationDocument["block"] as bool,
//          notificationExpireDate: conversationDocument["notificationExpireDate"] as int,
//          creatorUserId: conversationDocument["creatorUserId"].toString(),
//          createdDate: conversationDocument["createdDate"].toString(),
//        );
//        wholeAppBloc.dispatch(AddConversationEvent(conversation: conversation, callback: (Conversation conversation) {}));
//      } else {
//        print("if (conversationDocuments.length <= 0)");
//      }
//    }

    QuerySnapshot userContactSnapshot = await Firestore.instance
        .collection("user_contact")
        .where("userId", isEqualTo: wholeAppBloc.currentState.userState.id)
        .getDocuments();
    List<DocumentSnapshot> userContactDocuments = userContactSnapshot.documents;
    if (userContactDocuments.length > 0) {
      List<String> conversationIds = userContactDocuments.map((DocumentSnapshot userContactDocument) {
        return userContactDocument["conversationId"];
      });
      print("conversationIds: " + conversationIds.toString());
      QuerySnapshot conversationSnapshot =
          await Firestore.instance.collection("conversation").where("groupMembersIds", arrayContains: conversationIds).getDocuments();

      List<DocumentSnapshot> conversationDocuments = conversationSnapshot.documents;
      print("conversationDocuments.length: " + conversationDocuments.length.toString());
      if (conversationDocuments.length > 0) {
        print("if (conversationDocuments.length > 0)");
        DocumentSnapshot conversationDocument = conversationDocuments[0];

        Conversation conversation = new Conversation(
          id: conversationDocument["id"].toString(),
          name: conversationDocument["name"].toString(),
          description: conversationDocument["description"].toString(),
          type: conversationDocument["type"].toString(),
          timestamp: conversationDocument["timestamp"].toString(),
          block: conversationDocument["block"] as bool,
          notificationExpireDate: conversationDocument["notificationExpireDate"] as int,
          creatorUserId: conversationDocument["creatorUserId"].toString(),
          createdDate: conversationDocument["createdDate"].toString(),
        );
        wholeAppBloc.dispatch(AddConversationEvent(conversation: conversation, callback: (Conversation conversation) {}));
      } else {
        print("if (conversationDocuments.length <= 0)");
      }
    }

    return true;
  }

  getUnreadMessage() async {}

  @override
  Widget build(BuildContext context) {
    final WholeAppBloc _wholeAppBloc = BlocProvider.of<WholeAppBloc>(context);
    wholeAppBloc = _wholeAppBloc;

    checkUserLogin();
    print("getListDone: " + getListDone.toString());
    if (getListDone == false) {
      print("if (!getListDone)");
      getConversations().then((bool done) {
        print("getConversation() success!");
        setState(() {
          getListDone = true;
        });
      });
    }
    return BlocBuilder(
      bloc: wholeAppBloc,
      builder: (context, WholeAppState state) {
        if (!isObjectEmpty(state.conversationList) && state.conversationList.length > 0) {
          return SmartRefresher(
            controller: _refreshController,
            header: WaterDropHeader(),
            onRefresh: () {
              //Delay 1 second to simulate something loading
              Future.delayed(Duration(seconds: 1), () {
                _refreshController.refreshCompleted();
              });
            },
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                itemCount: state.conversationList.length,
                itemBuilder: (context, index) {
                  print("ListView.builder");
                  return PageListTile(mapConversationToPageListTile(state.conversationList[index]), context);
                }),
          );
        } else {
          return getListDone
              ? Center(child: Text("No conversations. Tap \"+\" to create one!"))
              : Center(child: Text("Loading messages..."));
        }
      },
    );
  }

  PageListItem mapConversationToPageListTile(Conversation conversation) {
    print('mapConversationToPageListTile()');
    return PageListItem(
        title: Hero(
          tag: conversation.name,
          child: Text(conversation.name),
        ),
        subtitle: Text("Test subtitle"),
//        subtitle: Text(unreadMessage.lastMessage),
        leading: Hero(
          tag: conversation.id,
          child: CircleAvatar(
            backgroundColor: Colors.white,
//            backgroundImage: conversation.groupPhoto.imageData.length != 0 ? MemoryImage(conversation.groupPhoto.imageData) : NetworkImage(''),
            backgroundImage: AssetImage("lib/ui/images/group2013.jpg"),
//            child: conversation.groupPhoto.imageData.length == 0 ? Text(conversation.name[0]) : Text(''),
            child: Text(''),
          ),
        ),
//        trailing: Text(unreadMessage.count.toString() == "0" ? "" : unreadMessage.count.toString()),
        trailing: Text("0"),
        onTap: (BuildContext context, object) {
          // Send argument need to use the old way
          Navigator.push(context, MaterialPageRoute(builder: ((context) => ChatRoomPage(conversation))));
        });
  }
}
