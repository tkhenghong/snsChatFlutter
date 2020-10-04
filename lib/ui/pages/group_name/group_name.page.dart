import 'dart:async';
import 'dart:io';

import 'package:contacts_service/contacts_service.dart';
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
  int imageThumbnailWidthSize = globals.imagePickerQuality;

  double header1 = globals.header1;
  double header2 = globals.header2;
  double inkWellDefaultPadding = globals.inkWellDefaultPadding;

  PickedFile pickedFile;
  File imageFile;
  TextEditingController textEditingController;
  TextStyle circleAvatarTextStyle;
  BorderRadius circleAvatarCircleRadius = BorderRadius.circular(20.0);

  UserContact ownUserContact;
  ConversationGroupBloc conversationGroupBloc;

  CustomFileService fileService = Get.find();
  ImageService imageService = Get.find();
  FirebaseStorageService firebaseStorageService = Get.find();
  ImagePicker imagePicker = Get.find();

  @override
  void initState() {
    super.initState();
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
    return mainBody();
  }

  Widget mainBody() {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(appBar: topBar(), body: multiBlocListener()),
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
          if (!isObjectEmpty(userContactState.ownUserContact)) {
            ownUserContact = userContactState.ownUserContact;
            return body();
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
    return Container(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(top: 50.0, left: 20.0),
          child: Row(
            children: <Widget>[
              groupPhotoCircleAvatar(),
              groupNameTextField(),
              emojiButton(),
            ],
          ),
        ),
        groupMembersLabel(),
        groupMemberList(),
      ],
    ));
  }

  Widget groupPhotoCircleAvatar() {
    return Container(
        height: 65.0,
        width: 65.0,
        child: InkWell(
          onTap: () {
            //TODO: Add group photo from gallery/ take photo
            // showOptionsDialog(context);
            getImage();
          },
          borderRadius: circleAvatarCircleRadius,
          child: CircleAvatar(
            radius: Get.width * 0.25, // Testing
            // AssetImage('lib/ui/icons/default_blank_photo.png')
            // backgroundImage: FileImage(imageFile),
            child: !imageExists
                ? Icon(Icons.camera_alt)
                : ClipRRect(
                    borderRadius: circleAvatarCircleRadius,
                    child: Image.file(
                      imageFile,
                      fit: BoxFit.cover,
                    ),
                  ),
          ),
        ));
  }

  Widget groupNameTextField() {
    return Container(
      width: 230.0,
      padding: EdgeInsets.only(left: 10.0),
      child: Column(
        children: <Widget>[
          TextField(
            controller: textEditingController,
            decoration: InputDecoration(hintText: "Type group subject here..."),
          ),
          Text(
            "Provide a group subject and optional group icon.",
            style: TextStyle(color: Colors.grey, fontSize: 12.0),
          )
        ],
      ),
    );
  }

  // TODO: Show a menu that show a list of custom icons.
  Widget emojiButton() {
    return Icon(Icons.tag_faces);
  }

  Widget groupMembersLabel() {
    return Container(
      padding: EdgeInsets.only(top: Get.height * 0.05, left: Get.width * 0.03, bottom: Get.height * 0.05),
      child: Text(
        "Group Members: " + widget.selectedUserContacts.length.toString(),
        style: TextStyle(color: Colors.grey, fontSize: 14.0),
        textAlign: TextAlign.left,
      ),
    );
  }

  Widget groupMemberList() {
    return Container(
      height: Get.height * 0.4,
      child: ListView(
        physics: BouncingScrollPhysics(),
        children: widget.selectedContacts.map((Contact contact) {
          return Card(
              elevation: 5.0,
              child: InkWell(
                onTap: () {},
                child: Container(
                  padding: EdgeInsets.all(10.0),
                  child: Row(children: [
                    CircleAvatar(
                      backgroundImage: contact.avatar.isNotEmpty ? MemoryImage(contact.avatar) : NetworkImage(''),
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

  // TODO: Conversation Group Creation into BLOC, can be merged with Group & Broadcast
  createGroupConversation() async {
    widget.selectedUserContacts;
    widget.selectedContacts;

    conversationGroupBloc.add(CreateConversationGroupEvent(
        createConversationGroupRequest: CreateConversationGroupRequest(
          name: textEditingController.text,
          conversationGroupType: ConversationGroupType.Group,
          description: null,
          memberIds: widget.selectedUserContacts.map((e) => e.id).toList(),
          adminMemberIds: [ownUserContact.id],
        ),
        callback: (ConversationGroup conversationGroup) {
          if (!isObjectEmpty(conversationGroup)) {
            Get.back(); // Close select phone number pop up
            goToChatRoomPage(conversationGroup);
          }
        }));

    // TODO: create loading that cannot be dismissed to prevent exit, and make it faster
    // showLoading("Creating conversation...");

    // UserState userState = BlocProvider.of<UserBloc>(context).state;
    // if (userState is UserLoaded) {
    //   User currentUser = userState.user;
    //
    //   ConversationGroup conversationGroup = new ConversationGroup(
    //     id: null,
    //     creatorUserId: currentUser.id,
    //     createdDate: new DateTime.now(),
    //     name: textEditingController.text,
    //     conversationGroupType: ConversationGroupType.Group,
    //     block: false,
    //     description: '',
    //     adminMemberIds: [],
    //     // Add later
    //     memberIds: [],
    //     // Add later
    //     // memberIds put UserContact.id. NOT User.id
    //     notificationExpireDate: null,
    //   );
    //
    //   UnreadMessage unreadMessage = UnreadMessage(
    //     id: null,
    //     conversationId: null,
    //     count: 0,
    //     date: DateTime.now(),
    //     lastMessage: '${userState.user.displayName.toString()} has created the group.',
    //     userId: currentUser.id,
    //   );
    //   File copiedImageFile;
    //   if (!isObjectEmpty(imageFile) && !isStringEmpty(imageFile.path)) {
    //     // Copy full file to our directory. Create thumbnail of this image and copy this to our directory as well.
    //     copiedImageFile = await fileService.copyFile(imageFile, "ApplicationDocumentDirectory");
    //   }
    //
    //   // Multimedia for group chat
    //   Multimedia groupMultimedia = Multimedia(
    //       id: null,
    //       localFullFileUrl: isObjectEmpty(copiedImageFile) ? null : copiedImageFile.path,
    //       localThumbnailUrl: null,
    //       remoteThumbnailUrl: null,
    //       remoteFullFileUrl: null,
    //       userContactId: null,
    //       conversationId: null,
    //       // Add later
    //       messageId: null,
    //       userId: null);
    //
    //   // 2. Upload UserContactList
    //   // Note: Backend already helped you to check any duplicates of the same UserContact
    //   List<UserContact> userContactList = [];
    //
    //   UserContact yourOwnUserContact = UserContact(
    //     id: null,
    //     userIds: [currentUser.id],
    //     userId: currentUser.id,
    //     displayName: currentUser.displayName,
    //     realName: currentUser.realName,
    //     block: false,
    //     lastSeenDate: new DateTime.now(),
    //     // make unknown time, let server decide
    //     mobileNo: currentUser.mobileNo,
    //   );
    //
    //   userContactList.add(yourOwnUserContact);
    //
    //   contactList.forEach((contact) {
    //     List<String> primaryNo = [];
    //     if (contact.phones.length > 0) {
    //       contact.phones.forEach((phoneNo) {
    //         primaryNo.add(phoneNo.value);
    //       });
    //     } else {
    //       // No phone number and the display name is the phone number itself
    //       // Reason: No contact.phones when the mobile number doesn't have a name on it
    //       String mobileNo = contact.displayName.replaceAll(new RegExp(r"\s+\b|\b\s|\s|\b"), "");
    //       primaryNo.add(mobileNo);
    //     }
    //
    //     UserContact userContact = UserContact(
    //       id: null,
    //       // So this contact number is mine. Later send it to backend and merge with other UserContact who got the same number
    //       userIds: [currentUser.id],
    //       displayName: contact.displayName,
    //       realName: contact.displayName,
    //       block: false,
    //       lastSeenDate: new DateTime.now(),
    //     );
    //
    //     userContact.mobileNo = primaryNo.length == 0 ? "" : primaryNo[0];
    //
    //     // If got Malaysia number
    //     if (primaryNo[0].contains("+60")) {
    //       print("If Malaysian Number: ");
    //       String trimmedString = primaryNo[0].substring(3);
    //       print("trimmedString: " + trimmedString);
    //     }
    //
    //     userContactList.add(userContact);
    //   });
    //
    //   // TODO: Remove AddMultipleUserContactEvent
    //   BlocProvider.of<UserContactBloc>(context).add(AddMultipleUserContactEvent(
    //       userContactList: userContactList,
    //       callback: (List<UserContact> newUserContactList) {
    //         if ((contactList.length != newUserContactList.length - 1) || newUserContactList.length == 0) {
    //           // event.contactList doesn't include yourself, so newUserContactList.length - 1 OR Any UserContact is not added into the list (means not uploaded successfully)
    //           // That means some UseContact are not uploaded into the REST
    //           Navigator.pop(context);
    //           showToast('Unable to upload your member list. Please try again.', Toast.LENGTH_SHORT);
    //         } else {
    //           // Give the list of UserContactIds to memberIds of ConversationGroup
    //           conversationGroup.memberIds = newUserContactList.map((newUserContact) => newUserContact.id).toList();
    //
    //           // Add your own userContact's ID as admin by find the one that has the same mobile number in the userContactList
    //           conversationGroup.adminMemberIds.add(newUserContactList.firstWhere((UserContact newUserContact) => newUserContact.mobileNo == currentUser.mobileNo, orElse: () => null).id);
    //
    //           BlocProvider.of<ConversationGroupBloc>(context).add(AddConversationGroupEvent(
    //               conversationGroup: conversationGroup,
    //               callback: (ConversationGroup conversationGroup2) async {
    //                 if (!isObjectEmpty(conversationGroup2)) {
    //                   groupMultimedia.conversationId = unreadMessage.conversationId = conversationGroup2.id;
    //                   unreadMessage.userId = conversationGroup2.creatorUserId;
    //                   // TODO: Removed UnreadMessage, should be created from backend
    //                   addMultimedia(groupMultimedia, !isObjectEmpty(copiedImageFile) ? copiedImageFile : null, conversationGroup2, context);
    //                 } else {
    //                   Navigator.pop(context);
    //                   Fluttertoast.showToast(msg: 'Unable to create conversation group. Please try again.', toastLength: Toast.LENGTH_SHORT);
    //                 }
    //               }));
    //         }
    //       }));
    // }
  }

  // addMultimedia(Multimedia groupMultimedia, File imageFile, ConversationGroup conversationGroup, BuildContext context) async {
  //   // 4. Upload Group Multimedia
  //   // Create thumbnail before upload
  //   File thumbnailImageFile;
  //   if (!isStringEmpty(groupMultimedia.localFullFileUrl) && !isObjectEmpty(imageFile)) {
  //     thumbnailImageFile = await imageService.getImageThumbnail(imageFile);
  //   }
  //
  //   if (!isObjectEmpty(thumbnailImageFile)) {
  //     groupMultimedia.localThumbnailUrl = thumbnailImageFile.path;
  //   }
  //
  //   BlocProvider.of<MultimediaBloc>(context).add(AddMultimediaEvent(
  //       multimedia: groupMultimedia,
  //       callback: (Multimedia multimedia2) async {
  //         updateMultimediaContent(context, multimedia2, conversationGroup);
  //       }));
  // }

  // Actually shouldn't be here
  // updateMultimediaContent(BuildContext context, Multimedia multimedia, ConversationGroup conversationGroup) async {
  //   Navigator.pop(context); // close create conversation group loading
  //   showLoading('Uploading group photo...');
  //   String remoteUrl = await firebaseStorageService.uploadFile(multimedia.localFullFileUrl, conversationGroup.conversationGroupType, conversationGroup.id);
  //   String remoteThumbnailUrl = await firebaseStorageService.uploadFile(multimedia.localThumbnailUrl, conversationGroup.conversationGroupType, conversationGroup.id);
  //
  //   if (!isStringEmpty(remoteUrl)) {
  //     multimedia.remoteFullFileUrl = remoteUrl;
  //   }
  //
  //   if (!isStringEmpty(remoteThumbnailUrl)) {
  //     multimedia.remoteThumbnailUrl = remoteThumbnailUrl;
  //   }
  //
  //   BlocProvider.of<MultimediaBloc>(context).add(EditMultimediaEvent(
  //       multimedia: multimedia,
  //       callback: (Multimedia multimedia2) {
  //         if (!isObjectEmpty(multimedia2)) {
  //           // Go to chat room page
  //           Navigator.pop(context); //pop loading dialog
  //           Navigator.of(context).pushNamedAndRemoveUntil('tabs_page', (Route<dynamic> route) => false);
  //           Navigator.push(context, MaterialPageRoute(builder: ((context) => ChatRoomPage(conversationGroup))));
  //         }
  //       }));
  // }

  goToChatRoomPage(ConversationGroup conversationGroup) {
    // Go to chat room page
    Navigator.pop(context); //pop loading dialog
    Navigator.of(context).pushNamedAndRemoveUntil('tabs_page', (Route<dynamic> route) => false);
    // Navigator.of(context).pushReplacementNamed(ChatRoomPage(conversationGroup));
    Navigator.push(context, MaterialPageRoute(builder: ((context) => ChatRoomPage(conversationGroup))));
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
}
