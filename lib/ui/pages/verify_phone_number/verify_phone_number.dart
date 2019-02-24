import 'package:flutter/material.dart';
import 'package:snschat_flutter/general/ui-component/loading.dart';
import 'package:snschat_flutter/general/ui-component/pin_text_field.dart';
import 'package:snschat_flutter/ui/pages/chat_group_list/chat_group_list.dart';

class VerifyPhoneNumberPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new VerifyPhoneNumberState();
  }
}

class VerifyPhoneNumberState extends State<VerifyPhoneNumberPage> {
  @override
  Widget build(BuildContext context) {
    String phoneNo = "+6012 309 6127";
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Verify ' + phoneNo),
        centerTitle: true,
      ),
      body: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Text('Verify ' + phoneNo),
          new RichText(
              text: new TextSpan(
                  style: new TextStyle(inherit: true, color: Colors.black),
                  children: <TextSpan>[
                    new TextSpan(text: 'We have sent and SMS with a code to '),
                    new TextSpan(
                        text: phoneNo.toString(),
                        style: new TextStyle(
                            inherit: true, fontWeight: FontWeight.bold)),
//                new TextSpan(text: 'Can\'t send an SMS with your code because you\'ve tried to register '),
//                new TextSpan(text: phoneNo.toString(), style: new TextStyle(inherit: true, fontWeight: FontWeight.bold)),
//                new TextSpan(text: ' recently. Request a call or wait before requesting an SMS. '),
                  ])),
          new FlatButton(
              onPressed: () {},
              child: new Text(
                'Wrong number?',
                style: new TextStyle(color: Colors.blue),
              )),
          new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new PinEntryTextField(
                  fields: 4,
                  onSubmit: (pin) {
                    showLoading(context);
                    print('PIN number is: ' + pin);
                    new Future.delayed(new Duration(seconds: 1), () { //Delay 1 second to simulate something loading
                      print('Loaded 3 seconds.');
                      Navigator.pop(context); //pop dialog
                      this.goToChatGroupList();
                    });
                  },
                  fieldWidth: 40.0,
                  fontSize: 20.0,
                  isTextObscure: false,
                  showFieldAsBox: false)
            ],
          ),
          new Text('Enter 4-digit code'),
//          new RaisedButton(onPressed: () {},  child: new Text('Resend SMS'),), //In case youre able to resend SMS
          new RaisedButton(
            onPressed: () {},
            child: new Text('Resend SMS in 7 hours'),
          ),
          // In case you request a lot of times but you never retreived and entered the correct PIN
          new RaisedButton(
            onPressed: () {},
            child: new Text('Call me'),
          ),
        ],
      ),
    );
  }

  goToChatGroupList() {
    //Remove all pages and make chat_group_list_page be the only page
    Navigator.of(context).pushNamedAndRemoveUntil("tabs_page", (Route<dynamic> route) => false);
  }
}
