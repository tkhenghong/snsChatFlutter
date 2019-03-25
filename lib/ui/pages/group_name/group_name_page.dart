import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class GroupNamePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new GroupNamePageState();
  }
}

class GroupNamePageState extends State<GroupNamePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('New Group'),
        ),
        body: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                CircleAvatar(
                  radius: 30.0,
                ),
                Container(
                  child: Row(
                    children: <Widget>[
                      TextField(),
                      Icon(Icons.tag_faces)
                    ],
                  ),
                )
              ],
            ),
//            SmartRefresher(
//              enablePullDown: false,
//            )
          ],
        )
    );
  }
}