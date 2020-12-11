import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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

  FirebaseMessaging _firebaseMessaging = Get.find();
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
  PermissionBloc permissionBloc;
  NetworkBloc networkBloc;

  bool firstRun = true;
  bool loggingOut = false;
  bool webSocketDisconnected = true;


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
    permissionBloc = BlocProvider.of<PermissionBloc>(context);
    networkBloc = BlocProvider.of<NetworkBloc>(context);

    if (firstRun) {
      authenticationBloc.add(InitializeAuthenticationsEvent(callback: (bool done) {}));
      testFirebaseNotification();
    }

    return multiBlocListener();
  }

  testFirebaseNotification() {
    _firebaseMessaging.configure(
      onMessage: (dynamic message) async {
        String messageTitle = message["notification"]["title"];
        String notificationAlert = "New Notification Alert";
        print('_firebaseMessaging onMessage: ');
        print('notificationAlert: $notificationAlert');
        print('messageTitle: $messageTitle');
      },
      onResume: (dynamic message) async {
        String messageTitle = message["data"]["title"];
        String notificationAlert = "Application opened from Notification";
        print('_firebaseMessaging onResume: ');
        print('notificationAlert: $notificationAlert');
        print('messageTitle: $messageTitle');
      }
    );
  }

  Widget multiBlocListener() => MultiBlocListener(listeners: [
        userAuthenticationBlocListener(),
        conversationGroupBlocListener(),
      ], child: userAuthenticationBlocBuilder());

  Widget userAuthenticationBlocListener() {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, authenticationState) {
        if (authenticationState is AuthenticationsNotLoaded) {
          logout();
        }

        if (authenticationState is AuthenticationsLoaded) {
          loadConversationGroups();
        }
      },
    );
  }

  Widget webSocketBlocListener() {
    return BlocListener<WebSocketBloc, WebSocketState>(
      listener: (context, webSocketState) {
        if (webSocketState is WebSocketLoading) {
          if (webSocketDisconnected) {
            showWebSocketLoadingSnackbar();
          }
        }

        if (webSocketState is ReconnectingWebSocket) {
          webSocketDisconnected = true;
          if(!loggingOut) {
            showWebSocketReconnectingSnackbar();
          }
        }

        if (webSocketState is OfficialWebSocketLoaded) {
          if (!webSocketDisconnected) {
            showConnectWebSocketSuccessfulSnackbar();
          }
          webSocketDisconnected = false;

          Stream<dynamic> webSocketStream = webSocketState.webSocketStream;
          if (!webSocketStream.isNull) {
            processWebSocketMessage(webSocketStream);
          }
        }

        if (webSocketState is WebSocketNotLoaded) {
          webSocketDisconnected = true;
          if (!loggingOut) {
            showWebSocketNotLoadedSnackbar();
            checkNetworkConditions();
          }
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
          if(firstRun) {
            initialize();
            firstRun = false;
          }
          connectWebSocket();
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
    connectWebSocket();
    setState(() {
      _refreshController.refreshCompleted();
    });
  }

  initialize() {
    ipGeoLocationBloc.add(InitializeIPGeoLocationEvent(callback: (bool done) {}));
    userBloc.add(InitializeUserEvent(callback: (bool done) {}));
    ipGeoLocationBloc.add(InitializeIPGeoLocationEvent(callback: (bool done) {}));
    multimediaProgressBloc.add(InitializeMultimediaProgressEvent(callback: (bool done) {}));
    multimediaBloc.add(InitializeMultimediaEvent(callback: (bool done) {}));
    userBloc.add(GetOwnUserEvent(callback: (User user) {}));
    webSocketBloc.add(ConnectOfficialWebSocketEvent(callback: (bool done) {}));
    permissionBloc.add(LoadPermissionsEvent(callback: (bool done) {}));
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
    webSocketStream.listen((data) {
      showToast('Message confirmed received!', Toast.LENGTH_LONG);
      WebSocketMessage receivedWebSocketMessage = WebSocketMessage.fromJson(json.decode(data));
      testProcessingWebSocketMessage(receivedWebSocketMessage);
    }, onError: (onError) {
      checkNetworkConditions();
    }, onDone: () {
      checkNetworkConditions();
    }, cancelOnError: false);
  }

  checkNetworkConditions() {
    networkBloc.add(CheckNetworkEvent(callback: (bool hasInternetConnection) {
      if(!hasInternetConnection) {
        // Only shows messenger not connected, handled by NetworkBlocListener, so do nothing here.
      } else {
        logout();
      }
    }));
  }

  connectWebSocket() {
    webSocketBloc.add(ConnectOfficialWebSocketEvent(callback: (bool done) {}));
  }

  disconnectWebSocket() {
    webSocketBloc.add(DisconnectOfficialWebSocketEvent(callback: (bool done) {}));
  }

  testProcessingWebSocketMessage(WebSocketMessage webSocketMessage) {
    try {
      if (!isObjectEmpty(webSocketMessage)) {
        if (!isObjectEmpty(webSocketMessage.conversationGroup)) {
          processConversationGroup(webSocketMessage.conversationGroup);
        }

        if (!isObjectEmpty(webSocketMessage.message)) {
          processChatMessage(webSocketMessage.message);
        }

        if (!isObjectEmpty(webSocketMessage.multimedia)) {}

        if (!isObjectEmpty(webSocketMessage.unreadMessage)) {}

        if (!isObjectEmpty(webSocketMessage.settings)) {}

        if (!isObjectEmpty(webSocketMessage.user)) {}

        if (!isObjectEmpty(webSocketMessage.userContact)) {}
      } else {
        showToast('Unsupported message detected. Ignoring!', Toast.LENGTH_LONG);
      }
    } catch (e) {
      showToast('Error in processing WebSocket messages. Please try again later.', Toast.LENGTH_LONG);
      // TODO: Not acknowledging this message.
    }
  }

  processConversationGroup(ConversationGroup conversationGroup) {
    /// TODO: Add ConversationGroup object to state and DB.
  }

  processChatMessage(ChatMessage chatMessage) {
    UserState userState = userBloc.state;
    if (userState is UserLoaded) {
      if (userState.user.id != chatMessage.senderId) {
        /// TODO: Add chat message to state and DB.
        /// TODO: Retrieve Chat message's Multimedia object, save it to the localDB and state.
      } else {
        // Mark your own message as sent, received status will changed by recipient
        /// TODO: UpdateChatMessageEvent (Different than EditChatMessageEvent)
      }
    }
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
          RaisedButton(child: Text('Restart App'), onPressed: logout)
        ],
      ),
    );
  }

  showWebSocketLoadingSnackbar() {
    Get.snackbar('Loading....', 'Connecting to WebSocket...', snackPosition: SnackPosition.TOP, isDismissible: false);
  }

  showWebSocketReconnectingSnackbar() {
    Get.snackbar('Reconnecting....', 'Reconnecting to WebSocket...', snackPosition: SnackPosition.TOP, isDismissible: false);
  }

  showConnectWebSocketSuccessfulSnackbar() {
    Get.snackbar('Connection Successful.', 'WebSocket is connected.', snackPosition: SnackPosition.TOP, isDismissible: true);
  }

  showWebSocketNotLoadedSnackbar() {
    FlatButton retryButton = FlatButton(
      child: Text('Retry'),
      onPressed: () {
        connectWebSocket();
      },
    );
    Get.snackbar('Connection Failed.', 'WebSocket is not connected. Please try again later.', snackPosition: SnackPosition.TOP, isDismissible: false, mainButton: retryButton);
  }

  logout() {
    disconnectWebSocket();
    clearAllData();
    showToast('Logged out.', Toast.LENGTH_LONG);
    goToLoginPage();
  }

  clearAllData() {
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
  }

  goToLoginPage() {
    Navigator.of(context).pushNamedAndRemoveUntil('login_page', (Route<dynamic> route) => false);
  }

  goToChatRoomPage(String conversationGroupId) {
    Navigator.push(context, MaterialPageRoute(builder: ((context) => ChatRoomPage(conversationGroupId))));
  }
}
