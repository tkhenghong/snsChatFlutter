import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:snschat_flutter/environments/development/variables.dart' as globals;
import 'package:snschat_flutter/general/index.dart';
import 'package:snschat_flutter/objects/models/index.dart';
import 'package:snschat_flutter/objects/rest/index.dart';
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
  String REST_URL = globals.REST_URL;
  int page = 0;
  int size = globals.numberOfRecords;
  int totalRecords = 0;
  bool last = false;

  List<ConversationGroup> conversationGroups = [];
  List<UnreadMessage> unreadMessages = [];
  List<Multimedia> multimediaList = [];

  RefreshController _refreshController;

  CustomFileService customFileService = Get.find();

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

  bool firstRun = true;

  Color whiteColor = Colors.white;
  TextStyle buttonTextStyle = TextStyle(color: Colors.white);

  @override
  initState() {
    super.initState();
    _refreshController = new RefreshController(initialRefresh: false);
  }

  @override
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

    return multiBlocListener();
  }

  Widget multiBlocListener() => MultiBlocListener(listeners: [
        userAuthenticationBlocListener(),
        userContactBlocListener(),
        userBlocListener(),
        conversationGroupBlocListener(),
      ], child: userAuthenticationBlocBuilder());

  Widget userAuthenticationBlocListener() {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, authenticationState) {
        if (authenticationState is AuthenticationsNotLoaded) {
          goToLoginPage();
        }

        if (authenticationState is AuthenticationsLoaded) {
          loadConversationGroups();
        }
      },
    );
  }

  Widget userContactBlocListener() {
    return BlocListener<UserContactBloc, UserContactState>(
      listener: (context, userContactState) {
        if (userContactState is UserContactsLoaded) {}
      },
    );
  }

  Widget userBlocListener() {
    return BlocListener<UserBloc, UserState>(
      listener: (context, userState) {
        if (userState is UserLoaded) {
          webSocketBloc.add(InitializeWebSocketEvent(callback: (bool done) {}));
        }
      },
    );
  }

  Widget webSocketBlocListener() {
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

  Widget conversationGroupBlocListener() {
    return BlocListener<ConversationGroupBloc, ConversationGroupState>(
      listener: (context, conversationGroupState) {},
    );
  }

  Widget userAuthenticationBlocBuilder() {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, authenticationState) {
        if (authenticationState is AuthenticationsLoading) {
          showLoading('authentications');
        }

        if (authenticationState is AuthenticationsLoaded) {
          return conversationGroupBlocBuilder();
        }

        return showError('authentications');
      },
    );
  }

  Widget conversationGroupBlocBuilder() {
    return BlocBuilder<ConversationGroupBloc, ConversationGroupState>(
      builder: (context, conversationGroupState) {
        if (conversationGroupState is ConversationGroupsLoading) {
          return showLoading('conversation groups');
        }

        if (conversationGroupState is ConversationGroupsLoaded) {
          conversationGroups = conversationGroupState.conversationGroupList;
          return unreadMessageBlocBuilder();
        }

        return showError('conversation groups');
      },
    );
  }

  Widget unreadMessageBlocBuilder() {
    return BlocBuilder<UnreadMessageBloc, UnreadMessageState>(
      builder: (context, unreadMessageState) {
        if (unreadMessageState is UnreadMessageLoading) {
          return showLoading('unread messages');
        }

        if (unreadMessageState is UnreadMessagesLoaded) {
          unreadMessages = unreadMessageState.unreadMessageList;
          return multimediaBlocBuilder();
        }

        return showError('unread messages');
      },
    );
  }

  Widget multimediaBlocBuilder() {
    return BlocBuilder<MultimediaBloc, MultimediaState>(
      builder: (context, multimediaState) {
        if (multimediaState is MultimediaLoading) {
          return showLoading('multimedia');
        }

        if (multimediaState is MultimediaLoaded) {
          multimediaList = multimediaState.multimediaList;
          return mainBody();
        }

        return showError('multimedia');
      },
    );
  }

  Widget mainBody() {
    if ((isObjectEmpty(conversationGroups) || conversationGroups.isEmpty)) {
      return SmartRefresher(
        controller: _refreshController,
        onRefresh: onRefresh,
        enablePullDown: true,
        physics: BouncingScrollPhysics(),
        header: ClassicHeader(),
        child: Center(child: Text('No conversations. Tap \'+\' to create one!')),
      );
    }

    return SmartRefresher(
      controller: _refreshController,
      onLoading: onRefresh,
      enablePullUp: true,
      enablePullDown: false,
      physics: BouncingScrollPhysics(),
      header: ClassicHeader(),
      child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: conversationGroups.length,
          itemBuilder: (context, index) {
            return mapConversationToPageListTile(conversationGroups[index]);
          }),
    );
  }

  ListTile mapConversationToPageListTile(ConversationGroup conversationGroup) {
    UnreadMessage unreadMessage = unreadMessages.firstWhere((UnreadMessage existingUnreadMessage) => existingUnreadMessage.conversationId.toString() == conversationGroup.id, orElse: () => null);

    AssetImage defaultImage = AssetImage(
      DefaultImagePathTypeUtil.getByConversationGroupType(conversationGroup.conversationGroupType).path,
    );

    return ListTile(
        title: Hero(
          tag: conversationGroup.id,
          child: Text(conversationGroup.name),
        ),
        subtitle: Text(isObjectEmpty(unreadMessage) || isObjectEmpty(unreadMessage.lastMessage) ? '' : unreadMessage.lastMessage),
        leading: Hero(
          tag: conversationGroup.id + '1',
          child: CachedNetworkImage(
            imageUrl: '$REST_URL/conversationGroup/${conversationGroup.id}/groupPhoto',
            useOldImageOnUrlChange: true,
            placeholder: (context, url) => CircleAvatar(backgroundImage: defaultImage),
            errorWidget: (context, url, error) => CircleAvatar(backgroundImage: defaultImage),
            imageBuilder: (BuildContext context, ImageProvider<dynamic> imageProvider) {
              return CircleAvatar(
                backgroundImage: imageProvider,
              );
            },
          ),
        ),
        trailing: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: Get.height * 0.01),
              child: Text(isObjectEmpty(unreadMessage) ? '' : formatTime(unreadMessage.lastModifiedDate.millisecondsSinceEpoch), style: TextStyle(fontSize: 9.0)),
            ),
            Text(isObjectEmpty(unreadMessage) || unreadMessage.count.toString() == '0' ? '' : unreadMessage.count.toString())
          ],
        ),
        onTap: () => goToChatRoomPage(conversationGroup.id));
  }

  onRefresh() async {
    loadConversationGroups();
    setState(() {
      _refreshController.refreshCompleted();
    });
  }

  initialize() {
    authenticationBloc.add(InitializeAuthenticationsEvent(callback: (bool done) {}));
    ipGeoLocationBloc.add(InitializeIPGeoLocationEvent(callback: (bool done) {}));
    userBloc.add(InitializeUserEvent(callback: (bool done) {}));
    ipGeoLocationBloc.add(InitializeIPGeoLocationEvent(callback: (bool done) {}));
    multimediaProgressBloc.add(InitializeMultimediaProgressEvent(callback: (bool done) {}));
    multimediaBloc.add(InitializeMultimediaEvent(callback: (bool done) {}));
    loadConversationGroups();
  }

  /// Run conversation groups with pagination.
  loadConversationGroups() {
    unreadMessageBloc.add(LoadUnreadMessagesEvent(callback: (bool done) {}));
    GetConversationGroupsRequest getConversationGroupsRequest = GetConversationGroupsRequest(pageable: Pageable(sort: Sort(orders: [Order(direction: Direction.DESC, property: 'lastModifiedDate')]), page: page, size: size));
    conversationGroupBloc.add(GetUserOwnConversationGroupsEvent(
        getConversationGroupsRequest: getConversationGroupsRequest,
        callback: (ConversationPageableResponse conversationPageableResponse) {
          if (!isObjectEmpty(conversationPageableResponse)) {
            totalRecords = conversationPageableResponse.conversationGroupResponses.totalElements;
            checkPagination(conversationPageableResponse);

            List<UnreadMessage> unreadMessageList = conversationPageableResponse.unreadMessageResponses.content.map((e) => UnreadMessage.fromJson(e)).toList();
            unreadMessageBloc.add(UpdateUnreadMessagesEvent(unreadMessages: unreadMessageList, callback: (bool done) {}));
          }

          if (_refreshController.isRefresh) {
            if (!isObjectEmpty(conversationPageableResponse)) {
              _refreshController.refreshCompleted();
            } else {
              _refreshController.refreshFailed();
            }
          }

          if (_refreshController.isLoading) {
            // NOTE: Use onLoading when scrolling down, NOT onRefresh().
            if (!isObjectEmpty(conversationPageableResponse)) {
              _refreshController.loadComplete();
            } else {
              _refreshController.loadFailed();
            }
          }
        }));
  }

  checkPagination(ConversationPageableResponse conversationPageableResponse) {
    last = conversationPageableResponse.conversationGroupResponses.last;
    if (!last) {
      // Prepare to go to next page.
      page++;
    } else {
      showToast('End of conversation groups.', Toast.LENGTH_SHORT);
    }
  }

  /// Need this method to listen WebSocket messages
  /// As long as this page is not removed during logged in state, it will receive and process the messages correctly
  /// If user perform sudden logout or system logout, it will be disconnected immediately even if there's a message processing here. It's excepted.
  processWebSocketMessage(Stream<dynamic> webSocketStream) {
    UserState userState = userBloc.state;
    webSocketStream.listen((data) {
      showToast('Message confirmed received!', Toast.LENGTH_LONG);
      WebSocketMessage receivedWebSocketMessage = WebSocketMessage.fromJson(json.decode(data));
      webSocketBloc.add(ProcessWebSocketMessageEvent(webSocketMessage: receivedWebSocketMessage, context: context, callback: (bool done) {}));
    }, onError: (onError) {
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

  Widget showLoading(String module) {
    return Center(
      child: Text('Loading $module...'),
    );
  }

  Widget showError(String module) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'An error has occurred in $module. Please try again later.',
            textAlign: TextAlign.center,
          ),
          RaisedButton(child: Text('Restart App'), onPressed: goToLoginPage)
        ],
      ),
    );
  }

  goToLoginPage() {
    ipGeoLocationBloc.add(InitializeIPGeoLocationEvent(callback: (bool done) {}));
    googleInfoBloc.add(RemoveGoogleInfoEvent(callback: (bool done) {}));
    conversationGroupBloc.add(RemoveConversationGroupsEvent(callback: (bool done) {}));
    chatMessageBloc.add(RemoveAllChatMessagesEvent(callback: (bool done) {}));
    multimediaBloc.add(RemoveAllMultimediaEvent(callback: (bool done) {}));
    multimediaProgressBloc.add(RemoveAllMultimediaProgressEvent(callback: (bool done) {}));
    settingsBloc.add(RemoveAllSettingsEvent(callback: (bool done) {}));
    unreadMessageBloc.add(RemoveAllUnreadMessagesEvent(callback: (bool done) {}));
    userBloc.add(RemoveAllUsersEvent(callback: (bool done) {}));
    userContactBloc.add(RemoveAllUserContactsEvent(callback: (bool done) {}));
    authenticationBloc.add(RemoveAllAuthenticationsEvent(callback: (bool done) {}));

    Navigator.of(context).pushNamedAndRemoveUntil('login_page', (Route<dynamic> route) => false);
  }

  goToChatRoomPage(String conversationGroupId) {
    Navigator.push(context, MaterialPageRoute(builder: ((context) => ChatRoomPage(conversationGroupId))));
  }
}
