import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:snschat_flutter/general/functions/validation_functions.dart';
import 'package:snschat_flutter/general/ui-component/loading.dart';
import 'package:snschat_flutter/objects/index.dart';
import 'package:snschat_flutter/state/bloc/WholeApp/WholeAppBloc.dart';
import 'package:snschat_flutter/state/bloc/WholeApp/WholeAppState.dart';
import 'package:snschat_flutter/state/bloc/bloc.dart';
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

  String countryCodeString;

  bool deviceLocated = false;

  Color themePrimaryColor;

  String getPhoneNumber() {
    String phoneNoInitials = "";

    if (isObjectEmpty(countryCode)) {
//      phoneNoInitials = wholeAppBloc.currentState.ipGeoLocation.calling_code;
      phoneNoInitials = '+60';
    } else {
      phoneNoInitials = countryCode.dialCode;
    }
    String phoneNumber = phoneNoInitials + mobileNoTextController.value.text;
    return phoneNumber;
  }

  _signIn(BuildContext context) async {
    if (_formKey.currentState.validate()) {

      print('getPhoneNumber(): ' + getPhoneNumber());
      showCenterLoadingIndicator(context);

      BlocProvider.of<GoogleInfoBloc>(context).add(InitializeGoogleInfoEvent(callback: (GoogleSignIn googleSignIn) {
        if (!isObjectEmpty(googleSignIn)) {
          BlocProvider.of<UserBloc>(context).add(CheckUserSignedUpEvent(
              mobileNo: getPhoneNumber(),
              googleSignIn: googleSignIn,
              callback: (bool isSignedUp) {
                if (isSignedUp) {
                  BlocProvider.of<UserBloc>(context).add(UserSignInEvent(
                      googleSignIn: googleSignIn,
                      mobileNo: getPhoneNumber(),
                      callback: (bool signedIn) {
                        if (signedIn) {
                          Navigator.pop(context);
                          goToVerifyPhoneNumber(getPhoneNumber());
                        } else {
                          Fluttertoast.showToast(
                              msg: 'Invalid Mobile No./matching Google account. Please try again!', toastLength: Toast.LENGTH_SHORT);
                          BlocProvider.of<GoogleInfoBloc>(context).add(RemoveGoogleInfoEvent());
                          Navigator.pop(context);
                        }
                      }));
                }
              }));
        } else {
          Fluttertoast.showToast(msg: 'Please sign into your Google Account.', toastLength: Toast.LENGTH_SHORT);
          BlocProvider.of<GoogleInfoBloc>(context).add(RemoveGoogleInfoEvent());
          Navigator.pop(context);
        }
      }));
    }
  }

  onCountryPickerChanged(CountryCode countryCode) {
    print("onCountryPickerChanged()");
    print("countryCode: " + countryCode.toString());
    print("countryCode.code: " + countryCode.code.toString());
    print("countryCode.flagUri: " + countryCode.flagUri.toString());
    this.countryCode = countryCode;
    this.countryCodeString = countryCode.code.toString();
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;

    themePrimaryColor = Theme.of(context).textTheme.title.color;

    return BlocBuilder<IPGeoLocationBloc, IPGeoLocationState>(
      condition: (previousIpGeoLocationState, ipGeoLocationState) {
        if (ipGeoLocationState is IPGeoLocationLoaded) {
          countryCodeString = 'US';
          return true;
        }
        return false;
      },
      builder: (context, ipGeoLocationState) {
        if (ipGeoLocationState is IPGeoLocationLoading) {
          BlocProvider.of<IPGeoLocationBloc>(context).add(GetIPGeoLocationEvent());
          return Center();
        }

        if (ipGeoLocationState is IPGeoLocationNotLoaded) {
          print('login_page.dart if (ipGeoLocationState is IPGeoLocationNotLoaded)');
          countryCodeString = 'US';
          return loginScreen(deviceWidth, deviceHeight);
        }

        if (ipGeoLocationState is IPGeoLocationLoaded) {
          print('login_page.dart if (ipGeoLocationState is IPGeoLocationLoaded)');
          countryCodeString = isObjectEmpty(ipGeoLocationState.ipGeoLocation) ? "US" : ipGeoLocationState.ipGeoLocation.country_code2;
          return loginScreen(deviceWidth, deviceHeight);
        }

        return Center(
          child: Text('Login page error. Please try restart the app.'),
        );
      },
    );
  }

  loginScreen(deviceWidth, deviceHeight) => MultiBlocListener(
        listeners: [
          BlocListener<IPGeoLocationBloc, IPGeoLocationState>(
            listener: (context, state) {},
          ),
          BlocListener<UserBloc, UserState>(
            listener: (context, state) {
              print('login_page.dart UserBloc Listener is working.');
              if (state is UserLoaded) {
                print('login_page.dart is state is userloaded');
                // If you hear UserLoaded event, this listener will initialize the settings of the user.
                BlocProvider.of<SettingsBloc>(context).add(GetUserSettingsEvent(user: state.user));
              }
            },
          ),
        ],
        child: GestureDetector(
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
                                initialSelection: countryCodeString,
                                alignLeft: false,
                                showCountryOnly: false,
                                showFlag: true,
                                showOnlyCountryWhenClosed: false,
                                favorite: [countryCodeString],
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
                    onPressed: () => _signIn(context),
                    textColor: Colors.white,
                    splashColor: Colors.grey,
                    animationDuration: Duration(milliseconds: 500),
                    padding: EdgeInsets.only(left: 70.0, right: 70.0, top: 15.0, bottom: 15.0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
                    child: Text("Next"),
                  ),
                  Padding(padding: EdgeInsets.symmetric(vertical: 10.00)),
                  Text("Don't have account yet?"),
                  FlatButton(
                      onPressed: () => goToSignUp(),
                      child: Text(
                        "Sign Up Now",
                        style: TextStyle(color: themePrimaryColor),
                      )),
                  Padding(padding: EdgeInsets.symmetric(vertical: 50.00)),
                  RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(children: [
                        TextSpan(
                            text: "Contact Support",
                            style: TextStyle(color: themePrimaryColor),
                            recognizer: TapGestureRecognizer()..onTap = () => goToContactSupport)
                      ])),
                  Padding(padding: EdgeInsets.symmetric(vertical: 5.00)),
                  RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(children: [
                        TextSpan(
                            text: "Terms and Conditions",
                            style: TextStyle(color: themePrimaryColor),
                            recognizer: TapGestureRecognizer()..onTap = () => goToTermsAndConditions())
                      ])),
                  Padding(padding: EdgeInsets.symmetric(vertical: 5.00)),
                  RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(children: [
                        TextSpan(
                            text: "Privacy Notice",
                            style: TextStyle(color: themePrimaryColor),
                            recognizer: TapGestureRecognizer()..onTap = () => goToPrivacyNotice())
                      ])),
                ],
              ),
            )),
      );

  goToVerifyPhoneNumber(mobileNo) {
    Navigator.push(context, MaterialPageRoute(builder: ((context) => VerifyPhoneNumberPage(mobileNo: getPhoneNumber()))));
  }

  goToSignUp() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: ((context) => SignUpPage(mobileNo: mobileNoTextController.value.text, countryCodeString: countryCodeString))));
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
