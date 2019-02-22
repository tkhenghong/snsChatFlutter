import 'package:flutter/material.dart';

class ChatGroupListPage extends StatefulWidget implements HasLayoutGroup {
  ChatGroupListPage({Key key, this.layoutGroup, this.onLayoutToggle}) : super(key: key);
  final LayoutGroup layoutGroup;
  final VoidCallback onLayoutToggle;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new ChatGroupListState();
  }

}

class ChatGroupListState extends State<ChatGroupListPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  new Scaffold(
      appBar: new AppBar(
        title: new Text('Chats'),
      ),
      body: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new ListTile(
            title: new Text('List Title'),
            subtitle: new Text('List subtitle'),
            trailing: new Text('trailling words'),
            isThreeLine: true,
            onTap: () {print('You have clicked me!');},
          ),
          new ListTile(
            title: new Text('List Title'),
            subtitle: new Text('List subtitle'),
            trailing: new Text('trailling words'),
            isThreeLine: true,
          ),
          new ListTile(
            title: new Text('List Title'),
            subtitle: new Text('List subtitle'),
            trailing: new Text('trailling words'),
            isThreeLine: true,
          ),
          new ListTile(
            title: new Text('List Title'),
            subtitle: new Text('List subtitle'),
            trailing: new Text('trailling words'),
            isThreeLine: true,
          ),
          new ListTile(
            title: new Text('List Title'),
            subtitle: new Text('List subtitle'),
            trailing: new Text('trailling words'),
            isThreeLine: true,
          ),
        ],
      ),
    );
  }

  // Test data
  List<Contact> allContacts = [
    Contact(name: 'Isa Tusa', email: 'isa.tusa@me.com'),
    Contact(name: 'Racquel Ricciardi', email: 'racquel.ricciardi@me.com'),
    Contact(name: 'Teresita Mccubbin', email: 'teresita.mccubbin@me.com'),
    Contact(name: 'Rhoda Hassinger', email: 'rhoda.hassinger@me.com'),
    Contact(name: 'Carson Cupps', email: 'carson.cupps@me.com'),
    Contact(name: 'Devora Nantz', email: 'devora.nantz@me.com'),
    Contact(name: 'Tyisha Primus', email: 'tyisha.primus@me.com'),
    Contact(name: 'Muriel Lewellyn', email: 'muriel.lewellyn@me.com'),
    Contact(name: 'Hunter Giraud', email: 'hunter.giraud@me.com'),
    Contact(name: 'Corina Whiddon', email: 'corina.whiddon@me.com'),
    Contact(name: 'Meaghan Covarrubias', email: 'meaghan.covarrubias@me.com'),
    Contact(name: 'Ulysses Severson', email: 'ulysses.severson@me.com'),
    Contact(name: 'Richard Baxter', email: 'richard.baxter@me.com'),
    Contact(name: 'Alessandra Kahn', email: 'alessandra.kahn@me.com'),
    Contact(name: 'Libby Saari', email: 'libby.saari@me.com'),
    Contact(name: 'Valeria Salvador', email: 'valeria.salvador@me.com'),
    Contact(name: 'Fredrick Folkerts', email: 'fredrick.folkerts@me.com'),
    Contact(name: 'Delmy Izzi', email: 'delmy.izzi@me.com'),
    Contact(name: 'Leann Klock', email: 'leann.klock@me.com'),
    Contact(name: 'Rhiannon Macfarlane', email: 'rhiannon.macfarlane@me.com'),
  ];

}

//Test data
class Contact {
  Contact({this.name, this.email});
  final String name;
  final String email;
}

abstract class HasLayoutGroup {
  LayoutGroup get layoutGroup;
  VoidCallback get onLayoutToggle;
}

enum LayoutGroup {
  nonScrollable,
  scrollable,
}