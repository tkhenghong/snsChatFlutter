import 'dart:async';
import 'dart:io';
import 'dart:io' show Platform;

import 'package:contacts_service/contacts_service.dart';
import 'package:emoji_picker/emoji_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:snschat_flutter/environments/development/variables.dart' as globals;
import 'package:snschat_flutter/general/index.dart';
import 'package:snschat_flutter/objects/models/index.dart';
import 'package:snschat_flutter/objects/rest/index.dart';
import 'package:snschat_flutter/service/index.dart';
import 'package:snschat_flutter/state/bloc/bloc.dart';
import 'package:snschat_flutter/ui/pages/index.dart';

class GroupNamePage extends StatefulWidget {
  final List<UserContact> selectedUserContacts;
  final List<Contact> selectedContacts;

  GroupNamePage({this.selectedUserContacts, this.selectedContacts});

  @override
  State<StatefulWidget> createState() {
    return new GroupNamePageState();
  }
}

class GroupNamePageState extends State<GroupNamePage> {
  bool imageExists = false;
  bool showEmojis = false;
  int imageThumbnailWidthSize = globals.imagePickerQuality;

  double header1 = globals.header1;
  double header2 = globals.header2;
  double header3 = globals.header3;
  double header4 = globals.header4;
  double header5 = globals.header5;

  int emojiRows = globals.emojiRows;
  int emojiColumns = globals.emojiColumns;
  int recommendedEmojis = globals.recommendedEmojis;

  double inkWellDefaultPadding = globals.inkWellDefaultPadding;

  PickedFile pickedFile;
  File imageFile;
  TextEditingController textEditingController;
  TextStyle circleAvatarTextStyle;
  FocusNode textFieldFocusNode = new FocusNode();
  final _formKey = GlobalKey<FormState>();

  UserContact ownUserContact;
  ConversationGroupBloc conversationGroupBloc;
  UnreadMessageBloc unreadMessageBloc;

  CustomFileService fileService = Get.find();
  FirebaseStorageService firebaseStorageService = Get.find();
  ImagePicker imagePicker = Get.find();

  @override
  void initState() {
    super.initState();
    textFieldFocusNode.addListener(onFocusChange);
    textEditingController = new TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    textEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    conversationGroupBloc = BlocProvider.of<ConversationGroupBloc>(context);
    unreadMessageBloc = BlocProvider.of<UnreadMessageBloc>(context);
    return mainBody();
  }

  Widget mainBody() {
    return GestureDetector(
      onTap: onGlobalFocusChange,
      child: Scaffold(
        appBar: topBar(),
        body: multiBlocListener(),
      ),
    );
  }

  Widget multiBlocListener() {
    return MultiBlocListener(listeners: [
      userContactBlocListener(),
    ], child: userContactBlocBuilder());
  }

  Widget userContactBlocListener() {
    return BlocListener<UserContactBloc, UserContactState>(
      listener: (context, userContactState) {
        if (userContactState is UserContactsLoaded) {
          ownUserContact = userContactState.ownUserContact;
        }
      },
    );
  }

  Widget userContactBlocBuilder() {
    return BlocBuilder<UserContactBloc, UserContactState>(
      builder: (context, userContactState) {
        if (userContactState is UserContactsLoading) {
          return showLoadingContactsPage();
        }

        if (userContactState is UserContactsLoaded) {
          if (!userContactState.ownUserContact.isNull) {
            ownUserContact = userContactState.ownUserContact;
            return WillPopScope(
              child: Stack(
                children: [body()],
              ),
              onWillPop: onBackPress,
            );
            // return body();
          }
        }

        return showErrorPage();
      },
    );
  }

  Widget showLoadingContactsPage() {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text('Loading contacts....'),
        SizedBox(
          height: Get.height * 0.1,
        ),
        CircularProgressIndicator(),
      ],
    ));
  }

  Widget showErrorPage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            'Error in loading this page. Please try again.',
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }

  Widget topBar() {
    return AppBar(
        title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: Get.height * 0.01),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'New Group',
                style: TextStyle(fontSize: header1),
              ),
              Text(
                'Add group name below',
                style: TextStyle(fontSize: header2, fontWeight: FontWeight.w300),
              )
            ],
          ),
        ),
        Tooltip(
          message: 'Next',
          child: InkWell(
            borderRadius: BorderRadius.circular(Get.width * 0.25),
            child: Padding(
              padding: EdgeInsets.all(inkWellDefaultPadding),
              child: Icon(Icons.check),
            ),
            onTap: () {
              createGroupConversation();
            },
          ),
        ),
      ],
    ));
  }

  Widget body() {
    return SafeArea(
        bottom: true,
        child: Container(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
                padding: EdgeInsets.only(top: Get.height * 0.05, left: Get.width * 0.05),
                child: Row(
                  children: [
                    groupPhotoCircleAvatar(),
                    groupNameTextField(),
                    emojiButton(),
                  ],
                )),
            groupMembersLabel(),
            groupMemberList(),
            showEmojis ? showStickerKeyboard() : Container()
          ],
        )));
  }

  Widget groupPhotoCircleAvatar() {
    return InkWell(
      onTap: () {
        //TODO: Add group photo from gallery/ take photo
        // showOptionsDialog(context);
        getImage();
      },
      customBorder: CircleBorder(),
      child: CircleAvatar(
        radius: Get.width * 0.1, // Testing
        // AssetImage('lib/ui/icons/default_blank_photo.png')
        backgroundImage: imageExists ? FileImage(imageFile, scale: 2.0) : AssetImage('lib/ui/images/blank_black.png'),
        child: !imageExists ? Icon(Icons.camera_alt) : Container(),
      ),
    );
  }

  Widget groupNameTextField() {
    return Form(
        key: _formKey,
        child: Container(
          width: Get.width * 0.6,
          padding: EdgeInsets.only(left: Get.width * 0.05),
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: textEditingController,
                focusNode: textFieldFocusNode,
                validator: validateGroupNameTextField,
                maxLength: 25,
                decoration: InputDecoration(
                  hintText: "Type group subject here...",
                  hintStyle: TextStyle(fontSize: header3),
                  contentPadding: EdgeInsets.only(bottom: Get.height * 0.01),
                  isDense: true,
                ),
              ),
              Text(
                "Provide a group subject and optional group icon.",
                style: TextStyle(color: Colors.grey, fontSize: header5),
              )
            ],
          ),
        ));
  }

  String validateGroupNameTextField(value) {
    if (value.isEmpty) {
      return 'Please enter your group name.';
    }

    return null;
  }

  Widget emojiButton() {
    return Column(
      children: [
        InkWell(
          // child: Icon(Icons.tag_faces),
          borderRadius: BorderRadius.circular(Get.width * 0.25),
          child: Padding(
            padding: EdgeInsets.all(inkWellDefaultPadding),
            child: Icon(Icons.tag_faces),
          ),
          onTap: () {
            onEmojiButtonClicked();
          },
        ),
        SizedBox(
          height: Get.height * 0.05,
        ),
      ],
    );
  }

  Widget showStickerKeyboard() {
    return EmojiPicker(
      rows: emojiRows,
      columns: emojiColumns,
      buttonMode: determinePlatform() ? ButtonMode.MATERIAL : ButtonMode.CUPERTINO,
      numRecommended: recommendedEmojis,
      onEmojiSelected: (emoji, category) {
        print('emoji: ' + emoji.emoji);
        textEditingController.text = textEditingController.text + emoji.emoji;
      },
    );
  }

  Widget groupMembersLabel() {
    return Container(
      padding: EdgeInsets.only(top: Get.height * 0.05, left: Get.width * 0.03, bottom: Get.height * 0.05),
      child: Text(
        "Group Members: " + widget.selectedUserContacts.length.toString(),
        style: TextStyle(color: Colors.grey, fontSize: header2),
        textAlign: TextAlign.left,
      ),
    );
  }

  Widget groupMemberList() {
    return Expanded(
      flex: 1,
      child: ListView(
        physics: BouncingScrollPhysics(),
        children: widget.selectedContacts.map((Contact contact) {
          return Card(
              elevation: 5.0,
              child: InkWell(
                onTap: () {},
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: Get.height * 0.02, horizontal: Get.width * 0.05),
                  child: Row(children: [
                    CircleAvatar(
                      backgroundImage: contact.avatar.isNotEmpty ? MemoryImage(contact.avatar) : AssetImage('lib/ui/images/blank_black.png'),
                      child: contact.avatar.isEmpty
                          ? Text(
                              contact.displayName[0],
                              style: circleAvatarTextStyle,
                            )
                          : Text(''),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[Text(contact.displayName, overflow: TextOverflow.ellipsis)],
                      ),
                    )
                  ]),
                ),
              ));
        }).toList(),
      ),
    );
  }

  createGroupConversation() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    showLoading('Loading group conversation....');
    List<String> memberUserContactIds = widget.selectedUserContacts.map((e) => e.id).toList();
    memberUserContactIds.add(ownUserContact.id); // Add yourself.

    conversationGroupBloc.add(CreateConversationGroupEvent(
        createConversationGroupRequest: CreateConversationGroupRequest(
          name: textEditingController.text,
          conversationGroupType: ConversationGroupType.Group,
          description: null,
          memberIds: memberUserContactIds,
          adminMemberIds: [ownUserContact.id],
        ),
        callback: (ConversationGroup conversationGroup) {
          if (!conversationGroup.isNull) {
            Get.back(); // Close select phone number pop up.
            Get.back(); // Close loading indicator.
            if (!conversationGroup.isNull) {
              unreadMessageBloc.add(GetUnreadMessageByConversationGroupIdEvent(conversationGroupId: conversationGroup.id));
              goToChatRoomPage(conversationGroup);
            }
          }
        }));
  }

  goToChatRoomPage(ConversationGroup conversationGroup) {
    // Go to chat room page
    Navigator.pop(context); //pop loading dialog
    Navigator.of(context).pushNamedAndRemoveUntil('tabs_page', (Route<dynamic> route) => false);
    // Navigator.of(context).pushReplacementNamed(ChatRoomPage(conversationGroup));
    Navigator.push(context, MaterialPageRoute(builder: ((context) => ChatRoomPage(conversationGroup.id))));
  }

  /// Get image from Image Picker.
  Future getImage() async {
    pickedFile = await imagePicker.getImage(source: ImageSource.camera, imageQuality: imageThumbnailWidthSize);

    if (!pickedFile.isNullOrBlank) {
      setState(() {
        imageFile = File(pickedFile.path);
        imageExists = true;
      });
    } else {
      imageFile = null;
      imageExists = false;
    }
  }

  onEmojiButtonClicked() {
    textFieldFocusNode.unfocus(); // Hide text field keyboard
    setState(() {
      showEmojis = !showEmojis;
    });
  }

  /// Related to WillPopScope and EmojiPicker
  void onFocusChange() {
    if (textFieldFocusNode.hasFocus) {
      // Hide sticker/emojis when keyboard appear
      setState(() {
        showEmojis = false;
      });
    }
  }

  void onGlobalFocusChange() {
    FocusScope.of(context).requestFocus(new FocusNode());
    // Hide sticker/emojis when keyboard appear
    setState(() {
      showEmojis = false;
    });
  }

  /// Register listener when the back button is pressed.
  Future<bool> onBackPress() {
    if (showEmojis) {
      setState(() {
        showEmojis = false;
      });
    } else {
      Navigator.pop(context);
    }

    return Future.value(false);
  }

  // true: Android, Fuchsia, Linux, Windows
  // false: iOS, MacOS
  bool determinePlatform() {
    if (Platform.isAndroid || Platform.isFuchsia || Platform.isLinux || Platform.isWindows) {
      return true;
    }

    if (Platform.isIOS || Platform.isMacOS) {
      return false;
    }

    return true;
  }
}
