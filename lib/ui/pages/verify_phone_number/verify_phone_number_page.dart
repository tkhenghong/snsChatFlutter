import 'package:flutter/material.dart';
import 'package:snschat_flutter/general/ui-component/loading.dart';
import 'package:snschat_flutter/general/ui-component/pin_text_field.dart';
import 'package:snschat_flutter/ui/pages/chat_group_list/chat_group_list_page.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Text('Verify ' + phoneNo),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('Verify ' + phoneNo),
          RichText(
              text: TextSpan(
                  style: TextStyle(inherit: true, color: Colors.black),
                  children: <TextSpan>[
                    TextSpan(text: 'We have sent and SMS with a code to '),
                    TextSpan(
                        text: phoneNo.toString(),
                        style: TextStyle(
                            inherit: true, fontWeight: FontWeight.bold)),
// TODO: Add other types of error messages for different situations
//                TextSpan(text: 'Can\'t send an SMS with your code because you\'ve tried to register '),
//                TextSpan(text: phoneNo.toString(), style: TextStyle(inherit: true, fontWeight: FontWeight.bold)),
//                TextSpan(text: ' recently. Request a call or wait before requesting an SMS. '),
                  ])),
          FlatButton(
              onPressed: () {},
              child: Text(
                'Wrong number?',
                style: TextStyle(color: Colors.black),
              )),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              PinEntryTextField(
                  fields: 4,
                  onSubmit: (pin) {
                    showLoading(context);
                    print('PIN number is: ' + pin);
                    Future.delayed(Duration(seconds: 1), () { //Delay 1 second to simulate something loading
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
          Text('Enter 4-digit code'),
//          RaisedButton(onPressed: () {},  child: Text('Resend SMS'),), //In case youre able to resend SMS
          RaisedButton(
            onPressed: () {},
            child: Text('Resend SMS in 7 hours'),
          ),
          // In case you request a lot of times but you never retreived and entered the correct PIN
          RaisedButton(
            onPressed: () {},
            child: Text('Call me'),
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
