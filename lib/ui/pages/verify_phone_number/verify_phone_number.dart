import 'package:flutter/material.dart';
import 'package:snschat_flutter/general/ui-component/pin_text_field.dart';

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
    // TODO: implement build
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
                    print('PIN number is: ' + pin);
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
}
