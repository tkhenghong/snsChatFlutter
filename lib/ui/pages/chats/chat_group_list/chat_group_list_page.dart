import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:snschat_flutter/general/functions/validation_functions.dart';
import 'package:snschat_flutter/general/ui-component/list-view.dart';
import 'package:snschat_flutter/objects/chat/conversation_group.dart';
import 'package:snschat_flutter/objects/multimedia/multimedia.dart';
import 'package:snschat_flutter/objects/unreadMessage/UnreadMessage.dart';
import 'package:snschat_flutter/service/file/FileService.dart';
import 'package:snschat_flutter/service/image/ImageService.dart';
import 'package:snschat_flutter/state/bloc/WholeApp/WholeAppBloc.dart';
import 'package:snschat_flutter/state/bloc/WholeApp/WholeAppEvent.dart';
import 'package:snschat_flutter/state/bloc/WholeApp/WholeAppState.dart';
import 'package:snschat_flutter/ui/pages/chats/chat_room/chat_room_page.dart';
import 'package:time_formatter/time_formatter.dart';

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
  FileService fileService = FileService();
  ImageService imageService = ImageService();

  @override
  initState() {
    super.initState();
    print("chat_group_list_page.dart initState()");
    _refreshController = new RefreshController();
    final WholeAppBloc _wholeAppBloc = BlocProvider.of<WholeAppBloc>(context);
    wholeAppBloc = _wholeAppBloc;
    initialize();
  }

  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  initialize() async {
    print("initialize()");
    wholeAppBloc.dispatch(LoadDatabaseToStateEvent(callback: (bool loadDone) {
      print("loadDone: " + loadDone.toString());
      if (loadDone) {
        // Set list done to true to prevent waiting due to poor Internet connection
        setState(() {
          getListDone = true;
        });
        wholeAppBloc.dispatch(CheckUserLoginEvent(callback: (bool hasSignedIn) {
          print("hasSignedIn: " + hasSignedIn.toString());
          if (hasSignedIn) {
            if (getListDone == false) {
              // TODO: Get Conversations for the User
              wholeAppBloc.dispatch(LoadUserPreviousDataEvent(callback: (bool done) {
                print("done: " + done.toString());
              }));
            }
          } else {
            wholeAppBloc.dispatch(UserSignOutEvent()); // Remove State data before leaving
            goToLoginPage();
          }
        }));
      } else {
        wholeAppBloc.dispatch(UserSignOutEvent()); // Remove State data before leaving
        goToLoginPage();
      }
    }));
  }

  goToLoginPage() {
    Navigator.of(context).pushNamedAndRemoveUntil("login_page", (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: wholeAppBloc,
      builder: (context, WholeAppState state) {
        if (conversationGroupsAreReady(state) && unreadMessagesAreReady(state)) {
          return SmartRefresher(
            controller: _refreshController,
            header: WaterDropHeader(),
            onRefresh: () {
              setState(() {});
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

  bool conversationGroupsAreReady(WholeAppState state) {
    return !isObjectEmpty(state.conversationGroupList) && state.conversationGroupList.length > 0;
  }

  bool unreadMessagesAreReady(WholeAppState state) {
    return !isObjectEmpty(state.unreadMessageList) && state.unreadMessageList.length > 0;
  }

  PageListItem mapConversationToPageListTile(ConversationGroup conversation) {
    print("conversation.id: " + conversation.id);
    Multimedia multimedia = findMultimedia(conversation.id);
    UnreadMessage unreadMessage = findUnreadMessage(conversation.id);

    return PageListItem(
        title: Hero(
          tag: conversation.name,
          child: Text(conversation.name),
        ),
        subtitle: Text(unreadMessage.lastMessage),
        leading: Hero(
          tag: conversation.id,
          child: CircleAvatar(
            backgroundColor: Colors.white,
            backgroundImage: imageService.processImage(multimedia, conversation.type), // temporary
            // TODO: Make the below code as an "image" if all multimedia URLs (and files) are missing
//            child: conversation.groupPhoto.imageData.length == 0 ? Text(conversation.name[0]) : Text(''),
            child: Text(''),
          ),
        ),
        trailing: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: Text(formatTime(unreadMessage.date), style: TextStyle(fontSize: 9.0)),
            ),
            Text(unreadMessage.count.toString() == "0" ? "" : unreadMessage.count.toString())
          ],
        ),
        onTap: (BuildContext context, object) {
          // Send argument need to use the old way
          Navigator.push(context, MaterialPageRoute(builder: ((context) => ChatRoomPage(conversation))));
        });
  }

  Multimedia findMultimedia(String conversationId) {
    Multimedia multimedia;
    print("wholeAppBloc.currentState.multimediaList.length: " + wholeAppBloc.currentState.multimediaList.length.toString());
    multimedia = wholeAppBloc.currentState.multimediaList.firstWhere((Multimedia existingMultimedia) {
      return existingMultimedia.conversationId.toString() == conversationId && isStringEmpty(existingMultimedia.messageId);
    });

    if(isObjectEmpty(multimedia)) {
      print("Multimedia is not found.");
    } else {
      print("Multimedia is found.");
    }

    return multimedia;
  }

  UnreadMessage findUnreadMessage(String conversationId) {
    UnreadMessage unreadMessage;
    wholeAppBloc.currentState.unreadMessageList.forEach((UnreadMessage existingUnreadMessage) {
      if (existingUnreadMessage.conversationId == conversationId) {
        unreadMessage = existingUnreadMessage;
      }
    });

    return unreadMessage;
  }
}
