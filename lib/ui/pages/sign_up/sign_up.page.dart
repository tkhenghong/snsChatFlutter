import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:snschat_flutter/general/index.dart';
import 'package:snschat_flutter/objects/models/index.dart';
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
  TextEditingController nameTextController = new TextEditingController();
  TextEditingController mobileNoTextController = new TextEditingController();

  FocusNode nodeOne = FocusNode();
  FocusNode nodeTwo = FocusNode();

  CountryCode countryCode;

  bool deviceLocated = false;

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
    nodeTwo.dispose();
    super.dispose();
  }

  String getPhoneNumber(BuildContext context) {
    String phoneNoInitials = "";
    if (isObjectEmpty(countryCode)) {
      IPGeoLocationState ipGeoLocationState = BlocProvider.of<IPGeoLocationBloc>(context).state;
      if (ipGeoLocationState is IPGeoLocationLoaded) {
        phoneNoInitials = ipGeoLocationState.ipGeoLocation.calling_code;
      }
    } else {
      phoneNoInitials = countryCode.dialCode;
    }
    String phoneNumber = phoneNoInitials + mobileNoTextController.value.text;
    return phoneNumber;
  }

  onCountryPickerChanged(CountryCode countryCode) {
    this.countryCode = countryCode;
    widget.countryCodeString = countryCode.code.toString();
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;

    return MultiBlocListener(
      listeners: [
        BlocListener<GoogleInfoBloc, GoogleInfoState>(
          listener: (context, googleInfoState) {
            if (googleInfoState is GoogleInfoLoaded) {}
          },
        ),
        BlocListener<UserBloc, UserState>(
          listener: (context, userState) {
            if (userState is UserLoaded) {}
          },
        ),
        BlocListener<MultimediaBloc, MultimediaState>(
          listener: (context, multimediaState) {
            if (multimediaState is MultimediaLoaded) {}
          },
        ),
        BlocListener<SettingsBloc, SettingsState>(
          listener: (context, settingsState) {
            if (settingsState is SettingsLoaded) {}
          },
        ),
        BlocListener<UserContactBloc, UserContactState>(
          listener: (context, userContactState) {
            if (userContactState is UserContactsLoaded) {}
          },
        ),
      ],
      child: signUpScreen(deviceHeight, deviceWidth, context),
    );
  }

  signUpScreen(deviceHeight, deviceWidth, BuildContext context) => Material(
      child: GestureDetector(
          // call this method here to hide soft keyboard
          onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0, //Set Shadow
              iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
            ),
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
                            CountryCodePicker(
                              initialSelection: widget.countryCodeString,
                              alignLeft: false,
                              showCountryOnly: false,
                              showFlag: true,
                              showOnlyCountryWhenClosed: false,
                              favorite: [widget.countryCodeString],
                              onChanged: onCountryPickerChanged,
                            ),
                            Container(
                              width: deviceWidth * 0.6,
                              margin: EdgeInsetsDirectional.only(top: deviceHeight * 0.03),
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
                                onFieldSubmitted: (value) {
                                  FocusScope.of(context).requestFocus(nodeTwo);
                                },
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return "Mobile number is empty";
                                  }

                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        TextFormField(
                          controller: nameTextController,
                          textCapitalization: TextCapitalization.words,
                          maxLength: 100,
                          decoration: InputDecoration(hintText: "Name"),
                          autofocus: true,
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.text,
                          focusNode: nodeTwo,
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (value) {},
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Name is empty";
                            }

                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                RaisedButton(
                  onPressed: () => signUp(context),
                  textColor: Colors.white,
                  animationDuration: Duration(milliseconds: 500),
                  padding: EdgeInsets.only(left: 70.0, right: 70.0, top: 15.0, bottom: 15.0),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
                  child: Text("Sign Up"),
                ),
                Padding(padding: EdgeInsets.symmetric(vertical: 50.00)),
              ],
            ),
          )));

  signUp(BuildContext context) async {
    if (!_formKey.currentState.validate()) {
      return;
    }

    showCenterLoadingIndicator(context);
    //

    BlocProvider.of<GoogleInfoBloc>(context).add(SignInGoogleInfoEvent(callback: (bool initialized) {
      if (initialized) {
        BlocProvider.of<GoogleInfoBloc>(context).add(GetOwnGoogleInfoEvent(callback: (GoogleSignIn googleSignIn2, FirebaseAuth firebaseAuth2, FirebaseUser firebaseUser2) {
          BlocProvider.of<UserBloc>(context).add(CheckUserSignedUpEvent(
              googleSignIn: googleSignIn2,
              mobileNo: getPhoneNumber(context),
              callback: (bool isSignedUp) {
                if (!isSignedUp) {
                  User user = User(
                      id: null,
                      mobileNo: getPhoneNumber(context),
                      countryCode: widget.countryCodeString,
                      effectivePhoneNumber: mobileNoTextController.value.text.toString(),
                      displayName: firebaseUser2.displayName.toString(),
                      googleAccountId: googleSignIn2.currentUser.id.toString(),
                      realName: nameTextController.value.text.toString());
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
                      mobileNo: getPhoneNumber(context),
                      displayName: firebaseUser2.displayName,
                      realName: nameTextController.value.text.toString(),
                      about: 'Hey There! I am using PocketChat.',
                      lastSeenDate: DateTime.now().millisecondsSinceEpoch,
                      block: false,
                      userIds: [],
                      // Add userId into it after User is Created
                      userId: null);

                  if (!isObjectEmpty(googleSignIn2)) {
                    BlocProvider.of<UserBloc>(context).add(AddUserEvent(
                        user: user,
                        callback: (User user2) {
                          // TODO: Error Handling
                          userContact.userId = multimedia.userId = settings.userId = user2.id;
                          userContact.userIds.add(user2.id);
                          BlocProvider.of<SettingsBloc>(context).add(AddSettingsEvent(
                              settings: settings,
                              callback: (Settings settings2) {
                                if (!isObjectEmpty(settings2)) {
                                  BlocProvider.of<MultimediaBloc>(context).add(AddMultimediaEvent(
                                      multimedia: multimedia,
                                      callback: (Multimedia multimedia2) {
                                        if (!isObjectEmpty(multimedia2)) {
                                          userContact.multimediaId = multimedia.id;
                                          multimedia2.userContactId = userContact.id;
                                          BlocProvider.of<UserContactBloc>(context).add(AddUserContactEvent(
                                              userContact: userContact,
                                              callback: (UserContact userContact2) {
                                                BlocProvider.of<MultimediaBloc>(context).add(EditMultimediaEvent(
                                                    multimedia: multimedia2,
                                                    callback: (Multimedia multimedia3) {
                                                      if (!isObjectEmpty(googleSignIn2) && !isObjectEmpty(user2) && !isObjectEmpty(settings2) && !isObjectEmpty(userContact2) && !isObjectEmpty(multimedia3)) {
                                                        showToast('Sign up success. Please verify your phone number.', Toast.LENGTH_SHORT);
                                                        Navigator.pop(context);
                                                        goToVerifyPhoneNumber(context);
                                                      }
                                                    }));
                                              }));
                                        } else {
                                          showToast('Sign up error. Please try again.', Toast.LENGTH_SHORT);
                                        }
                                      }));
                                } else {
                                  showToast('Sign up error. Please try again.', Toast.LENGTH_SHORT);
                                  BlocProvider.of<GoogleInfoBloc>(context).add(RemoveGoogleInfoEvent());
                                  Navigator.pop(context);
                                }
                              }));
                        }));
                  } else {
                    showToast('Google Sign in error. Please try again.', Toast.LENGTH_SHORT);
                    BlocProvider.of<GoogleInfoBloc>(context).add(RemoveGoogleInfoEvent());
                    Navigator.pop(context);
                  }
                } else {
                  showToast('Registered Mobile No./Google Account. Please use another Mobile No./Google Account to register.', Toast.LENGTH_SHORT);
                  BlocProvider.of<GoogleInfoBloc>(context).add(RemoveGoogleInfoEvent(callback: (bool done) {}));
                  Navigator.pop(context);
                }
              }));
        }));
      } else {
        showToast('Please sign into your Google account first. Please try again.', Toast.LENGTH_LONG);
        BlocProvider.of<GoogleInfoBloc>(context).add(RemoveGoogleInfoEvent());
        Navigator.pop(context);
      }
    }));
  }

  goToVerifyPhoneNumber(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: ((context) => VerifyPhoneNumberPage(mobileNo: getPhoneNumber(context)))));
  }
}
