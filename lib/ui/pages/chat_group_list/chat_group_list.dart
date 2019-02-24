import 'package:flutter/material.dart';
import 'package:snschat_flutter/ui/pages/scan_qr_code/scan_qr_code_page.dart';
import 'package:snschat_flutter/ui/pages/settings/settings.dart';

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

class GroupChatListTile extends ListTile {
  // UI Layout for the list's element
  GroupChatListTile(Contact contact)
      : super(
    title: Text(contact.name),
    subtitle: Text(contact.email),
    leading: CircleAvatar(child: Text(contact.name[0])),
    onTap: () {print("List element clicked!");}
  );
}

class ChatGroupListPage extends StatefulWidget implements HasLayoutGroup {
  ChatGroupListPage({Key key, this.layoutGroup, this.onLayoutToggle})
      : super(key: key);
  final LayoutGroup layoutGroup;
  final VoidCallback onLayoutToggle;

  @override
  State<StatefulWidget> createState() {
    return new ChatGroupListState();
  }
}

class ChatGroupListState extends State<ChatGroupListPage> {

  // buildChatListElementUILayout()
  @override
  Widget build(BuildContext context) {
    return new Material(
      color: Colors.white,
      child: buildChatListElementUILayout()
    );
  }

  Widget buildChatListElementUILayout() {
    // Put your data here
    return new ListView.builder(
        itemCount: allContacts.length,
        physics: const AlwaysScrollableScrollPhysics(),
        //suggestion from https://github.com/flutter/flutter/issues/22314
        itemBuilder: (BuildContext content, int index) {
          Contact contact = allContacts[index];
          return new GroupChatListTile(contact);
        });
  }

  // Test data: 240 items
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
