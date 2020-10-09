import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:snschat_flutter/general/index.dart';
import 'package:snschat_flutter/objects/models/index.dart';
import 'package:snschat_flutter/service/index.dart';
import 'package:snschat_flutter/state/bloc/bloc.dart';
import 'package:snschat_flutter/ui/pages/index.dart';
import 'package:time_formatter/time_formatter.dart';

class ChatGroupListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ChatGroupListState();
  }
}

class ChatGroupListState extends State<ChatGroupListPage> {
  RefreshController _refreshController;

  CustomFileService fileService = Get.find();
  ImageService imageService = Get.find();

  IPGeoLocationBloc ipGeoLocationBloc;
  AuthenticationBloc authenticationBloc;
  MultimediaProgressBloc multimediaProgressBloc;
  ConversationGroupBloc conversationGroupBloc;
  ChatMessageBloc chatMessageBloc;
  MultimediaBloc multimediaBloc;
  UnreadMessageBloc unreadMessageBloc;
  UserContactBloc userContactBloc;
  SettingsBloc settingsBloc;
  UserBloc userBloc;
  WebSocketBloc webSocketBloc;
  GoogleInfoBloc googleInfoBloc;

  static bool firstRun = true;
  static bool userContactsMultimediaLoaded = false;

  @override
  initState() {
    super.initState();
    _refreshController = new RefreshController(initialRefresh: false);
  }

  void dispose() {
    super.dispose();
    _refreshController.dispose();
    ipGeoLocationBloc.close();
    authenticationBloc.close();
    multimediaProgressBloc.close();
    conversationGroupBloc.close();
    chatMessageBloc.close();
    multimediaBloc.close();
    unreadMessageBloc.close();
    userContactBloc.close();
    settingsBloc.close();
    userBloc.close();
    webSocketBloc.close();
    googleInfoBloc.close();
  }

  @override
  Widget build(BuildContext context) {
    ipGeoLocationBloc = BlocProvider.of<IPGeoLocationBloc>(context);
    authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    multimediaProgressBloc = BlocProvider.of<MultimediaProgressBloc>(context);
    conversationGroupBloc = BlocProvider.of<ConversationGroupBloc>(context);
    chatMessageBloc = BlocProvider.of<ChatMessageBloc>(context);
    multimediaBloc = BlocProvider.of<MultimediaBloc>(context);
    unreadMessageBloc = BlocProvider.of<UnreadMessageBloc>(context);
    userContactBloc = BlocProvider.of<UserContactBloc>(context);
    settingsBloc = BlocProvider.of<SettingsBloc>(context);
    userBloc = BlocProvider.of<UserBloc>(context);
    webSocketBloc = BlocProvider.of<WebSocketBloc>(context);
    googleInfoBloc = BlocProvider.of<GoogleInfoBloc>(context);

    if (firstRun) {
      initialize();
      firstRun = false;
    }

    return MultiBlocListener(listeners: [
      // googleBlocListener(),
      userAuthenticationBlocListener(),
      userContactBlocListener(),
      userBlocListener(),
      conversationGroupBlocListener(),
    ], child: userAuthenticationBlocBuilder());
  }

  Widget userAuthenticationBlocBuilder() {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, authenticationState) {
        if (authenticationState is AuthenticationsLoaded) {
          return userBlocBuilder();
        }

        if (authenticationState is AuthenticationsNotLoaded) {
          return Center(child: Text('Error. Authentication is not loaded. Second.'));
        }

        return Center(child: Text('Error. Authentication is not loaded.'));
      },
    );
  }

  Widget userBlocBuilder() {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, userState) {
        if (userState is UserLoaded) {
          return conversationGroupBlocBuilder();
        }

        // User Not Loaded Event
        return Center(child: Text('Error. User is not loaded.'));
      },
    );
  }

  Widget conversationGroupBlocBuilder() {
    return BlocBuilder<ConversationGroupBloc, ConversationGroupState>(
      builder: (context, conversationGroupState) {
        if (conversationGroupState is ConversationGroupsLoading) {
          return showLoading();
        }

        if (conversationGroupState is ConversationGroupsLoaded) {
          return unreadMessageBlocBuilder();
        }

        // Conversation Groups Not Loaded Event
        return Center(child: Text('Error. Conversation Groups are not loaded.'));
      },
    );
  }

  Widget unreadMessageBlocBuilder() {
    return BlocBuilder<UnreadMessageBloc, UnreadMessageState>(
      builder: (context, unreadMessageState) {
        if (unreadMessageState is UnreadMessageLoading) {
          return showLoading();
        }
        if (unreadMessageState is UnreadMessagesLoaded) {
          return multimediaBlocBuilder();
        }

        // Unread Messages Not Loaded Event
        return Center(child: Text('Error. Unread Messages are not loaded.'));
      },
    );
  }

  Widget multimediaBlocBuilder() {
    return BlocBuilder<MultimediaBloc, MultimediaState>(
      builder: (context, multimediaState) {
        if (multimediaState is MultimediaLoading) {
          return showLoading();
        }

        if (multimediaState is MultimediaLoaded) {
          ConversationGroupState conversationGroupState = conversationGroupBloc.state;
          UnreadMessageState unreadMessageState = unreadMessageBloc.state;

          if (conversationGroupState is ConversationGroupsLoaded) {
            if (conversationGroupState.conversationGroupList.isNullOrBlank || conversationGroupState.conversationGroupList.isEmpty) {
              return Center(child: Text('No conversations. Tap \'+\' to create one!'));
            } else {
              return SmartRefresher(
                controller: _refreshController,
                onRefresh: () => onRefresh(),
                enablePullDown: true,
                physics: BouncingScrollPhysics(),
                header: ClassicHeader(),
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: conversationGroupState.conversationGroupList.length,
                    itemBuilder: (context, index) {
                      PageListItem pageListItem = mapConversationToPageListTile(
                          conversationGroupState.conversationGroupList[index], multimediaState, unreadMessageState);
                      return PageListTile(pageListItem, context);
                    }),
              );
            }
          }
        }

        // Multimedia Not Loaded Event
        return Center(child: Text('Error. Multimedia are not loaded.'));
      },
    );
  }

  userAuthenticationBlocListener() {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, authenticationState) {
        print('userAuthenticationBlocListener() is triggered.');
        if (authenticationState is AuthenticationsNotLoaded) {
          goToLoginPage();
        }

        if (authenticationState is AuthenticationsLoaded) {
          print('if (authenticationState is AuthenticationsLoaded)');
          refreshUserData();
          if (userContactBloc.state is UserContactsLoaded) {
            List<UserContact> userContactList = (userContactBloc.state as UserContactsLoaded).userContactList;

            multimediaBloc.add(GetUserContactsMultimediaEvent(userContactList: userContactList, callback: (bool done) {}));
            userContactsMultimediaLoaded = true;
          }
        }
      },
    );
  }

  googleBlocListener() {
    return BlocListener<GoogleInfoBloc, GoogleInfoState>(
      listener: (context, googleInfoState) {
        if (googleInfoState is GoogleInfoLoaded) {
//          BlocProvider.of<UserBloc>(context).add(InitializeUserEvent(
//              userId: ,
//              callback: (bool initialized) {
//                if (!initialized) {
//                  goToLoginPage();
//                }
//              }));
//          userContactBloc.add(InitializeUserContactsEvent(callback: (bool done) {}));
        }

        if (googleInfoState is GoogleInfoLoading) {
          googleInfoBloc.add(InitializeGoogleInfoEvent(callback: (bool initialized) {}));
        }

        if (googleInfoState is GoogleInfoNotLoaded) {
          goToLoginPage();
        }
      },
    );
  }

  userContactBlocListener() {
    return BlocListener<UserContactBloc, UserContactState>(
      listener: (context, userContactState) {
        if (userContactState is UserContactsLoaded) {
          if (userBloc.state is UserLoaded) {
            multimediaBloc.add(GetUserContactsMultimediaEvent(userContactList: userContactState.userContactList, callback: (bool done) {}));
            userContactsMultimediaLoaded = true;
          }
        }
      },
    );
  }

  userBlocListener() {
    return BlocListener<UserBloc, UserState>(
      listener: (context, userState) {
        if (userState is UserLoaded) {
          webSocketBloc.add(InitializeWebSocketEvent(callback: (bool done) {}));
        }
      },
    );
  }

  webSocketBlocListener() {
    return BlocListener<WebSocketBloc, WebSocketState>(
      listener: (context, websocketState) {
        if (websocketState is WebSocketLoaded) {
          webSocketBloc.add(GetOwnWebSocketEvent(callback: (Stream<dynamic> webSocketStream) {
            if (!webSocketStream.isNull) {
              processWebSocketMessage(webSocketStream);
            }
          }));
        }
      },
    );
  }

  conversationGroupBlocListener() {
    return BlocListener<ConversationGroupBloc, ConversationGroupState>(
      listener: (context, conversationGroupState) {},
    );
  }

  Widget showLoading() {
    return Center(child: Text('Loading...'));
  }

  PageListItem mapConversationToPageListTile(
      ConversationGroup conversationGroup, MultimediaState multimediaState, UnreadMessageState unreadMessageState) {
    Multimedia multimedia = (multimediaState as MultimediaLoaded).multimediaList.firstWhere(
        (Multimedia existingMultimedia) =>
            existingMultimedia.conversationId.toString() == conversationGroup.id && existingMultimedia.messageId.isEmpty,
        orElse: () => null);

    UnreadMessage unreadMessage = (unreadMessageState as UnreadMessagesLoaded).unreadMessageList.firstWhere(
        (UnreadMessage existingUnreadMessage) => existingUnreadMessage.conversationId.toString() == conversationGroup.id,
        orElse: () => null);

    return PageListItem(
        title: Hero(
          tag: conversationGroup.id,
          child: Text(conversationGroup.name),
        ),
        subtitle: Text(unreadMessage.isNull ? '' : unreadMessage.lastMessage),
        leading: Hero(
          tag: conversationGroup.id + '1',
          child: imageService.loadImageThumbnailCircleAvatar(
              multimedia, convertConversationGroupTypeToDefaultImagePathType(conversationGroup.conversationGroupType)),
        ),
        trailing: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 10.0),
              child:
                  Text(unreadMessage.isNull ? '' : formatTime(unreadMessage.date.millisecondsSinceEpoch), style: TextStyle(fontSize: 9.0)),
            ),
            Text(unreadMessage.isNull
                ? ''
                : unreadMessage.count.toString() == '0'
                    ? ''
                    : unreadMessage.count.toString())
          ],
        ),
        onTap: (BuildContext context, object) {
          // Send argument need to use the old way
          Navigator.push(context, MaterialPageRoute(builder: ((context) => ChatRoomPage(conversationGroup))));
        });
  }

  onRefresh() async {
    refreshUserData();
    setState(() {
      _refreshController.refreshCompleted();
    });
  }

  initialize() async {
    authenticationBloc.add(InitializeAuthenticationsEvent(callback: (bool done) {}));
    ipGeoLocationBloc.add(InitializeIPGeoLocationEvent(callback: (bool done) {}));
    userBloc.add(InitializeUserEvent(callback: (bool done) {}));
    ipGeoLocationBloc.add(InitializeIPGeoLocationEvent(callback: (bool done) {}));
    multimediaProgressBloc.add(InitializeMultimediaProgressEvent(callback: (bool done) {}));
    conversationGroupBloc.add(InitializeConversationGroupsEvent(callback: (bool done) {}));
    chatMessageBloc.add(InitializeChatMessagesEvent(callback: (bool done) {}));
    multimediaBloc.add(InitializeMultimediaEvent(callback: (bool done) {}));
    unreadMessageBloc.add(InitializeUnreadMessagesEvent(callback: (bool done) {}));
    userContactBloc.add(InitializeUserContactsEvent(callback: (bool done) {}));
  }

  refreshUserData() {
    print('refreshUserData()');
    userBloc.add(GetOwnUserEvent(callback: (User user) {}));
    settingsBloc.add(GetUserOwnSettingsEvent(callback: (Settings settings) {}));
    conversationGroupBloc.add(GetUserOwnConversationGroupsEvent(callback: (bool done) {
      if (done) {
        getConversationGroupsMultimedia();
      }
    }));
    unreadMessageBloc.add(GetUserPreviousUnreadMessagesEvent(callback: (bool done) {}));
    multimediaBloc.add(GetUserOwnProfilePictureMultimediaEvent(callback: (bool done) {}));
    userContactBloc.add(GetUserOwnUserContactEvent(callback: (bool done) {
      print('GetUserOwnUserContactEvent is done: $done');
      if (done) {
        userContactBloc.add(GetUserOwnUserContactsEvent(callback: (bool done) {}));
      }
    }));
  }

  /// Need this method to listen WebSocket messages
  /// As long as this page is not removed during logged in state, it will receive and process the messages correctly
  /// If user perform sudden logout or system logout, it will be disconnected immediately even if there's a message processing here. It's excepted.
  processWebSocketMessage(Stream<dynamic> webSocketStream) {
    UserState userState = userBloc.state;
    webSocketStream.listen((data) {
      showToast('Message confirmed received!', Toast.LENGTH_LONG);
      WebSocketMessage receivedWebSocketMessage = WebSocketMessage.fromJson(json.decode(data));
      webSocketBloc
          .add(ProcessWebSocketMessageEvent(webSocketMessage: receivedWebSocketMessage, context: context, callback: (bool done) {}));
    }, onError: (onError) {
      print('chat_room.page.dart onError listener is working.');
      print('chat_room.page.dart onError: ' + onError.toString());
      if (userState is UserLoaded) {
        webSocketBloc.add(ReconnectWebSocketEvent(callback: (bool done) {}));
      }
    }, onDone: () {
      // TODO: Show reconnect message
      if (userState is UserLoaded) {
        webSocketBloc.add(ReconnectWebSocketEvent(callback: (bool done) {}));
      }
    }, cancelOnError: false);
  }

  getConversationGroupsMultimedia() {
    ConversationGroupState conversationGroupState = conversationGroupBloc.state;
    if (conversationGroupState is ConversationGroupsLoaded) {
      multimediaBloc.add(GetConversationGroupsMultimediaEvent(
          conversationGroupList: conversationGroupState.conversationGroupList, callback: (bool done) {}));
    }
  }

  goToLoginPage() {
    googleInfoBloc.add(RemoveGoogleInfoEvent(callback: (bool done) {}));
//    Get.offAndToNamed('login_page');
    Navigator.of(context).pushNamedAndRemoveUntil('login_page', (Route<dynamic> route) => false);
  }
}
