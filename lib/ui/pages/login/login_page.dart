import 'package:country_pickers/country.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:snschat_flutter/backend/rest/ipLocation/IPLocationAPIService.dart';
import 'package:snschat_flutter/general/functions/validation_functions.dart';
import 'package:snschat_flutter/general/ui-component/loading.dart';
import 'package:snschat_flutter/objects/IPGeoLocation/IPGeoLocation.dart';
import 'package:snschat_flutter/state/bloc/WholeApp/WholeAppBloc.dart';
import 'package:snschat_flutter/state/bloc/WholeApp/WholeAppEvent.dart';
import 'package:snschat_flutter/state/bloc/WholeApp/WholeAppState.dart';
import 'package:snschat_flutter/ui/pages/sign_up/sign_up_page.dart';
import 'package:snschat_flutter/ui/pages/verify_phone_number/verify_phone_number_page.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:date_format/date_format.dart';

//import 'package:country_code_picker/country_code_picker.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:device_info/device_info.dart';

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

  bool deviceLocated = false;

  String phoneIsoCode = "";
  String phoneNumber = "";

  Country _selectedDialogCountry, _selectedCupertinoCountry;

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
                  mobileNo: mobileNoTextController.value.text));
            } else {
              Fluttertoast.showToast(msg: 'Welcome! Please sign up first!', toastLength: Toast.LENGTH_SHORT);
              wholeAppBloc.dispatch(UserSignOutEvent()); // Reset everything to initial state first
              Navigator.pop(context);
              goToSignUp();
            }
          },
          mobileNo: mobileNoTextController.value.text));
    }
  }

  testDeviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    print("deviceInfo: " + deviceInfo.toString());
    print("androidInfo: " + androidInfo.toString());
  }

  Widget _buildDropdownItem(Country country) => Container(
        child: Row(
          children: <Widget>[
            CountryPickerUtils.getDefaultFlagImage(country),
            SizedBox(
              width: 8.0,
            ),
            Text("+${country.phoneCode}(${country.isoCode})"),
          ],
        ),
      );

  void _openCountryPickerDialog() => showDialog(
        context: context,
        builder: (context) => Theme(
            data: Theme.of(context).copyWith(primaryColor: Colors.pink),
            child: CountryPickerDialog(
              titlePadding: EdgeInsets.all(8.0),
              searchCursorColor: Colors.pinkAccent,
              searchInputDecoration: InputDecoration(hintText: 'Search...'),
              isSearchable: true,
              title: Text('Select your phone code'),
              onValuePicked: (Country country) => setState(() => _selectedDialogCountry = country),
//            itemBuilder: _buildDialogItem
            )),
      );

  void _openCupertinoCountryPicker() => showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) {
        return CountryPickerCupertino(
          pickerSheetHeight: 300.0,
          onValuePicked: (Country country) => setState(() => _selectedCupertinoCountry = country),
        );
      });

  @override
  Widget build(BuildContext context) {
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

    print("phoneIsoCode: " + phoneIsoCode.toString());
    if (!deviceLocated) {
      print("if(!deviceLocated)");
      wholeAppBloc.dispatch(GetIPGeoLocationEvent(callback: (IPGeoLocation ipGeoLocation) {
        print("Callback success");
        setState(() {
          print("Set state!");
          phoneIsoCode = ipGeoLocation.country_code2;
          deviceLocated = true;
        });
      }));
    } else {
      print("if(deviceLocated)");
    }

    print("DateTime.now().timeZoneName.toString(): " + DateTime.now().timeZoneName.toString());

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

//                              CountryCodePicker(
//                                // Show fails when there's no Wifi.
//                                // Try another developer's country picker.
//                                // TODO: Try ask developer this issue in GitHub
//                                initialSelection: state.ipGeoLocation.country_code2,
//                                alignLeft: false,
//                                showCountryOnly: false,
//                                showFlag: true,
//                                showOnlyCountryWhenClosed: false,
//                                favorite: [phoneIsoCode],
//                                onChanged: (CountryCode countryCode) {},
//                              ),
                            ],
                          ),
                          CountryPickerDropdown(
                            initialValue: 'tr',
                            itemBuilder: _buildDropdownItem,
                            onValuePicked: (Country country) {
                              print("${country.name}");
                            },
                          ),
                          RaisedButton(
                            child: Text("Click here for _openCountryPickerDialog()"),
                            onPressed: () {
                              _openCountryPickerDialog();
                            },
                          ),
                          RaisedButton(
                            child: Text("Click here for _openCupertinoCountryPicker"),
                            onPressed: () {
                              _openCupertinoCountryPicker();
                            },
                          ),
                          Form(
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
    Navigator.push(context, MaterialPageRoute(builder: ((context) => VerifyPhoneNumberPage(mobileNo: mobileNoTextController.value.text))));
  }

  goToSignUp() {
    Navigator.push(context, MaterialPageRoute(builder: ((context) => SignUpPage(mobileNo: mobileNoTextController.value.text))));
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
