import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
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
  WebSocketBloc webSocketBloc;

  AnimationController _animationController, _animationController2;
  Animation animation;

  List<IconData> createConversationIcons = [Icons.person_add, Icons.group_add, Icons.campaign];
  List<ConversationGroupType> conversationGroupTypeTitles = [ConversationGroupType.Personal, ConversationGroupType.Group, ConversationGroupType.Broadcast];
  List<String> conversationGroupTypeLabels = ['Create Personal Conversation', 'Create Group Conversation', 'Create Broadcast Group'];

  List<IconData> tabIcons = [Icons.chat, Icons.code, Icons.person];
  List<String> tabTitles = ['Chats', 'Scan QR Code', 'Myself'];

  bool isActionButtonDisabled = false;

  int _bottomNavBarIndex = 0;
  String tabTitle = ''; // Have to put default tab name or compiler will say null error

  PageController pageViewController = PageController(initialPage: 0, keepPage: true);
  List<Widget> tabPages;

  @override
  void initState() {
    super.initState();

    tabTitle = tabTitles[0];

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
    webSocketBloc = BlocProvider.of<WebSocketBloc>(context);

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Get.theme.primaryTextTheme.headline6.color,
          textTheme: TextTheme(headline6: TextStyle(color: Get.theme.primaryColor)),
          titleSpacing: 0.0,
          elevation: 0.0,
          title: Text(
            tabTitle,
            textAlign: TextAlign.start,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32.0),
          ),
        ),
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
          items: initializeTabs(),
        ),
        floatingActionButton: FadeTransition(
          opacity: animation,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(createConversationIcons.length, (int index) {
              Widget child = new Container(
                height: Get.height * 0.1,
                width: Get.width * 0.1,
                alignment: FractionalOffset.topCenter,
                child: ScaleTransition(
                    scale: CurvedAnimation(
                      parent: _animationController,
                      curve: Interval(0.0, 1.0 - index / createConversationIcons.length / 2.0, curve: Curves.easeOut),
                    ),
                    child: Tooltip(
                      message: conversationGroupTypeLabels[index],
                      child: FloatingActionButton(
                        heroTag: null,
                        mini: true,
                        child: Icon(
                          createConversationIcons[index],
                        ),
                        onPressed: () {
                          if (!isActionButtonDisabled) {
                            goToSelectContactPage(index);
                          }
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
        ));
  }

  /// The reason of this implementation is due to compiler will give error if
  List<BottomNavigationBarItem> initializeTabs() {
    int i = 0;
    return tabIcons.map((e) {
      BottomNavigationBarItem item = BottomNavigationBarItem(
        icon: Icon(
          tabIcons[i],
        ),
        label: tabTitles[i],
      );
      i++;
      return item;
    }).toList();
  }

  changeTab(int pageNumber) {
    switch (pageNumber) {
      case 0:
        tabTitle = tabTitles[0];
        isActionButtonDisabled = false;
        _animationController2.forward();
        break;
      case 1:
        tabTitle = tabTitles[1];
        isActionButtonDisabled = true;
        _animationController2.reverse();
        break;
      case 2:
        tabTitle = tabTitles[2];
        isActionButtonDisabled = true;
        _animationController2.reverse();
        break;
      default:
        break;
    }
  }

  goToSelectContactPage(int index) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => SelectContactsPage(chatGroupType: conversationGroupTypeTitles[index])));
    _animationController.reverse();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      print('tabs.page.dart if (state == AppLifecycleState.resumed)');
      UserState userState = BlocProvider.of<UserBloc>(context).state;
      if (userState is UserLoaded) {
        webSocketBloc.add(ReconnectWebSocketEvent(callback: (bool done) {}));
      }
    }

    if (state == AppLifecycleState.paused) {
      print('tabs.page.dart if (state == AppLifecycleState.paused)');
      webSocketBloc.add(DisconnectWebSocketEvent(callback: (bool done) {}));
    }

    if (state == AppLifecycleState.inactive) {
      print('tabs.page.dart if (state == AppLifecycleState.inactive)');
    }

    if (state == AppLifecycleState.detached) {
      print('tabs.page.dart if (state == AppLifecycleState.detached)');
    }
  }
}
