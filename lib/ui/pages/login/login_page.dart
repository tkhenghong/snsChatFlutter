import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:snschat_flutter/general/functions/validation_functions.dart';
import 'package:snschat_flutter/general/ui-component/loading.dart';
import 'package:snschat_flutter/state/bloc/WholeApp/WholeAppBloc.dart';
import 'package:snschat_flutter/state/bloc/WholeApp/WholeAppEvent.dart';
import 'package:snschat_flutter/state/bloc/WholeApp/WholeAppState.dart';
import 'package:snschat_flutter/ui/pages/sign_up/sign_up_page.dart';
import 'package:snschat_flutter/ui/pages/verify_phone_number/verify_phone_number_page.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:date_format/date_format.dart';

import 'package:country_code_picker/country_code_picker.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new LoginPageState();
  }
}

class LoginPageState extends State<LoginPage> {
  WholeAppBloc wholeAppBloc;
  final _formKey = GlobalKey<FormState>();
  TextEditingController mobileNoTextController = new TextEditingController();

  CountryCode countryCode;

  bool deviceLocated = false;

  String getPhoneNumber() {
    String phoneNoInitials = "";
    if (isObjectEmpty(countryCode)) {
      phoneNoInitials = wholeAppBloc.currentState.ipGeoLocation.calling_code;
    } else {
      phoneNoInitials = countryCode.dialCode;
    }
    String phoneNumber = phoneNoInitials + mobileNoTextController.value.text;
    print("REAL phoneNumber: " + phoneNumber);
    return phoneNumber;
  }

  _signIn() async {
    if (_formKey.currentState.validate()) {
      showCenterLoadingIndicator(context);
      wholeAppBloc.dispatch(CheckUserSignedUpEvent(
          callback: (bool isSignedUp) {
            if (isSignedUp) {
              wholeAppBloc.dispatch(UserSignInEvent(
                  callback: (bool signInSuccessful) {
                    if (signInSuccessful) {
                      Navigator.pop(context);
                      goToVerifyPhoneNumber();
                    } else {
                      Fluttertoast.showToast(
                          msg: 'Invalid Mobile No./matching Google account. Please try again!', toastLength: Toast.LENGTH_SHORT);
                      wholeAppBloc.dispatch(UserSignOutEvent());
                      Navigator.pop(context);
                    }
                  },
                  mobileNo: getPhoneNumber()));
            } else {
              Fluttertoast.showToast(
                  msg: 'Invalid Mobile No./matching Google account. Please try again!', toastLength: Toast.LENGTH_SHORT);
              wholeAppBloc.dispatch(UserSignOutEvent()); // Reset everything to initial state first
              Navigator.pop(context);
//              goToSignUp();
            }
          },
          mobileNo: getPhoneNumber()));
    }
  }

  String isIPLocationExists(WholeAppState state) {
    return isObjectEmpty(state.ipGeoLocation) ? "US" : state.ipGeoLocation.country_code2;
  }

  onCountryPickerChanged(CountryCode countryCode) {
    print("onCountryPickerChanged()");
    print("countryCode: " + countryCode.toString());
    print("countryCode.code: " + countryCode.code.toString());
    print("countryCode.flagUri: " + countryCode.flagUri.toString());
    this.countryCode = countryCode;
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;

    print("deviceWidth: " + deviceWidth.toString());
    print("deviceHeight: " + deviceHeight.toString());

    final WholeAppBloc _wholeAppBloc = BlocProvider.of<WholeAppBloc>(context);
    wholeAppBloc = _wholeAppBloc;
    wholeAppBloc.dispatch(CheckPermissionEvent(callback: (Map<PermissionGroup, PermissionStatus> permissionResults) {
      permissionResults.forEach((PermissionGroup permissionGroup, PermissionStatus permissionStatus) {
        if (permissionGroup == PermissionGroup.contacts && permissionStatus == PermissionStatus.granted) {
          print('if(permissionGroup == PermissionGroup.contacts && permissionStatus == PermissionStatus.granted)');
          wholeAppBloc.dispatch(GetPhoneStorageContactsEvent(callback: (bool done) {}));
        }
      });
    }));

    return BlocBuilder(
      bloc: _wholeAppBloc,
      builder: (context, WholeAppState state) {
        print("Build?");
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
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(left: 20.0),
                              ),
                              CountryCodePicker(
                                initialSelection: isIPLocationExists(state),
                                alignLeft: false,
                                showCountryOnly: false,
                                showFlag: true,
                                showOnlyCountryWhenClosed: false,
                                favorite: [isIPLocationExists(state)],
                                onChanged: onCountryPickerChanged,
                              ),
                              Container(
                                width: deviceWidth * 0.5,
                                margin: EdgeInsetsDirectional.only(top: deviceHeight * 0.03),
                                child: Form(
                                  key: _formKey,
                                  child: TextFormField(
                                    controller: mobileNoTextController,
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return "Please enter your phone number";
                                      }
                                      if (value.length < 8) {
                                        return "Please enter a valid phone number format";
                                      }

                                      return null;
                                    },
                                    cursorColor: Colors.black,
                                    style: TextStyle(color: Colors.black),
                                    inputFormatters: [
                                      BlacklistingTextInputFormatter(RegExp('[\\.|\\,]')),
                                    ],
                                    maxLength: 15,
                                    decoration: InputDecoration(hintText: "Mobile Number"),
                                    autofocus: true,
                                    textAlign: TextAlign.left,
                                    keyboardType: TextInputType.number,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      )),
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
                            recognizer: TapGestureRecognizer()..onTap = () => goToContactSupport)
                      ])),
                  Padding(padding: EdgeInsets.symmetric(vertical: 5.00)),
                  RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(children: [
                        TextSpan(
                            text: "Terms and Conditions",
                            style: TextStyle(color: Colors.black),
                            recognizer: TapGestureRecognizer()..onTap = () => goToTermsAndConditions())
                      ])),
                  Padding(padding: EdgeInsets.symmetric(vertical: 5.00)),
                  RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(children: [
                        TextSpan(
                            text: "Privacy Notice",
                            style: TextStyle(color: Colors.black),
                            recognizer: TapGestureRecognizer()..onTap = () => goToPrivacyNotice())
                      ])),
                ],
              ),
            ));
      },
    );
  }

  goToVerifyPhoneNumber() {
    Navigator.push(context, MaterialPageRoute(builder: ((context) => VerifyPhoneNumberPage(mobileNo: getPhoneNumber()))));
  }

  goToSignUp() {
    Navigator.push(context, MaterialPageRoute(builder: ((context) => SignUpPage(mobileNo: getPhoneNumber()))));
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
