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
  MessageBloc messageBloc;
  MultimediaBloc multimediaBloc;
  UnreadMessageBloc unreadMessageBloc;
  UserContactBloc userContactBloc;
  SettingsBloc settingsBloc;
  UserBloc userBloc;
  WebSocketBloc webSocketBloc;
  GoogleInfoBloc googleInfoBloc;

  static bool firstRun = true;

  @override
  initState() {
    super.initState();
    _refreshController = new RefreshController(initialRefresh: false);
  }

  void dispose() {
    super.dispose();
    _refreshController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ipGeoLocationBloc = BlocProvider.of<IPGeoLocationBloc>(context);
    authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    multimediaProgressBloc = BlocProvider.of<MultimediaProgressBloc>(context);
    conversationGroupBloc = BlocProvider.of<ConversationGroupBloc>(context);
    messageBloc = BlocProvider.of<MessageBloc>(context);
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
//       googleBlocListener(),
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
            if (isObjectEmpty(conversationGroupState.conversationGroupList) || conversationGroupState.conversationGroupList.length == 0) {
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
                      PageListItem pageListItem = mapConversationToPageListTile(conversationGroupState.conversationGroupList[index], multimediaState, unreadMessageState);
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
        if (authenticationState is AuthenticationsNotLoaded) {
          goToLoginPage();
        }
        if (authenticationState is AuthenticationsLoaded) {
          userBloc.add(InitializeUserEvent(userId: authenticationState.username, callback: (bool initialized) {}));
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
          multimediaBloc.add(GetUserContactsMultimediaEvent(userContactList: userContactState.userContactList, callback: (bool done) {}));
        }
      },
    );
  }

  userBlocListener() {
    return BlocListener<UserBloc, UserState>(
      listener: (context, userState) {
        if (userState is UserLoaded) {
          webSocketBloc.add(InitializeWebSocketEvent(user: userState.user, callback: (bool done) {}));
          restoreUserPreviousData();
        }

        if(userState is UserNotLoaded) {
          userBloc.add(GetOwnUserEvent(callback: (User user) {}));
        }
      },
    );
  }

  webSocketBlocListener() {
    return BlocListener<WebSocketBloc, WebSocketState>(
      listener: (context, websocketState) {
        if (websocketState is WebSocketLoaded) {
          webSocketBloc.add(GetOwnWebSocketEvent(callback: (Stream<dynamic> webSocketStream) {
            if (!isObjectEmpty(webSocketStream)) {
              processWebSocketMessage(webSocketStream);
            }
          }));
        }
      },
    );
  }

  conversationGroupBlocListener() {
    return BlocListener<ConversationGroupBloc, ConversationGroupState>(
      listener: (context, conversationGroupState) {
        if (conversationGroupState is ConversationGroupsLoaded) {
          getConversationGroupsMultimedia();
        }
      },
    );
  }

  Widget showLoading() {
    return Center(child: Text('Loading...'));
  }

  PageListItem mapConversationToPageListTile(ConversationGroup conversationGroup, MultimediaState multimediaState, UnreadMessageState unreadMessageState) {
    Multimedia multimedia = (multimediaState as MultimediaLoaded)
        .multimediaList
        .firstWhere((Multimedia existingMultimedia) => existingMultimedia.conversationId.toString() == conversationGroup.id && isStringEmpty(existingMultimedia.messageId), orElse: () => null);

    UnreadMessage unreadMessage =
        (unreadMessageState as UnreadMessagesLoaded).unreadMessageList.firstWhere((UnreadMessage existingUnreadMessage) => existingUnreadMessage.conversationId.toString() == conversationGroup.id, orElse: () => null);

    return PageListItem(
        title: Hero(
          tag: conversationGroup.id,
          child: Text(conversationGroup.name),
        ),
        subtitle: Text(isObjectEmpty(unreadMessage) ? '' : unreadMessage.lastMessage),
        leading: Hero(
          tag: conversationGroup.id + '1',
          child: imageService.loadImageThumbnailCircleAvatar(multimedia, convertConversationGroupTypeToDefaultImagePathType(conversationGroup.type), context),
        ),
        trailing: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: Text(isObjectEmpty(unreadMessage) ? '' : formatTime(unreadMessage.date.millisecondsSinceEpoch), style: TextStyle(fontSize: 9.0)),
            ),
            Text(isObjectEmpty(unreadMessage) ? '' : unreadMessage.count.toString() == '0' ? '' : unreadMessage.count.toString())
          ],
        ),
        onTap: (BuildContext context, object) {
          // Send argument need to use the old way
          Navigator.push(context, MaterialPageRoute(builder: ((context) => ChatRoomPage(conversationGroup))));
        });
  }

  onRefresh() async {
    restoreUserPreviousData();
    setState(() {
      _refreshController.refreshCompleted();
    });
  }

  initialize() async {
    ipGeoLocationBloc.add(InitializeIPGeoLocationEvent(callback: (bool done) {}));
    authenticationBloc.add(InitializeAuthenticationsEvent(callback: (bool done) {}));
    multimediaProgressBloc.add(InitializeMultimediaProgressEvent(callback: (bool done) {}));
    conversationGroupBloc.add(InitializeConversationGroupsEvent(callback: (bool done) {}));
    messageBloc.add(InitializeMessagesEvent(callback: (bool done) {}));
    multimediaBloc.add(InitializeMultimediaEvent(callback: (bool done) {}));
    unreadMessageBloc.add(InitializeUnreadMessagesEvent(callback: (bool done) {}));
    userContactBloc.add(InitializeUserContactsEvent(callback: (bool done) {}));
  }

  restoreUserPreviousData() {
    UserState userState = userBloc.state;
    if (userState is UserLoaded) {
      // Restore previous data
      settingsBloc.add(GetUserSettingsEvent(user: userState.user, callback: (Settings settings) {}));
      conversationGroupBloc.add(GetUserPreviousConversationGroupsEvent(
          user: userState.user,
          callback: (bool done) {
            if (done) {
              getConversationGroupsMultimedia();
            }
          }));
      unreadMessageBloc.add(GetUserPreviousUnreadMessagesEvent(user: userState.user, callback: (bool done) {}));
      multimediaBloc.add(GetUserProfilePictureMultimediaEvent(user: userState.user, callback: (bool done) {}));
      userContactBloc.add(GetUserPreviousUserContactsEvent(user: userState.user, callback: (bool done) {}));
    }
  }

  // TODO: ProcessWebSocketMessage event should be completely inside Bloc, don't put it here.
  processWebSocketMessage(Stream<dynamic> webSocketStream) {
    UserState userState = userBloc.state;
    webSocketStream.listen((data) {
      Fluttertoast.showToast(msg: 'Message confirmed received!', toastLength: Toast.LENGTH_LONG);
      WebSocketMessage receivedWebSocketMessage = WebSocketMessage.fromJson(json.decode(data));
      webSocketBloc.add(ProcessWebSocketMessageEvent(webSocketMessage: receivedWebSocketMessage, callback: (bool done) {}));
    }, onError: (onError) {
      print('chat_room.page.dart onError listener is working.');
      print('chat_room.page.dart onError: ' + onError.toString());
      if (userState is UserLoaded) {
        webSocketBloc.add(ReconnectWebSocketEvent(user: userState.user, callback: (bool done) {}));
      }
    }, onDone: () {
      // TODO: Show reconnect message
      if (userState is UserLoaded) {
        webSocketBloc.add(ReconnectWebSocketEvent(user: userState.user, callback: (bool done) {}));
      }
    }, cancelOnError: false);
  }

  getConversationGroupsMultimedia() {
    ConversationGroupState conversationGroupState = conversationGroupBloc.state;
    if (conversationGroupState is ConversationGroupsLoaded) {
      multimediaBloc.add(GetConversationGroupsMultimediaEvent(conversationGroupList: conversationGroupState.conversationGroupList, callback: (bool done) {}));
    }
  }

  goToLoginPage() {
    googleInfoBloc.add(RemoveGoogleInfoEvent(callback: (bool done) {}));
//    Get.offAndToNamed('login_page');
    Navigator.of(context).pushNamedAndRemoveUntil('login_page', (Route<dynamic> route) => false);
  }
}
