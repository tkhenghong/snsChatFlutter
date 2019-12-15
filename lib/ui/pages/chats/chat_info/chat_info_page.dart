import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snschat_flutter/general/functions/validation_functions.dart';
import 'package:snschat_flutter/general/ui-component/custom_dialogs.dart';
import 'package:snschat_flutter/objects/conversationGroup/conversation_group.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:snschat_flutter/objects/multimedia/multimedia.dart';
import 'package:snschat_flutter/objects/userContact/userContact.dart';
import 'package:snschat_flutter/service/file/FileService.dart';
import 'package:snschat_flutter/service/image/ImageService.dart';
import 'package:snschat_flutter/state/bloc/bloc.dart';

class ChatInfoPage extends StatefulWidget {
  final ConversationGroup _conversationGroup;

  ChatInfoPage([this._conversationGroup]); //do not final

  @override
  State<StatefulWidget> createState() {
    return new ChatInfoPageState();
  }
}

class ChatInfoPageState extends State<ChatInfoPage> {
  bool messageListDone;

  TextEditingController textEditingController;
  ScrollController scrollController;

  File imageFile;
  FileService fileService = FileService();
  ImageService imageService = ImageService();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    textEditingController = new TextEditingController();
    scrollController = new ScrollController();
    textEditingController.text = widget._conversationGroup.name;
  }

  @override
  Widget build(BuildContext context) {
    Color textSelectionColor = Theme.of(context).textSelectionColor;

//    Multimedia multimedia = wholeAppBloc.findMultimediaByConversationId(widget._conversationGroup.id);
//    List<UserContact> userContactList = wholeAppBloc.getUserContactsByConversationId(widget._conversationGroup.id);
//    List<Multimedia> multimediaList =
//        userContactList.map((UserContact userContact) => wholeAppBloc.findMultimediaByUserContactId(userContact.id)).toList();
//
//    print("userContactList.length:" + userContactList.length.toString());
//    print("multimediaList.length:" + multimediaList.length.toString());
//
//    userContactList.forEach((UserContact userContact) {
//      if (!isObjectEmpty(userContact)) {
//        print("UserContact");
//        print("userContact.id: " + userContact.id.toString());
//        print("userContact.mobileNo: " + userContact.mobileNo.toString());
//        print("userContact.block: " + userContact.block.toString());
//        print("userContact.displayName: " + userContact.displayName.toString());
//        print("userContact.realName: " + userContact.realName.toString());
//        print("userContact.lastSeenDate: " + userContact.lastSeenDate.toString());
//        print("userContact.multimediaId: " + userContact.multimediaId.toString());
//      }
//    });
//
//    multimediaList.forEach((Multimedia multimedia) {
//      if (!isObjectEmpty(multimedia)) {
//        print("Multimedia");
//        print("multimedia.id: " + multimedia.id.toString());
//        print("multimedia.userContactId: " + multimedia.userContactId.toString());
//        print("multimedia.userId: " + multimedia.userId.toString());
//        print("multimedia.conversationId: " + multimedia.conversationId.toString());
//        print("multimedia.messageId: " + multimedia.messageId.toString());
//      }
//    });

    return MultiBlocListener(
      listeners: [],
      child: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Material(
          color: Colors.white,
          child: BlocBuilder<ConversationGroupBloc, ConversationGroupState>(
            builder: (BuildContext context, ConversationGroupState conversationGroupState) {
              if (conversationGroupState is ConversationGroupsLoaded) {
                List<ConversationGroup> conversationGroupList = conversationGroupState.conversationGroupList;

                ConversationGroup conversationGroup = conversationGroupList.firstWhere(
                    (ConversationGroup existingConversationGroup) => existingConversationGroup.id == widget._conversationGroup.id,
                    orElse: null);
                return CustomScrollView(
                  physics: BouncingScrollPhysics(),
                  slivers: <Widget>[
                    SliverAppBar(
                      floating: true,
                      pinned: true,
                      expandedHeight: 250.0,
                      flexibleSpace: FlexibleSpaceBar(
                        title: Hero(
                          tag: conversationGroup.id,
                          child: FlatButton(
                              onPressed: () async {
                                CustomDialogs customDialog = new CustomDialogs(
                                    context: context,
                                    title: "Edit Group Name",
                                    description: "Edit the group name below. Press OK to save.",
                                    value: conversationGroup.name);
                                String groupName = await customDialog.showConfirmationDialog();
                                if (conversationGroup.name != groupName) {
                                  conversationGroup.name = groupName;
                                  BlocProvider.of<ConversationGroupBloc>(context).add(EditConversationGroupEvent(conversationGroup: conversationGroup, callback: (ConversationGroup conversationGroup) {}));
                                }
                              },
                              child: Container(
                                padding: EdgeInsetsDirectional.only(top: 25.0),
                                child: Text(
                                  conversationGroup.name,
                                  style: TextStyle(color: Colors.white, fontSize: 18.0),
                                  overflow: TextOverflow.fade,
                                  softWrap: true,
                                ),
                              )),
                        ),
                        background: BlocBuilder<MultimediaBloc, MultimediaState>(
                          builder: (BuildContext context, MultimediaState multimediaState) {
                            if (multimediaState is MultimediaLoaded) {
                              List<Multimedia> multimediaList = multimediaState.multimediaList;

                              Multimedia multimedia = multimediaList.firstWhere((Multimedia existingMultimedia) =>
                                  existingMultimedia.conversationId.toString() == widget._conversationGroup.id &&
                                  isStringEmpty(existingMultimedia.messageId));

                              return Hero(
                                  tag: conversationGroup.id + "1", child: imageService.loadFullImage(multimedia, conversationGroup.type));
                            }
                            return Hero(tag: conversationGroup.id + "1", child: imageService.loadFullImage(null, conversationGroup.type));
                          },
                        ),
                      ),
                      actions: <Widget>[
                        IconButton(
                            icon: Icon(Icons.share),
                            onPressed: () {
                              Fluttertoast.showToast(
                                  msg: "Shared!",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIos: 1,
                                  fontSize: 16.0);
                            })
                      ],
                    ),
                    SliverList(
                      delegate: SliverChildListDelegate([
                        Material(
                            color: Colors.white,
                            child: Container(
                              height: 60.0,
                              child: InkWell(
                                onTap: () async {
                                  CustomDialogs customDialog = new CustomDialogs(
                                      context: context,
                                      title: "Edit Group Description",
                                      description: "Edit the group description below. Press OK to save.",
                                      value: conversationGroup.description);
                                  String groupDescription = await customDialog.showConfirmationDialog();
                                  if (conversationGroup.description != groupDescription) {
                                    conversationGroup.description = groupDescription;
                                    BlocProvider.of<ConversationGroupBloc>(context).add(EditConversationGroupEvent(conversationGroup: conversationGroup, callback: (ConversationGroup conversationGroup) {}));
                                  }
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(left: 10.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.only(top: 5.0),
                                      ),
                                      Text(
                                        "Group description",
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 5.0),
                                      ),
                                      Text(
                                        isStringEmpty(conversationGroup.description)
                                            ? "Add Group description"
                                            : conversationGroup.description,
                                        style: TextStyle(
                                          fontSize: 17.0,
                                          color: textSelectionColor,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(bottom: 5.0),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )),
                        Material(
                            color: Colors.white,
                            child: Container(
                              height: 60.0,
                              child: InkWell(
                                onTap: () {
                                  print("Tapped.");
                                  // TODO: Set notificationExpireDate
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(left: 10.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.only(top: 5.0),
                                      ),
                                      Text(
                                        "Notifications",
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 5.0),
                                      ),
                                      Text(
                                        conversationGroup.notificationExpireDate == 0 ? "On" : "Off",
                                        style: TextStyle(fontSize: 17.0, color: textSelectionColor),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(bottom: 5.0),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )),
                        Material(
                            color: Colors.white,
                            child: Container(
                              height: 60.0,
                              child: InkWell(
                                onTap: () {
                                  print("Tapped.");
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(left: 10.0, top: 10.0, right: 5.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                          padding: EdgeInsets.only(top: 5.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Text(
                                                "Favourites⭐",
                                                style: TextStyle(fontSize: 17.0),
                                              ),
                                              Icon(Icons.keyboard_arrow_right)
                                            ],
                                          )),
                                      Padding(
                                        padding: EdgeInsets.only(bottom: 5.0),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )),
                        Material(
                            color: Colors.white,
                            child: Container(
                              height: 60.0,
                              child: InkWell(
                                onTap: () {
                                  print("Tapped.");
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(left: 10.0, top: 10.0, right: 5.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                          padding: EdgeInsets.only(top: 5.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Text(
                                                "Media",
                                                style: TextStyle(fontSize: 17.0),
                                              ),
                                              Icon(Icons.keyboard_arrow_right)
                                            ],
                                          )),
                                      Padding(
                                        padding: EdgeInsets.only(bottom: 5.0),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )),
                        // showGroupMemberNumber
                        BlocBuilder<UserContactBloc, UserContactState>(
                          builder: (BuildContext context, UserContactState userContactState) {
                            if (userContactState is UserContactsLoaded) {
                              List<UserContact> userContactList = userContactState.userContactList;
                              List<UserContact> conversationGroupMemberList = userContactList.where((UserContact existingUserContact) =>
                                  conversationGroup.memberIds.contains((String memberId) => existingUserContact.id == memberId));
                              return showGroupMemberNumber(context, conversationGroupMemberList);
                            }
                            return showGroupMemberNumber(context, []);
                          },
                        ),
                        // showGroupMemberParticipants
                        BlocBuilder<UserContactBloc, UserContactState>(
                          builder: (BuildContext context, UserContactState userContactState) {
                            if (userContactState is UserContactsLoaded) {
                              List<UserContact> userContactList = userContactState.userContactList;
                              List<UserContact> conversationGroupMemberList = userContactList.where((UserContact existingUserContact) =>
                                  conversationGroup.memberIds.contains((String memberId) => existingUserContact.id == memberId)).toList();
                              return BlocBuilder<MultimediaBloc, MultimediaState>(
                                builder: (BuildContext context, MultimediaState multimediaState) {
                                  if (multimediaState is MultimediaLoaded) {
                                    List<Multimedia> conversationGroupMemberMultimediaList = [];
                                    conversationGroupMemberMultimediaList = multimediaState.multimediaList.where(
                                        (Multimedia existingMultimedia) => conversationGroupMemberList
                                            .contains((UserContact userContact) => userContact.id == existingMultimedia.userContactId)).toList();
                                    return showGroupMemberParticipants(
                                        context, conversationGroupMemberList, conversationGroupMemberMultimediaList);
                                  }

                                  return showGroupMemberParticipants(context, conversationGroupMemberList, []);
                                },
                              );
                            }

                            return showGroupMemberParticipants(context, [], []);
                          },
                        ),

                        Material(
                            color: Colors.white,
                            child: Container(
                              height: 60.0,
                              child: InkWell(
                                onTap: () {
                                  print("Tapped.");
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(left: 10.0, top: 10.0, right: 5.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                          padding: EdgeInsets.only(top: 5.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: <Widget>[
                                              Icon(Icons.exit_to_app, color: Colors.red),
                                              Text(
                                                "Exit group",
                                                style: TextStyle(fontSize: 17.0, color: Colors.red),
                                              ),
                                            ],
                                          )),
                                      Padding(
                                        padding: EdgeInsets.only(bottom: 5.0),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )),
                        Material(
                            color: Colors.white,
                            child: Container(
                              height: 60.0,
                              child: InkWell(
                                onTap: () {
                                  print("Tapped.");
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(left: 10.0, top: 10.0, right: 5.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                          padding: EdgeInsets.only(top: 5.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: <Widget>[
                                              Icon(Icons.report, color: Colors.red),
                                              Text(
                                                "Report group",
                                                style: TextStyle(fontSize: 17.0, color: Colors.red),
                                              ),
                                            ],
                                          )),
                                      Padding(
                                        padding: EdgeInsets.only(bottom: 5.0),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )),
                      ]),
                    ),
                  ],
                );
              }
              return Center(
                child: Text('Loading....'),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget showGroupMemberNumber(BuildContext context, List<UserContact> userContactList) {
    return Material(
      color: Colors.white,
      child: Container(
        height: 60.0,
        child: Padding(
          padding: EdgeInsets.only(left: 10.0, top: 10.0, right: 5.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(top: 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Icon(Icons.people),
                      Text(
                        "Group members: " + userContactList.length.toString() + " participants",
                        style: TextStyle(fontSize: 17.0),
                      ),
                    ],
                  )),
              Padding(
                padding: EdgeInsets.only(bottom: 5.0),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget showGroupMemberParticipants(BuildContext context, List<UserContact> userContactList, List<Multimedia> multimediaList) {
    // TODO: Make it become ExpansionTile
    return Container(
      height: 300.0,
      child: ListView(
        controller: scrollController,
        children: userContactList
            .map((UserContact userContact) => Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      ListTile(
                        title: Text(
                          userContact.displayName,
                          softWrap: true,
                        ),
                        subtitle: Text(
                          'Hey There! I am using PocketChat.',
                          softWrap: true,
                        ),
                        onTap: () {
                          print("Tapped!");
                        },
                        leading: imageService.loadImageThumbnailCircleAvatar(null, "UserContact", context),
//                                        leading: imageService.loadImageThumbnailCircleAvatar(
//                                            multimediaList.firstWhere(
//                                                (Multimedia userContactMultimedia) =>
//                                                    !isObjectEmpty(userContactMultimedia) &&
//                                                    userContactMultimedia.userContactId == userContact.id,
//                                                orElse: null),
//                                            "UserContact"),
                      )
                    ],
                  ),
                ))
            .toList(),
      ),
    );
  }
}
