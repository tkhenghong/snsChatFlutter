import 'dart:async';

import 'package:flutter/material.dart';

import 'package:pin_input_text_field/pin_input_text_field.dart';
import 'package:snschat_flutter/general/ui-component/loading.dart';

class VerifyPhoneNumberPage extends StatefulWidget {
  String mobileNo;

  VerifyPhoneNumberPage({this.mobileNo});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new VerifyPhoneNumberState();
  }
}

class VerifyPhoneNumberState extends State<VerifyPhoneNumberPage> {
  TextEditingController textEditingController;
  PinDecoration pinDecoration;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    textEditingController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    String phoneNo = widget.mobileNo;
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
              text: TextSpan(style: TextStyle(inherit: true, color: Colors.black), children: <TextSpan>[
            TextSpan(text: 'We have sent and SMS with a code to '),
            TextSpan(text: phoneNo.toString(), style: TextStyle(inherit: true, fontWeight: FontWeight.bold)),
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
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 70.0),
            // PIN Text Field: https://pub.dev/packages/pin_input_text_field
            // Auto "Enter" when all PIN text fields have values
            child: PinInputTextField(
              pinLength: 4,
              autoFocus: true,
              textInputAction: TextInputAction.go,
              controller: textEditingController,
              enabled: true,
              keyboardType: TextInputType.number,
              decoration: UnderlineDecoration(
                  textStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold),
                  color: Colors.black, obscureStyle: ObscureStyle(isTextObscure: true)),
              onSubmit: (pin) {
                print('PIN number is: ' + pin);
                showLoading(context);
                Future.delayed(Duration(milliseconds: 1000), () {
                  //Delay 1 second to simulate something loading
                  print('Loaded 1 second.');
                  Navigator.pop(context); //pop loading dialog
                  this.goToChatGroupList();
                });
              },
            ),
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
