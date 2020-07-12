import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:snschat_flutter/environments/development/variables.dart' as globals;
import 'package:snschat_flutter/general/index.dart';
import 'package:snschat_flutter/objects/models/index.dart';
import 'package:snschat_flutter/objects/rest/index.dart';
import 'package:snschat_flutter/state/bloc/bloc.dart';
import 'package:snschat_flutter/ui/pages/index.dart';

class SignUpPage extends StatefulWidget {
  String mobileNo;
  String countryCodeString;

  SignUpPage({this.mobileNo, this.countryCodeString});

  @override
  State<StatefulWidget> createState() {
    return new SignUpPageState();
  }
}

class SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController mobileNoTextController = new TextEditingController();

  String DEFAULT_COUNTRY_CODE = globals.DEFAULT_COUNTRY_CODE;

  FocusNode nodeOne = FocusNode();

  IPGeoLocation ipGeoLocation;
  CountryCode countryCode;
  String countryCodeString;
  String mobileNumber;

  bool deviceLocated = false;

  double screenWidth;
  double screenHeight;

  BuildContext mBuildContext;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mobileNoTextController.text = widget.mobileNo.isNotEmpty ? widget.mobileNo : null;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    nodeOne.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    mBuildContext = context;

    return MultiBlocListener(
      listeners: [ipGeoLocationBlocListener()],
      child: signUpScreen(),
    );
  }

  signUpScreen() => Material(
      child: GestureDetector(
          // call this method here to hide soft keyboard
          onTap: () => FocusScope.of(mBuildContext).requestFocus(new FocusNode()),
          child: Scaffold(
            appBar: appBar(),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Sign Up",
                  style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                Padding(padding: EdgeInsets.symmetric(vertical: 10.00)),
                Text(
                  "Enter your mobile number and name: ",
                  style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.normal),
                  textAlign: TextAlign.center,
                ),
                Padding(padding: EdgeInsets.symmetric(vertical: 10.00)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Row(
                          children: <Widget>[
                            countryPicker(),
                            mobileNoTextField(),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                signUpButton(),
                Padding(padding: EdgeInsets.symmetric(vertical: 50.00)),
              ],
            ),
          )));

  BlocListener ipGeoLocationBlocListener() {
    return BlocListener<IPGeoLocationBloc, IPGeoLocationState>(
      listener: (context, ipGeoLocationState) {
        print('ipGeoLocationState listener is working.');
        if (ipGeoLocationState is IPGeoLocationLoaded) {
          countryCodeString = isObjectEmpty(ipGeoLocationState.ipGeoLocation) ? DEFAULT_COUNTRY_CODE : ipGeoLocationState.ipGeoLocation.country_code2;
          ipGeoLocation = ipGeoLocationState.ipGeoLocation;
        }
      },
    );
  }

  Widget appBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0, //Set Shadow
      iconTheme: IconThemeData(color: Theme.of(mBuildContext).primaryColor),
    );
  }

  Widget countryPicker() {
    return BlocBuilder<IPGeoLocationBloc, IPGeoLocationState>(
      builder: (context, ipGeoLocationState) {
        if (ipGeoLocationState is IPGeoLocationLoading) {
          return Material(
            child: Center(
              child: Text('Loading...'),
            ),
          );
        }

        if (ipGeoLocationState is IPGeoLocationLoaded) {
          countryCodeString = isObjectEmpty(ipGeoLocationState.ipGeoLocation) ? DEFAULT_COUNTRY_CODE : ipGeoLocationState.ipGeoLocation.country_code2;
          ipGeoLocation = ipGeoLocationState.ipGeoLocation;
          return CountryCodePicker(
            initialSelection: widget.countryCodeString,
            alignLeft: false,
            showCountryOnly: false,
            showFlag: true,
            showOnlyCountryWhenClosed: false,
            favorite: [widget.countryCodeString],
            onChanged: onCountryPickerChanged,
          );
        }

        return Material(
          child: Center(
            child: Text('Sign Up page error. Please try restart the app.'),
          ),
        );
      },
    );
  }

  Widget mobileNoTextField() {
    return Container(
      width: screenWidth * 0.6,
      margin: EdgeInsetsDirectional.only(top: screenHeight * 0.03),
      child: TextFormField(
        controller: mobileNoTextController,
        inputFormatters: [
          BlacklistingTextInputFormatter(RegExp('[\\.|\\,]')),
        ],
        maxLength: 15,
        decoration: InputDecoration(hintText: "Mobile Number"),
        autofocus: true,
        textAlign: TextAlign.left,
        keyboardType: TextInputType.phone,
        focusNode: nodeOne,
        validator: (value) {
          if (value.isEmpty) {
            return "Mobile number is empty";
          }

          return null;
        },
      ),
    );
  }

  Widget signUpButton() {
    return RaisedButton(
      onPressed: () => signUp(),
      textColor: Colors.white,
      animationDuration: Duration(milliseconds: 500),
      padding: EdgeInsets.only(left: 70.0, right: 70.0, top: 15.0, bottom: 15.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
      child: Text("Sign Up"),
    );
  }

  getPhoneNumber() {
    print('sign_up_page.dart getPhoneNumber()');
    String phoneNoInitials = "";

    if (isObjectEmpty(countryCode)) {
      phoneNoInitials = ipGeoLocation.calling_code;
    } else {
      phoneNoInitials = countryCode.dialCode;
    }
    mobileNumber = phoneNoInitials + mobileNoTextController.value.text;
  }

  onCountryPickerChanged(CountryCode countryCode) {
    this.countryCode = countryCode;
    widget.countryCodeString = countryCode.code;
  }

  signUp() async {
    if (!_formKey.currentState.validate()) {
      return;
    }

    getPhoneNumber();

    showCenterLoadingIndicator();

    try {
      BlocProvider.of<AuthenticationBloc>(mBuildContext).add(RegisterUsingMobileNoEvent(
          mobileNo: mobileNumber,
          countryCode: !isObjectEmpty(countryCode) ? countryCode.code : countryCodeString,
          callback: (PreVerifyMobileNumberOTPResponse preVerifyMobileNumberOTPResponse) {
            print('RegisterUsingMobileNoEvent response.');
            Navigator.pop(mBuildContext); //pop loading dialog
            if (!isObjectEmpty(preVerifyMobileNumberOTPResponse)) {
              goToVerifyPhoneNumber(preVerifyMobileNumberOTPResponse);
            }
          }));
    } catch (e) {
      print('ERROR CATCHED HERE?');
    }
  }

  /// NOTE: sign up using Google is deprecated */
  @deprecated
  signUpUsingGoogle() {
    BlocProvider.of<GoogleInfoBloc>(mBuildContext).add(SignInGoogleInfoEvent(callback: (bool initialized) {
      if (initialized) {
        BlocProvider.of<GoogleInfoBloc>(mBuildContext).add(GetOwnGoogleInfoEvent(callback: (GoogleSignIn googleSignIn2, FirebaseAuth firebaseAuth2, FirebaseUser firebaseUser2) {
          BlocProvider.of<UserBloc>(mBuildContext).add(CheckUserSignedUpEvent(
              googleSignIn: googleSignIn2,
              mobileNo: mobileNumber,
              callback: (bool isSignedUp) {
                if (!isSignedUp) {
                  User user = User(id: null, mobileNo: mobileNumber, countryCode: widget.countryCodeString, displayName: firebaseUser2.displayName.toString(), googleAccountId: googleSignIn2.currentUser.id.toString(), realName: null);
                  Settings settings = Settings(id: null, allowNotifications: true, userId: null);
                  Multimedia multimedia = Multimedia(
                      id: null,
                      conversationId: null,
                      localFullFileUrl: null,
                      localThumbnailUrl: null,
                      remoteFullFileUrl: googleSignIn2.currentUser.photoUrl.toString(),
                      remoteThumbnailUrl: googleSignIn2.currentUser.photoUrl.toString(),
                      messageId: null,
                      userContactId: null);
                  UserContact userContact = UserContact(
                      id: null,
                      multimediaId: null,
                      mobileNo: mobileNumber,
                      displayName: firebaseUser2.displayName,
                      realName: null,
                      about: 'Hey There! I am using PocketChat.',
                      lastSeenDate: DateTime.now(),
                      block: false,
                      userIds: [],
                      // Add userId into it after User is Created
                      userId: null);

                  if (!isObjectEmpty(googleSignIn2)) {
                    BlocProvider.of<UserBloc>(mBuildContext).add(AddUserEvent(
                        user: user,
                        callback: (User user2) {
                          // TODO: Error Handling
                          userContact.userId = multimedia.userId = settings.userId = user2.id;
                          userContact.userIds.add(user2.id);
                          BlocProvider.of<SettingsBloc>(mBuildContext).add(AddSettingsEvent(
                              settings: settings,
                              callback: (Settings settings2) {
                                if (!isObjectEmpty(settings2)) {
                                  BlocProvider.of<MultimediaBloc>(mBuildContext).add(AddMultimediaEvent(
                                      multimedia: multimedia,
                                      callback: (Multimedia multimedia2) {
                                        if (!isObjectEmpty(multimedia2)) {
                                          userContact.multimediaId = multimedia.id;
                                          multimedia2.userContactId = userContact.id;
                                          BlocProvider.of<UserContactBloc>(mBuildContext).add(AddUserContactEvent(
                                              userContact: userContact,
                                              callback: (UserContact userContact2) {
                                                BlocProvider.of<MultimediaBloc>(mBuildContext).add(EditMultimediaEvent(
                                                    multimedia: multimedia2,
                                                    callback: (Multimedia multimedia3) {
                                                      if (!isObjectEmpty(googleSignIn2) && !isObjectEmpty(user2) && !isObjectEmpty(settings2) && !isObjectEmpty(userContact2) && !isObjectEmpty(multimedia3)) {
                                                        showToast('Sign up success. Please verify your phone number.', Toast.LENGTH_SHORT);
                                                        Navigator.pop(mBuildContext);
                                                        goToVerifyPhoneNumber(PreVerifyMobileNumberOTPResponse(mobileNumber: mobileNumber));
                                                      }
                                                    }));
                                              }));
                                        } else {
                                          showToast('Sign up error. Please try again.', Toast.LENGTH_SHORT);
                                        }
                                      }));
                                } else {
                                  showToast('Sign up error. Please try again.', Toast.LENGTH_SHORT);
                                  BlocProvider.of<GoogleInfoBloc>(mBuildContext).add(RemoveGoogleInfoEvent());
                                  Navigator.pop(mBuildContext);
                                }
                              }));
                        }));
                  } else {
                    showToast('Google Sign in error. Please try again.', Toast.LENGTH_SHORT);
                    BlocProvider.of<GoogleInfoBloc>(mBuildContext).add(RemoveGoogleInfoEvent());
                    Navigator.pop(mBuildContext);
                  }
                } else {
                  showToast('Registered Mobile No./Google Account. Please use another Mobile No./Google Account to register.', Toast.LENGTH_SHORT);
                  BlocProvider.of<GoogleInfoBloc>(mBuildContext).add(RemoveGoogleInfoEvent(callback: (bool done) {}));
                  Navigator.pop(mBuildContext);
                }
              }));
        }));
      } else {
        showToast('Please sign into your Google account first. Please try again.', Toast.LENGTH_LONG);
        BlocProvider.of<GoogleInfoBloc>(mBuildContext).add(RemoveGoogleInfoEvent());
        Navigator.pop(mBuildContext);
      }
    }));
  }

  goToVerifyPhoneNumber(PreVerifyMobileNumberOTPResponse preVerifyMobileNumberOTPResponse) {
    Navigator.push(mBuildContext, MaterialPageRoute(builder: ((context) => VerifyPhoneNumberPage(preVerifyMobileNumberOTPResponse: preVerifyMobileNumberOTPResponse))));
  }
}
