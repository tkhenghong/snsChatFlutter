import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:snschat_flutter/general/index.dart';
import 'package:snschat_flutter/objects/models/index.dart';
import 'package:snschat_flutter/objects/rest/index.dart';
import 'package:snschat_flutter/service/index.dart';
import 'package:snschat_flutter/state/bloc/index.dart';

class ChatInfoPage extends StatefulWidget {
  final String conversationGroupId;

  ChatInfoPage([this.conversationGroupId]); //do not final

  @override
  State<StatefulWidget> createState() {
    return new ChatInfoPageState();
  }
}

class ChatInfoPageState extends State<ChatInfoPage> {
  EnvironmentGlobalVariables env = Get.find();

  WebSocketBloc webSocketBloc;
  ConversationGroupBloc conversationGroupBloc;

  ConversationGroup currentConversationGroup;
  List<UserContact> conversationGroupMemberList = [];

  TextEditingController conversationGroupNameTextController;
  ScrollController scrollController;

  CustomFileService fileService = Get.find();

  Color whiteColor = Colors.white;

  @override
  void initState() {
    super.initState();
    conversationGroupNameTextController = new TextEditingController();
    scrollController = new ScrollController();
  }

  @override
  void dispose() {
    super.dispose();
    webSocketBloc.close();
  }

  @override
  Widget build(BuildContext context) {
    webSocketBloc = BlocProvider.of<WebSocketBloc>(context);
    conversationGroupBloc = BlocProvider.of<ConversationGroupBloc>(context);

    return multiBlocListeners();
  }

  Widget multiBlocListeners() {
    return MultiBlocListener(
      listeners: [webSocketBlocListener()],
      child: conversationGroupBlocBuilder(),
    );
  }

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

  Widget conversationGroupBlocBuilder() {
    return BlocBuilder<ConversationGroupBloc, ConversationGroupState>(
      builder: (context, conversationGroupState) {
        if (conversationGroupState is ConversationGroupsLoading) {
          return showLoading();
        }

        if (conversationGroupState is ConversationGroupsLoaded) {
          currentConversationGroup = conversationGroupState.conversationGroupList.firstWhere((ConversationGroup existingConversationGroup) => existingConversationGroup.id == widget.conversationGroupId, orElse: null);
          conversationGroupNameTextController.text = currentConversationGroup.name;

          return userContactBlocBuilder();
        }

        return showError();
      },
    );
  }

  Widget userContactBlocBuilder() {
    return BlocBuilder<UserContactBloc, UserContactState>(
      builder: (context, userContactState) {
        if (userContactState is UserContactsLoading) {
          return showLoading();
        }

        if (userContactState is UserContactsLoaded) {
          currentConversationGroup.memberIds.forEach((conversationGroupMemberId) {
            int userContactIndex = userContactState.userContactList.indexWhere((userContact) => conversationGroupMemberId == userContact.id);
            if (userContactIndex != -1) {
              conversationGroupMemberList.add(userContactState.userContactList[userContactIndex]);
            }
          });

          return multimediaBlocBuilder();
        }

        return showError();
      },
    );
  }

  // Multimedia
  Widget multimediaBlocBuilder() {
    return BlocBuilder<MultimediaBloc, MultimediaState>(
      builder: (context, multimediaState) {
        if (multimediaState is MultimediaLoaded) {
          return mainBody();
        }

        return showError();
      },
    );
  }

  Widget mainBody() {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Material(
        child: CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: <Widget>[
            sliverAppBar(),
            SliverList(
              delegate: SliverChildListDelegate([
                sliverConversationGroupDescription(),
                muteNotificationToggle(),
                favourites(),
                Material(
                    color: Colors.white,
                    child: Container(
                      height: 60.0,
                      child: InkWell(
                        onTap: () {},
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
                                        'Media',
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
                  builder: (context, userContactState) {
                    if (userContactState is UserContactsLoaded) {
                      List<UserContact> userContactList = userContactState.userContactList;

                      conversationGroupMemberList = getConversationGroupMembers(context, userContactList, currentConversationGroup);

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

                      return BlocBuilder<MultimediaBloc, MultimediaState>(
                        builder: (BuildContext context, MultimediaState multimediaState) {
                          if (multimediaState is MultimediaLoaded) {
                            List<Multimedia> conversationGroupMemberMultimediaList = [];
                            conversationGroupMemberList = getConversationGroupMembers(context, userContactList, currentConversationGroup);
                            conversationGroupMemberMultimediaList =
                                multimediaState.multimediaList.where((Multimedia existingMultimedia) => conversationGroupMemberList.contains((UserContact userContact) => userContact.profilePicture == existingMultimedia.id)).toList();
                            return showGroupMemberParticipants(context, conversationGroupMemberList, conversationGroupMemberMultimediaList);
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
                        onTap: () {},
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
                                        'Exit group',
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
                        onTap: () {},
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
                                        'Report group',
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
        ),
      ),
    );
  }

  Widget sliverAppBar() {
    return SliverAppBar(
      floating: true,
      pinned: true,
      expandedHeight: Get.height * 0.4,
      flexibleSpace: FlexibleSpaceBar(
        title: Hero(
          tag: currentConversationGroup.id,
          child: FlatButton(
              onPressed: () async {
                String groupName = showConfirmationDialog(title: 'Edit Group Name', description: 'Edit the group name below. Press OK to save.', value: currentConversationGroup.name);
                if (currentConversationGroup.name != groupName) {
                  currentConversationGroup.name = groupName;
                  conversationGroupBloc.add(EditConversationGroupEvent(editConversationGroupRequest: EditConversationGroupRequest(name: groupName), callback: (ConversationGroup conversationGroup) {}));
                }
              },
              child: Container(
                padding: EdgeInsetsDirectional.only(top: 25.0),
                child: Text(
                  currentConversationGroup.name,
                  style: TextStyle(color: whiteColor, fontSize: 18.0),
                  overflow: TextOverflow.fade,
                  softWrap: true,
                ),
              )),
        ),
        background: conversationGroupPhoto(),
      ),
      actions: <Widget>[IconButton(icon: Icon(Icons.share), onPressed: shareConversationGroup)],
    );
  }

  Widget sliverConversationGroupDescription() {
    return Container(
      height: Get.height * 0.1,
      child: InkWell(
        onTap: () async {
          String groupDescription = showConfirmationDialog(title: 'Edit Group Description', description: 'Edit the group description below. Press OK to save.', value: currentConversationGroup.description);
          if (currentConversationGroup.description != groupDescription) {
            currentConversationGroup.description = groupDescription;
            conversationGroupBloc.add(EditConversationGroupEvent(editConversationGroupRequest: EditConversationGroupRequest(description: groupDescription), callback: (ConversationGroup conversationGroup) {}));
          }
        },
        child: Padding(
          padding: EdgeInsets.only(left: Get.width * 0.02),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: Get.height * 0.01,
              ),
              Text(
                'Group description',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: Get.height * 0.01,
              ),
              Text(
                isObjectEmpty(currentConversationGroup.description) ? 'Add Group description' : currentConversationGroup.description,
                style: TextStyle(
                  fontSize: 17.0,
                ),
              ),
              SizedBox(
                height: Get.height * 0.01,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget muteNotificationToggle() {
    return Container(
      height: Get.height * 0.1,
      child: InkWell(
        onTap: () {
          // TODO: Set notificationExpireDate
        },
        child: Padding(
          padding: EdgeInsets.only(left: Get.width * 0.05),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: Get.height * 0.01),
              ),
              Text(
                'Notifications',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: EdgeInsets.only(top: Get.height * 0.01),
              ),
              // TODO: ConversationGroup Block
              // Text(
              //   conversationGroup.notificationExpireDate == 0 ? 'On' : 'Off',
              //   style: TextStyle(
              //     fontSize: 17.0,
              //   ),
              // ),
              Padding(
                padding: EdgeInsets.only(bottom: Get.height * 0.01),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget favourites() {
    return Container(
      height: Get.height * 0.1,
      child: InkWell(
        onTap: () {},
        child: Padding(
          padding: EdgeInsets.only(left: Get.width * 0.05, top: Get.height * 0.02, right: Get.width * 0.05),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(top: Get.height * 0.01),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Favourites⭐',
                        style: TextStyle(fontSize: 17.0),
                      ),
                      Icon(Icons.keyboard_arrow_right)
                    ],
                  )),
              Padding(
                padding: EdgeInsets.only(bottom: Get.height * 0.01),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget conversationGroupPhoto() {
    Widget defaultImage = CircleAvatar(backgroundImage: AssetImage(DefaultImagePathTypeUtil.getByConversationGroupType(currentConversationGroup.conversationGroupType).path));
    return Hero(
        tag: currentConversationGroup.id + '1',
        child: CachedNetworkImage(
          imageUrl: '${env.REST_URL}/conversationGroup/${widget.conversationGroupId}/groupPhoto',
          useOldImageOnUrlChange: true,
          placeholder: (context, url) => defaultImage,
          errorWidget: (context, url, error) => defaultImage,
          imageBuilder: (BuildContext context, ImageProvider<dynamic> imageProvider) {
            return CircleAvatar(
              backgroundImage: imageProvider,
            );
          },
        ));
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
                        'Group members: ' + userContactList.length.toString() + ' participants',
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
    Widget defaultImage = Image.asset(
      DefaultImagePathType.UserContact.path,
    );

    // TODO: Make it become ExpansionTile
    return Container(
      height: Get.height * 0.4,
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
                          userContact.about,
                          softWrap: true,
                        ),
                        onTap: () {},
                        leading: CachedNetworkImage(
                          imageUrl: '${env.REST_URL}/userContact/${userContact.id}/profilePhoto',
                          useOldImageOnUrlChange: true,
                          placeholder: (context, url) => defaultImage,
                          errorWidget: (context, url, error) => defaultImage,
                          imageBuilder: (BuildContext context, ImageProvider<dynamic> imageProvider) {
                            return CircleAvatar(
                              backgroundImage: imageProvider,
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ))
            .toList(),
      ),
    );
  }

  List<UserContact> getConversationGroupMembers(BuildContext context, List<UserContact> userContactList, ConversationGroup conversationGroup) {
    List<UserContact> conversationGroupMemberList = [];

    for (String memberId in conversationGroup.memberIds) {
      for (UserContact existingUserContact in userContactList) {
        if (existingUserContact.id == memberId) {
          conversationGroupMemberList.add(existingUserContact);
        }
      }
    }

    return conversationGroupMemberList;
  }

  shareConversationGroup() {
    showToast('Shared!', Toast.LENGTH_SHORT);
    // TODO: Share with QR image. Can be screenshot or scanned.
    // TODO: Share with link.
  }

  Widget showError() {
    return Center(
      child: Column(
        children: <Widget>[Text('An error has occurred. Please try again later.'), RaisedButton(onPressed: goBackToChatGroupListPage)],
      ),
    );
  }

  goBackToChatGroupListPage() {
    Navigator.of(context).popUntil(ModalRoute.withName('chat_group_list_page'));
  }
}
