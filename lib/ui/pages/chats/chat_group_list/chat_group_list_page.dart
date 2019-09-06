import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
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

  initialize() async {
    wholeAppBloc.dispatch(CheckUserLoginEvent(callback: (bool hasSignedIn) {
      if (hasSignedIn) {
//        wholeAppBloc.dispatch(UserSignInEvent(callback: (bool isSignedIn) {
//          if (isSignedIn) {
            wholeAppBloc.dispatch(LoadDatabaseToStateEvent(callback: (bool loadDone){
              if(loadDone) {
                if (getListDone == false) {
                  // TODO: Get Conversations for the User
                  wholeAppBloc.dispatch(GetConversationsForUserEvent(callback: (bool done) {
                    setState(() {
                      getListDone = done;
                    });
                  }));
                }
              }
            }));
//
//          } else {
//            goToLoginPage();
//          }
//        })); // Mobile no is not entered here
      } else {
        goToLoginPage();
      }
    }));
  }

  goToLoginPage() {
    Navigator.of(context).pushNamedAndRemoveUntil("login_page", (Route<dynamic> route) => false);
  }

  getUnreadMessage() async {}

  @override
  Widget build(BuildContext context) {
    final WholeAppBloc _wholeAppBloc = BlocProvider.of<WholeAppBloc>(context);
    wholeAppBloc = _wholeAppBloc;

    initialize();
    return BlocBuilder(
      bloc: wholeAppBloc,
      builder: (context, WholeAppState state) {
        if (!isObjectEmpty(state.conversationGroupList) && state.conversationGroupList.length > 0) {
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
                itemCount: state.conversationGroupList.length,
                itemBuilder: (context, index) {
                  return PageListTile(mapConversationToPageListTile(state.conversationGroupList[index]), context);
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

  PageListItem mapConversationToPageListTile(ConversationGroup conversation) {
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
