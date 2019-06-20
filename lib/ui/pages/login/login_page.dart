import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:snschat_flutter/general/functions/repeating_functions.dart';
import 'package:snschat_flutter/general/ui-component/loading.dart';
import 'package:snschat_flutter/objects/settings/settings.dart';
import 'package:snschat_flutter/objects/user/user.dart';
import 'package:snschat_flutter/state/bloc/WholeApp/WholeAppBloc.dart';
import 'package:snschat_flutter/state/bloc/WholeApp/WholeAppEvent.dart';
import 'package:snschat_flutter/state/bloc/WholeApp/WholeAppState.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:date_format/date_format.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new LoginPageState();
  }
}

class LoginPageState extends State<LoginPage> {
  WholeAppBloc wholeAppBloc;
  final _formKey = GlobalKey<FormState>();
  TextEditingController textEditingController = new TextEditingController();

  _signIn() async {
    if (_formKey.currentState.validate()) {
      showCenterLoadingIndicator(context);
      wholeAppBloc.dispatch(UserSignInEvent(callback: (User user) {
        print('Callback reached.');
        if(user.id.isNotEmpty) {
          goToVerifyPhoneNumber();
        } else {
          // TODO: Add new Settings to the Bloc State
          Settings userSettings = Settings(id: generateNewId().toString(), notification: true, userId: user.id);
          wholeAppBloc.dispatch(AddSettingsEvent(
              callback: (Settings settings) {
                print('returned to login page. Settings id is: ' + settings.id);
                print("textEditingController.value.toString(): " + textEditingController.value.toString());
                wholeAppBloc.dispatch(UserSignUpEvent(callback: () {}, user: User(mobileNo: textEditingController.value.text, settingsId: settings.id)));
              },
              settings: userSettings));
        }

      }));
    }
  }

  @override
  Widget build(BuildContext context) {
    final WholeAppBloc _wholeAppBloc = BlocProvider.of<WholeAppBloc>(context);
    wholeAppBloc = _wholeAppBloc;
    wholeAppBloc.dispatch(CheckPermissionEvent(callback: (Map<PermissionGroup, PermissionStatus> permissionResults) {
      permissionResults.forEach((PermissionGroup permissionGroup, PermissionStatus permissionStatus) {
        if (permissionGroup == PermissionGroup.contacts && permissionStatus == PermissionStatus.granted) {
          print('if(permissionGroup == PermissionGroup.contacts && permissionStatus == PermissionStatus.granted)');
          wholeAppBloc.dispatch(GetPhoneStorageContactsEvent(callback: () {}));
        }
      });
    }));

    return BlocBuilder(
      bloc: _wholeAppBloc,
      builder: (context, WholeAppState state) {
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
                      child: Form(
                          key: _formKey,
                          child: TextFormField(
                            controller: textEditingController,
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Please enter your phone number";
                              }
                            },
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
                      )
                  ),
                  RaisedButton(
                    onPressed: () => _signIn(),
                    textColor: Colors.white,
                    color: Colors.black,
                    highlightColor: Colors.black54,
                    splashColor: Colors.grey,
                    animationDuration: Duration(milliseconds: 500),
                    padding: EdgeInsets.only(left: 70.0, right: 70.0, top: 15.0, bottom: 15.0),
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
      },
    );
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
    String url = 'mailto:<support@neurogine.com>?subject=Request for Contact Support ' +
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
