import 'package:flutter/material.dart';
import 'package:snschat_flutter/general/ui-component/custom_dialogs.dart';
import 'package:snschat_flutter/objects/chat/conversation_group.dart';

class ChatInfoPage extends StatefulWidget {
  Conversation _conversation;

  ChatInfoPage([this._conversation]); //do not final

  @override
  State<StatefulWidget> createState() {
    return new ChatInfoPageState();
  }
}

class ChatInfoPageState extends State<ChatInfoPage> {
  TextEditingController textEditingController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    textEditingController = new TextEditingController();
    textEditingController.text = widget._conversation.name;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Material(
          color: Colors.white,
          child: CustomScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            slivers: <Widget>[
              SliverAppBar(
                floating: true,
                pinned: true,
                expandedHeight: 250.0,
                flexibleSpace: FlexibleSpaceBar(
                    title: Hero(
                      tag: "group-name",
                      child: FlatButton(
                          onPressed: () async {
                            CustomDialogs customDialog = new CustomDialogs(
                                context: context,
                                title: "Edit Group Name",
                                description:
                                    "Edit the group name below. Press OK to save.",
                                value: widget._conversation.name);
                            String groupName =
                                await customDialog.showConfirmationDialog();
                            print("groupName: " + groupName);
                            if (widget._conversation.name != groupName) {
                              widget._conversation.name = groupName;
                            }
                            print("widget._conversation.name: " +
                                widget._conversation.name);
                          },
                          child: Text(
                            widget._conversation.name,
                            style:
                                TextStyle(color: Colors.white, fontSize: 20.0),
                          )),
                    ),
                    background: Hero(
                      tag: "group-image",
                      child: Image.asset(
                        "lib/ui/images/group2013.jpg",
                        fit: BoxFit.cover,
                      ),
                    )),
              ),
              SliverList(
                delegate: SliverChildListDelegate([
                  Material(
                      color: Colors.white,
                      child: Container(
                        height: 80.0,
                        decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: Colors.grey,
                                  width: 0.5,
                                  style: BorderStyle.solid)),
                        ),
                        child: InkWell(
                          onTap: () {
                            print("Tapped.");
                          },
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.only(left: 10.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Group description",
                                    style: TextStyle(
                                        fontSize: 15.0, color: Colors.black54),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      )),
                ]),
              ),
            ],
          )),
    );
  }
}
