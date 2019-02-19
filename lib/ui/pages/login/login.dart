import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:snschat_flutter/ui/pages/verify_phone_number/verify_phone_number.dart';
import '../contact_support/contact_support.dart';
import '../privacy_notice/privacy_notice.dart';
import '../terms_and_conditions/terms_and_conditions.dart';
import '../sign_up/sign_up.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:date_format/date_format.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new LoginPageState();
  }
}

class LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(new FocusNode()), //Focuses on nothing, means disable focus and hide keyboard
      child: new Material(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Padding(padding: new EdgeInsets.symmetric(vertical: 70.00)),
            new Text(
              "Login",
              style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            new Padding(padding: new EdgeInsets.symmetric(vertical: 20.00)),
            new Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: new TextField(
                maxLength: 15,
                decoration: new InputDecoration(
                    hintText: "Mobile Number"),
                autofocus: true,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
              ),
            ),
            new RaisedButton(
              onPressed: () => goToVerifyPhoneNumber(),
              textColor: Colors.white,
              color: Colors.blue,
              animationDuration: Duration(milliseconds: 500),
              padding: EdgeInsets.only(
                  left: 70.0, right: 70.0, top: 15.0, bottom: 15.0),
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.blue, width: 1.0),
                  borderRadius: BorderRadius.circular(50.0)),
              child: new Text("Next"),
            ),
            new Padding(padding: new EdgeInsets.symmetric(vertical: 10.00)),
            new Text("Don't have account yet?"),
            new FlatButton(
                onPressed: () => goToSignUp(),
                child: new Text(
                  "Sign Up Now",
                  style: new TextStyle(color: Colors.blue),
                )),
            new Padding(padding: new EdgeInsets.symmetric(vertical: 50.00)),
            new RichText(
                textAlign: TextAlign.center,
                text: new TextSpan(children: [
                  new TextSpan(
                      text: "Contact Support",
                      style: new TextStyle(color: Colors.blue),
                      recognizer: new TapGestureRecognizer()..onTap = () {
                        goToContactSupport();
                      }
                  )
                ])),
            new Padding(padding: new EdgeInsets.symmetric(vertical: 5.00)),
            new RichText(
                textAlign: TextAlign.center,
                text: new TextSpan(children: [
                  new TextSpan(
                      text: "Terms and Conditions",
                      style: new TextStyle(color: Colors.blue),
                      recognizer: new TapGestureRecognizer()..onTap = () {
                        goToTermsAndConditions();
                      }
                  )
                ])),
            new Padding(padding: new EdgeInsets.symmetric(vertical: 5.00)),
            new RichText(
                textAlign: TextAlign.center,
                text: new TextSpan(children: [
                  new TextSpan(
                      text: "Privacy Notice",
                      style: new TextStyle(color: Colors.blue),
                      recognizer: new TapGestureRecognizer()..onTap = () {
                        goToPrivacyNotice()();
                      }
                  )
                ])),
          ],
        ),
      )
    );
  }

  goToVerifyPhoneNumber () {
    Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new VerifyPhoneNumberPage()));
  }

  goToSignUp () {
    Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new SignUpPage()));
  }

  goToContactSupport () async {
    String now = formatDate(new DateTime.now(), [dd, '/', mm, '/', yyyy]);
    String linebreak = '%0D%0A';
    String url = 'mailto:<support@neurogine.com>?subject=Request for Contact Support '+ now + ' &body=Name: '+linebreak+linebreak+'Email: '+linebreak+linebreak+'Enquiry Details:';
    if (await canLaunch(url)) {
    await launch(url);
    } else {
    throw 'Could not launch $url';
    }
//    return Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new ContactSupportPage()));
  }

  goToTermsAndConditions() {
    Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new TermsAndConditionsPage()));
  }

  goToPrivacyNotice() {
    Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new PrivacyNoticePage()));
  }
}


