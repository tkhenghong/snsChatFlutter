import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:snschat_flutter/general/functions/validation_functions.dart';
import 'package:snschat_flutter/general/ui-component/loading.dart';
import 'package:snschat_flutter/state/bloc/WholeApp/WholeAppBloc.dart';
import 'package:snschat_flutter/state/bloc/WholeApp/WholeAppEvent.dart';
import 'package:snschat_flutter/state/bloc/WholeApp/WholeAppState.dart';
import 'package:snschat_flutter/ui/pages/verify_phone_number/verify_phone_number_page.dart';

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
  WholeAppBloc wholeAppBloc;
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

  String isIPLocationExists(WholeAppState state) {
    return isObjectEmpty(state.ipGeoLocation) ? "US" : state.ipGeoLocation.country_code2;
  }

  String getPhoneNumber() {
    String phoneNoInitials = "";
    if (isObjectEmpty(countryCode) && !isObjectEmpty(wholeAppBloc.currentState.ipGeoLocation)) {
      phoneNoInitials = wholeAppBloc.currentState.ipGeoLocation.calling_code;
    } else {
      phoneNoInitials = countryCode.dialCode;
    }
    String phoneNumber = phoneNoInitials + mobileNoTextController.value.text;
    print("REAL phoneNumber: " + phoneNumber);
    return phoneNumber;
  }

  onCountryPickerChanged(CountryCode countryCode) {
    print("onCountryPickerChanged()");
    print("countryCode: " + countryCode.toString());
    print("countryCode.code: " + countryCode.code.toString());
    print("countryCode.flagUri: " + countryCode.flagUri.toString());
    this.countryCode = countryCode;
    widget.countryCodeString = countryCode.code.toString();
  }

  @override
  Widget build(BuildContext context) {
    final WholeAppBloc _wholeAppBloc = BlocProvider.of<WholeAppBloc>(context);
    wholeAppBloc = _wholeAppBloc;

    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;

    return BlocBuilder(
      bloc: _wholeAppBloc,
      builder: (context, WholeAppState state) {
        return Material(
            child: GestureDetector(
                // call this method here to hide soft keyboard
                onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
                child: Scaffold(
                  appBar: AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0, //Set Shadow
                    iconTheme: IconThemeData(
                      color: Theme.of(context).primaryColor
                    ),
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
                                      textAlign: TextAlign.center,
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
                        onPressed: () => signUp(),
                        textColor: Colors.white,
                        animationDuration: Duration(milliseconds: 500),
                        padding: EdgeInsets.only(left: 70.0, right: 70.0, top: 15.0, bottom: 15.0),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
                        child: Text("Submit"),
                      ),
                      Padding(padding: EdgeInsets.symmetric(vertical: 50.00)),
                    ],
                  ),
                )));
      },
    );
  }

  signUp() async {
    if (_formKey.currentState.validate()) {
      showCenterLoadingIndicator(context);
      wholeAppBloc.dispatch(UserSignUpEvent(
          callback: (bool isSignedUp) {
            if (isSignedUp) {
              wholeAppBloc.dispatch(UserSignInEvent(
                  callback: (bool signInSuccessful) {
                    if (signInSuccessful) {
                      Navigator.pop(context);
                      goToVerifyPhoneNumber();
                    } else {
                      Navigator.pop(context); // Pop loading indicator
                      Fluttertoast.showToast(msg: 'Unable to login. Please try again.', toastLength: Toast.LENGTH_SHORT);
                      wholeAppBloc.dispatch(UserSignOutEvent()); // Reset everything to initial state first
                      Navigator.pop(context);
                    }
                  },
                  mobileNo: getPhoneNumber()));
            } else {
              Navigator.pop(context); // Pop loading indicator
              Fluttertoast.showToast(msg: 'Unable to sign up. Please try again.', toastLength: Toast.LENGTH_SHORT);
              wholeAppBloc.dispatch(UserSignOutEvent()); // Reset everything to initial state first
              Navigator.pop(context);
            }
          },
          mobileNo: getPhoneNumber(),
          effectiveMobileNo: mobileNoTextController.value.text,
          countryCode: widget.countryCodeString,
          displayName: nameTextController.value.text));
    }
  }

  goToVerifyPhoneNumber() {
    Navigator.push(context, MaterialPageRoute(builder: ((context) => VerifyPhoneNumberPage(mobileNo: getPhoneNumber()))));
  }
}
