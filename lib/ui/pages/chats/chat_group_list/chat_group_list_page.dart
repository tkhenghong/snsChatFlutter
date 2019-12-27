import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:snschat_flutter/general/functions/validation_functions.dart';
import 'package:snschat_flutter/general/ui-component/list-view.dart';
import 'package:snschat_flutter/objects/conversationGroup/conversation_group.dart';
import 'package:snschat_flutter/objects/multimedia/multimedia.dart';
import 'package:snschat_flutter/objects/unreadMessage/UnreadMessage.dart';
import 'package:snschat_flutter/service/file/FileService.dart';
import 'package:snschat_flutter/service/image/ImageService.dart';
import 'package:snschat_flutter/state/bloc/bloc.dart';
import 'package:snschat_flutter/ui/pages/chats/chat_room/chat_room_page.dart';
import 'package:time_formatter/time_formatter.dart';

class ChatGroupListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ChatGroupListState();
  }
}

class ChatGroupListState extends State<ChatGroupListPage> {
  RefreshController _refreshController;

  FileService fileService = FileService();
  ImageService imageService = ImageService();

  @override
  initState() {
    super.initState();
    _refreshController = new RefreshController(initialRefresh: false);
  }

  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  initialize(BuildContext context) async {
    BlocProvider.of<ConversationGroupBloc>(context).add(InitializeConversationGroupsEvent(callback: (bool done) {}));
    BlocProvider.of<MessageBloc>(context).add(InitializeMessagesEvent(callback: (bool done) {}));
    BlocProvider.of<MultimediaBloc>(context).add(InitializeMultimediaEvent(callback: (bool done) {}));
    BlocProvider.of<UnreadMessageBloc>(context).add(InitializeUnreadMessagesEvent(callback: (bool done) {}));
    BlocProvider.of<UserContactBloc>(context).add(InitializeUserContactsEvent(callback: (bool done) {}));
    BlocProvider.of<WebSocketBloc>(context).add(InitializeWebSocketEvent(callback: (bool done) {}));
    BlocProvider.of<IPGeoLocationBloc>(context).add(InitializeIPGeoLocationEvent(callback: (bool done) {}));
  }

  @override
  Widget build(BuildContext context) {
    if (BlocProvider.of<GoogleInfoBloc>(context).state is GoogleInfoLoading) {
      initialize(context);
    }

    return MultiBlocListener(
      listeners: [
        BlocListener<GoogleInfoBloc, GoogleInfoState>(
          listener: (context, googleInfoState) {
            if (googleInfoState is GoogleInfoLoaded) {
              BlocProvider.of<UserBloc>(context).add(InitializeUserEvent(
                  googleSignIn: googleInfoState.googleSignIn,
                  callback: (bool initialized) {
                    if (!initialized) {
                      goToLoginPage();
                    }
                  }));
              BlocProvider.of<UserContactBloc>(context).add(InitializeUserContactsEvent(callback: (bool done) {}));
            }

            if (googleInfoState is GoogleInfoLoading) {
              BlocProvider.of<GoogleInfoBloc>(context).add(InitializeGoogleInfoEvent(callback: (bool initialized) {}));
            }

            if (googleInfoState is GoogleInfoNotLoaded) {
              goToLoginPage();
            }
          },
        ),
        BlocListener<UserContactBloc, UserContactState>(
          listener: (context, userContactState) {
            if (userContactState is UserContactsLoaded) {
              BlocProvider.of<MultimediaBloc>(context)
                  .add(GetUserContactsMultimediaEvent(userContactList: userContactState.userContactList, callback: (bool done) {}));
            }
          },
        ),
        BlocListener<UserBloc, UserState>(
          listener: (context, userState) {
            if (userState is UserNotLoaded) {
              goToLoginPage();
            }

            if (userState is UserLoaded) {
              print('chat_group_list_page.dart if (userState is UserLoaded)');
              print('chat_group_list_page.dart Get user previous data');

              // Restore previous data
              BlocProvider.of<SettingsBloc>(context).add(GetUserSettingsEvent(user: userState.user));
              BlocProvider.of<ConversationGroupBloc>(context)
                  .add(GetUserPreviousConversationGroupsEvent(user: userState.user, callback: (bool done) {}));
              BlocProvider.of<UnreadMessageBloc>(context)
                  .add(GetUserPreviousUnreadMessagesEvent(user: userState.user, callback: (bool done) {}));
              BlocProvider.of<MultimediaBloc>(context)
                  .add(GetUserProfilePictureMultimediaEvent(user: userState.user, callback: (bool done) {}));
              BlocProvider.of<UserContactBloc>(context)
                  .add(GetUserPreviousUserContactsEvent(user: userState.user, callback: (bool done) {}));
            }
          },
        ),
        BlocListener<ConversationGroupBloc, ConversationGroupState>(
          listener: (context, conversationGroupState) {
            if (conversationGroupState is ConversationGroupsNotLoaded) {
              goToLoginPage();
            }

            if (conversationGroupState is ConversationGroupsLoaded) {
              BlocProvider.of<MultimediaBloc>(context).add(GetConversationGroupsMultimediaEvent(
                  conversationGroupList: conversationGroupState.conversationGroupList, callback: (bool done) {}));
            }
          },
        ),
        BlocListener<UnreadMessageBloc, UnreadMessageState>(
          listener: (context, unreadMessageState) {},
        ),
        BlocListener<MultimediaBloc, MultimediaState>(
          listener: (context, multimediaState) {},
        ),
      ],
      child: BlocBuilder<GoogleInfoBloc, GoogleInfoState>(
        builder: (context, googleInfoState) {
          if (googleInfoState is GoogleInfoLoading) {
            BlocProvider.of<GoogleInfoBloc>(context).add(InitializeGoogleInfoEvent(callback: (bool initialized) {}));
            return showLoading();
          }

          if (googleInfoState is GoogleInfoLoaded) {
            return BlocBuilder<UserBloc, UserState>(
              builder: (context, userState) {
                if (userState is UserLoading) {
                  BlocProvider.of<UserBloc>(context)
                      .add(InitializeUserEvent(googleSignIn: googleInfoState.googleSignIn, callback: (bool initialized) {}));
                  return showLoading();
                }

                if (userState is UserLoaded) {
                  return BlocBuilder<ConversationGroupBloc, ConversationGroupState>(
                    builder: (context, conversationGroupState) {
                      if (conversationGroupState is ConversationGroupsLoading) {
                        return showLoading();
                      }

                      if (conversationGroupState is ConversationGroupsLoaded) {
                        return BlocBuilder<UnreadMessageBloc, UnreadMessageState>(
                          builder: (context, unreadMessageState) {
                            if (unreadMessageState is UnreadMessageLoading) {
                              return showLoading();
                            }
                            if (unreadMessageState is UnreadMessagesLoaded) {
                              return BlocBuilder<MultimediaBloc, MultimediaState>(
                                builder: (context, multimediaState) {
                                  if (multimediaState is MultimediaLoading) {
                                    return showLoading();
                                  }

                                  if (multimediaState is MultimediaLoaded) {
                                    if (isObjectEmpty(conversationGroupState.conversationGroupList) ||
                                        conversationGroupState.conversationGroupList.length == 0) {
                                      return Center(child: Text("No conversations. Tap \"+\" to create one!"));
                                    } else {
                                      return SmartRefresher(
                                        controller: _refreshController,
                                        onRefresh: () => onRefresh(context),
                                        enablePullDown: true,
                                        physics: BouncingScrollPhysics(),
                                        header: ClassicHeader(),
                                        child: ListView.builder(
                                            scrollDirection: Axis.vertical,
                                            shrinkWrap: true,
                                            itemCount: conversationGroupState.conversationGroupList.length,
                                            itemBuilder: (context, index) {
                                              PageListItem pageListItem = mapConversationToPageListTile(
                                                  conversationGroupState.conversationGroupList[index], multimediaState, unreadMessageState);
                                              return PageListTile(pageListItem, context);
                                            }),
                                      );
                                    }
                                  }

                                  // Multimedia Not Loaded Event
                                  return Center(child: Text('Error. Multimedia are not loaded.'));
                                },
                              );
                            }

                            // Unread Messages Not Loaded Event
                            return Center(child: Text('Error. Unread Messages are not loaded.'));
                          },
                        );
                      }

                      // Conversation Groups Not Loaded Event
                      return Center(child: Text('Error. Conversation Groups are not loaded.'));
                    },
                  );
                }

                // User Not Loaded Event
                return Center(child: Text("Error. User is not loaded."));
              },
            );
          }

          // GoogleInfo Not Loaded Event
          return Center(child: Text("Error. Google is not signed in."));
        },
      ),
    );
  }

  Widget showLoading() {
    return Center(child: Text("Loading..."));
  }

  PageListItem mapConversationToPageListTile(
      ConversationGroup conversationGroup, MultimediaState multimediaState, UnreadMessageState unreadMessageState) {
    Multimedia multimedia = (multimediaState as MultimediaLoaded).multimediaList.firstWhere(
        (Multimedia existingMultimedia) =>
            existingMultimedia.conversationId.toString() == conversationGroup.id && isStringEmpty(existingMultimedia.messageId),
        orElse: () => null);

    if (!isObjectEmpty(conversationGroup)) {
      print('chat_group_list_page.dart if(!isObjectEmpty(conversationGroup))');
      print('chat_group_list_page.dart conversationGroup.id.toString(): ' + conversationGroup.id.toString());
      print('chat_group_list_page.dart conversationGroup.name.toString(): ' + conversationGroup.name.toString());
    } else {
      print('chat_group_list_page.dart if(isObjectEmpty(conversationGroup))');
    }

    if (!isObjectEmpty(multimedia)) {
      print('chat_group_list_page.dart if(!isObjectEmpty(multimedia))');
      print('chat_group_list_page.dart multimedia.id.toString(): ' + multimedia.id.toString());
      print('chat_group_list_page.dart multimedia.conversationId.toString(): ' + multimedia.conversationId.toString());
      print('chat_group_list_page.dart multimedia.remoteThumbnailUrl.toString(): ' + multimedia.remoteThumbnailUrl.toString());
      print('chat_group_list_page.dart multimedia.remoteFullFileUrl.toString(): ' + multimedia.remoteFullFileUrl.toString());
      print('chat_group_list_page.dart multimedia.localThumbnailUrl.toString(): ' + multimedia.localThumbnailUrl.toString());
    } else {
      print('chat_group_list_page.dart if(isObjectEmpty(multimedia))');
    }

    UnreadMessage unreadMessage = (unreadMessageState as UnreadMessagesLoaded).unreadMessageList.firstWhere(
        (UnreadMessage existingUnreadMessage) => existingUnreadMessage.conversationId.toString() == conversationGroup.id,
        orElse: () => null);

    return PageListItem(
        title: Hero(
          tag: conversationGroup.id,
          child: Text(conversationGroup.name),
        ),
        subtitle: Text(isObjectEmpty(unreadMessage) ? "" : unreadMessage.lastMessage),
        leading: Hero(
          tag: conversationGroup.id + "1",
          child: imageService.loadImageThumbnailCircleAvatar(multimedia, conversationGroup.type, context),
        ),
        trailing: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: Text(isObjectEmpty(unreadMessage) ? "" : formatTime(unreadMessage.date), style: TextStyle(fontSize: 9.0)),
            ),
            Text(isObjectEmpty(unreadMessage) ? "" : unreadMessage.count.toString() == "0" ? "" : unreadMessage.count.toString())
          ],
        ),
        onTap: (BuildContext context, object) {
          // Send argument need to use the old way
          Navigator.push(context, MaterialPageRoute(builder: ((context) => ChatRoomPage(conversationGroup))));
        });
  }

  onRefresh(BuildContext context) async {
    await Future.delayed(Duration(milliseconds: 500));
    setState(() {
      _refreshController.refreshCompleted();
    });
  }

  goToLoginPage() {
    BlocProvider.of<GoogleInfoBloc>(context).add(RemoveGoogleInfoEvent(callback: (bool done) {}));
    Navigator.of(context).pushNamedAndRemoveUntil("login_page", (Route<dynamic> route) => false);
  }
}
