import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snschat_flutter/general/index.dart';
import 'package:snschat_flutter/state/bloc/bloc.dart';

import '../index.dart';

class TabsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new TabsPageState();
  }
}

class TabsPageState extends State<TabsPage> with TickerProviderStateMixin, AutomaticKeepAliveClientMixin, WidgetsBindingObserver {
  AnimationController _animationController, _animationController2;
  Animation animation;
  static const List<IconData> icons = const [Icons.person_add, Icons.group_add]; // TODO: Add Broadcast
  static const List<ConversationGroupType> chatTitles = const [ConversationGroupType.Personal, ConversationGroupType.Group]; // TODO: Add Broadcast
  Color foregroundColor = Colors.white;
  Color themePrimaryColor;

  int _bottomNavBarIndex = 0;
  String tabTitle = "Chats"; // Have to put default tab name or compiler will say null error

  PageController pageViewController = PageController(initialPage: 0, keepPage: true);
  List<Widget> tabPages;

  // BuildContext context;

  @override
  void initState() {
    super.initState();
    tabPages = [ChatGroupListPage(), ScanQrCodePage(), MyselfPage()];
    _animationController = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _animationController2 = new AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    animation = Tween(begin: 0.0, end: 1.0).animate(_animationController2);
    _animationController2.forward();

    // To detect app is background or foreground state
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _animationController2.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
//    this.context = context;
    themePrimaryColor = Theme.of(context).textTheme.title.color;

    return Material(
      color: Colors.white,
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            titleSpacing: 0.0,
            elevation: 0.0,
            title: Text(
              tabTitle,
              textAlign: TextAlign.start,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32.0, color: themePrimaryColor),
            ),
          ),
          backgroundColor: Colors.white,
          body: PageView(
            controller: pageViewController,
            onPageChanged: (int index) {
              changeTab(index);
              setState(() {
                _bottomNavBarIndex = index;
              });
            },
            physics: BouncingScrollPhysics(),
            children: tabPages,
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _bottomNavBarIndex,
            type: BottomNavigationBarType.shifting,
            onTap: (int index) {
              setState(() {
                _bottomNavBarIndex = index;
                pageViewController.jumpToPage(index);
                changeTab(index);
              });
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.chat,
                  color: themePrimaryColor,
                ),
                title: Text(
                  "Chats",
                  style: TextStyle(color: themePrimaryColor),
                ),
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.code,
                  color: themePrimaryColor,
                ),
                title: Text(
                  "Scan QR Code",
                  style: TextStyle(color: themePrimaryColor),
                ),
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.person,
                  color: themePrimaryColor,
                ),
                title: Text(
                  "Myself",
                  style: TextStyle(color: themePrimaryColor),
                ),
              ),
            ],
          ),
          floatingActionButton: FadeTransition(
            opacity: animation,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(icons.length, (int index) {
                // 0 = Personal, 1 = Group, 2 = Broadcast
                Widget child = new Container(
                  height: 70.0,
                  width: 56.0,
                  alignment: FractionalOffset.topCenter,
                  child: ScaleTransition(
                      scale: CurvedAnimation(
                        parent: _animationController,
                        curve: Interval(0.0, 1.0 - index / icons.length / 2.0, curve: Curves.easeOut),
                      ),
                      child: Tooltip(
                        message: index == 0 ? "Create Personal Conversation" : index == 1 ? "Create Group Conversation" : index == 2 ? "Create Broadcast Group" : "Create Others...",
                        child: FloatingActionButton(
                          heroTag: null,
                          mini: true,
                          child: Icon(icons[index], color: foregroundColor),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => SelectContactsPage(chatGroupType: chatTitles[index])));
                            _animationController.reverse();
                          },
                        ),
                      )),
                );
                return child;
              }).toList()
                ..add(
                  new FloatingActionButton(
                    heroTag: null,
                    child: AnimatedBuilder(
                      animation: _animationController,
                      builder: (BuildContext context, Widget child) {
                        return Transform(
                          transform: new Matrix4.rotationZ(_animationController.value * 0.5 * math.pi),
                          alignment: FractionalOffset.center,
                          child: Icon(
                            _animationController.isDismissed ? Icons.add_comment : Icons.close,
                          ),
                        );
                      },
                    ),
                    onPressed: () {
                      if (_animationController.isDismissed) {
                        _animationController.forward();
                      } else {
                        _animationController.reverse();
                      }
                    },
                  ),
                ),
            ),
          )),
    );
  }

  Widget changeTab(int pageNumber) {
    switch (pageNumber) {
      case 0:
        tabTitle = "Chats";
        _animationController2.forward();
        break;
      case 1:
        tabTitle = "Scan QR Code";
        _animationController2.reverse();
        break;
      case 2:
        tabTitle = "Myself";
        _animationController2.reverse();
        break;
      default:
        break;
    }
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      print('tabs.page.dart if (state == AppLifecycleState.resumed)');
      UserState userState = BlocProvider.of<UserBloc>(context).state;
      if (userState is UserLoaded) {
        BlocProvider.of<WebSocketBloc>(context).add(ReconnectWebSocketEvent(user: userState.user, callback: (bool done) {}));
      }
    }

    if (state == AppLifecycleState.paused) {
      print('tabs.page.dart if (state == AppLifecycleState.paused)');
      BlocProvider.of<WebSocketBloc>(context).add(DisconnectWebSocketEvent(callback: (bool done) {}));
    }

    if (state == AppLifecycleState.inactive) {
      print('tabs.page.dart if (state == AppLifecycleState.inactive)');
    }

    if (state == AppLifecycleState.detached) {
      print('tabs.page.dart if (state == AppLifecycleState.detached)');
    }
  }
}
