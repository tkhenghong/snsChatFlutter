import 'dart:async';

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
    conversationGroupBlocSubscription.cancel();
    googleInfoBlocSubscription.cancel();
    ipGeoLocationBlocSubscription.cancel();
    messageBlocSubscription.cancel();
    multimediaBlocSubscription.cancel();
    settingsBlocSubscription.cancel();
    unreadMessageBlocSubscription.cancel();
    userBlocSubscription.cancel();
    userContactBlocSubscription.cancel();
    webSocketBlocSubscription.cancel();
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
    Navigator.of(context).pushNamedAndRemoveUntil("login_page", (Route<dynamic> route) => false);
  }

  final ConversationGroupBloc conversationGroupBloc = ConversationGroupBloc();
  StreamSubscription conversationGroupBlocSubscription;

  final GoogleInfoBloc googleInfoBloc = GoogleInfoBloc();
  StreamSubscription googleInfoBlocSubscription;

  final IPGeoLocationBloc ipGeoLocationBloc = IPGeoLocationBloc();
  StreamSubscription ipGeoLocationBlocSubscription;

  final MessageBloc messageBloc = MessageBloc();
  StreamSubscription messageBlocSubscription;

  final MultimediaBloc multimediaBloc = MultimediaBloc();
  StreamSubscription multimediaBlocSubscription;

  final SettingsBloc settingsBloc = SettingsBloc();
  StreamSubscription settingsBlocSubscription;

  final UnreadMessageBloc unreadMessageBloc = UnreadMessageBloc();
  StreamSubscription unreadMessageBlocSubscription;

  final UserBloc userBloc = UserBloc();
  StreamSubscription userBlocSubscription;

  final UserContactBloc userContactBloc = UserContactBloc();
  StreamSubscription userContactBlocSubscription;

  final WebSocketBloc webSocketBloc = WebSocketBloc();
  StreamSubscription webSocketBlocSubscription;


  listenToAllStates() async {
    conversationGroupBlocSubscription = conversationGroupBloc.listen((state) {
      print('chat_group_list_page.dart conversationGroupBloc listener working.');
      print('chat_group_list_page.dart state: ' + state.toString());
    });

    googleInfoBlocSubscription = googleInfoBloc.listen((state) {
      print('chat_group_list_page.dart googleInfoBloc listener working.');
      print('chat_group_list_page.dart state: ' + state.toString());
    });

    ipGeoLocationBlocSubscription = ipGeoLocationBloc.listen((state) {
      print('chat_group_list_page.dart ipGeoLocationBloc listener working.');
      print('chat_group_list_page.dart state: ' + state.toString());
    });

    messageBlocSubscription = messageBloc.listen((state) {
      print('chat_group_list_page.dart messageBloc listener working.');
      print('chat_group_list_page.dart state: ' + state.toString());
    });

    multimediaBlocSubscription = multimediaBloc.listen((state) {
      print('chat_group_list_page.dart multimediaBloc listener working.');
      print('chat_group_list_page.dart state: ' + state.toString());
    });

    settingsBlocSubscription = settingsBloc.listen((state) {
      print('chat_group_list_page.dart settingsBloc listener working.');
      print('chat_group_list_page.dart state: ' + state.toString());
    });

    unreadMessageBlocSubscription = unreadMessageBloc.listen((state) {
      print('chat_group_list_page.dart unreadMessageBloc listener working.');
      print('chat_group_list_page.dart state: ' + state.toString());
    });

    userBlocSubscription = userBloc.listen((state) {
      print('chat_group_list_page.dart userBloc listener working.');
      print('chat_group_list_page.dart state: ' + state.toString());
    });

    userContactBlocSubscription = userContactBloc.listen((state) {
      print('chat_group_list_page.dart userContactseBloc listener working.');
      print('chat_group_list_page.dart state: ' + state.toString());
    });

    webSocketBlocSubscription = webSocketBloc.listen((state) {
      print('chat_group_list_page.dart webSocketBloc listener working.');
      print('chat_group_list_page.dart state: ' + state.toString());
    });
  }



  @override
  Widget build(BuildContext context) {
//    listenToAllStates();

    // A bit annoying but need to get state of
    return BlocBuilder<GoogleInfoBloc, GoogleInfoState>(
      builder: (context, googleInfoState) {
        print('chat_group_list_page.dart GoogleInfoBloc state changes');
        if(googleInfoState is GoogleInfoLoaded) {
          return BlocBuilder<UserBloc, UserState> (
            builder: (context, userState) {
              print('chat_group_list_page.dart UserBloc state changes');
              if(userState is UserLoaded) {
                return BlocBuilder<ConversationGroupBloc, ConversationGroupState>(
                  builder: (context, conversationGroupState) {
                    print('chat_group_list_page.dart ConversationGroupBloc state changes');
                    if(conversationGroupState is ConversationGroupsLoaded) {
                      return BlocBuilder<UnreadMessageBloc, UnreadMessageState>(
                        builder: (context, unreadMessageState) {
                          print('chat_group_list_page.dart UnreadMessageBloc state changes');
                          if(unreadMessageState is UnreadMessagesLoaded) {
                            return BlocBuilder<MultimediaBloc, MultimediaState>(
                              builder: (context, multimediaState) {
                                print('chat_group_list_page.dart MultimediaBloc state changes');
                                if(multimediaState is MultimediaLoaded) {
                                  if(conversationGroupState.conversationGroupList.length == 0) {
                                    return Center(child: Text("No conversations. Tap \"+\" to create one!"));
                                  } else {
                                    return ListView.builder(
                                        scrollDirection: Axis.vertical,
                                        shrinkWrap: true,
                                        physics: BouncingScrollPhysics(),
                                        itemCount: conversationGroupState.conversationGroupList.length,
                                        itemBuilder: (context, index) {
                                          PageListItem pageListItem = mapConversationToPageListTile(conversationGroupState.conversationGroupList[index], multimediaState, unreadMessageState);
                                          return PageListTile(pageListItem, context);
                                        });
                                  }
                                } else {
                                  return Center(child: Text("Loading messages..."));
                                }
                              },
                            );
                          } else {
                            return Center(child: Text("Loading messages..."));
                          }
                        },
                      );
                    } else {
                      return Center(child: Text("Loading messages..."));
                    }
                  },
                );
              } else {
                goToLoginPage();
                return Center(child: Text("Loading messages..."));
              }
            },
          );
        } else {
          goToLoginPage();
          return Center(child: Text("Loading messages..."));
        }
      },
    );




//    return MultiBlocListener(
//      listeners: [
//        BlocListener<ConversationGroupBloc, ConversationGroupState>(
//          listener: (context, state) {
//            if(state is ConversationGroupsLoading) {
//              print('if(state is ConversationGroupsLoading)');
//              child = Center(child: Text("Loading messages..."));
//            } else if(state is ConversationGroupsNotLoaded) {
//              print('if(state is ConversationGroupsNotLoaded)');
//              child = Center(child: Text("No conversations. Tap \"+\" to create one!"));
//            } else if(state is ConversationGroupsLoaded) {
//              child =  ListView.builder(
//                  scrollDirection: Axis.vertical,
//                  shrinkWrap: true,
//                  physics: BouncingScrollPhysics(),
//                  itemCount: state.conversationGroupList.length,
//                  itemBuilder: (context, index) {
//                    return PageListTile(mapConversationToPageListTile(state.conversationGroupList[index]), context);
//                  });
//            }
//          },
//        ),
//        BlocListener<UnreadMessageBloc, UnreadMessageState>(
//          listener: (context, state) {
//            if(state is UnreadMessagesNotLoaded) {
//              print('if(state is ConversationGroupsLoading)');
//              child = Center(child: Text("Loading messages..."));
//            }
//          },
//        ),
//        BlocListener<MultimediaBloc, MultimediaState>(
//          listener: (context, state) {},
//        ),
//        BlocListener<GoogleInfoBloc, GoogleInfoState>(
//          listener: (context, state) {},
//        ),
//        BlocListener<UserBloc, UserState>(
//          listener: (context, state) {},
//        ),
//      ],
//      child: child,
//    );
//
//    return BlocBuilder(
//      bloc: wholeAppBloc,
//      builder: (context, WholeAppState state) {
//        if (conversationGroupsAreReady(state) && unreadMessagesAreReady(state)) {
//          return SmartRefresher(
//            controller: _refreshController,
//            header: WaterDropHeader(),
//            onRefresh: () {
//              setState(() {});
//              //Delay 1 second to simulate something loading
//              Future.delayed(Duration(seconds: 1), () {
//                _refreshController.refreshCompleted();
//              });
//            },
//            child: ListView.builder(
//                scrollDirection: Axis.vertical,
//                shrinkWrap: true,
//                physics: BouncingScrollPhysics(),
//                itemCount: state.conversationGroupList.length,
//                itemBuilder: (context, index) {
//                  return PageListTile(mapConversationToPageListTile(state.conversationGroupList[index]), context);
//                }),
//          );
//        } else {
//          return getListDone
//              ? Center(child: Text("No conversations. Tap \"+\" to create one!"))
//              : Center(child: Text("Loading messages..."));
//        }
//      },
//    );
  }

  PageListItem mapConversationToPageListTile(ConversationGroup conversationGroup, MultimediaState multimediaState, UnreadMessageState unreadMessageState) {

    Multimedia multimedia = (multimediaState as MultimediaLoaded)
        .multimediaList.firstWhere((Multimedia existingMultimedia) =>
    existingMultimedia.conversationId.toString() == conversationGroup.id &&
        isStringEmpty(existingMultimedia.messageId), orElse: () => null);

    UnreadMessage unreadMessage = (unreadMessageState as UnreadMessagesLoaded)
        .unreadMessageList.firstWhere((UnreadMessage existingUnreadMessage) =>
    existingUnreadMessage.conversationId.toString() == conversationGroup.id, orElse: () => null);


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
