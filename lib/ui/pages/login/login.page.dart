import 'package:country_code_picker/country_code_picker.dart';
import 'package:date_format/date_format.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:snschat_flutter/environments/development/variables.dart' as globals;
import 'package:snschat_flutter/general/index.dart';
import 'package:snschat_flutter/objects/models/index.dart';
import 'package:snschat_flutter/objects/rest/index.dart';
import 'package:snschat_flutter/state/bloc/authentication/AuthenticationBloc.dart';
import 'package:snschat_flutter/state/bloc/authentication/AuthenticationEvent.dart';
import 'package:snschat_flutter/state/bloc/bloc.dart';
import 'package:snschat_flutter/ui/pages/index.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new LoginPageState();
  }
}

class LoginPageState extends State<LoginPage> {
  bool deviceLocated = false;

  double deviceWidth;
  double deviceHeight;

  String DEFAULT_COUNTRY_CODE = globals.DEFAULT_COUNTRY_CODE;

  IPGeoLocation ipGeoLocation;
  CountryCode countryCode;
  String countryCodeString;
  String mobileNumber;

  Color themePrimaryColor;

  final _formKey = GlobalKey<FormState>();
  TextEditingController mobileNoTextController = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext buildContext) {
    deviceWidth = MediaQuery.of(buildContext).size.width;
    deviceHeight = MediaQuery.of(buildContext).size.height;

    themePrimaryColor = Theme.of(buildContext).textTheme.title.color;

    return BlocBuilder<IPGeoLocationBloc, IPGeoLocationState>(
      builder: (context, ipGeoLocationState) {
        if (ipGeoLocationState is IPGeoLocationLoading) {
          return Material(
            child: Center(
              child: Text('Loading...'),
            ),
          );
        }

        if (ipGeoLocationState is IPGeoLocationNotLoaded) {
          countryCodeString = DEFAULT_COUNTRY_CODE;
          return loginScreen(buildContext);
        }

        if (ipGeoLocationState is IPGeoLocationLoaded) {
          countryCodeString = isObjectEmpty(ipGeoLocationState.ipGeoLocation) ? DEFAULT_COUNTRY_CODE : ipGeoLocationState.ipGeoLocation.country_code2;
          ipGeoLocation = ipGeoLocationState.ipGeoLocation;
          return loginScreen(buildContext);
        }

        return Material(
          child: Center(
            child: Text('Login page error. Please try restart the app.'),
          ),
        );
      },
    );
  }

  Widget loginScreen(BuildContext buildContext) => MultiBlocListener(
        listeners: [
          BlocListener<IPGeoLocationBloc, IPGeoLocationState>(
            listener: (context, state) {},
          ),
          BlocListener<UserBloc, UserState>(
            listener: (context, state) {},
          ),
        ],
        child: GestureDetector(
            // Detect user touch out of the text fields
            onTap: () => FocusScope.of(buildContext).requestFocus(FocusNode()),
            // Focuses on nothing, means disable focus and hide keyboard
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
                                    validator: validateMobileNo,
                                    inputFormatters: [
                                      BlacklistingTextInputFormatter(RegExp('[\\.|\\,]')),
                                    ],
                                    maxLength: 15,
                                    decoration: InputDecoration(hintText: "Mobile Number"),
                                    autofocus: true,
                                    textAlign: TextAlign.left,
                                    keyboardType: TextInputType.number,
                                    onChanged: getPhoneNumber(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      )),
                  RaisedButton(
                    onPressed: () => _signIn(buildContext),
                    textColor: Colors.white,
                    splashColor: Colors.grey,
                    animationDuration: Duration(milliseconds: 500),
                    padding: EdgeInsets.only(left: 70.0, right: 70.0, top: 15.0, bottom: 15.0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
                    child: Text("Sign In"),
                  ),
                  Padding(padding: EdgeInsets.symmetric(vertical: 10.00)),
                  // GoogleSignInButton(onPressed: () {
                  //   _signIn(mainBuildContext);
                  // }),
                  // FacebookSignInButton(onPressed: () {
                  //   _signInwithFacebook(mainBuildContext);
                  // }),
                  // AppleSignInButton(
                  //   onPressed: () {
                  //     _signInwithApple(mainBuildContext);
                  //   },
                  // ),
                  // TwitterSignInButton(
                  //   onPressed: () {
                  //     _signInwithTwitter(mainBuildContext);
                  //   },
                  // ),
                  Padding(padding: EdgeInsets.symmetric(vertical: 10.00)),
                  Text("Don't have account yet?"),
                  FlatButton(
                      onPressed: () => goToSignUp(buildContext),
                      child: Text(
                        "Sign Up Now",
                        style: TextStyle(color: themePrimaryColor),
                      )),
                  Padding(padding: EdgeInsets.symmetric(vertical: 15.00)),
                  RichText(textAlign: TextAlign.center, text: TextSpan(children: [TextSpan(text: "Contact Support", style: TextStyle(color: themePrimaryColor), recognizer: TapGestureRecognizer()..onTap = () => goToContactSupport)])),
                  Padding(padding: EdgeInsets.symmetric(vertical: 5.00)),
                  RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(children: [TextSpan(text: "Terms and Conditions", style: TextStyle(color: themePrimaryColor), recognizer: TapGestureRecognizer()..onTap = () => goToTermsAndConditions(context))])),
                  Padding(padding: EdgeInsets.symmetric(vertical: 5.00)),
                  RichText(textAlign: TextAlign.center, text: TextSpan(children: [TextSpan(text: "Privacy Notice", style: TextStyle(color: themePrimaryColor), recognizer: TapGestureRecognizer()..onTap = () => goToPrivacyNotice(context))])),
                ],
              ),
            )),
      );

  String validateMobileNo(value) {
    if (value.isEmpty) {
      return "Please enter your phone number";
    }
    if (value.length < 8) {
      return "Please enter a valid phone number format";
    }

    return null;
  }

  onCountryPickerChanged(CountryCode countryCode) {
    this.countryCode = countryCode;
    this.countryCodeString = countryCode.code;
  }

  getPhoneNumber() {
    String phoneNoInitials = "";

    if (isObjectEmpty(countryCode)) {
      phoneNoInitials = ipGeoLocation.calling_code;
    } else {
      phoneNoInitials = countryCode.dialCode;
    }
    mobileNumber = phoneNoInitials + mobileNoTextController.value.text;
  }

  getConversationGroupsMultimedia(BuildContext context) {
    ConversationGroupState conversationGroupState = BlocProvider.of<ConversationGroupBloc>(context).state;
    if (conversationGroupState is ConversationGroupsLoaded) {
      BlocProvider.of<MultimediaBloc>(context).add(GetConversationGroupsMultimediaEvent(conversationGroupList: conversationGroupState.conversationGroupList, callback: (bool done) {}));
    }
  }

  goToVerifyPhoneNumber(PreVerifyMobileNumberOTPResponse preVerifyMobileNumberOTPResponse, BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: ((context) => VerifyPhoneNumberPage(preVerifyMobileNumberOTPResponse: preVerifyMobileNumberOTPResponse))));
  }

  goToSignUp(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: ((context) => SignUpPage(mobileNo: mobileNoTextController.value.text, countryCodeString: countryCodeString))));
  }

  goToContactSupport() async {
    String now = formatDate(new DateTime.now(), [dd, '/', mm, '/', yyyy]);
    String linebreak = '%0D%0A';
    String url = 'mailto:<tkhenghong@gmail.com>?subject=Request for Contact Support ' + now + ' &body=Name: ' + linebreak + linebreak + 'Email: ' + linebreak + linebreak + 'Enquiry Details:';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  goToTermsAndConditions(BuildContext context) {
    Navigator.of(context).pushNamed("terms_and_conditions_page");
  }

  goToPrivacyNotice(BuildContext context) {
    Navigator.of(context).pushNamed("privacy_notice_page");
  }

  _signIn(BuildContext context) async {
    getPhoneNumber();
    BlocProvider.of<AuthenticationBloc>(context).add(PreVerifyMobileNoEvent(
        mobileNo: mobileNumber,
        callback: (PreVerifyMobileNumberOTPResponse preVerifyMobileNumberOTPResponse) {
          if (!isObjectEmpty(preVerifyMobileNumberOTPResponse)) {
            goToVerifyPhoneNumber(preVerifyMobileNumberOTPResponse, context);
          }
        }));
  }

  _signInwithGoogle(BuildContext context, IPGeoLocation ipGeoLocation) async {
    if (_formKey.currentState.validate()) {
      showCenterLoadingIndicator(context);

      BlocProvider.of<GoogleInfoBloc>(context).add(SignInGoogleInfoEvent(callback: (bool initialized) {
        if (initialized) {
          BlocProvider.of<GoogleInfoBloc>(context).add(GetOwnGoogleInfoEvent(callback: (GoogleSignIn googleSignIn, FirebaseAuth firebaseAuth, FirebaseUser firebaseUser) {
            BlocProvider.of<UserBloc>(context).add(CheckUserSignedUpEvent(
                mobileNo: mobileNumber,
                googleSignIn: googleSignIn,
                callback: (bool isSignedUp) {
                  if (isSignedUp) {
                    BlocProvider.of<UserBloc>(context).add(UserSignInEvent(
                        googleSignIn: googleSignIn,
                        mobileNo: mobileNumber,
                        callback: (User user2) {
                          if (!isObjectEmpty(user2)) {
                            BlocProvider.of<SettingsBloc>(context).add(GetUserSettingsEvent(
                                user: user2,
                                callback: (Settings settings) {
                                  if (!isObjectEmpty(settings)) {
                                    Navigator.pop(context);
                                    // TODO: Go to verify Phone Number using sign in with Google
                                    // goToVerifyPhoneNumber(mobileNumber, context);
                                  } else {
                                    showToast('Invalid Mobile No./matching Google account. Please try again.', Toast.LENGTH_SHORT);
                                    BlocProvider.of<GoogleInfoBloc>(context).add(RemoveGoogleInfoEvent(callback: (bool done) {}));
                                    Navigator.pop(context);
                                  }
                                  ;
                                }));
                            // Get previous data
                            BlocProvider.of<ConversationGroupBloc>(context).add(GetUserPreviousConversationGroupsEvent(
                                user: user2,
                                callback: (bool done) {
                                  if (done) {
                                    getConversationGroupsMultimedia(context);
                                  }
                                }));
                            BlocProvider.of<UnreadMessageBloc>(context).add(GetUserPreviousUnreadMessagesEvent(user: user2, callback: (bool done) {}));
                            BlocProvider.of<MultimediaBloc>(context).add(GetUserProfilePictureMultimediaEvent(user: user2, callback: (bool done) {}));
                            BlocProvider.of<UserContactBloc>(context).add(GetUserPreviousUserContactsEvent(user: user2, callback: (bool done) {}));
                          } else {
                            showToast('Invalid Mobile No./matching Google account. Please try again.', Toast.LENGTH_SHORT);
                            BlocProvider.of<GoogleInfoBloc>(context).add(RemoveGoogleInfoEvent(callback: (bool done) {
                              Navigator.pop(context);
                            }));
                          }
                        }));
                  } else {
                    showToast('Unregconized phone number/Google Account. Please sign up first.', Toast.LENGTH_SHORT);
                    BlocProvider.of<GoogleInfoBloc>(context).add(RemoveGoogleInfoEvent(callback: (bool done) {
                      Navigator.pop(context);
                    }));
                  }
                }));
          }));
        } else {
          showToast('Please sign into your Google Account first.', Toast.LENGTH_SHORT);
          BlocProvider.of<GoogleInfoBloc>(context).add(RemoveGoogleInfoEvent(callback: (bool done) {}));
          Navigator.pop(context);
        }
      }));
    }
  }

  _signInwithFacebook(BuildContext context) {
    print('Sign in using Facebook');
    showToast("Coming soon.", Toast.LENGTH_SHORT);
  }

  _signInwithApple(BuildContext context) {
    print('Sign in using Apple');
    showToast("Coming soon.", Toast.LENGTH_SHORT);
  }

  _signInwithTwitter(BuildContext context) {
    print('Sign in using Twitter');
    showToast("Coming soon.", Toast.LENGTH_SHORT);
  }
}
