import 'package:flutter/material.dart';
import 'package:snschat_flutter/ui/pages/chat_group_list/chat_group_list.dart';
import 'package:snschat_flutter/ui/pages/myself/myself_page.dart';
import 'package:snschat_flutter/ui/pages/scan_qr_code/scan_qr_code_page.dart';
import 'package:snschat_flutter/ui/pages/settings/settings.dart';

class TabsPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return new TabsPageState();
  }
}

class TabsPageState extends State<TabsPage> {
  int _bottomNavBarIndex = 0;

  @override
  Widget build(BuildContext context) {
    return new Material(
      color: Colors.white,
      child: new Scaffold(
          appBar: new AppBar(
            backgroundColor: Colors.white,
            titleSpacing: 0.0,
            elevation: 0,
            title: new Text(
              'Chats',
              textAlign: TextAlign.start,
              style: new TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 32.0,
                  color: Colors.black),
            ),
          ),
          backgroundColor: Colors.white,
          body: buildPageView(_bottomNavBarIndex),
          bottomNavigationBar: new BottomNavigationBar(
            currentIndex: _bottomNavBarIndex,
            type: BottomNavigationBarType.shifting,
            onTap: (int index) {
              setState(() {
                _bottomNavBarIndex = index;
                buildPageView(index);
              });
            },
            items: [
              new BottomNavigationBarItem(
                icon: new Icon(Icons.chat, color: Colors.black,),
                title: new Text("Chats", style: new TextStyle(color: Colors.black),),
              ),
              new BottomNavigationBarItem(
                icon: new Icon(Icons.code, color: Colors.black,),
                title: new Text("Scan QR Code", style: new TextStyle(color: Colors.black),),
              ),
              new BottomNavigationBarItem(
                icon: new Icon(Icons.person, color: Colors.black,),
                title: new Text("Settings", style: new TextStyle(color: Colors.black),),
              ),
            ],
          )),
    );
  }

  Widget buildPageView(int pageNumber) {
    switch(pageNumber) {
      case 0:
        return PageView(children: <Widget>[new ChatGroupListPage()]);
        break;
      case 1:
        return PageView(children: <Widget>[new ScanQrCodePage()]);
        break;
      case 2:
        return PageView(children: <Widget>[new MyselfPage()]);
        break;
      default:
        print("No such page.");
        break;
    }
  }
}