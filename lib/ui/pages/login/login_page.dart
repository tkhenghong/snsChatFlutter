import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:snschat_flutter/general/ui-component/loading.dart';
import 'package:snschat_flutter/state/bloc/user/UserBloc.dart';
import 'package:snschat_flutter/state/bloc/user/UserEvents.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:date_format/date_format.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new LoginPageState();
  }
}

class LoginPageState extends State<LoginPage> {
  UserBloc userBloc = UserBloc();

  _signIn() async {
    showCenterLoadingIndicator(context);
    userBloc.dispatch(UserLogin());
    Navigator.pop(context); // Kill loading screen
  }

  requestPermissions() async {
    Map<PermissionGroup, PermissionStatus> permissions =
        await PermissionHandler().requestPermissions([
      PermissionGroup.contacts,
      PermissionGroup.camera,
      PermissionGroup.storage,
      PermissionGroup.location,
      PermissionGroup.microphone
    ]);
    return permissions;
  }

  @override
  Widget build(BuildContext context) {
    requestPermissions();
    return GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        //Focuses on nothing, means disable focus and hide keyboard
        child: Material(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(padding: EdgeInsets.symmetric(vertical: 70.00)),
              Text(
                "Login",
                style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              Padding(padding: EdgeInsets.symmetric(vertical: 20.00)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: TextField(
                  cursorColor: Colors.black,
                  style: TextStyle(color: Colors.black),
                  inputFormatters: [
                    BlacklistingTextInputFormatter(RegExp('[\\.|\\,]')),
                  ],
                  maxLength: 15,
                  decoration: InputDecoration(hintText: "Mobile Number"),
                  autofocus: true,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                ),
              ),
              RaisedButton(
                onPressed: () {
                  _signIn();
//                      .then((FirebaseUser user) {
//                    print("user.displayName: " + user.displayName);
//                    print("user.email: " + user.email);
//                    print("user.isAnonymous: " + user.isAnonymous.toString());
//                    print("user.isEmailVerified: " +
//                        user.isEmailVerified.toString());
//                    print("user.phoneNumber: " + user.phoneNumber.toString());
//                    print("user.photoUrl: " + user.photoUrl.toString());
//                    print("user.uid: " + user.uid.toString());
                    goToVerifyPhoneNumber();
//                  });
                },
                textColor: Colors.white,
                color: Colors.black,
                highlightColor: Colors.black54,
                splashColor: Colors.grey,
                animationDuration: Duration(milliseconds: 500),
                padding: EdgeInsets.only(
                    left: 70.0, right: 70.0, top: 15.0, bottom: 15.0),
                shape: RoundedRectangleBorder(
//                  side: BorderSide(color: Colors.black, width: 1.0),
                    borderRadius: BorderRadius.circular(50.0)),
                child: Text("Next"),
              ),
              Padding(padding: EdgeInsets.symmetric(vertical: 10.00)),
              Text("Don't have account yet?"),
              FlatButton(
                  onPressed: () => goToSignUp(),
                  child: Text(
                    "Sign Up Now",
                    style: TextStyle(color: Colors.black),
                  )),
              Padding(padding: EdgeInsets.symmetric(vertical: 50.00)),
              RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(children: [
                    TextSpan(
                        text: "Contact Support",
                        style: TextStyle(color: Colors.black),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            goToContactSupport();
                          })
                  ])),
              Padding(padding: EdgeInsets.symmetric(vertical: 5.00)),
              RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(children: [
                    TextSpan(
                        text: "Terms and Conditions",
                        style: TextStyle(color: Colors.black),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            goToTermsAndConditions();
                          })
                  ])),
              Padding(padding: EdgeInsets.symmetric(vertical: 5.00)),
              RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(children: [
                    TextSpan(
                        text: "Privacy Notice",
                        style: TextStyle(color: Colors.black),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            goToPrivacyNotice()();
                          })
                  ])),
            ],
          ),
        ));
  }

  goToVerifyPhoneNumber() {
    Navigator.of(context).pushNamed("verify_phone_number_page");
  }

  goToSignUp() {
    Navigator.of(context).pushNamed("sign_up_page");
  }

  goToContactSupport() async {
    String now = formatDate(new DateTime.now(), [dd, '/', mm, '/', yyyy]);
    String linebreak = '%0D%0A';
    String url =
        'mailto:<support@neurogine.com>?subject=Request for Contact Support ' +
            now +
            ' &body=Name: ' +
            linebreak +
            linebreak +
            'Email: ' +
            linebreak +
            linebreak +
            'Enquiry Details:';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  goToTermsAndConditions() {
    Navigator.of(context).pushNamed("terms_and_conditions_page");
  }

  goToPrivacyNotice() {
    Navigator.of(context).pushNamed("privacy_notice_page");
  }
}
