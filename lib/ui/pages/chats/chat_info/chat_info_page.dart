import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:snschat_flutter/general/functions/validation_functions.dart';
import 'package:snschat_flutter/general/ui-component/custom_dialogs.dart';
import 'package:snschat_flutter/objects/conversationGroup/conversation_group.dart';
import 'package:snschat_flutter/objects/multimedia/multimedia.dart';
import 'package:snschat_flutter/objects/userContact/user_contact.dart';
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
  List<UserContact> conversationGroupMemberList = [];

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
                                  BlocProvider.of<ConversationGroupBloc>(context).add(EditConversationGroupEvent(
                                      conversationGroup: conversationGroup, callback: (ConversationGroup conversationGroup) {}));
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
                                  tag: conversationGroup.id + "1",
                                  child: imageService.loadFullImage(context, multimedia, conversationGroup.type));
                            }
                            return Hero(
                                tag: conversationGroup.id + "1", child: imageService.loadFullImage(context, null, conversationGroup.type));
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
                                    BlocProvider.of<ConversationGroupBloc>(context).add(EditConversationGroupEvent(
                                        conversationGroup: conversationGroup, callback: (ConversationGroup conversationGroup) {}));
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

                              conversationGroupMemberList = getConversationGroupMembers(context, userContactList, conversationGroup);

                              return showGroupMemberNumber(context, conversationGroupMemberList);
                            }
                            return showGroupMemberNumber(context, []);
                          },
                        ),
                        // showGroupMemberParticipants
                        BlocBuilder<UserContactBloc, UserContactState>(
                          builder: (BuildContext context, UserContactState userContactState) {
                            if (userContactState is UserContactsLoaded) {
                              return BlocBuilder<MultimediaBloc, MultimediaState>(
                                builder: (BuildContext context, MultimediaState multimediaState) {
                                  if (multimediaState is MultimediaLoaded) {
                                    List<Multimedia> conversationGroupMemberMultimediaList = [];
                                    conversationGroupMemberMultimediaList = multimediaState.multimediaList
                                        .where((Multimedia existingMultimedia) => conversationGroupMemberList
                                            .contains((UserContact userContact) => userContact.id == existingMultimedia.userContactId))
                                        .toList();
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

  List<UserContact> getConversationGroupMembers(
      BuildContext context, List<UserContact> userContactList, ConversationGroup conversationGroup) {
    List<UserContact> conversationGroupMemberList = [];
    List<String> notFoundMemberId = [];

    UserState userState = BlocProvider.of<UserBloc>(context).state;

    if (userState is UserLoaded) {
      for (String memberId in conversationGroup.memberIds) {
        bool userContactFound = false;
        for (UserContact existingUserContact in userContactList) {
          if (existingUserContact.id == memberId) {
            userContactFound = true;
            conversationGroupMemberList.add(existingUserContact);
          }
        }
        // Warning: Bad practice as it will cause more and more loop in this page
        // In case not found. Get the userContact from backend and add it into local DB. Then, BlocBuilder triggers and all userContacts will be found.
        if (!userContactFound) {
          notFoundMemberId.add(memberId);
        }
      }

      // Get userContacts from server
      for (String memberId in notFoundMemberId) {
        BlocProvider.of<UserContactBloc>(context).add(GetUserContactEvent(
            userContactId: memberId,
            callback: (UserContact userContact) {
              if (!isObjectEmpty(userContact)) {
                BlocProvider.of<UserContactBloc>(context)
                    .add(AddUserContactEvent(userContact: userContact, callback: (UserContact userContact2) {}));
              }
            }));
      }
    }

    return conversationGroupMemberList;
  }
}
