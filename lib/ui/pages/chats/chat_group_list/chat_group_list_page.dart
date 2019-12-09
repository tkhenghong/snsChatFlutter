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
import 'package:snschat_flutter/state/bloc/WholeApp/WholeAppBloc.dart';
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
  bool getListDone = false;

  RefreshController _refreshController;
  WholeAppBloc wholeAppBloc;

  FileService fileService = FileService();
  ImageService imageService = ImageService();

  @override
  initState() {
    super.initState();
    _refreshController = new RefreshController();
//    final WholeAppBloc _wholeAppBloc = BlocProvider.of<WholeAppBloc>(context);
//    wholeAppBloc = _wholeAppBloc;
    initialize();
  }

  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  initialize() async {
    // InitializeWebSocketEvent not needed anymore
    // LoadDatabaseToStateEvent not needed anymore, loadDone thing mechanism will be handled by BlocListeners
    // CheckUserLoginEvent not needed anymore, will check using User in the state or not, if not in the state will go to Login page
    // If not signed in, go to Login page WITH SIGN OUT event
    // GetIPGeoLocationEvent not needed anymore.
  }

  goToLoginPage() {
    BlocProvider.of<GoogleInfoBloc>(context).add(RemoveGoogleInfoEvent());
    Navigator.of(context).pushNamedAndRemoveUntil("login_page", (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
//    listenToAllStates();

    return BlocListener<GoogleInfoBloc, GoogleInfoState>(
      listener: (context, googleInfoState) {
        if (googleInfoState is GoogleInfoLoaded) {
          BlocProvider.of<UserBloc>(context).add(InitializeUserEvent(googleSignIn: googleInfoState.googleSignIn));
          BlocProvider.of<IPGeoLocationBloc>(context).add(GetIPGeoLocationEvent());
        }

        if (googleInfoState is GoogleInfoLoading) {
          BlocProvider.of<GoogleInfoBloc>(context).add(InitializeGoogleInfoEvent(callback: (bool initialized) {}));
        }

        if (googleInfoState is GoogleInfoNotLoaded) {
          goToLoginPage();
        }
      },
      child: BlocBuilder<GoogleInfoBloc, GoogleInfoState>(
        builder: (context, googleInfoState) {
          if (googleInfoState is GoogleInfoLoading) {
            BlocProvider.of<GoogleInfoBloc>(context).add(InitializeGoogleInfoEvent(callback: (bool initialized) {}));
            return showLoading();
          }

          if (googleInfoState is GoogleInfoLoaded) {
            return BlocListener<UserBloc, UserState>(
              listener: (context, userState) {
                if (userState is UserNotLoaded) {
                  goToLoginPage();
                }
              },
              child: BlocBuilder<UserBloc, UserState>(
                builder: (context, userState) {
                  if (userState is UserLoading) {
                    BlocProvider.of<UserBloc>(context)
                        .add(InitializeUserEvent(googleSignIn: googleInfoState.googleSignIn, callback: (bool initialized) {}));
                    return showLoading();
                  }

                  if (userState is UserLoaded) {
                    return BlocListener<ConversationGroupBloc, ConversationGroupState>(
                      listener: (context, conversationGroupState) {
                        if (conversationGroupState is ConversationGroupsNotLoaded) {
                          goToLoginPage();
                        }
                      },
                      child: BlocBuilder<ConversationGroupBloc, ConversationGroupState>(
                        builder: (context, conversationGroupState) {
                          if (conversationGroupState is ConversationGroupsLoading) {
                            return showLoading();
                          }

                          if (conversationGroupState is ConversationGroupsLoaded) {
                            return BlocListener<UnreadMessageBloc, UnreadMessageState>(
                              listener: (context, unreadMessageState) {},
                              child: BlocBuilder<UnreadMessageBloc, UnreadMessageState>(
                                builder: (context, unreadMessageState) {
                                  if (unreadMessageState is UnreadMessageLoading) {
                                    return showLoading();
                                  }
                                  if (unreadMessageState is UnreadMessagesLoaded) {
                                    return BlocListener<MultimediaBloc, MultimediaState>(
                                      listener: (context, multimediaState) {},
                                      child: BlocBuilder<MultimediaBloc, MultimediaState>(
                                        builder: (context, multimediaState) {
                                          if (multimediaState is MultimediaLoading) {
                                            return showLoading();
                                          }

                                          if (multimediaState is MultimediaLoaded) {
                                            if (isObjectEmpty(conversationGroupState.conversationGroupList) ||
                                                conversationGroupState.conversationGroupList.length == 0) {
                                              return Center(child: Text("No conversations. Tap \"+\" to create one!"));
                                            } else {
                                              return ListView.builder(
                                                  scrollDirection: Axis.vertical,
                                                  shrinkWrap: true,
                                                  physics: BouncingScrollPhysics(),
                                                  itemCount: conversationGroupState.conversationGroupList.length,
                                                  itemBuilder: (context, index) {
                                                    PageListItem pageListItem = mapConversationToPageListTile(
                                                        conversationGroupState.conversationGroupList[index],
                                                        multimediaState,
                                                        unreadMessageState);
                                                    return PageListTile(pageListItem, context);
                                                  });
                                            }
                                          }

                                          // Multimedia Not Loaded Event
                                          return Center(child: Text('Error. Multimedia are not loaded.'));
                                        },
                                      ),
                                    );
                                  }

                                  // Unread Messages Not Loaded Event
                                  return Center(child: Text('Error. Unread Messages are not loaded.'));
                                },
                              ),
                            );
                          }

                          // Conversation Groups Not Loaded Event
                          return Center(child: Text('Error. Conversation Groups are not loaded.'));
                        },
                      ),
                    );
                  }

                  // User Not Loaded Event
                  goToLoginPage();
                  return Center(child: Text("Error. User is not loaded."));
                },
              ),
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
}
