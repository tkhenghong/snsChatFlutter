import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:snschat_flutter/environments/development/variables.dart' as globals;
import 'package:snschat_flutter/general/index.dart';
import 'package:snschat_flutter/objects/models/index.dart';
import 'package:snschat_flutter/objects/rest/index.dart';
import 'package:snschat_flutter/state/bloc/bloc.dart';

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

  String defaultCountryCode = globals.DEFAULT_COUNTRY_CODE;

  FocusNode nodeOne = FocusNode();

  IPGeoLocation ipGeoLocation;
  CountryCode countryCode;
  String countryCodeString;
  String mobileNumber;

  bool deviceLocated = false;

  double screenWidth;
  double screenHeight;

  IPGeoLocationBloc ipGeoLocationBloc;
  AuthenticationBloc authenticationBloc;
  GoogleInfoBloc googleInfoBloc;
  SettingsBloc settingsBloc;
  UserBloc userBloc;
  UserContactBloc userContactBloc;
  MultimediaBloc multimediaBloc;

  @override
  void initState() {
    super.initState();
    mobileNoTextController.text = widget.mobileNo.isNotEmpty ? widget.mobileNo : null;
  }

  @override
  void dispose() {
    nodeOne.dispose();
    ipGeoLocationBloc.close();
    authenticationBloc.close();
    googleInfoBloc.close();
    settingsBloc.close();
    userBloc.close();
    userContactBloc.close();
    multimediaBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    ipGeoLocationBloc = BlocProvider.of<IPGeoLocationBloc>(context);
    authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    googleInfoBloc = BlocProvider.of<GoogleInfoBloc>(context);
    settingsBloc = BlocProvider.of<SettingsBloc>(context);
    userBloc = BlocProvider.of<UserBloc>(context);
    userContactBloc = BlocProvider.of<UserContactBloc>(context);
    multimediaBloc = BlocProvider.of<MultimediaBloc>(context);

    return MultiBlocListener(
      listeners: [ipGeoLocationBlocListener(), userAuthenticationBlocListener()],
      child: signUpScreen(),
    );
  }

  signUpScreen() => Material(
      child: GestureDetector(
          // call this method here to hide soft keyboard
          onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
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
                            ipGeoLocationBlocBuilder(),
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
        if (ipGeoLocationState is IPGeoLocationLoaded) {
          countryCodeString = ipGeoLocationState.ipGeoLocation.isNull ? defaultCountryCode : ipGeoLocationState.ipGeoLocation.country_code2;
          ipGeoLocation = ipGeoLocationState.ipGeoLocation;
        }
      },
    );
  }

  BlocListener userAuthenticationBlocListener() {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, authenticationState) {
        if (authenticationState is Authenticating) {
          //
          Get.back();
          goToVerifyPhoneNumber();
        }
      },
    );
  }

  Widget appBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0, //Set Shadow
      iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
    );
  }

  Widget ipGeoLocationBlocBuilder() {
    return BlocBuilder<IPGeoLocationBloc, IPGeoLocationState>(
      builder: (context, ipGeoLocationState) {
        if (ipGeoLocationState is IPGeoLocationLoading) {
          return Center(
            child: Text('Loading...'),
          );
        }

        if (ipGeoLocationState is IPGeoLocationLoaded) {
          countryCodeString = ipGeoLocationState.ipGeoLocation.isNull ? defaultCountryCode : ipGeoLocationState.ipGeoLocation.country_code2;
          ipGeoLocation = ipGeoLocationState.ipGeoLocation;
          return countryCodePicker();
        }

        return Center(
          child: Text('Sign Up page error. Please try restart the app.'),
        );
      },
    );
  }

  Widget countryCodePicker() {
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

  Widget mobileNoTextField() {
    return Container(
      width: screenWidth * 0.6,
      margin: EdgeInsetsDirectional.only(top: screenHeight * 0.03),
      child: TextFormField(
        controller: mobileNoTextController,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp('[0-9]')),
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
    String phoneNoInitials = "";

    if (countryCode.isNull) {
      if (!ipGeoLocation.isNull) {
        phoneNoInitials = ipGeoLocation.calling_code;
      }
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

    authenticationBloc.add(RegisterUsingMobileNoEvent(
        mobileNo: mobileNumber,
        countryCode: !countryCode.isNull ? countryCode.code : countryCodeString,
        callback: (PreVerifyMobileNumberOTPResponse preVerifyMobileNumberOTPResponse) {}));
  }

  goToVerifyPhoneNumber() {
    Navigator.of(context).pushNamed('verify_phone_number_page');
//    Navigator.push(context, MaterialPageRoute(builder: ((context) => BlocProvider.value(value: authenticationBloc, child: VerifyPhoneNumberPage(),))));
  }
}
