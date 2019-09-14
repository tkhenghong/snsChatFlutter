import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snschat_flutter/general/functions/repeating_functions.dart';
import 'package:snschat_flutter/general/functions/validation_functions.dart';
import 'package:snschat_flutter/general/ui-component/custom_dialogs.dart';
import 'package:snschat_flutter/objects/chat/conversation_group.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:snschat_flutter/objects/multimedia/multimedia.dart';
import 'package:snschat_flutter/service/file/FileService.dart';
import 'package:snschat_flutter/state/bloc/WholeApp/WholeAppBloc.dart';
import 'package:palette_generator/palette_generator.dart';

class ChatInfoPage extends StatefulWidget {
  ConversationGroup _conversationGroup;

  ChatInfoPage([this._conversationGroup]); //do not final

  @override
  State<StatefulWidget> createState() {
    return new ChatInfoPageState();
  }
}

class ChatInfoPageState extends State<ChatInfoPage> {
  TextEditingController textEditingController;
  WholeAppBloc wholeAppBloc;
  File imageFile;
  FileService fileService = FileService();
  bool messageListDone;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    textEditingController = new TextEditingController();
    textEditingController.text = widget._conversationGroup.name;
  }

  @override
  Widget build(BuildContext context) {
    final WholeAppBloc _wholeAppBloc = BlocProvider.of<WholeAppBloc>(context);
    wholeAppBloc = _wholeAppBloc;
    print("widget._conversation.id: " + widget._conversationGroup.id);
    imageFile = File("lib/ui/images/group2013.jpg");

    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Material(
          color: Colors.white,
          child: CustomScrollView(
            physics: BouncingScrollPhysics(),
            slivers: <Widget>[
              SliverAppBar(
                floating: true,
                pinned: true,
                titleSpacing: 0.0,
                expandedHeight: 250.0,
                flexibleSpace: FlexibleSpaceBar(
                    title: Hero(
                      tag: widget._conversationGroup.name,
                      child: FlatButton(
                        onPressed: () async {
                          CustomDialogs customDialog = new CustomDialogs(
                              context: context,
                              title: "Edit Group Name",
                              description:
                                  "Edit the group name below. Press OK to save.",
                              value: widget._conversationGroup.name);
                          String groupName =
                              await customDialog.showConfirmationDialog();
                          if (widget._conversationGroup.name != groupName) {
                            widget._conversationGroup.name = groupName;
                          }
                        },
                        child: Text(
                          widget._conversationGroup.name,
                          style: TextStyle(color: Colors.white),
                          overflow: TextOverflow.fade,
                          softWrap: true,
                        ),
                      ),
                    ),
                    background: Hero(
                      tag: widget._conversationGroup.id,
                      // TODO: Need to change it to Future
//                      child: groupPhoto.localFullFileUrl.length != 0
//                          ? Image.file(imageFile)
//                          : Image.asset(
//                              'lib/ui/icons/default_group_photo.jpg',
//                              fit: BoxFit.cover,
//                            ),
                      child: Image.asset(fileService.getDefaultImagePath(widget._conversationGroup.type)),
                    )),
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
                          onTap: () {
                            print("Tapped.");
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
                                  isStringEmpty(widget._conversationGroup.description)
                                      ? "Add Group description"
                                      : widget._conversationGroup.description,
                                  style: TextStyle(
                                      fontSize: 17.0, color: Colors.black54),
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
                                  widget._conversationGroup.notificationExpireDate ==
                                          0
                                      ? "On"
                                      : "Off",
                                  style: TextStyle(
                                      fontSize: 17.0, color: Colors.black54),
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
                            padding: EdgeInsets.only(
                                left: 10.0, top: 10.0, right: 5.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                    padding: EdgeInsets.only(top: 5.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
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
                            padding: EdgeInsets.only(
                                left: 10.0, top: 10.0, right: 5.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                    padding: EdgeInsets.only(top: 5.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
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
                  Material(
                      color: Colors.white,
                      child: Container(
                        height: 60.0,
                        child: InkWell(
                          onTap: () {
                            print("Tapped.");
                          },
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: 10.0, top: 10.0, right: 5.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                    padding: EdgeInsets.only(top: 5.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Icon(Icons.people),
                                        Text(
                                          "Group members",
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
                            padding: EdgeInsets.only(
                                left: 10.0, top: 10.0, right: 5.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                    padding: EdgeInsets.only(top: 5.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Icon(Icons.exit_to_app,
                                            color: Colors.red),
                                        Text(
                                          "Exit group",
                                          style: TextStyle(
                                              fontSize: 17.0,
                                              color: Colors.red),
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
                            padding: EdgeInsets.only(
                                left: 10.0, top: 10.0, right: 5.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                    padding: EdgeInsets.only(top: 5.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Icon(Icons.report, color: Colors.red),
                                        Text(
                                          "Report group",
                                          style: TextStyle(
                                              fontSize: 17.0,
                                              color: Colors.red),
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
          )),
    );
  }
}
