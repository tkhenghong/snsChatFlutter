import 'package:flutter/material.dart';
import 'package:snschat_flutter/general/ui-component/list-view.dart';
import 'package:snschat_flutter/objects/chat/conversation_group.dart';
import 'package:snschat_flutter/objects/message/message.dart';
import 'package:snschat_flutter/objects/multimedia/multimedia.dart';

class ChatGroupListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new ChatGroupListState();
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
    return new PageListView(array: listItems, context: context);
  }

  mapConversationToPageListTile(
      Conversation conversation, BuildContext context) {
    return PageListItem(
        title: new Text(conversation.name),
        subtitle: new Text(conversation.unreadMessage.lastMessage),
        leading: CircleAvatar(child: Text(conversation.name[0])),
        trailing: Text(conversation.unreadMessage.count.toString()),
        onTap: (BuildContext context) {
          Navigator.of(context).pushNamed("chat_room_page");
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
