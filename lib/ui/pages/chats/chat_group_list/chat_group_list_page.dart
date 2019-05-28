import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:snschat_flutter/general/functions/repeating_functions.dart';
import 'package:snschat_flutter/general/ui-component/list-view.dart';
import 'package:snschat_flutter/general/ui-component/loading.dart';
import 'package:snschat_flutter/objects/chat/conversation_group.dart';
import 'package:snschat_flutter/objects/multimedia/multimedia.dart';
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

  @override
  Widget build(BuildContext context) {
    final WholeAppBloc _wholeAppBloc = BlocProvider.of<WholeAppBloc>(context);
    wholeAppBloc = _wholeAppBloc;
//    showCenterLoadingIndicator(context);
    // TODO: Should only CheckUserLoginEvent first, doing this because haven't save user to DB*
    wholeAppBloc.dispatch(UserSignInEvent(callback: () {
      wholeAppBloc.dispatch(CheckUserLoginEvent(callback: (bool signUp) {
        print('CheckUserLoginEvent callback()');
        print('signUp: ' + signUp.toString());
        if (!signUp) {
          Navigator.of(context).pushNamedAndRemoveUntil("login_page", (Route<dynamic> route) => false);
        }
      }));
    }));
//    List<PageListItem> listItems = [];
    return BlocBuilder(
      bloc: wholeAppBloc,
      builder: (context, WholeAppState state) {
        return new Material(
            color: Colors.white,
            child: new SmartRefresher(
                // Need to add a header or else list display will not be correct
                header: WaterDropHeader(),
                controller: _refreshController,
                enablePullDown: true,
                onRefresh: () {
                  //Delay 1 second to simulate something loading
                  Future.delayed(Duration(seconds: 1), () {
                    _refreshController.refreshCompleted();
                  });
                },
                onOffsetChange: (result, change) {},
                // Unable to put PageView under child properties, so have to get manual
                child: new ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: state.conversationList.length,
//                    physics: const AlwaysScrollableScrollPhysics(),
                    //suggestion from https://github.com/flutter/flutter/issues/22314
                    itemBuilder: (BuildContext content, int index) {
                      print('chat_group_list_page.dart rendering....');
                      print('state.conversationList.length.toString(): ' + state.conversationList.length.toString());
                      print('conversationList:');
                      return PageListTile(mapConversationToPageListTile(state.conversationList[index], context), context);
                    })));
      },
    );
  }

  PageListItem mapConversationToPageListTile(Conversation conversation, BuildContext context2) {
    print('mapConversationToPageListTile()');
    File imageFile;
//    FileImage(conversation.groupPhoto.imageFile) || MemoryImage(conversation.groupPhoto.imageData)
    print("wholeAppBloc.currentState.unreadMessageList.length: " + wholeAppBloc.currentState.unreadMessageList.length.toString());
    print("wholeAppBloc.currentState.multimediaList.length: " + wholeAppBloc.currentState.multimediaList.length.toString());
    wholeAppBloc.currentState.unreadMessageList.forEach((UnreadMessage unreadMessage) {
      print('Got something?');
      print("unreadMessage.id: " + unreadMessage.id);
      print("unreadMessage.id: " + unreadMessage.lastMessage);
      print("unreadMessage.id: " + unreadMessage.count.toString());
    });
    UnreadMessage unreadMessage;
    wholeAppBloc.currentState.unreadMessageList.forEach((UnreadMessage existingUnreadMessage) {
      if (existingUnreadMessage.id == conversation.unreadMessageId) {
        unreadMessage = existingUnreadMessage;
      }
    });
    Multimedia groupPhoto;

    wholeAppBloc.currentState.multimediaList.forEach((Multimedia existingMultimedia) {
      if (existingMultimedia.id == conversation.groupPhotoId) {
        groupPhoto = existingMultimedia;
      }
    });
//    dynamic imageProvider = await loadImageHandler(groupPhoto);

    imageFile = File(groupPhoto.localFullFileUrl);
    imageFile.exists().then((fileExists) {
      if (!fileExists) {
        print('local file not exist!');
        loadImageHandler(groupPhoto).then((remoteDownloadedfile) {
          setState(() {
            imageFile = remoteDownloadedfile;
          });
        });
      }
    });

    return PageListItem(
        title: Hero(
          tag: conversation.name,
          child: Text(conversation.name),
        ),
//        subtitle: Text(conversation.unreadMessage.lastMessage),
        subtitle: Text(unreadMessage.lastMessage),
        leading: Hero(
          tag: conversation.id,
          child: CircleAvatar(
            backgroundColor: Colors.white,
//            backgroundImage: conversation.groupPhoto.imageData.length != 0 ? MemoryImage(conversation.groupPhoto.imageData) : NetworkImage(''),
            backgroundImage: FileImage(imageFile),
//            child: conversation.groupPhoto.imageData.length == 0 ? Text(conversation.name[0]) : Text(''),
            child: Text(''),
          ),
        ),
        trailing: Text(unreadMessage.count.toString() == "0" ? "" : unreadMessage.count.toString()),
        onTap: (BuildContext context, object) {
          // Send argument need to use the old way
          Navigator.push(context, MaterialPageRoute(builder: ((context) => ChatRoomPage(conversation))));
        });
  }
}
