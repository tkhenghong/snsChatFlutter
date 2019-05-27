import 'package:flutter/material.dart';
import 'package:snschat_flutter/database/sqflite/repositories/conversation_group/conversation_group.dart';
import 'package:snschat_flutter/database/sqflite/repositories/conversation_member/conversation_member.dart';
import 'package:snschat_flutter/database/sqflite/repositories/message/message.dart';
import 'package:snschat_flutter/database/sqflite/repositories/multimedia/multimedia.dart';
import 'package:snschat_flutter/database/sqflite/repositories/settings/settings.dart';
import 'package:snschat_flutter/database/sqflite/repositories/unread_message/unread_message.dart';
import 'package:snschat_flutter/database/sqflite/repositories/user/user.dart';
import 'package:snschat_flutter/database/sqflite/repositories/userContact/userContact.dart';

import 'dart:io';
import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:jaguar_query_sqflite/jaguar_query_sqflite.dart';

// FYI, https://github.com/Jaguar-dart/jaguar_orm/tree/master/sqflite

/// The adapter
SqfliteAdapter _adapter;

Future<void> startupDatabase() async {

  _adapter =  new SqfliteAdapter(await getDatabasesPath());

  // Connect
  await _adapter.connect();

  final conversationBean = new ConversationBean(_adapter);
  final conversationMemberBean = new ConversationMemberBean(_adapter);
  final messageBean = new MessageBean(_adapter);
  final multimediaBean = new MultimediaBean(_adapter);
  final settingsBean = new SettingsBean(_adapter);
  final unreadMessageBean = new UnreadMessageBean(_adapter);
  final userBean = new UserBean(_adapter);
  final userContactBean = new UserContactBean(_adapter);

  conversationBean.createTable(ifNotExists: true);
  conversationMemberBean.createTable(ifNotExists: true);
  messageBean.createTable(ifNotExists: true);
  multimediaBean.createTable(ifNotExists: true);
  settingsBean.createTable(ifNotExists: true);
  unreadMessageBean.createTable(ifNotExists: true);
  userBean.createTable(ifNotExists: true);
  userContactBean.createTable(ifNotExists: true);

}