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
    List<PageListItem> listItems = [];
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
                    print('Delayed 1 second.');
                    _refreshController.refreshCompleted();
                    // _refreshController.sendBack(up, RefreshStatus.completed); // Deprecated
                  });
                },
                onOffsetChange: (result, change) {
                  print("onOffsetChange......");
                },
                // Unable to put PageView under child properties, so have to get manual
                child: new ListView.builder(
                    itemCount: listItems.length,
                    physics: const AlwaysScrollableScrollPhysics(),
                    //suggestion from https://github.com/flutter/flutter/issues/22314
                    itemBuilder: (BuildContext content, int index) {
                      print("Checkpoint 1");
                      Conversation conversation = state.conversationList[index];
                      print("Checkpoint 2");
                      listItems.add(
                          mapConversationToPageListTile(conversation, context));
                      print("Checkpoint 3");
                      PageListItem listItem = listItems[index];
                      print("Checkpoint 4");
                      return new PageListTile(listItem, context);
                    })));
      },
    );
  }

  mapConversationToPageListTile(
      Conversation conversation, BuildContext context2) {
    print("mapConversationToPageListTile()");
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
            backgroundImage: AssetImage(
              "lib/ui/images/group2013.jpg",
            ),
          ),
        ),
        trailing: Text(conversation.unreadMessage.count.toString()),
        onTap: (BuildContext context, object) {
          print('onTap() ListTile');
          // Send argument need to use the old way
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: ((context) => ChatRoomPage(conversation))));
        });
  }

// Test data: 240
//  List<Conversation> conversations = [
//    Conversation(
//        id: '65451fse56rsg23hre',
//        name: 'Testing group',
//        type: ChatGroupType.Group,
//        groupPhoto: Multimedia(
//          localUrl: "Test local url",
//          remoteUrl: "Test remote url",
//          thumbnail: "thumbnail",
//        ),
//        description: 'Testing description',
//        block: false,
//        notificationExpireDate: 0,
//        unreadMessage: UnreadMessage(
//            count: 5, date: 8743895437, lastMessage: "Testing last message")),
//    Conversation(
//        id: 'tefuyjdhgverdjuygfaeriuyg',
//        name: 'Testing group 2',
//        type: ChatGroupType.Group,
//        groupPhoto: Multimedia(
//          localUrl: "Test local url",
//          remoteUrl: "Test remote url",
//          thumbnail: "thumbnail",
//        ),
//        description: 'Testing description',
//        block: false,
//        notificationExpireDate: 0,
//        unreadMessage: UnreadMessage(
//            count: 5, date: 8743895437, lastMessage: "Testing last message")),
//    Conversation(
//        id: '345p98t7y34uithgf325',
//        name: 'Testing group 3',
//        type: ChatGroupType.Group,
//        groupPhoto: Multimedia(
//          localUrl: "Test local url",
//          remoteUrl: "Test remote url",
//          thumbnail: "thumbnail",
//        ),
//        description: 'Testing description',
//        block: false,
//        notificationExpireDate: 0,
//        unreadMessage: UnreadMessage(
//            count: 5, date: 8743895437, lastMessage: "Testing last message")),
//    Conversation(
//        id: '5tg4p9o834huktyjf',
//        name: 'Testing group 4',
//        type: ChatGroupType.Group,
//        groupPhoto: Multimedia(
//          localUrl: "Test local url",
//          remoteUrl: "Test remote url",
//          thumbnail: "thumbnail",
//        ),
//        description: 'Testing description',
//        block: false,
//        notificationExpireDate: 0,
//        unreadMessage: UnreadMessage(
//            count: 5, date: 8743895437, lastMessage: "Testing last message")),
//    Conversation(
//        id: 'er3glikuherjhklgb',
//        name: 'Testing group 5',
//        type: ChatGroupType.Group,
//        groupPhoto: Multimedia(
//          localUrl: "Test local url",
//          remoteUrl: "Test remote url",
//          thumbnail: "thumbnail",
//        ),
//        description: 'Testing description',
//        block: false,
//        notificationExpireDate: 0,
//        unreadMessage: UnreadMessage(
//            count: 5, date: 8743895437, lastMessage: "Testing last message")),
//    Conversation(
//        id: '65451fsertglikuje56rsg23hre',
//        name: 'Testing group 6',
//        type: ChatGroupType.Group,
//        groupPhoto: Multimedia(
//          localUrl: "Test local url",
//          remoteUrl: "Test remote url",
//          thumbnail: "thumbnail",
//        ),
//        description: 'Testing description',
//        block: false,
//        notificationExpireDate: 0,
//        unreadMessage: UnreadMessage(
//            count: 5, date: 8743895437, lastMessage: "Testing last message")),
//    Conversation(
//        id: '45t9op8iujhw54git',
//        name: 'Testing group 7',
//        type: ChatGroupType.Group,
//        groupPhoto: Multimedia(
//          localUrl: "Test local url",
//          remoteUrl: "Test remote url",
//          thumbnail: "thumbnail",
//        ),
//        description: 'Testing description',
//        block: false,
//        notificationExpireDate: 0,
//        unreadMessage: UnreadMessage(
//            count: 5, date: 8743895437, lastMessage: "Testing last message")),
//    Conversation(
//        id: 'rtgyfbkuisne 98v',
//        name: 'Testing group 8',
//        type: ChatGroupType.Group,
//        groupPhoto: Multimedia(
//          localUrl: "Test local url",
//          remoteUrl: "Test remote url",
//          thumbnail: "thumbnail",
//        ),
//        description: 'Testing description',
//        block: false,
//        notificationExpireDate: 0,
//        unreadMessage: UnreadMessage(
//            count: 5, date: 8743895437, lastMessage: "Testing last message")),
//    Conversation(
//        id: 't4rweg[09pompium',
//        name: 'Testing group 9',
//        type: ChatGroupType.Group,
//        groupPhoto: Multimedia(
//          localUrl: "Test local url",
//          remoteUrl: "Test remote url",
//          thumbnail: "thumbnail",
//        ),
//        description: 'Testing description',
//        block: false,
//        notificationExpireDate: 0,
//        unreadMessage: UnreadMessage(
//            count: 5, date: 8743895437, lastMessage: "Testing last message")),
//    Conversation(
//        id: 'ty3pw9o8j87fct3-4q ',
//        name: 'Testing group 10',
//        type: ChatGroupType.Group,
//        groupPhoto: Multimedia(
//          localUrl: "Test local url",
//          remoteUrl: "Test remote url",
//          thumbnail: "thumbnail",
//        ),
//        description: 'Testing description',
//        block: false,
//        notificationExpireDate: 0,
//        unreadMessage: UnreadMessage(
//            count: 5, date: 8743895437, lastMessage: "Testing last message")),
//  ];
}
