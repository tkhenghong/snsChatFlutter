import 'package:flutter/material.dart';
import 'package:snschat_flutter/ui/pages/chats/chat_group_list/chat_group_list_page.dart';
import 'package:snschat_flutter/ui/pages/myself/myself_page.dart';
import 'package:snschat_flutter/ui/pages/scan_qr_code/scan_qr_code_page.dart';
import 'dart:math' as math;

class TabsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new TabsPageState();
  }
}

class TabsPageState extends State<TabsPage> with TickerProviderStateMixin {
  AnimationController _controller;
  static const List<IconData> icons = const [ Icons.person_add, Icons.group_add ];
  Color backgroundColor = Colors.black;
  Color foregroundColor = Colors.white;


  int _bottomNavBarIndex = 0;
  String tabTitle =
      "Chats"; // Have to put default tab name or compiler will say null error

  PageController pageViewController =
      PageController(initialPage: 0, keepPage: true);
  List<Widget> tabPages;

  @override
  void initState() {
    super.initState();
    tabPages = [ChatGroupListPage(), ScanQrCodePage(), MyselfPage()];
    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  Widget build(BuildContext context) {
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
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 32.0,
                  color: Colors.black),
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
                  color: Colors.black,
                ),
                title: Text(
                  "Chats",
                  style: TextStyle(color: Colors.black),
                ),
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.code,
                  color: Colors.black,
                ),
                title: Text(
                  "Scan QR Code",
                  style: TextStyle(color: Colors.black),
                ),
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.person,
                  color: Colors.black,
                ),
                title: Text(
                  "Myself",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        floatingActionButton: Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(icons.length, (int index) {
            Widget child = new Container(
              height: 70.0,
              width: 56.0,
              alignment: FractionalOffset.topCenter,
              child: ScaleTransition(
                scale: CurvedAnimation(
                  parent: _controller,
                  curve: Interval(
                      0.0,
                      1.0 - index / icons.length / 2.0,
                      curve: Curves.easeOut
                  ),
                ),
                child: FloatingActionButton(
                  heroTag: null,
                  backgroundColor: backgroundColor,
                  mini: true,
                  child: Icon(icons[index], color: foregroundColor),
                  onPressed: () {
                    Navigator.of(context).pushNamed('contacts_page');
                  },
                ),
              ),
            );
            return child;
          }).toList()..add(
            new FloatingActionButton(
              heroTag: null,
              backgroundColor: Colors.black,
              child: AnimatedBuilder(
                animation: _controller,
                builder: (BuildContext context, Widget child) {
                  return Transform(
                    transform: new Matrix4.rotationZ(_controller.value * 0.5 * math.pi),
                    alignment: FractionalOffset.center,
                    child: Icon(_controller.isDismissed ? Icons.add_comment : Icons.close,),
                  );
                },
              ),
              onPressed: () {
                if (_controller.isDismissed) {
                  _controller.forward();
                } else {
                  _controller.reverse();
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget changeTab(int pageNumber) {
    switch (pageNumber) {
      case 0:
        tabTitle = "Chats";
        break;
      case 1:
        tabTitle = "Scan QR Code";
        break;
      case 2:
        tabTitle = "Myself";
        break;
      default:
        print("No such page.");
        break;
    }
  }
}
