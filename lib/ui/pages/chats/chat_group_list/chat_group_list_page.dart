import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:snschat_flutter/enums/chat_group/chat_group.dart';
import 'package:snschat_flutter/general/ui-component/list-view.dart';
import 'package:snschat_flutter/objects/chat/conversation_group.dart';
import 'package:snschat_flutter/objects/message/message.dart';
import 'package:snschat_flutter/objects/multimedia/multimedia.dart';
import 'package:snschat_flutter/state/bloc/WholeApp/WholeAppBloc.dart';
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
//    List<PageListItem> listItems = [];
    return BlocBuilder(
      bloc: wholeAppBloc,
      builder: (context, WholeAppState state) {
        return new Material(
            color: Colors.white,
            child: new SmartRefresher(
                controller: _refreshController,
                // Very important, without this whole thing won't work. Check the examples in the plugins
                onRefresh: () {
                  //Delay 1 second to simulate something loading
                  Future.delayed(Duration(seconds: 1), () {
                    _refreshController.refreshCompleted();
                    // _refreshController.sendBack(up, RefreshStatus.completed); // Deprecated
                  });
                },
                onOffsetChange: (result, change) {
                },
                // Unable to put PageView under child properties, so have to get manual
                child: new ListView.builder(
                    itemCount: state.conversationList.length,
                    physics: const AlwaysScrollableScrollPhysics(),
                    //suggestion from https://github.com/flutter/flutter/issues/22314
                    itemBuilder: (BuildContext content, int index) {
                      return new PageListTile(
                          mapConversationToPageListTile(
                              state.conversationList[index], context),
                          context);
                    })));
      },
    );
  }

  mapConversationToPageListTile(
      Conversation conversation, BuildContext context2) {
//    FileImage(conversation.groupPhoto.imageFile) || MemoryImage(conversation.groupPhoto.imageData)

    return PageListItem(
        title: Hero(
          tag: conversation.name,
          child: Text(conversation.name),
        ),
        subtitle: Text(conversation.unreadMessage.lastMessage),
        leading: Hero(
          tag: conversation.id,
          child: CircleAvatar(
            backgroundColor: Colors.white,
            backgroundImage: conversation.groupPhoto.imageData.length != 0 ? MemoryImage(conversation.groupPhoto.imageData) : NetworkImage(''),
            child: conversation.groupPhoto.imageData.length == 0 ? Text(conversation.name[0]) : Text(''),
          ),
        ),
        trailing: Text(conversation.unreadMessage.count.toString() == "0"
            ? ""
            : conversation.unreadMessage.count.toString()),
        onTap: (BuildContext context, object) {
          // Send argument need to use the old way
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: ((context) => ChatRoomPage(conversation))));
        });
  }
}
