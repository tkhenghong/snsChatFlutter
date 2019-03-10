import 'package:flutter/material.dart';
import 'package:snschat_flutter/ui/pages/chats/chat_group_list/chat_group_list_page.dart';
import 'package:snschat_flutter/ui/pages/myself/myself_page.dart';
import 'package:snschat_flutter/ui/pages/scan_qr_code/scan_qr_code_page.dart';

class TabsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new TabsPageState();
  }
}

class TabsPageState extends State<TabsPage> {
  int _bottomNavBarIndex = 0;
  String tabTitle =
      "Chats"; // Have to put default tab name or compiler will say null error
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            titleSpacing: 0.0,
            elevation: 0,
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
          body: buildPageView(_bottomNavBarIndex),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _bottomNavBarIndex,
            type: BottomNavigationBarType.shifting,
            onTap: (int index) {
              setState(() {
                _bottomNavBarIndex = index;
                buildPageView(index);
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
          )),
    );
  }

  Widget buildPageView(int pageNumber) {
    switch (pageNumber) {
      case 0:
        tabTitle = "Chats";
        return PageView(children: <Widget>[ChatGroupListPage()]);
        break;
      case 1:
        tabTitle = "Scan QR Code";
        return PageView(children: <Widget>[ScanQrCodePage()]);
        break;
      case 2:
        tabTitle = "Myself";
        return PageView(children: <Widget>[MyselfPage()]);
        break;
      default:
        print("No such page.");
        break;
    }
  }
}
