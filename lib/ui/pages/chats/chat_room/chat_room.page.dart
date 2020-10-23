import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:snschat_flutter/environments/development/variables.dart' as globals;
import 'package:snschat_flutter/general/index.dart';
import 'package:snschat_flutter/objects/models/index.dart';
import 'package:snschat_flutter/objects/rest/index.dart';
import 'package:snschat_flutter/service/index.dart';
import 'package:snschat_flutter/state/bloc/bloc.dart';
import 'package:snschat_flutter/ui/pages/index.dart';

class ChatRoomPage extends StatefulWidget {
  final ConversationGroup _conversationGroup;

  ChatRoomPage([this._conversationGroup]);

  @override
  State<StatefulWidget> createState() {
    return new ChatRoomPageState();
  }
}

class ChatRoomPageState extends State<ChatRoomPage> with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  String REST_URL = globals.REST_URL;

  ConversationGroupBloc conversationGroupBloc;
  ChatMessageBloc chatMessageBloc;
  MultimediaBloc multimediaBloc;
  UserContactBloc userContactBloc;
  WebSocketBloc webSocketBloc;

  bool isWebSocketConnected = false;
  User ownUser;
  ConversationGroup currentConversationGroup;
  Multimedia groupPhotoMultimedia;
  List<ChatMessage> conversationGroupMessageList = [];
  List<Multimedia> conversationGroupMultimediaList = [];

  ImagePicker imagePicker = Get.find();
  CustomFileService customFileService = Get.find();
  AudioService audioService = Get.find();

  bool isShowSticker = false;
  bool isLoading;
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

  TextEditingController textEditingController = new TextEditingController();
  ScrollController listScrollController = new ScrollController();
  ScrollController imageViewScrollController = new ScrollController();
  ScrollController fileViewScrollController = new ScrollController();
  FocusNode focusNode = new FocusNode();
  AnimationController _animationController, _animationController2;
  Animation animation;

  @override
  void initState() {
    super.initState();
    focusNode.addListener(onFocusChange);
    isLoading = false;
    isShowSticker = false;

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
    listScrollController.dispose();
    textEditingController.dispose();
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

    // TODO: GetCurrentConversationGroup messages using pagination, get multimedia from localDB first, if not get from REST.

    return multiBlocListener();
  }

  Widget multiBlocListener() => MultiBlocListener(listeners: [
        webSocketBlocListener(),
      ], child: userBlocBuilder());

  Widget webSocketBlocListener() {
    return BlocListener<WebSocketBloc, WebSocketState>(
      listener: (context, webSocketState) {
        if (webSocketState is WebSocketNotLoaded) {
          showToast('Connection broken. Reconnecting WebSocket...', Toast.LENGTH_SHORT);
          webSocketBloc.add(InitializeWebSocketEvent(callback: (bool done) {}));
        }
      },
    );
  }

  Widget userBlocBuilder() {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, userState) {
        if (userState is UserLoading) {
          return Center(
            child: Text('Loading...'),
          );
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

        return Center(
          child: Text('Error. Unable to load user'),
        );
      },
    );
  }

  Widget conversationGroupBlocBuilder() {
    return BlocBuilder<ConversationGroupBloc, ConversationGroupState>(
      builder: (context, conversationGroupState) {
        if (conversationGroupState is ConversationGroupsLoaded) {
          currentConversationGroup = conversationGroupState.conversationGroupList.firstWhere((ConversationGroup conversationGroup) => conversationGroup.id == widget._conversationGroup.id, orElse: () => null);

          return multimediaBlocBuilder();
        }

        return showSingleMessagePage('Conversation group not found.');
      },
    );
  }

  Widget multimediaBlocBuilder() {
    return BlocBuilder<MultimediaBloc, MultimediaState>(
      builder: (context, multimediaState) {
        if (multimediaState is MultimediaLoaded) {
          groupPhotoMultimedia = multimediaState.multimediaList.firstWhere((Multimedia existingMultimedia) => existingMultimedia.id == currentConversationGroup.groupPhoto, orElse: () => null);
        }

        return mainBody();
      },
    );
  }

  Widget mainBody() {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          titleSpacing: 0.0,
          title: chatRoomPageTopBar(),
        ),
        body: WillPopScope(
          // To handle event when user press back button when sticker screen is on, dismiss sticker if keyboard is shown
          child: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  //UI for message list
                  buildListMessage(),
                  // UI for stickers, gifs
                  (isShowSticker ? buildSticker() : Container()),
                  // UI for text field
                  buildInput(),
                ],
              ),
              showLoading(),
            ],
          ),
          onWillPop: () => onBackPress(),
        ),
      ),
    );
  }

  Widget chatRoomPageTopBar() {
    return AppBar(
      leading: backButtonWithImage(),
      title: conversationGroupTitle(),
    );
  }

  Widget backButtonWithImage() {
    Widget defaultImage = Image.asset(
      DefaultImagePathTypeUtil.getByConversationGroupType(currentConversationGroup.conversationGroupType).path,
    );

    return Tooltip(
      message: 'Back',
      child: InkWell(
        customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
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

  Widget conversationGroupTitle() {
    return InkWell(
        customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        onTap: () {
          goToChatInfoPage();
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 10.0, right: 250.0),
            ),
            Hero(
              tag: currentConversationGroup.id,
              child: Text(
                currentConversationGroup.name,
                style: TextStyle(fontWeight: FontWeight.bold, color: Get.theme.primaryTextTheme.button.color),
              ),
            ),
            Text(
              'Tap here for more details',
              style: TextStyle(fontSize: 13.0, color: Get.theme.primaryTextTheme.button.color),
            )
          ],
        ));
  }

  Widget showLoading() {
    return Center(
      child: Text('Loading...'),
    );
  }

  Widget buildInput() {
    return Container(
      child: Column(
        children: <Widget>[
          buildImageListTab(),
          buildFileListTab(),
          buildMultimediaTab(),
          Row(
            children: <Widget>[
              // Send image button
              Material(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 1.0),
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
                ),
                // color: Colors.white,
              ),

              // Stickers button
              Container(
                margin: EdgeInsets.symmetric(horizontal: 1.0),
                child: IconButton(
                  icon: Icon(Icons.face),
                  onPressed: () => getSticker(),
                ),
                // color: Colors.white,
              ),

              // Edit text field
              Flexible(
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
                    onChanged: checkTextOnField,
                  ),
                ),
              ),

              // Send message button
              Material(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 8.0),
                  child: !textFieldHasValue ? recordVoiceMessageButton() : textSendButton(),
                ),
                // color: Colors.white,
              ),
            ],
          )
        ],
      ),
      width: double.infinity,
//      height: fileList.length > 0 ? deviceHeight * 0.2 : deviceHeight * 0.1,
      decoration: BoxDecoration(
        border: Border(
            top: BorderSide(
                // color: Colors.grey,
                width: 0.5)),
        // color: Colors.white
      ),
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
      onPressed: () => sendChatMessage(textEditingController.text, null),
    );
  }

  checkTextOnField(String text) {
    setState(() {
      textFieldHasValue = textEditingController.text.isNotEmpty;
    });
  }

  Widget buildImageListTab() {
    return // Use Visibility to control to show widget easily. https://stackoverflow.com/questions/44489804/show-hide-widgets-in-flutter-programmatically
        Visibility(
      visible: imageFileList.isNotEmpty,
      child: Row(
        children: <Widget>[
          Container(
            height: 150,
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
                          right: 5.0,
                          top: 5.0,
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

  Widget buildFileListTab() {
    return // Use Visibility to control to show widget easily. https://stackoverflow.com/questions/44489804/show-hide-widgets-in-flutter-programmatically
        Visibility(
      visible: documentFileList.isNotEmpty,
      child: Row(
        children: <Widget>[
          Container(
            height: 150,
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
                          right: 5.0,
                          top: 5.0,
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

  Widget buildMultimediaTab() {
    return Material(
      child: Visibility(
          visible: openMultimediaTab,
          child: FadeTransition(
            opacity: animation,
            child: Row(
              children: <Widget>[
                Container(
                    height: Get.height * 0.3,
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

  Widget buildListMessage() {
    return BlocBuilder<WebSocketBloc, WebSocketState>(
      builder: (context, webSocketState) {
        if (webSocketState is WebSocketNotLoaded) {
          BlocProvider.of<WebSocketBloc>(context).add(ReconnectWebSocketEvent(callback: (bool done) {}));
        }

        if (webSocketState is WebSocketLoaded) {
          isWebSocketConnected = true;
          return loadMessageList();
        }

        isWebSocketConnected = false;
        return loadMessageList();
      },
    );
  }

  Widget loadMessageList() {
    return BlocBuilder<ChatMessageBloc, ChatMessageState>(
      builder: (context, chatMessageState) {
        if (chatMessageState is ChatMessageLoading) {
          return showSingleMessagePage('Loading...');
        }

        if (chatMessageState is ChatMessagesLoaded) {
          // Get current conversation messages and sort them.
          conversationGroupMessageList = chatMessageState.chatMessageList.where((ChatMessage message) => message.conversationId == widget._conversationGroup.id).toList();

          conversationGroupMessageList.sort((message1, message2) => message2.createdDate.compareTo(message1.createdDate));

          return Flexible(
            child: ListView.builder(
              controller: listScrollController,
              itemCount: conversationGroupMessageList.length,
              reverse: true,
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) => displayChatMessage(conversationGroupMessageList[index]),
            ),
          );
        }

        return showSingleMessagePage('No messages.');
      },
    );
  }

  Widget showSingleMessagePage(String message) {
    return Material(
      // color: Colors.white,
      child: Flexible(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                message,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget displayChatMessage(ChatMessage chatMessage) {
    bool isSenderMessage = chatMessage.senderId == ownUser.id;
    double lrPadding = 15.0;
    Widget messageWidget = showUnidentifiedMessageText(chatMessage, isSenderMessage);

    Multimedia messageMultimedia = conversationGroupMultimediaList.firstWhere((multimedia) => multimedia.id == chatMessage.multimediaId, orElse: null);

    if (!isObjectEmpty(chatMessage.multimediaId)) {
      messageWidget = showTextMessage(chatMessage, isSenderMessage);
    } else {
      switch (messageMultimedia.multimediaType) {
        case MultimediaType.Image:
          messageWidget = imageMessage(chatMessage, messageMultimedia, isSenderMessage);
          break;
        case MultimediaType.Document:
          messageWidget = fileMessage(chatMessage, messageMultimedia, isSenderMessage);
          break;
        case MultimediaType.Document:
          messageWidget = fileMessage(chatMessage, messageMultimedia, isSenderMessage);
          break;
        case MultimediaType.Audio:
          messageWidget = showAudioMessage(chatMessage, messageMultimedia, isSenderMessage);
          break;
        default:
          break;
      }
    }

    return Column(
      children: <Widget>[
        Row(
          crossAxisAlignment: isSenderMessage ? CrossAxisAlignment.start : CrossAxisAlignment.end,
          mainAxisAlignment: isSenderMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: lrPadding),
            ),
            Text(
              chatMessage.senderName + ', ' + messageTimeDisplay(chatMessage.createdDate.millisecondsSinceEpoch),
//                    message.senderName,
              style: TextStyle(
                fontSize: 10.0,
              ),
            ),
          ],
        ),
        messageWidget,
      ],
    );
  }

  Widget showTextMessage(ChatMessage chatMessage, bool isSenderMessage) {
    Widget textMessageContent = Text(
      // message.senderName + message.messageContent + messageTimeDisplay(message.timestamp),
      chatMessage.messageContent,
      style: TextStyle(),
    );

    return buildMessageChatBubble(chatMessage, isSenderMessage, textMessageContent);
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
    ;
  }

  Widget buildMessageChatBubble(ChatMessage message, bool isSenderMessage, Widget content) {
    double lrPadding = 15.0;
    double tbPadding = 10.0;

    return Row(
      crossAxisAlignment: isSenderMessage ? CrossAxisAlignment.start : CrossAxisAlignment.end,
      mainAxisAlignment: isSenderMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: EdgeInsets.fromLTRB(lrPadding, tbPadding, lrPadding, tbPadding),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(32.0)),
          margin: EdgeInsets.only(bottom: 20.0, right: isSenderMessage ? Get.width * 0.01 : 0.0, left: isSenderMessage ? Get.width * 0.01 : 0.0),
          child: Row(
            children: <Widget>[
              Column(
                children: <Widget>[content],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget fileMessage(ChatMessage chatMessage, Multimedia chatMessageMultimedia, bool isSenderMessage) {
    Multimedia messageMultimedia = conversationGroupMultimediaList.firstWhere((Multimedia multimedia) => multimedia.id == chatMessage.multimediaId, orElse: () => null);

    /// TODO: Check the file exist or not. If not download the file from Internet, if got load the file.
    // fileService.downloadMultimediaFile(context, messageMultimedia);

    Widget documentMessage = RichText(text: TextSpan(children: [TextSpan(text: chatMessage.messageContent, style: TextStyle(), recognizer: TapGestureRecognizer()..onTap = () => downloadFile(messageMultimedia, chatMessage))]));
    return buildMessageChatBubble(chatMessage, isSenderMessage, documentMessage);
  }

  Widget showAudioMessage(ChatMessage chatMessage, Multimedia chatMessageMultimedia, bool isSenderMessage) {
    Multimedia messageMultimedia, userContactMultimedia;
    messageMultimedia = conversationGroupMultimediaList.firstWhere((Multimedia multimedia) => multimedia.id == chatMessage.multimediaId, orElse: () => null);

    userContactMultimedia = conversationGroupMultimediaList.firstWhere((Multimedia multimedia) => multimedia.id == chatMessage.multimediaId, orElse: () => null);

    /// TODO: Check audio file, show download button if not downloaded, load the audio in ready state.
    downloadFile(messageMultimedia, chatMessage);

    Widget content = messageAudioPlayer(chatMessage, userContactMultimedia, messageMultimedia, audioService);
    return buildMessageChatBubble(chatMessage, isSenderMessage, content);
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

  String messageTimeDisplay(int timestamp) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd-MM-yyyy').format(now);
    DateFormat dateFormat = DateFormat('dd-MM-yyyy');
    DateTime today = dateFormat.parse(formattedDate);
    // String formattedDate2 = DateFormat('dd-MM-yyyy hh:mm:ss').format(today);
    DateTime messageTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    String formattedDate3 = DateFormat('hh:mm').format(messageTime);
    return formattedDate3;
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
    print('chat_room.page.dart minimumRecordingLength: ' + minimumRecordingLength.toString());
    // print('chat_room.page.dart recordDuration: ' + recordDuration.toString());
    // return recordDuration < minimumRecordingLength;
    return false;
  }

  sendChatMessage(String content, [MultimediaType multimediaType]) {
    if (isObjectEmpty(multimediaType) && content.trim() != '') {
      textEditingController.clear();
      setState(() {
        textFieldHasValue = false;
      });

      chatMessageBloc.add(AddChatMessageEvent(
          createChatMessageRequest: CreateChatMessageRequest(conversationId: currentConversationGroup.id, messageContent: content),
          callback: (ChatMessage message) {
            if (message.isNull) {
              showToast('ChatMessage not sent. Please try again.', Toast.LENGTH_SHORT);
            } else {
              WebSocketMessage webSocketMessage = WebSocketMessage(message: message);
              webSocketBloc.add(SendWebSocketMessageEvent(webSocketMessage: webSocketMessage, callback: (bool done) {}));
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
    } else {}
    File chatMessageFile = File('${customFileService.baseDirectory}${chatMessageMultimedia.multimediaType.name}/${chatMessageMultimedia.fileName + chatMessageMultimedia.fileExtension}');

    if (chatMessageFile.existsSync()) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: ((context) => PhotoViewPage(
                    heroId: chatMessageMultimedia.fileName,
                    photo: chatMessageFile,
                    defaultImagePathType: DefaultImagePathType.ConversationGroupMessage,
                  ))));
    } else {
      showToast('Please download the file first.', Toast.LENGTH_LONG);
    }
  }

  // Note: Can get any file
  Future getFiles() async {
    FilePickerResult filePickerResult = await FilePicker.platform.pickFiles(type: FileType.any);

    if (!filePickerResult.isNullOrBlank && filePickerResult.files.isNotEmpty) {
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
