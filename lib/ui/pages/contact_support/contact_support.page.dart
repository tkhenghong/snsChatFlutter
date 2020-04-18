import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactSupportPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ContactSupportPageState();

}

class ContactSupportPageState extends State<ContactSupportPage> {
  @override
  Widget build(BuildContext context) {
    return new Container();
  }

  _launchURL() async {
    const url = 'https://flutter.io';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

}