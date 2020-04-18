import 'dart:async';
import 'dart:io';
import 'package:snschat_flutter/state/bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vibration/vibration.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';

import 'package:snschat_flutter/general/index.dart';
import 'package:snschat_flutter/objects/index.dart';
import 'package:snschat_flutter/service/index.dart';
import 'package:snschat_flutter/ui/pages/index.dart';
import 'package:snschat_flutter/environments/development/variables.dart'
    as globals;

class ChatRoomPage extends StatefulWidget {
  final ConversationGroup _conversationGroup;

  ChatRoomPage([this._conversationGroup]);

  @override
  State<StatefulWidget> createState() {
    return new ChatRoomPageState();
  }
}

class ChatRoomPageState extends State<ChatRoomPage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  bool isShowSticker = false;
  bool isLoading;
  bool isRecording = false;
  bool imageFound = false;
  bool openMultimediaTab = false;
  double deviceWidth;
  double deviceHeight;
  bool textFieldHasValue = false;

  String inputFieldText = 'Type your message...';
  DateTime recordStartTime;
  Timer recordingTimer;
  double recordingTimeText;

  Color appBarTextTitleColor;
  Color appBarThemeColor;

  // This is used to get batch send multiple multimedia in one go, like multiple image and video
  List<File> imageFileList = [];
  List<File> imageThumbnailFileList = [];
  List<File> documentFileList = [];

  String WEBSOCKET_URL = globals.WEBSOCKET_URL;
  int minimumRecordingLength = globals.minimumRecordingLength;

  int imagePickerQuality = globals.imagePickerQuality;

  TextEditingController textEditingController = new TextEditingController();
  ScrollController listScrollController = new ScrollController();
  ScrollController imageViewScrollController = new ScrollController();
  ScrollController fileViewScrollController = new ScrollController();
  FocusNode focusNode = new FocusNode();
  AnimationController _animationController, _animationController2;
  Animation animation;

  CustomFileService fileService = CustomFileService();
  ImageService imageService = ImageService();
  AudioService audioService = AudioService();
  FirebaseStorageService firebaseStorageService = FirebaseStorageService();

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
    _animationController2 = new AnimationController(
        vsync: this, duration: Duration(milliseconds: 300));
    animation = Tween(begin: 0.0, end: 1.0).animate(_animationController2);
    _animationController2.forward();
  }

  @override
  void dispose() {
    listScrollController.dispose();
    textEditingController.dispose();
    _animationController.dispose();
    _animationController2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    appBarTextTitleColor = Theme.of(context).appBarTheme.textTheme.title.color;
    appBarThemeColor = Theme.of(context).appBarTheme.color;

    deviceWidth = MediaQuery.of(context).size.width;
    deviceHeight = MediaQuery.of(context).size.height;

    // TODO: Send message using WebSocket
    // Do in this order (To allow resend message if anything goes wrong [Send timeout, websocket down, Internet down situations])
    // 1. Send to DB
    // 2. Send to State
    // 3. Send to API
    // 4. Retrieve through WebSocket

    return MultiBlocListener(
      listeners: [],
      child: BlocBuilder<UserBloc, UserState>(
        builder: (context, userState) {
          if (userState is UserLoading) {
            return Center(
              child: Text('Loading...'),
            );
          }

          if (userState is UserNotLoaded) {
            goToLoginPage(context);
            return Center(
              child: Text('Unable to load user.'),
            );
          }

          if (userState is UserLoaded) {
            return BlocBuilder<ConversationGroupBloc, ConversationGroupState>(
              builder: (context, conversationGroupState) {
                if (conversationGroupState is ConversationGroupsLoaded) {
                  ConversationGroup conversationGroup =
                      conversationGroupState.conversationGroupList.firstWhere(
                          (ConversationGroup conversationGroup) =>
                              conversationGroup.id ==
                              widget._conversationGroup.id,
                          orElse: () => null);
                  if (!isObjectEmpty(conversationGroup)) {
                    return chatRoomMainBody(
                        context, conversationGroup, userState.user);
                  } else {
                    Fluttertoast.showToast(
                        msg: 'Error. Conversation Group not found.',
                        toastLength: Toast.LENGTH_LONG);
                    Navigator.pop(context);
                  }
                }

                return chatRoomMainBody(context, null, userState.user);
              },
            );
          }

          return Center(
            child: Text('Error. Unable to load user'),
          );
        },
      ),
    );
  }

  Widget chatRoomMainBody(BuildContext context,
      ConversationGroup selectedConversationGroup, User user) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          titleSpacing: 0.0,
          title: BlocBuilder<MultimediaBloc, MultimediaState>(
            builder: (context, multimediaState) {
              if (multimediaState is MultimediaLoaded) {
                Multimedia multimedia = multimediaState.multimediaList
                    .firstWhere(
                        (Multimedia existingMultimedia) =>
                            existingMultimedia.conversationId ==
                            selectedConversationGroup.id,
                        orElse: () => null);

                return chatRoomPageTopBar(
                    context, selectedConversationGroup, multimedia);
              }

              return chatRoomPageTopBar(
                  context, selectedConversationGroup, null);
            },
          ),
        ),
        body: WillPopScope(
          // To handle event when user press back button when sticker screen is on, dismiss sticker if keyboard is shown
          child: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  //UI for message list
                  buildListMessage(context, user),
                  // UI for stickers, gifs
                  (isShowSticker
                      ? buildSticker(context, user, selectedConversationGroup)
                      : Container()),
                  // UI for text field
                  buildInput(context, user, selectedConversationGroup),
                ],
              ),
              buildLoading(),
            ],
          ),
          onWillPop: () => onBackPress(context),
        ),
      ),
    );
  }

  Widget chatRoomPageTopBar(BuildContext context,
      ConversationGroup conversationGroup, Multimedia multimedia) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Tooltip(
          message: 'Back',
          child: Material(
            color: appBarThemeColor,
            child: InkWell(
              customBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Row(
                children: <Widget>[
                  Icon(Icons.arrow_back),
                  Hero(
                    tag: conversationGroup.id + '1',
                    child: imageService.loadImageThumbnailCircleAvatar(
                        multimedia,
                        convertConversationGroupTypeToDefaultImagePathType(
                            conversationGroup.type),
                        context),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 5.0, vertical: 30.0),
                  ),
                ],
              ),
            ),
          ),
        ),
        Material(
          color: appBarThemeColor,
          child: InkWell(
              customBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0)),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) =>
                        ChatInfoPage(conversationGroup)));
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 10.0, right: 250.0),
                  ),
                  Hero(
                    tag: conversationGroup.id,
                    child: Text(
                      conversationGroup.name,
                      style: TextStyle(
                          color: appBarTextTitleColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(
                    'Tap here for more details',
                    style:
                        TextStyle(color: appBarTextTitleColor, fontSize: 13.0),
                  )
                ],
              )),
        ),
      ],
    );
  }

  Widget buildLoading() {
    return Positioned(
      child: isLoading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue)),
              ),
              color: Colors.white.withOpacity(0.8),
            )
          : Container(),
    );
  }

  Widget buildInput(
      BuildContext context, User user, ConversationGroup conversationGroup) {
    return Container(
      child: Column(
        children: <Widget>[
          buildImageListTab(context),
          buildFileListTab(context),
          buildMultimediaTab(context),
          Row(
            children: <Widget>[
              // Button send image
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
                color: Colors.white,
              ),
              Material(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 1.0),
                  child: IconButton(
                    icon: Icon(Icons.face),
                    onPressed: () => getSticker(),
                  ),
                ),
                color: Colors.white,
              ),

              // Edit text
              Flexible(
                child: Container(
                  child: TextField(
                    enabled: !isRecording,
                    style: TextStyle(fontSize: 17.0),
                    controller: textEditingController,
                    decoration: InputDecoration.collapsed(
                      hintText: inputFieldText,
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                    focusNode: focusNode,
                    onChanged: checkTextOnField,
                  ),
                ),
              ),

              // Button send message
              Material(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 8.0),
                  child: !textFieldHasValue
                      ? recordVoiceMessageButton(
                          context, user, conversationGroup)
                      : textSendButton(context, user, conversationGroup),
                ),
                color: Colors.white,
              ),
            ],
          )
        ],
      ),
      width: double.infinity,
//      height: fileList.length > 0 ? deviceHeight * 0.2 : deviceHeight * 0.1,
      decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey, width: 0.5)),
          color: Colors.white),
    );
  }

  Widget recordVoiceMessageButton(
      BuildContext context, User user, ConversationGroup conversationGroup) {
    return GestureDetector(
      child: IconButton(
        icon: !isRecording ? Icon(Icons.keyboard_voice) : Icon(Icons.clear),
//        onPressed: () => sendChatMessage(context, '', 3, user, conversationGroup),
        onPressed: () => recordOrStopAudio(context, user, conversationGroup),
      ),
    );
  }

  Widget textSendButton(
      BuildContext context, User user, ConversationGroup conversationGroup) {
    return IconButton(
      icon: Icon(Icons.send),
      onPressed: () => sendChatMessage(
          context, textEditingController.text, 0, user, conversationGroup),
    );
  }

  checkTextOnField(String text) {
    setState(() {
      textFieldHasValue = !isStringEmpty(textEditingController.text);
    });
  }

  Widget buildImageListTab(BuildContext context) {
    return // Use Visibility to control to show widget easily. https://stackoverflow.com/questions/44489804/show-hide-widgets-in-flutter-programmatically
        Visibility(
      visible: imageFileList.length > 0,
      child: Row(
        children: <Widget>[
          Container(
            height: 150,
            width: deviceWidth,
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
                      color: appBarTextTitleColor,
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
                            color: Colors.black,
                            child: Icon(
                              Icons.clear,
                              color: Colors.white,
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

  Widget buildFileListTab(BuildContext context) {
    return // Use Visibility to control to show widget easily. https://stackoverflow.com/questions/44489804/show-hide-widgets-in-flutter-programmatically
        Visibility(
      visible: documentFileList.length > 0,
      child: Row(
        children: <Widget>[
          Container(
            height: 150,
            width: deviceWidth,
            child: ListView.builder(
              controller: fileViewScrollController,
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              reverse: true,
              itemCount: documentFileList.length,
              itemBuilder: (BuildContext buildContext2, int index) {
                File currentFile = documentFileList[index];
                String fileName = basename(currentFile.path);
                return Stack(
                  alignment: AlignmentDirectional.topEnd,
                  children: <Widget>[
                    Card(
                      elevation: 2.0,
                      color: appBarTextTitleColor,
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
                            color: Colors.black,
                            child: Icon(
                              Icons.clear,
                              color: Colors.white,
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

  Widget buildMultimediaTab(BuildContext context) {
    return Material(
      child: Visibility(
          visible: openMultimediaTab,
          child: FadeTransition(
            opacity: animation,
            child: Row(
              children: <Widget>[
                Container(
                    height: deviceHeight * 0.3,
                    width: deviceWidth,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            multimediaButton(context, 'Image', Icons.image,
                                () => getImage()),
                            multimediaButton(context, 'Camera',
                                Icons.camera_alt, () => openCamera()),
                            multimediaButton(context, 'File',
                                Icons.insert_drive_file, () => getFiles()),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            multimediaButton(
                                context, 'Audio', Icons.audiotrack, () => {}),
                            multimediaButton(context, 'Location',
                                Icons.location_on, () => {}),
                            multimediaButton(
                                context, 'Contact', Icons.contacts, () => {}),
                          ],
                        ),
                      ],
                    )),
              ],
            ),
          )),
    );
  }

  Widget multimediaButton(
      BuildContext context, String name, IconData iconData, Function function) {
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

  Widget buildListMessage(BuildContext context, User user) {
    return BlocBuilder<WebSocketBloc, WebSocketState>(
      builder: (context, webSocketState) {
        if (webSocketState is WebSocketNotLoaded) {
          BlocProvider.of<WebSocketBloc>(context)
              .add(ReconnectWebSocketEvent(callback: (bool done) {}));
        }

        if (webSocketState is WebSocketLoaded) {
          return loadMessageList(context, user);
        }
        return loadMessageList(context, user);
      },
    );
  }

  Widget loadMessageList(BuildContext context, User user) {
    return BlocBuilder<MessageBloc, MessageState>(
      builder: (context, messageState) {
        if (messageState is MessageLoading) {
          return showSingleMessagePage('Loading...');
        }

        if (messageState is MessagesLoaded) {
          // Get current conversation messages and sort them.
          List<ChatMessage> conversationGroupMessageList = messageState
              .messageList
              .where((ChatMessage message) =>
                  message.conversationId == widget._conversationGroup.id)
              .toList();
          conversationGroupMessageList.sort((message1, message2) =>
              message2.createdTime.compareTo(message1.createdTime));

          return Flexible(
            child: ListView.builder(
              controller: listScrollController,
              itemCount: conversationGroupMessageList.length,
              reverse: true,
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) => displayChatMessage(
                  context, index, conversationGroupMessageList[index], user),
            ),
          );
        }

        return showSingleMessagePage('No messages.');
      },
    );
  }

  Widget showSingleMessagePage(String message) {
    return Material(
      color: Colors.white,
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

  Widget displayChatMessage(
      BuildContext context, int index, ChatMessage message, User user) {
    bool isSenderMessage = message.senderId == user.id;
    double lrPadding = 15.0;
    bool isText = message.type == ChatMessageType.Text;
    bool isImage = message.type == ChatMessageType.Image;
    bool isFile = message.type == ChatMessageType.Document;
    bool isAudio = message.type == ChatMessageType.Audio;
    return Column(
      children: <Widget>[
        Row(
          crossAxisAlignment: isSenderMessage
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.end,
          mainAxisAlignment:
              isSenderMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: lrPadding),
            ),
            Text(
              message.senderName +
                  ', ' +
                  messageTimeDisplay(message.createdTime),
//                    message.senderName,
              style: TextStyle(fontSize: 10.0, color: Colors.black38),
            ),
          ],
        ),
        isText
            ? showTextMessage(context, message, isSenderMessage)
            : isImage
                ? showImageMessage(context, message, isSenderMessage)
                : isFile
                    ? showFileMessage(context, message, isSenderMessage)
                    : isAudio
                        ? showAudioMessage(context, message, isSenderMessage)
                        : showUnidentifiedMessageText(
                            context, message, isSenderMessage),
      ],
    );
  }

  Widget showTextMessage(
      BuildContext context, ChatMessage message, bool isSenderMessage) {
    Widget textMessageContent = Text(
      // message.senderName + message.messageContent + messageTimeDisplay(message.timestamp),
      message.messageContent,
      style: TextStyle(color: appBarTextTitleColor),
    );

    return buildMessageChatBubble(
        context, message, isSenderMessage, textMessageContent);
  }

  Widget showImageMessage(
      BuildContext context, ChatMessage message, bool isSenderMessage) {
    return BlocBuilder<MultimediaBloc, MultimediaState>(
        builder: (context, multimediaState) {
      if (multimediaState is MultimediaLoaded) {
        List<Multimedia> multimediaList = multimediaState.multimediaList;
        Multimedia messageMultimedia = multimediaList.firstWhere(
            (Multimedia multimedia) => multimedia.messageId == message.id,
            orElse: () => null);
        if (!isObjectEmpty(messageMultimedia)) {
          // Need custom design, so Image doesn't use buildMessageChatBubble() method.
          return Row(
            crossAxisAlignment: isSenderMessage
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.end,
            mainAxisAlignment: isSenderMessage
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(
                    bottom: 20.0,
                    right: isSenderMessage ? deviceWidth * 0.01 : 0.0,
                    left: isSenderMessage ? deviceWidth * 0.01 : 0.0),
                child: Row(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Hero(
                          tag: messageMultimedia.id,
                          child: InkWell(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16.0),
                              child: imageService.loadFullImage(
                                  context,
                                  messageMultimedia,
                                  DefaultImagePathType
                                      .ConversationGroupMessage),
                            ),
                            onTap: () => {
                              // View photo
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: ((context) =>
                                          PhotoViewPage(messageMultimedia))))
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
      }

      return buildMessageChatBubble(
          context,
          message,
          isSenderMessage,
          imageService.loadFullImage(
              context, null, DefaultImagePathType.ConversationGroupMessage));
    });
  }

  Widget buildMessageChatBubble(BuildContext context, ChatMessage message,
      bool isSenderMessage, Widget content) {
    double lrPadding = 15.0;
    double tbPadding = 10.0;

    return Row(
      crossAxisAlignment:
          isSenderMessage ? CrossAxisAlignment.start : CrossAxisAlignment.end,
      mainAxisAlignment:
          isSenderMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: <Widget>[
        Container(
          padding:
              EdgeInsets.fromLTRB(lrPadding, tbPadding, lrPadding, tbPadding),
          decoration: BoxDecoration(
              color: appBarThemeColor,
              borderRadius: BorderRadius.circular(32.0)),
          margin: EdgeInsets.only(
              bottom: 20.0,
              right: isSenderMessage ? deviceWidth * 0.01 : 0.0,
              left: isSenderMessage ? deviceWidth * 0.01 : 0.0),
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

  Widget showFileMessage(
      BuildContext context, ChatMessage message, bool isSenderMessage) {
    return BlocBuilder<MultimediaBloc, MultimediaState>(
        builder: (context, multimediaState) {
      if (multimediaState is MultimediaLoaded) {
        List<Multimedia> multimediaList = multimediaState.multimediaList;
        Multimedia messageMultimedia = multimediaList.firstWhere(
            (Multimedia multimedia) => multimedia.messageId == message.id,
            orElse: () => null);
        fileService.downloadMultimediaFile(context, messageMultimedia);

        Widget documentMessage = RichText(
            text: TextSpan(children: [
          TextSpan(
              text: message.messageContent,
              style: TextStyle(color: appBarTextTitleColor),
              recognizer: TapGestureRecognizer()
                ..onTap =
                    () => downloadFile(context, messageMultimedia, message))
        ]));
        return buildMessageChatBubble(
            context, message, isSenderMessage, documentMessage);
      }

      return buildMessageChatBubble(
          context,
          message,
          isSenderMessage,
          Text(
            'Document appears here',
            style: TextStyle(color: appBarTextTitleColor),
          ));
    });
  }

  Widget showAudioMessage(
      BuildContext context, ChatMessage message, bool isSenderMessage) {
    return BlocBuilder<MultimediaBloc, MultimediaState>(
      builder: (context, multimediaState) {
        Multimedia messageMultimedia, userContactMultimedia;
        if (multimediaState is MultimediaLoaded) {
          List<Multimedia> multimediaList = multimediaState.multimediaList;
          messageMultimedia = multimediaList.firstWhere(
              (Multimedia multimedia) => multimedia.messageId == message.id,
              orElse: () => null);

          UserContactState userContactState =
              BlocProvider.of<UserContactBloc>(context).state;
          if (userContactState is UserContactsLoaded) {
            List<UserContact> userContactList =
                userContactState.userContactList;
            UserContact userContact = userContactList.firstWhere(
                (UserContact userContact) => userContact.id == message.senderId,
                orElse: () => null);
          }

          userContactMultimedia = multimediaList.firstWhere(
              (Multimedia multimedia) =>
                  multimedia.messageId == message.senderId,
              orElse: () => null);
          fileService.downloadMultimediaFile(context, messageMultimedia);
          Widget content = messageAudioPlayer(context, message,
              userContactMultimedia, messageMultimedia, audioService);
          return buildMessageChatBubble(
              context, message, isSenderMessage, content);
        }

        Widget content = messageAudioPlayer(
            context, message, userContactMultimedia, null, audioService);

        return buildMessageChatBubble(
            context, message, isSenderMessage, content);
      },
    );
  }

  Widget showUnidentifiedMessageText(
      BuildContext context, ChatMessage message, bool isSenderMessage) {
    double lrPadding = 15.0;
    double tbPadding = 10.0;

    return Container(
      padding: EdgeInsets.fromLTRB(lrPadding, tbPadding, lrPadding, tbPadding),
      decoration: BoxDecoration(
          color: appBarThemeColor, borderRadius: BorderRadius.circular(32.0)),
      margin: EdgeInsets.only(
          bottom: 20.0,
          right: isSenderMessage ? deviceWidth * 0.01 : 0.0,
          left: isSenderMessage ? deviceWidth * 0.01 : 0.0),
      child: Row(
        children: <Widget>[
          Column(
            children: <Widget>[
              Text(
                'Unindentified message.',
                style: TextStyle(color: appBarTextTitleColor),
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
    String formattedDate2 = DateFormat('dd-MM-yyyy hh:mm:ss').format(today);
    DateTime messageTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    String formattedDate3 = DateFormat('hh:mm').format(messageTime);
    return formattedDate3;
  }

  Widget buildSticker(
      BuildContext context, User user, ConversationGroup conversationGroup) {
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              FlatButton(
                  onPressed: () => sendChatMessage(
                      context, 'mimi1', 2, user, conversationGroup),
                  child: Image(
                    image: AssetImage('lib/ui/images/mimi1.gif'),
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  )),
              FlatButton(
                  onPressed: () => sendChatMessage(
                      context, 'mimi2', 2, user, conversationGroup),
                  child: Image(
                    image: AssetImage('lib/ui/images/mimi2.gif'),
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  )),
              FlatButton(
                  onPressed: () => sendChatMessage(
                      context, 'mimi3', 2, user, conversationGroup),
                  child: Image(
                    image: AssetImage('lib/ui/images/mimi3.gif'),
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  ))
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),
          Row(
            children: <Widget>[
              FlatButton(
                  onPressed: () => sendChatMessage(
                      context, 'mimi4', 2, user, conversationGroup),
                  child: Image(
                    image: AssetImage('lib/ui/images/mimi4.gif'),
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  )),
              FlatButton(
                  onPressed: () => sendChatMessage(
                      context, 'mimi5', 2, user, conversationGroup),
                  child: Image(
                    image: AssetImage('lib/ui/images/mimi5.gif'),
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  )),
              FlatButton(
                  onPressed: () => sendChatMessage(
                      context, 'mimi6', 2, user, conversationGroup),
                  child: Image(
                    image: AssetImage('lib/ui/images/mimi6.gif'),
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  ))
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),
          Row(
            children: <Widget>[
              FlatButton(
                  onPressed: () => sendChatMessage(
                      context, 'mimi7', 2, user, conversationGroup),
                  child: Image(
                    image: AssetImage('lib/ui/images/mimi7.gif'),
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  )),
              FlatButton(
                  onPressed: () => sendChatMessage(
                      context, 'mimi8', 2, user, conversationGroup),
                  child: Image(
                    image: AssetImage('lib/ui/images/mimi8.gif'),
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  )),
              FlatButton(
                  onPressed: () => sendChatMessage(
                      context, 'mimi9', 2, user, conversationGroup),
                  child: Image(
                    image: AssetImage('lib/ui/images/mimi9.gif'),
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  ))
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          )
        ],
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      ),
      decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey, width: 0.5)),
          color: Colors.white),
      padding: EdgeInsets.all(5.0),
      height: 180.0,
    );
  }

  recordVoiceMessage(BuildContext context, User user,
      ConversationGroup conversationGroup) async {
    print('chat_room.page.dart recordVoiceMessage()');
  }

  saveVoiceMessage(
      BuildContext context,
      User user,
      ConversationGroup conversationGroup,
      LongPressEndDetails longPressEndDetails) async {
    print('chat_room.page.dart saveVoiceMessage()');
  }

  cancelVoiceMessage(BuildContext context, User user,
      ConversationGroup conversationGroup) async {
    print('chat_room.page.dart cancelVoiceMessage()');
  }

  recordOrStopAudio(BuildContext context, User user,
      ConversationGroup conversationGroup) async {
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

  // recordingTimer
  startRecordingTimer() {
    recordingTimeText = 0.0;
    const duration = const Duration(seconds: 1);
    recordingTimer = new Timer.periodic(duration, (Timer timer) {
      recordingTimeText += 1.0;
    });
  }

  Future<bool> recordngIsTooShort() async {
    // int recordDuration = this.audioService.durationsInMiliseconds;
    print('chat_room.page.dart minimumRecordingLength: ' +
        minimumRecordingLength.toString());
    // print('chat_room.page.dart recordDuration: ' + recordDuration.toString());
    // return recordDuration < minimumRecordingLength;
    return false;
  }

  sendChatMessage(BuildContext context, String content, int type, User user,
      ConversationGroup conversationGroup) {
    // Types:
    // 0 = text,
    // 1 = image,
    // 2 = sticker
    // 3 = voice
    if (type == 0 && content.trim() != '') {
      textEditingController.clear();
      setState(() {
        textFieldHasValue = false;
      });

      ChatMessage newMessage = ChatMessage(
        id: null,
        conversationId: widget._conversationGroup.id,
        messageContent: content,
        multimediaId: '',
        // Send to group will not need receiver
        receiverId: '',
        receiverMobileNo: '',
        receiverName: '',
        senderId: user.id,
        senderMobileNo: user.mobileNo,
        senderName: user.displayName,
        status: ChatMessageStatus.Sent,
        type: ChatMessageType.Text,
        createdTime: DateTime.now().millisecondsSinceEpoch,
      );

      BlocProvider.of<MessageBloc>(context).add(AddMessageEvent(
          message: newMessage,
          callback: (ChatMessage message) {
            if (isObjectEmpty(message)) {
              Fluttertoast.showToast(
                  msg: 'ChatMessage not sent. Please try again.',
                  toastLength: Toast.LENGTH_SHORT);
            } else {
              WebSocketMessage webSocketMessage =
                  WebSocketMessage(message: message);
              BlocProvider.of<WebSocketBloc>(context).add(
                  SendWebSocketMessageEvent(
                      webSocketMessage: webSocketMessage,
                      callback: (bool done) {}));
            }
          }));
    }

    // Got files to send (Images, Video, Audio, Files)
    if (imageFileList.length > 0) {
      uploadMultimediaFiles(context, imageFileList, user, conversationGroup,
          ChatMessageType.Image);
    }

    if (documentFileList.length > 0) {
      uploadMultimediaFiles(context, documentFileList, user, conversationGroup,
          ChatMessageType.Document);
    }

    // if(type == 3 && !isStringEmpty(audioService.audioFilePath)) {
    //   List<File> fileList = [];
    //   File audioFile = File(audioService.audioFilePath);
    //   fileList.add(audioFile);
    //   uploadMultimediaFiles(context, fileList, user, conversationGroup, 'Audio');
    //   audioService.audioFilePath = null;
    // }
  }

  Future getImage() async {
    File imageFile = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: imagePickerQuality);
    if (!isObjectEmpty(imageFile) && await imageFile.exists()) {
      setState(() {
        imageFileList.add(imageFile);
      });
      scrollToTheEnd();
    }
  }

  Future openCamera() async {
    File imageFile = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: imagePickerQuality);
    if (await imageFile.exists()) {
      setState(() {
        imageFileList.add(imageFile);
      });
      scrollToTheEnd();
    }
  }

  // Note: Can get any file
  Future getFiles() async {
    List<File> fileList = await FilePicker.getMultiFile(type: FileType.any);
    if (!isObjectEmpty(fileList) && fileList.length > 0) {
      setState(() {
        documentFileList.addAll(fileList.where((File file) => true));
      });
      scrollToTheEnd();
    }
  }

  downloadFile(
      BuildContext context, Multimedia multimedia, ChatMessage message) {
    // message.messageContent is the filename
    Fluttertoast.showToast(
        msg: 'Your download has started.', toastLength: Toast.LENGTH_LONG);
    fileService.downloadFile(context, multimedia.remoteFullFileUrl, true, true,
        message.messageContent);
  }

  scrollToTheEnd() {
    // 2 timers. First to delay scrolling, 2nd is the given time to animate scrolling effect
    Timer(
        Duration(milliseconds: 1000),
        () => imageViewScrollController.animateTo(
            imageViewScrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeOut));
  }

  uploadMultimediaFiles(BuildContext context, List<File> fileList, User user,
      ConversationGroup conversationGroup, ChatMessageType type) {
    if (fileList.length > 0) {
      fileList.forEach((File file) async {
        FileStat fileStat = await file.stat();

        ChatMessage message = ChatMessage(
          id: null,
          conversationId: widget._conversationGroup.id,
          messageContent: basename(file.path),
          multimediaId: '',
          // Send to group will not need receiver
          receiverId: '',
          receiverMobileNo: '',
          receiverName: '',
          senderId: user.id,
          senderMobileNo: user.mobileNo,
          senderName: user.displayName,
          status: ChatMessageStatus.Sent,
          type: type,
          createdTime: DateTime.now().millisecondsSinceEpoch,
        );
        BlocProvider.of<MessageBloc>(context).add(AddMessageEvent(
            message: message,
            callback: (ChatMessage message2) async {
              if (!isObjectEmpty(message2)) {
                Multimedia messageMultimedia = Multimedia(
                    id: null,
                    localFullFileUrl: isObjectEmpty(file) ? null : file.path,
                    localThumbnailUrl: null,
                    remoteThumbnailUrl: null,
                    remoteFullFileUrl: null,
                    userContactId: null,
                    conversationId: conversationGroup.id,
                    // Add later
                    messageId: message.id,
                    userId: null,
                    fileSize: fileStat.size);

                if (type == 'Image') {
                  // Create thumbnail
                  File thumbnailImageFile;
                  if (!isStringEmpty(messageMultimedia.localFullFileUrl) &&
                      !isObjectEmpty(file)) {
                    thumbnailImageFile =
                        await imageService.getImageThumbnail(file);

                    if (!isObjectEmpty(thumbnailImageFile)) {
                      messageMultimedia.localThumbnailUrl =
                          thumbnailImageFile.path;
                    }
                  }
                }

                BlocProvider.of<MultimediaBloc>(context).add(AddMultimediaEvent(
                    multimedia: messageMultimedia,
                    callback: (Multimedia multimedia2) async {
                      Multimedia multimedia3 = await uploadMultimediaToCloud(
                          context, multimedia2, conversationGroup);

                      updateMultimediaContent(
                          context, multimedia3, message2, conversationGroup);
                    }));
              }
            }));
        setState(() {
          fileList.remove(file);
        });
      });
    }
  }

  Future<Multimedia> uploadMultimediaToCloud(BuildContext context,
      Multimedia multimedia, ConversationGroup conversationGroup) async {
    if (!isStringEmpty(multimedia.localFullFileUrl)) {
      multimedia.remoteFullFileUrl = await firebaseStorageService.uploadFile(
          multimedia.localFullFileUrl,
          conversationGroup.type,
          conversationGroup.id);
    }

    if (!isStringEmpty(multimedia.localThumbnailUrl)) {
      multimedia.remoteThumbnailUrl = await firebaseStorageService.uploadFile(
          multimedia.localThumbnailUrl,
          conversationGroup.type,
          conversationGroup.id);
    }

    return multimedia;
  }

  updateMultimediaContent(BuildContext context, Multimedia multimedia,
      ChatMessage message, ConversationGroup conversationGroup) async {
    BlocProvider.of<MultimediaBloc>(context).add(EditMultimediaEvent(
        multimedia: multimedia,
        callback: (Multimedia multimedia2) {
          if (!isObjectEmpty(multimedia2)) {
            WebSocketMessage webSocketMessage =
                WebSocketMessage(message: message, multimedia: multimedia);
            BlocProvider.of<WebSocketBloc>(context).add(
                SendWebSocketMessageEvent(
                    webSocketMessage: webSocketMessage,
                    callback: (bool done) {}));
          }
        }));
  }

  // TODO: Will think about last message is left or right to determine bottom margin between last message and textfield
//  isLastMessage(int index) {
//    if ((index > 0 && messageList != null &&
//        messageList[index - 1]['idFrom'] != id) || index == 0) {
//      return true;
//    } else {
//      return false;
//    }
//  }

  // Hide sticker or back
  Future<bool> onBackPress(BuildContext context) {
    if (isShowSticker) {
      setState(() {
        isShowSticker = false;
      });
    } else {
      Navigator.pop(context);
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

  goToLoginPage(BuildContext context) {
    BlocProvider.of<GoogleInfoBloc>(context).add(RemoveGoogleInfoEvent());
    Navigator.of(context)
        .pushNamedAndRemoveUntil('login_page', (Route<dynamic> route) => false);
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => false;
}
