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
import 'package:snschat_flutter/state/bloc/WholeApp/WholeAppBloc.dart';
import 'package:snschat_flutter/state/bloc/WholeApp/WholeAppEvent.dart';
import 'package:snschat_flutter/state/bloc/WholeApp/WholeAppState.dart';
import 'package:snschat_flutter/ui/pages/chats/chat_room/chat_room_page.dart';
import 'package:network_to_file_image/network_to_file_image.dart';
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
    wholeAppBloc.dispatch(LoadDatabaseToStateEvent(callback: (bool loadDone) {
      print("loadDone: " + loadDone.toString());
      if (loadDone) {
        wholeAppBloc.dispatch(CheckUserLoginEvent(callback: (bool hasSignedIn) {
          print("hasSignedIn: " + hasSignedIn.toString());
          if (hasSignedIn) {
            if (getListDone == false) {
              // TODO: Get Conversations for the User
              wholeAppBloc.dispatch(LoadUserPreviousDataEvent(callback: (bool done) {
                print("done: " + done.toString());
                setState(() {
                  getListDone = done;
                });
              }));
            }
          } else {
            goToLoginPage();
          }
        }));
      } else {
        goToLoginPage();
      }
    }));
  }

  goToLoginPage() {
    Navigator.of(context).pushNamedAndRemoveUntil("login_page", (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final WholeAppBloc _wholeAppBloc = BlocProvider.of<WholeAppBloc>(context);
    wholeAppBloc = _wholeAppBloc;

    initialize();
    return BlocBuilder(
      bloc: wholeAppBloc,
      builder: (context, WholeAppState state) {
        if (conversationGroupsAreReady(state) && unreadMessagesAreReady(state)) {
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

  bool conversationGroupsAreReady(WholeAppState state) {
    return !isObjectEmpty(state.conversationGroupList) && state.conversationGroupList.length > 0;
  }

  bool unreadMessagesAreReady(WholeAppState state) {
    return !isObjectEmpty(state.conversationGroupList) && state.conversationGroupList.length > 0;
  }

  PageListItem mapConversationToPageListTile(ConversationGroup conversation) {
//    Multimedia multimedia = wholeAppBloc.currentState.multimediaList.firstWhere((Multimedia multimedia) => (multimedia.conversationId == conversation.id));
    UnreadMessage unreadMessage = wholeAppBloc.currentState.unreadMessageList.firstWhere((UnreadMessage unreadMessage) => (unreadMessage.conversationId == conversation.id));

    print("formatTime(unreadMessage.date): " + formatTime(unreadMessage.date));

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
            backgroundImage: AssetImage(fileService.getDefaultImagePath(conversation.type)), // temporary
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

  // TODO: Incomplete
//  AssetImage getImage(Multimedia multimedia, String type) {
//    File file = await fileService.getLocalImage(multimedia, type);
//    File file2 = File(multimedia.localFullFileUrl);
//    if(isObjectEmpty(file2)) {
//      return fileService.getDefaultImage(type);
//    }
//    return Image(image: NetworkToFileImage(url: multimedia.remoteFullFileUrl, file: file2));
//  }
}
