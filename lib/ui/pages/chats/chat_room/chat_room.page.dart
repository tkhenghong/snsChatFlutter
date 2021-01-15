import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:snschat_flutter/environments/development/variables.dart' as globals;
import 'package:snschat_flutter/general/functions/index.dart';
import 'package:snschat_flutter/general/index.dart';
import 'package:snschat_flutter/objects/models/index.dart';
import 'package:snschat_flutter/objects/rest/index.dart';
import 'package:snschat_flutter/service/index.dart';
import 'package:snschat_flutter/state/bloc/index.dart';
import 'package:snschat_flutter/ui/pages/index.dart';

class ChatRoomPage extends StatefulWidget {
  final String conversationGroupId;

  ChatRoomPage([this.conversationGroupId]);

  @override
  State<StatefulWidget> createState() {
    return new ChatRoomPageState();
  }
}

class ChatRoomPageState extends State<ChatRoomPage> with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  String REST_URL = globals.REST_URL;

  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  // Option button list
  List<String> optionButtonTitle = [
    'Group Info',
    'Group Media',
    'Search',
    'Mute Notifications',
    'Conversation background wallpaper',
    'Report this conversation',
    'Block conversation',
    'Clear all messages',
    'Export chat messages',
    'Add shortcut to home screen'
  ];
  List<IconData> optionButtonIcon = [
    Icons.info_outline,
    Icons.perm_media_outlined,
    Icons.search,
    Icons.notifications_off_outlined,
    Icons.now_wallpaper_outlined,
    Icons.report_outlined,
    Icons.block_outlined,
    Icons.clear_all_outlined,
    Icons.import_export_outlined,
    Platform.isIOS || Platform.isMacOS ? Icons.desktop_mac_outlined : Icons.desktop_windows_outlined
  ];
  List<Function> optionButtonOnTapped = [() {}, () {}, () {}, () {}, () {}, () {}, () {}, () {}, () {}, () {}];

  // Pagination
  int page = 0;
  int size = globals.numberOfRecords;
  int totalRecords = 0;
  bool last = false;

  ConversationGroupBloc conversationGroupBloc;
  ChatMessageBloc chatMessageBloc;
  MultimediaBloc multimediaBloc;
  UserContactBloc userContactBloc;
  UserBloc userBloc;
  WebSocketBloc webSocketBloc;

  bool firstTime = true;
  bool isWebSocketConnected = false;
  User ownUser;
  ConversationGroup currentConversationGroup;
  Multimedia groupPhotoMultimedia;
  List<ChatMessage> conversationGroupMessageList = [];
  List<Map<String, bool>> conversationGroupMessageExpanded = []; // A list to record which chat message to be expanded.
  List<Multimedia> conversationGroupMultimediaList = [];

  ImagePicker imagePicker = Get.find();
  CustomFileService customFileService = Get.find();
  AudioService audioService = Get.find();

  bool isShowSticker = false;
  bool isLoading = false;
  bool isRecording = false;
  bool imageFound = false;
  bool openMultimediaTab = false;
  bool textFieldHasValue = false;

  String inputFieldText = 'Type your message...';
  DateTime recordStartTime;
  Timer recordingTimer;
  double recordingTimeText;

  // This is used to get batch send multiple multimedia in one go, like multiple image and video
  List<File> imageFileList = [];
  List<File> imageThumbnailFileList = [];
  List<File> documentFileList = [];

  Map<String, File> loadedMultimediaFiles = new Map();

  String webSocketUrl = globals.WEBSOCKET_URL;
  int minimumRecordingLength = globals.minimumRecordingLength;

  int imagePickerQuality = globals.imagePickerQuality;

  TextEditingController textEditingController;
  ScrollController listScrollController;
  ScrollController imageViewScrollController;
  ScrollController fileViewScrollController;
  FocusNode focusNode = new FocusNode();
  AnimationController _animationController, _animationController2;
  Animation animation;
  RefreshController _refreshController;
  ScrollController _scrollController;

  double tabHeight = Get.height * 0.3;

  @override
  void initState() {
    super.initState();
    textEditingController = new TextEditingController();
    listScrollController = new ScrollController();
    imageViewScrollController = new ScrollController();
    fileViewScrollController = new ScrollController();
    _refreshController = new RefreshController();
    _scrollController = new ScrollController();

    focusNode.addListener(onFocusChange);

    _animationController = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _animationController2 = new AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    animation = Tween(begin: 0.0, end: 1.0).animate(_animationController2);
    _animationController2.forward();
  }

  @override
  void dispose() {
    super.dispose();
    textEditingController.dispose();
    listScrollController.dispose();
    imageViewScrollController.dispose();
    fileViewScrollController.dispose();
    _refreshController.dispose();
    _scrollController.dispose();

    _animationController.dispose();
    _animationController2.dispose();
  }

  @override
  Widget build(BuildContext context) {
    webSocketBloc = BlocProvider.of<WebSocketBloc>(context);
    conversationGroupBloc = BlocProvider.of<ConversationGroupBloc>(context);
    chatMessageBloc = BlocProvider.of<ChatMessageBloc>(context);
    multimediaBloc = BlocProvider.of<MultimediaBloc>(context);
    userContactBloc = BlocProvider.of<UserContactBloc>(context);
    userBloc = BlocProvider.of<UserBloc>(context);

    if (firstTime) {
      initialize();
      firstTime = false;
    }

    return SafeArea(child: Material(color: Colors.white, child: multiBlocListener()));
  }

  initialize() {
    userBloc.add(GetOwnUserEvent(callback: (User user) {}));

    loadConversationGroupInfo();
    loadChatMessages();
  }

  /// To update userContacts and conversation group's latest info.
  loadConversationGroupInfo() {
    conversationGroupBloc.add(GetSingleConversationGroupEvent(
        conversationGroupId: widget.conversationGroupId,
        callback: (ConversationGroup conversationGroup) {
          userContactBloc.add(GetConversationGroupUserContactsEvent(conversationGroupId: widget.conversationGroupId, userContactIds: conversationGroup.memberIds, callback: (bool done) {}));
        }));
  }

  loadChatMessages() {
    Pageable pageable = Pageable(sort: Sort(orders: [Order(direction: Direction.DESC, property: 'lastModifiedDate')]), page: page, size: size);
    chatMessageBloc.add(LoadConversationGroupChatMessagesEvent(
        conversationGroupId: widget.conversationGroupId,
        pageable: pageable,
        callback: (PageInfo chatMessagePageableResponse) {
          if (!isObjectEmpty(chatMessagePageableResponse)) {
            checkPagination(chatMessagePageableResponse);

            List<ChatMessage> chatMessageListFromServer = chatMessagePageableResponse.content.map((chatMessageRaw) => ChatMessage.fromJson(chatMessageRaw)).toList();
            multimediaBloc.add(GetMessagesMultimediaEvent(chatMessageList: chatMessageListFromServer, callback: (bool done) {})); // multimediaIds
            endRefreshController(true);
          } else {
            showToast('Something\'s wrong when loading the messages. Please try again later. ', Toast.LENGTH_LONG, toastGravity: ToastGravity.CENTER);
            endRefreshController(false);
          }
        }));
  }

  endRefreshController(bool success) {
    if (_refreshController.isRefresh) {
      if (success) {
        _refreshController.refreshCompleted();
      } else {
        _refreshController.refreshFailed();
      }
    }

    if (_refreshController.isLoading) {
      // NOTE: Use onLoading when scrolling down, NOT onRefresh().
      if (success) {
        _refreshController.loadComplete();
      } else {
        _refreshController.loadFailed();
      }
    }
  }

  checkPagination(PageInfo chatMessagePageableResponse) {
    last = chatMessagePageableResponse.last;
    if (!last) {
      // Prepare to go to next page.
      page++;
    } else {
      showToast('End of chat messages.', Toast.LENGTH_SHORT);
    }
  }

  Widget multiBlocListener() => MultiBlocListener(listeners: [
        webSocketBlocListener(),
      ], child: userBlocBuilder());

  Widget webSocketBlocListener() {
    return BlocListener<WebSocketBloc, WebSocketState>(
      listener: (context, webSocketState) {
        if (webSocketState is WebSocketNotLoaded) {
          showToast('Connection broken. Reconnecting WebSocket...', Toast.LENGTH_SHORT);
          webSocketBloc.add(ConnectOfficialWebSocketEvent(callback: (bool done) {}));
        }
      },
    );
  }

  Widget userBlocBuilder() {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, userState) {
        if (userState is UserLoading) {
          return showLoading();
        }

        if (userState is UserNotLoaded) {
          goToLoginPage();
          return Center(
            child: Text('Unable to load user.'),
          );
        }

        if (userState is UserLoaded) {
          ownUser = userState.user;
          return conversationGroupBlocBuilder();
        }

        return showError('user');
      },
    );
  }

  Widget conversationGroupBlocBuilder() {
    return BlocBuilder<ConversationGroupBloc, ConversationGroupState>(
      builder: (context, conversationGroupState) {
        if (conversationGroupState is ConversationGroupsLoaded) {
          currentConversationGroup = conversationGroupState.conversationGroupList.firstWhere((ConversationGroup conversationGroup) => conversationGroup.id == widget.conversationGroupId, orElse: () => null);

          return chatMessageBlocBuilder();
        }

        return showError('conversation group');
      },
    );
  }

  Widget chatMessageBlocBuilder() {
    return BlocBuilder<ChatMessageBloc, ChatMessageState>(
      builder: (context, chatMessageState) {
        print('chat_room.page.dart chatMessageState: $chatMessageState');
        if (chatMessageState is ChatMessageLoading) {
          return showLoading();
        }

        if (chatMessageState is ChatMessagesLoaded) {
          // Get current conversation messages and sort them.
          conversationGroupMessageList = chatMessageState.chatMessageList.where((ChatMessage message) => message.conversationId == widget.conversationGroupId).toList();

          conversationGroupMessageList.sort((message1, message2) => message2.createdDate.compareTo(message1.createdDate));

          return multimediaBlocBuilder();
        }

        return showError('chat messages');
      },
    );
  }

  Widget multimediaBlocBuilder() {
    return BlocBuilder<MultimediaBloc, MultimediaState>(
      builder: (context, multimediaState) {
        if (multimediaState is MultimediaLoaded) {
          groupPhotoMultimedia = multimediaState.multimediaList.firstWhere((Multimedia existingMultimedia) => existingMultimedia.id == currentConversationGroup.groupPhoto, orElse: () => null);
        }

        return webSocketBlocBuilder();
      },
    );
  }

  Widget webSocketBlocBuilder() {
    return BlocBuilder<WebSocketBloc, WebSocketState>(
      builder: (context, webSocketState) {
        if (webSocketState is WebSocketNotLoaded) {
          webSocketBloc.add(ConnectOfficialWebSocketEvent(callback: (bool done) {}));
          isWebSocketConnected = false;
        }

        if (webSocketState is OfficialWebSocketLoaded) {
          isWebSocketConnected = true;
        }

        return mainBody();
      },
    );
  }

  Widget mainBody() {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        key: _drawerKey,
        endDrawerEnableOpenDragGesture: false,
        // Prevent open drawer using screen gesture.
        appBar: appBar(),
        endDrawer: drawer(),
        body: WillPopScope(
          // To handle event when user press back button when sticker screen is on, dismiss sticker if keyboard is shown
          child: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  // UI for message list
                  chatMessageList(),
                  // UI for stickers, GIFs
                  (isShowSticker ? buildSticker() : Container()),
                  // UI for text field
                  buildInput(),
                ],
              ),
            ],
          ),
          onWillPop: onBackPress,
        ),
      ),
    );
  }

  Widget appBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      leadingWidth: Get.width * 0.18,
      leading: backButtonWithImage(),
      title: conversationGroupTitle(),
      actions: [videoCallButton(), voiceCallButton(), optionsButton()],
    );
  }

// TODO: Load widget with a list to reduce boilerplate codes.
  Widget drawer() {
    return Drawer(
      child: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
              expandedHeight: Get.height * 0.3,
              backgroundColor: Colors.transparent,
              flexibleSpace: Container(
                decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.black, Colors.black87, Colors.black54, Colors.black45, Colors.black38, Colors.black26, Colors.black12])),
                child: FlexibleSpaceBar(
                  // NOTE: May add photo of you and the him for personal conversation, and group photo for group conversation in the future.
                  // background: Container(
                  //   height: Get.height * 0.3,
                  //   width: Get.width * 0.3,
                  //   child: ,
                  // ),
                  title: Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: EdgeInsets.only(right: Get.width * 0.05),
                      child: Text('Options'),
                    ),
                  ),
                ),
              )),
          SliverList(
            delegate: SliverChildListDelegate(generateOptionButtons()),
          ),
        ],
      ),
    );
  }

  List<Widget> generateOptionButtons() {
    List<Widget> optionButtonList = [];
    for (int i = 0; i < optionButtonTitle.length; i++) {
      optionButtonList.add(ListTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: Get.width * 0.1,
              child: Icon(optionButtonIcon[i]),
            ),
            Text(optionButtonTitle[i])
          ],
        ),
        onTap: optionButtonOnTapped[i],
      ));
    }
    return optionButtonList;
  }

  Widget conversationGroupTitle() {
    return InkWell(
        customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        onTap: goToChatInfoPage,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Hero(
              tag: currentConversationGroup.id,
              child: Text(
                currentConversationGroup.name,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Text(
              'Tap here for more details',
              style: TextStyle(fontSize: 13.0, color: Get.theme.primaryTextTheme.button.color),
            )
          ],
        ));
  }

  Widget videoCallButton() {
    return IconButton(
        icon: Icon(Icons.voice_chat),
        onPressed: () {
          showToast('Video call is not yet implemented.', Toast.LENGTH_SHORT);
        });
  }

  Widget voiceCallButton() {
    return IconButton(
        icon: Icon(Icons.phone),
        onPressed: () {
          showToast('Voice call is not yet implemented.', Toast.LENGTH_SHORT);
        });
  }

  Widget optionsButton() {
    return IconButton(
        icon: Icon(Icons.menu),
        onPressed: () {
          print('_drawerKey.currentState.isEndDrawerOpen: ${_drawerKey.currentState.isEndDrawerOpen}');
          if (_drawerKey.currentState.isEndDrawerOpen) {
            Navigator.pop(context);
          } else {
            _drawerKey.currentState.openEndDrawer();
          }
        });
  }

  Widget backButtonWithImage() {
    Widget defaultImage = CircleAvatar(backgroundImage: AssetImage(DefaultImagePathTypeUtil.getByConversationGroupType(currentConversationGroup.conversationGroupType).path));

    return Tooltip(
      message: 'Back',
      child: InkWell(
        customBorder: CircleBorder(),
        radius: Get.width * 0.2,
        onTap: goBack,
        child: Row(
          children: <Widget>[
            Icon(Icons.arrow_back),
            Hero(
              tag: currentConversationGroup.id + '1',
              child: CachedNetworkImage(
                imageUrl: '$REST_URL/conversationGroup/${currentConversationGroup.id}/groupPhoto',
                useOldImageOnUrlChange: true,
                placeholder: (context, url) => defaultImage,
                errorWidget: (context, url, error) => defaultImage,
                imageBuilder: (BuildContext context, ImageProvider<dynamic> imageProvider) {
                  return CircleAvatar(
                    backgroundImage: imageProvider,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildInput() {
    return Container(
      width: double.infinity,
      child: Column(
        children: <Widget>[
          imageListTab(),
          fileListTab(),
          uploadTab(),
          Row(
            children: <Widget>[sendImageButton(), stickersButton(), textInput(), sendMessageButton()],
          )
        ],
      ),
      decoration: BoxDecoration(
        border: Border(
            top: BorderSide(
                // color: Colors.grey,
                width: 0.5)),
        // color: Colors.white
      ),
    );
  }

  Widget sendImageButton() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: Get.width * 0.01),
      child: IconButton(
        icon: Icon(Icons.attach_file),
        onPressed: () {
          setState(() {
            openMultimediaTab = !openMultimediaTab;
            if (openMultimediaTab) {
              _animationController2.forward();
            } else {
              _animationController2.reverse();
            }
          });
        },
      ),
    );
  }

  Widget stickersButton() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: Get.width * 0.01),
      child: IconButton(
        icon: Icon(Icons.face),
        onPressed: getSticker,
      ),
      // color: Colors.white,
    );
  }

  Widget textInput() {
    return Flexible(
      child: Container(
        child: TextField(
          enabled: !isRecording,
          style: TextStyle(fontSize: 17.0),
          controller: textEditingController,
          decoration: InputDecoration.collapsed(
            hintText: inputFieldText,
            // hintStyle: TextStyle(color: Colors.grey),
          ),
          focusNode: focusNode,
          onChanged: validateInput,
        ),
      ),
    );
  }

  Widget sendMessageButton() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
      child: !textFieldHasValue ? recordVoiceMessageButton() : textSendButton(),
    );
  }

  Widget recordVoiceMessageButton() {
    return GestureDetector(
      child: IconButton(
        icon: !isRecording ? Icon(Icons.keyboard_voice) : Icon(Icons.clear),
//        onPressed: () => sendChatMessage(context, '', 3, user, conversationGroup),
        onPressed: () => recordOrStopAudio(),
      ),
    );
  }

  Widget textSendButton() {
    return IconButton(
      icon: Icon(Icons.send),
      onPressed: () {
        print('chat_room.page.dart textSendButton() onPressed: ${textEditingController.text}');
        sendChatMessage(textEditingController.text, null);
      },
    );
  }

  validateInput(String text) {
    if (text.isNotEmpty) {
      if (!textFieldHasValue) {
        setState(() {
          textFieldHasValue = true;
        });
      }
    } else {
      if (textFieldHasValue) {
        setState(() {
          textFieldHasValue = false;
        });
      }
    }
  }

  Widget imageListTab() {
    // Use Visibility to control to show widget easily. https://stackoverflow.com/questions/44489804/show-hide-widgets-in-flutter-programmatically
    return Visibility(
      visible: imageFileList.isNotEmpty,
      child: Row(
        children: <Widget>[
          Container(
            height: tabHeight,
            width: Get.width,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              controller: imageViewScrollController,
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              reverse: true,
              itemCount: imageFileList.length,
              itemBuilder: (BuildContext buildContext2, int index) {
                File currentFile = imageFileList[index];
                return Stack(
                  alignment: AlignmentDirectional.topEnd,
                  children: <Widget>[
                    Card(
                      elevation: 2.0,
                      child: Image.file(currentFile),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        padding: EdgeInsets.only(
                          right: Get.width * 0.01,
                          top: Get.height * 0.01,
                        ),
                        child: InkWell(
                          onTap: () => removeImageFile(currentFile),
                          child: Material(
                            // color: Colors.black,
                            child: Icon(
                              Icons.clear,
                              // color: Colors.white,
                            ),
                            elevation: 2.0,
                            type: MaterialType.circle,
                          ),
                          radius: 15.0,
                        ),
                      ),
                    )
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget fileListTab() {
    return // Use Visibility to control to show widget easily. https://stackoverflow.com/questions/44489804/show-hide-widgets-in-flutter-programmatically
        Visibility(
      visible: documentFileList.isNotEmpty,
      child: Row(
        children: <Widget>[
          Container(
            height: tabHeight,
            width: Get.width,
            child: ListView.builder(
              controller: fileViewScrollController,
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              reverse: true,
              itemCount: documentFileList.length,
              itemBuilder: (BuildContext buildContext2, int index) {
                File currentFile = documentFileList[index];
                String fileName = customFileService.getFileName(currentFile);
                return Stack(
                  alignment: AlignmentDirectional.topEnd,
                  children: <Widget>[
                    Card(
                      elevation: 2.0,
                      child: Text(fileName),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        padding: EdgeInsets.only(
                          right: Get.width * 0.01,
                          top: Get.height * 0.01,
                        ),
                        child: InkWell(
                          onTap: () => removeFile(currentFile),
                          child: Material(
                            // color: Colors.black,
                            child: Icon(
                              Icons.clear,
                              // color: Colors.white,
                            ),
                            elevation: 2.0,
                            type: MaterialType.circle,
                          ),
                          radius: 15.0,
                        ),
                      ),
                    )
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget uploadTab() {
    return Material(
      child: Visibility(
          visible: openMultimediaTab,
          child: FadeTransition(
            opacity: animation,
            child: Row(
              children: <Widget>[
                Container(
                    height: tabHeight,
                    width: Get.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            multimediaButton('Image', Icons.image, () => getImage()),
                            multimediaButton('Camera', Icons.camera_alt, () => openCamera()),
                            multimediaButton('File', Icons.insert_drive_file, () => getFiles()),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            multimediaButton('Audio', Icons.audiotrack, () => {}),
                            multimediaButton('Location', Icons.location_on, () => {}),
                            multimediaButton('Contact', Icons.contacts, () => {}),
                          ],
                        ),
                      ],
                    )),
              ],
            ),
          )),
    );
  }

  Widget multimediaButton(String name, IconData iconData, Function function) {
    return Material(
      child: InkWell(
          customBorder: CircleBorder(),
          onTap: function,
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                Text(name),
                Icon(iconData),
              ],
            ),
          )),
    );
  }

  removeImageFile(File file) {
    setState(() {
      imageFileList.remove(file);
    });
  }

  removeFile(File file) {
    setState(() {
      documentFileList.remove(file);
    });
  }

  Widget chatMessageList() {
    if (isObjectEmpty(conversationGroupMessageList) || conversationGroupMessageList.isEmpty) {}

    return Flexible(
      child: Padding(
        padding: EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0), // Hard code 10px for the bottom of the list.
        child: ListView.builder(
          controller: listScrollController,
          itemCount: conversationGroupMessageList.length,
          reverse: true,
          physics: BouncingScrollPhysics(),
          itemBuilder: (context, index) => displayChatMessage(conversationGroupMessageList[index]),
        ),
      ),
    );
  }

  Widget displayChatMessage(ChatMessage chatMessage) {
    bool isSenderMessage = chatMessage.senderId == ownUser.id;

    if (isObjectEmpty(chatMessage.multimediaId)) {
      return showTextMessage(chatMessage, isSenderMessage);
    } else {
      Multimedia messageMultimedia = conversationGroupMultimediaList.firstWhere((multimedia) => multimedia.id == chatMessage.multimediaId, orElse: null);
      switch (messageMultimedia.multimediaType) {
        case MultimediaType.Image:
          return imageMessage(chatMessage, messageMultimedia, isSenderMessage);
          break;
        case MultimediaType.Document:
          return fileMessage(chatMessage, messageMultimedia, isSenderMessage);
          break;
        case MultimediaType.Document:
          return fileMessage(chatMessage, messageMultimedia, isSenderMessage);
          break;
        case MultimediaType.Audio:
          return showAudioMessage(chatMessage, messageMultimedia, isSenderMessage);
          break;
        default:
          return showUnidentifiedMessageText(chatMessage, isSenderMessage);
          break;
      }
    }
  }

  Widget showTextMessage(ChatMessage chatMessage, bool isSenderMessage) {
    Widget textMessageContent = Container(
      width: Get.width * 0.5,
      child: Text(
        // message.senderName + message.messageContent + messageTimeDisplay(message.timestamp),
        chatMessage.messageContent,
        softWrap: true,
        overflow: TextOverflow.visible,
        textAlign: isSenderMessage ? TextAlign.end : TextAlign.start,
        style: TextStyle(),
      ),
    );

    return chatMessageBubble(chatMessage, isSenderMessage, textMessageContent);
  }

  Widget imageMessage(ChatMessage chatMessage, Multimedia chatMessageMultimedia, bool isSenderMessage) {
    Widget defaultImage = Image.asset(
      DefaultImagePathType.ConversationGroupMessage.path,
    );
    return Row(
      crossAxisAlignment: isSenderMessage ? CrossAxisAlignment.start : CrossAxisAlignment.end,
      mainAxisAlignment: isSenderMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(bottom: 20.0, right: isSenderMessage ? Get.width * 0.01 : 0.0, left: isSenderMessage ? Get.width * 0.01 : 0.0),
          child: Row(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Hero(
                    tag: chatMessage.multimediaId,
                    child: InkWell(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16.0),
                        child: CachedNetworkImage(
                          imageUrl: '$REST_URL/chatMessage/${chatMessage.id}/multimedia',
                          useOldImageOnUrlChange: true,
                          placeholder: (context, url) => defaultImage,
                          errorWidget: (context, url, error) => defaultImage,
                          imageBuilder: (BuildContext context, ImageProvider<dynamic> imageProvider) {
                            return Image(
                              image: imageProvider,
                            );
                          },
                        ),
                      ),
                      onTap: () {
                        openImageMessage(chatMessage, chatMessageMultimedia);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget chatMessageBubble(ChatMessage chatMessage, bool isSenderMessage, Widget content) {
    Radius bubbleCornerRadius = Radius.circular(20.0);

    return Padding(
      padding: EdgeInsets.only(top: 10.0), // Hardcode 10px for top spacing of each message.
      child: Column(
        crossAxisAlignment: isSenderMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            chatMessage.senderName + ', ' + messageTimeDisplay(chatMessage.createdDate),
            style: TextStyle(
              fontSize: 10.0,
            ),
          ),
          RaisedButton(
            child: content,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: bubbleCornerRadius,
                topRight: bubbleCornerRadius,
                bottomLeft: isSenderMessage ? bubbleCornerRadius : Radius.zero,
                bottomRight: isSenderMessage ? Radius.zero : bubbleCornerRadius,
              ),
            ),
            padding: EdgeInsets.symmetric(horizontal: Get.width * 0.02, vertical: Get.height * 0.02),
            onPressed: () {
              showToast('Chat message bubble clicked!', Toast.LENGTH_SHORT);
            },
          )
        ],
      ),
    );
  }

  Widget fileMessage(ChatMessage chatMessage, Multimedia chatMessageMultimedia, bool isSenderMessage) {
    Multimedia messageMultimedia = conversationGroupMultimediaList.firstWhere((Multimedia multimedia) => multimedia.id == chatMessage.multimediaId, orElse: () => null);

    /// TODO: Check the file exist or not. If not download the file from Internet, if got load the file.
    // fileService.downloadMultimediaFile(context, messageMultimedia);

    Widget documentMessage = RichText(text: TextSpan(children: [TextSpan(text: chatMessage.messageContent, style: TextStyle(), recognizer: TapGestureRecognizer()..onTap = () => downloadFile(messageMultimedia, chatMessage))]));
    return chatMessageBubble(chatMessage, isSenderMessage, documentMessage);
  }

  Widget showAudioMessage(ChatMessage chatMessage, Multimedia chatMessageMultimedia, bool isSenderMessage) {
    Multimedia messageMultimedia, userContactMultimedia;
    messageMultimedia = conversationGroupMultimediaList.firstWhere((Multimedia multimedia) => multimedia.id == chatMessage.multimediaId, orElse: () => null);

    userContactMultimedia = conversationGroupMultimediaList.firstWhere((Multimedia multimedia) => multimedia.id == chatMessage.multimediaId, orElse: () => null);

    /// TODO: Check audio file, show download button if not downloaded, load the audio in ready state.
    downloadFile(messageMultimedia, chatMessage);

    Widget content = messageAudioPlayer(chatMessage, userContactMultimedia, messageMultimedia, audioService);
    return chatMessageBubble(chatMessage, isSenderMessage, content);
  }

  Widget showUnidentifiedMessageText(ChatMessage chatMessage, bool isSenderMessage) {
    // double lrPadding = 15.0;
    double lrPadding = Get.width * 0.1;
    // double tbPadding = 10.0;
    double tbPadding = Get.height * 0.05;

    return Container(
      padding: EdgeInsets.fromLTRB(lrPadding, tbPadding, lrPadding, tbPadding),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(32.0)),
      margin: EdgeInsets.only(bottom: 20.0, right: isSenderMessage ? Get.width * 0.01 : 0.0, left: isSenderMessage ? Get.width * 0.01 : 0.0),
      child: Row(
        children: <Widget>[
          Column(
            children: <Widget>[
              Text(
                'Unidentified message.',
                style: TextStyle(),
              )
            ],
          ),
        ],
      ),
    );
  }

  // TODO: Build day tabs with DateFormat and time_formatter plugin.
  String messageTimeDisplay(DateTime timestamp) {
    return DateFormat('hh:mm').format(timestamp.toLocal());
  }

  Widget showError(String module) {
    return Material(
      // color: Colors.white,
      child: Flexible(
        child: Center(
          child: Column(
            children: <Widget>[
              Text(
                'Error in $module, please try again later.',
                textAlign: TextAlign.center,
              ),
              RaisedButton(child: Text('Go back'), onPressed: goBack)
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSticker() {
    return Container(
      child: Column(
        children: gifRows(),
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      ),
      padding: EdgeInsets.all(5.0),
      height: Get.height * 0.4,
    );
  }

  /// Sample for generate 3 x 3 rows of GIFs widgets.
  List<Widget> gifRows() {
    List<String> gifCode = ['mimi1', 'mimi2', 'mimi3', 'mimi4', 'mimi5', 'mimi6', 'mimi7', 'mimi8', 'mimi9'];
    List<String> gifUrl = [
      'lib/ui/images/mimi1.gif',
      'lib/ui/images/mimi2.gif',
      'lib/ui/images/mimi3.gif',
      'lib/ui/images/mimi4.gif',
      'lib/ui/images/mimi5.gif',
      'lib/ui/images/mimi6.gif',
      'lib/ui/images/mimi7.gif',
      'lib/ui/images/mimi8.gif',
      'lib/ui/images/mimi9.gif'
    ];
    List<Widget> gifRows = [];
    for (int i = 0; i < gifCode.length; i += 3) {
      gifRows.add(
        Row(
          children: <Widget>[
            i < gifCode.length
                ? FlatButton(
                    onPressed: () => sendChatMessage(gifCode[i], MultimediaType.GIF),
                    child: Image(
                      image: AssetImage(gifUrl[i]),
                      width: Get.width * 0.2,
                      height: Get.height * 0.15,
                      fit: BoxFit.cover,
                    ))
                : Container(),
            i + 1 < gifCode.length
                ? FlatButton(
                    onPressed: () => sendChatMessage(gifCode[i + 1], MultimediaType.GIF),
                    child: Image(
                      image: AssetImage(gifUrl[i + 1]),
                      width: Get.width * 0.2,
                      height: Get.height * 0.15,
                      fit: BoxFit.cover,
                    ))
                : Container(),
            FlatButton(
                onPressed: () => sendChatMessage(gifCode[i + 2], MultimediaType.GIF),
                child: Image(
                  image: AssetImage(gifUrl[i + 2]),
                  width: Get.width * 0.2,
                  height: Get.height * 0.15,
                  fit: BoxFit.cover,
                ))
          ],
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        ),
      );
    }

    return gifRows;
  }

  recordVoiceMessage(BuildContext context, User user, ConversationGroup conversationGroup) async {
    print('chat_room.page.dart recordVoiceMessage()');
  }

  saveVoiceMessage(BuildContext context, User user, ConversationGroup conversationGroup, LongPressEndDetails longPressEndDetails) async {
    print('chat_room.page.dart saveVoiceMessage()');
  }

  cancelVoiceMessage(BuildContext context, User user, ConversationGroup conversationGroup) async {
    print('chat_room.page.dart cancelVoiceMessage()');
  }

  recordOrStopAudio() async {
    // if (!isRecording) {
    //   recordStartTime = DateTime.now();
    //   startRecordingTimer();
    //   Vibration.vibrate(duration: 100);
    //   bool startRecordSuccessful = await this.audioService.startRecorder();
    //   if (startRecordSuccessful) {
    //     setState(() {
    //       isRecording = true;
    //       inputFieldText = 'Recording...';
    //     });
    //   }
    // } else {
    //   Vibration.vibrate(duration: 100);
    //   bool stopRecordSuccessful = await this.audioService.stopRecorder();
    //   recordingTimer.cancel();
    //   setState(() {
    //     isRecording = false;
    //     inputFieldText = 'Type your message...';
    //   });
    //   if (stopRecordSuccessful) {
    //     String audioFilePath = this.audioService.audioFilePath;
    //     bool recordingIsTooShort = await recordngIsTooShort();
    //     if (!recordingIsTooShort) {
    //       String secondsRecorded = recordingTimer.tick.toString();
    //       sendChatMessage(context, 'Audio (${secondsRecorded} second(s))', 3, user, conversationGroup);
    //       this.audioService.startAudio(this.audioService.audioFilePath);
    //     } else {
    //       // Delete the audio message
    //       this.fileService.deleteFile(audioFilePath);
    //       Fluttertoast.showToast(msg: 'Voice message is too short.', toastLength: Toast.LENGTH_SHORT);
    //     }
    //
    //     this.audioService.durationsInMiliseconds = 0;
    //   }
    // }
  }

  startRecordingTimer() {
    recordingTimeText = 0.0;
    const duration = const Duration(seconds: 1);
    recordingTimer = new Timer.periodic(duration, (Timer timer) {
      recordingTimeText += 1.0;
    });
  }

  Future<bool> recordingIsTooShort() async {
    // int recordDuration = this.audioService.durationsInMilliseconds;
    print('chat_room.page_info.dart minimumRecordingLength: ' + minimumRecordingLength.toString());
    // print('chat_room.page_info.dart recordDuration: ' + recordDuration.toString());
    // return recordDuration < minimumRecordingLength;
    return false;
  }

  sendChatMessage(String content, [MultimediaType multimediaType]) {
    print('chat_room.page.dart sendChatMessage() content: $content');
    if (isObjectEmpty(multimediaType) && content.trim() != '') {
      textEditingController.clear();
      setState(() {
        textFieldHasValue = false;
      });

      chatMessageBloc.add(AddChatMessageEvent(
          createChatMessageRequest: CreateChatMessageRequest(conversationId: currentConversationGroup.id, messageContent: content),
          callback: (ChatMessage message) {
            print('chat_room.page.dart AddChatMessageEvent callback: $message');
            if (isObjectEmpty(message)) {
              showToast('ChatMessage not sent. Please try again.', Toast.LENGTH_SHORT);
            } else {
              // WebSocketMessage webSocketMessage = WebSocketMessage(chatMessage: message);
              // TODO: Acknowledge the message.
              // webSocketBloc.add(SendWebSocketMessageEvent(webSocketMessage: webSocketMessage, callback: (bool done) {}));
            }
          }));
    }

    // TODO: Multimedia files.
  }

  Future getImage() async {
    PickedFile pickedFile = await imagePicker.getImage(source: ImageSource.gallery, imageQuality: imagePickerQuality);

    if (!isObjectEmpty(pickedFile) && !isObjectEmpty(pickedFile.path)) {
      File imageFile = File(pickedFile.path);
      if (!(await imageFile.exists())) {
        showToast('Unable to add the selected image. File is missing.', Toast.LENGTH_LONG);
      } else {
        setState(() {
          imageFileList.add(imageFile);
        });
      }

      scrollToTheEnd();
    }
  }

  Future openCamera() async {
    PickedFile pickedFile = await imagePicker.getImage(source: ImageSource.camera, imageQuality: imagePickerQuality);
    if (!isObjectEmpty(pickedFile) && !isObjectEmpty(pickedFile.path)) {
      File imageFile = File(pickedFile.path);
      if (!(await imageFile.exists())) {
        showToast('Unable to add the image. File is missing.', Toast.LENGTH_LONG);
      } else {
        imageFileList.add(imageFile);
      }
    }
  }

  /// Opens the chat message's image file.
  openImageMessage(ChatMessage chatMessage, Multimedia chatMessageMultimedia) {
    if (!customFileService.baseDirectoryIsReady) {
      showToast('Error in getting message image. Please check check file permission of your app.', Toast.LENGTH_LONG);
    }

    File chatMessageFile = File('${customFileService.baseDirectory}${chatMessageMultimedia.multimediaType.name}/${chatMessageMultimedia.fileName + chatMessageMultimedia.fileExtension}');

    if (chatMessageFile.existsSync()) {
      goToViewPhotoPage(chatMessageMultimedia, chatMessageFile);
    } else {
      showToast('Please download the file first.', Toast.LENGTH_LONG);
    }
  }

  // Note: Can get any file
  Future getFiles() async {
    FilePickerResult filePickerResult = await FilePicker.platform.pickFiles(type: FileType.any);

    if (!isObjectEmpty(filePickerResult) && filePickerResult.files.isNotEmpty) {
      setState(() {
        documentFileList.addAll(filePickerResult.files.map((PlatformFile file) {
          return File(file.path);
        }));
      });
      scrollToTheEnd();
    }
  }

  downloadFile(Multimedia multimedia, ChatMessage message) async {
    showToast('Your download has started.', Toast.LENGTH_SHORT);
    File file = await customFileService.retrieveMultimediaFile(multimedia, '$REST_URL/chatMessages/${message.id}/multimedia');
    setState(() {
      loadedMultimediaFiles.putIfAbsent(multimedia.fileName, () => file);
    });
  }

  scrollToTheEnd() {
    // 2 timers. First to delay scrolling, 2nd is the given time to animate scrolling effect
    Timer(Duration(milliseconds: 1000), () => imageViewScrollController.animateTo(imageViewScrollController.position.maxScrollExtent, duration: Duration(milliseconds: 300), curve: Curves.easeOut));
  }

  // Hide sticker or back
  Future<bool> onBackPress() {
    if (isShowSticker) {
      setState(() {
        isShowSticker = false;
      });
    } else {
      Navigator.of(context).pop();
    }
    return Future.value(false);
  }

  void getSticker() {
    // Hide keyboard when sticker appear
    focusNode.unfocus();
    setState(() {
      isShowSticker = !isShowSticker;
    });
  }

  void onFocusChange() {
    if (focusNode.hasFocus) {
      // Hide sticker when keyboard appear
      setState(() {
        isShowSticker = false;
        openMultimediaTab = false;
      });
    }
  }

  goToViewPhotoPage(Multimedia multimedia, File file) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: ((context) => PhotoViewPage(
                  heroId: multimedia.fileName,
                  photo: file,
                  defaultImagePathType: DefaultImagePathType.ConversationGroupMessage,
                ))));
  }

  goToLoginPage() {
    Navigator.of(context).pushNamedAndRemoveUntil('login_page', (Route<dynamic> route) => false);
  }

  goToChatInfoPage() {
    Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => ChatInfoPage(currentConversationGroup.id)));
  }

  goBack() {
    Navigator.of(context).pop();
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => false;
}
