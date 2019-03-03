import 'package:flutter/material.dart';
import 'package:snschat_flutter/general/ui-component/list-view.dart';
import 'package:snschat_flutter/objects/chat/conversation_group.dart';
import 'package:snschat_flutter/objects/message/message.dart';
import 'package:snschat_flutter/objects/multimedia/multimedia.dart';
import "package:pull_to_refresh/pull_to_refresh.dart";
import 'package:snschat_flutter/ui/pages/chat_room/chat_room_page.dart';

class ChatGroupListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ChatGroupListState();
  }
}

class ChatGroupListState extends State<ChatGroupListPage> {
  @override
  Widget build(BuildContext context) {
    List<PageListItem> listItems = [];
    conversations.forEach((conversation) {
      listItems.add(mapConversationToPageListTile(conversation, context));
    });
    print('chat_group_list_page.dart listItems.length: ' +
        listItems.length.toString());
    return PageListView(array: listItems, context: context);
  }

  mapConversationToPageListTile(
      Conversation conversation, BuildContext context) {
    return PageListItem(
        title: Text(conversation.name),
        subtitle: Text(conversation.unreadMessage.lastMessage),
        leading: CircleAvatar(
          child: Text(
            conversation.name[0],
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.black,
        ),
        trailing: Text(conversation.unreadMessage.count.toString()),
        onTap: (BuildContext context) {
          print('Go to Chat Room page.');
          print('Go to conversation.name: ' + conversation.name);
          print('Go to conversation.description: ' + conversation.description);
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => ChatRoomPage(
                  conversation))); //Send argument need to use the old way
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
        id: '65451fse56rsg23hre',
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
