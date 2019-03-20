import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:snschat_flutter/general/ui-component/list-view.dart';
import 'package:snschat_flutter/objects/chat/conversation_group.dart';
import 'package:snschat_flutter/objects/message/message.dart';
import 'package:snschat_flutter/objects/multimedia/multimedia.dart';
import 'package:snschat_flutter/ui/pages/chats/chat_room/chat_room_page.dart';

class ChatGroupListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ChatGroupListState();
  }
}

class ChatGroupListState extends State<ChatGroupListPage> {
  RefreshController _refreshController;

  @override
  initState() {
    super.initState();
    _refreshController = new RefreshController();
  }

  @override
  Widget build(BuildContext context) {
    List<PageListItem> listItems = [];
    conversations.forEach((conversation) {
      listItems.add(mapConversationToPageListTile(conversation, context));
    });
    return new Material(
        color: Colors.white,
        child: new SmartRefresher(
            controller: _refreshController,
            // Very important, without this whole thing won't work. Check the examples in the plugins
            onRefresh: (up) {
              if (up) {
                Future.delayed(Duration(seconds: 1), () {
                  //Delay 1 second to simulate something loading
                  _refreshController.sendBack(up, RefreshStatus.completed);
                });
              }
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
                  PageListItem listItem = listItems[index];
                  return new PageListTile(listItem, context);
                })));
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
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: ((context) => ChatRoomPage(
                      conversation)))); // Send argument need to use the old way
//        Navigator.of(context).pushNamed("contacts_page");
        });
  }

  // Test data: 240
  List<Conversation> conversations = [
    Conversation(
        id: '65451fse56rsg23hre',
        name: 'Testing group',
        type: 'Group',
        multimedia: Multimedia(
          localUrl: "Test local url",
          remoteUrl: "Test remote url",
          thumbnail: "thumbnail",
        ),
        description: 'Testing description',
        block: false,
        notificationExpireDate: 0,
        unreadMessage: UnreadMessage(
            count: 5, date: 8743895437, lastMessage: "Testing last message")),
    Conversation(
        id: 'tefuyjdhgverdjuygfaeriuyg',
        name: 'Testing group 2',
        type: 'Group',
        multimedia: Multimedia(
          localUrl: "Test local url",
          remoteUrl: "Test remote url",
          thumbnail: "thumbnail",
        ),
        description: 'Testing description',
        block: false,
        notificationExpireDate: 0,
        unreadMessage: UnreadMessage(
            count: 5, date: 8743895437, lastMessage: "Testing last message")),
    Conversation(
        id: '345p98t7y34uithgf325',
        name: 'Testing group 3',
        type: 'Group',
        multimedia: Multimedia(
          localUrl: "Test local url",
          remoteUrl: "Test remote url",
          thumbnail: "thumbnail",
        ),
        description: 'Testing description',
        block: false,
        notificationExpireDate: 0,
        unreadMessage: UnreadMessage(
            count: 5, date: 8743895437, lastMessage: "Testing last message")),
    Conversation(
        id: '5tg4p9o834huktyjf',
        name: 'Testing group 4',
        type: 'Group',
        multimedia: Multimedia(
          localUrl: "Test local url",
          remoteUrl: "Test remote url",
          thumbnail: "thumbnail",
        ),
        description: 'Testing description',
        block: false,
        notificationExpireDate: 0,
        unreadMessage: UnreadMessage(
            count: 5, date: 8743895437, lastMessage: "Testing last message")),
    Conversation(
        id: 'er3glikuherjhklgb',
        name: 'Testing group 5',
        type: 'Group',
        multimedia: Multimedia(
          localUrl: "Test local url",
          remoteUrl: "Test remote url",
          thumbnail: "thumbnail",
        ),
        description: 'Testing description',
        block: false,
        notificationExpireDate: 0,
        unreadMessage: UnreadMessage(
            count: 5, date: 8743895437, lastMessage: "Testing last message")),
    Conversation(
        id: '65451fsertglikuje56rsg23hre',
        name: 'Testing group 6',
        type: 'Group',
        multimedia: Multimedia(
          localUrl: "Test local url",
          remoteUrl: "Test remote url",
          thumbnail: "thumbnail",
        ),
        description: 'Testing description',
        block: false,
        notificationExpireDate: 0,
        unreadMessage: UnreadMessage(
            count: 5, date: 8743895437, lastMessage: "Testing last message")),
    Conversation(
        id: '45t9op8iujhw54git',
        name: 'Testing group 7',
        type: 'Group',
        multimedia: Multimedia(
          localUrl: "Test local url",
          remoteUrl: "Test remote url",
          thumbnail: "thumbnail",
        ),
        description: 'Testing description',
        block: false,
        notificationExpireDate: 0,
        unreadMessage: UnreadMessage(
            count: 5, date: 8743895437, lastMessage: "Testing last message")),
    Conversation(
        id: 'rtgyfbkuisne 98v',
        name: 'Testing group 8',
        type: 'Group',
        multimedia: Multimedia(
          localUrl: "Test local url",
          remoteUrl: "Test remote url",
          thumbnail: "thumbnail",
        ),
        description: 'Testing description',
        block: false,
        notificationExpireDate: 0,
        unreadMessage: UnreadMessage(
            count: 5, date: 8743895437, lastMessage: "Testing last message")),
    Conversation(
        id: 't4rweg[09pompium',
        name: 'Testing group 9',
        type: 'Group',
        multimedia: Multimedia(
          localUrl: "Test local url",
          remoteUrl: "Test remote url",
          thumbnail: "thumbnail",
        ),
        description: 'Testing description',
        block: false,
        notificationExpireDate: 0,
        unreadMessage: UnreadMessage(
            count: 5, date: 8743895437, lastMessage: "Testing last message")),
    Conversation(
        id: 'ty3pw9o8j87fct3-4q ',
        name: 'Testing group 10',
        type: 'Group',
        multimedia: Multimedia(
          localUrl: "Test local url",
          remoteUrl: "Test remote url",
          thumbnail: "thumbnail",
        ),
        description: 'Testing description',
        block: false,
        notificationExpireDate: 0,
        unreadMessage: UnreadMessage(
            count: 5, date: 8743895437, lastMessage: "Testing last message")),
  ];
}
