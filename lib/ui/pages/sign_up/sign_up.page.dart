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
  String defaultCountryCode = globals.DEFAULT_COUNTRY_CODE;

  IPGeoLocationBloc ipGeoLocationBloc;
  AuthenticationBloc authenticationBloc;

  final _formKey = GlobalKey<FormState>();
  TextEditingController mobileNoTextController = new TextEditingController();
  FocusNode nodeOne = FocusNode();

  IPGeoLocation ipGeoLocation;
  CountryCode countryCode;
  String countryCodeString;
  String mobileNumber;

  @override
  void initState() {
    super.initState();
    mobileNoTextController.text = widget.mobileNo.isNotEmpty ? widget.mobileNo : null;
  }

  @override
  void dispose() {
    nodeOne.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ipGeoLocationBloc = BlocProvider.of<IPGeoLocationBloc>(context);
    authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);

    return multiBlocListeners();
  }

  Widget multiBlocListeners() => MultiBlocListener(
        listeners: [ipGeoLocationBlocListener(), userAuthenticationBlocListener()],
        child: ipGeoLocationBlocBuilder(),
      );

  Widget ipGeoLocationBlocListener() {
    return BlocListener<IPGeoLocationBloc, IPGeoLocationState>(
      listener: (context, ipGeoLocationState) {
        if (ipGeoLocationState is IPGeoLocationLoaded) {
          countryCodeString = ipGeoLocationState.ipGeoLocation.isNull ? defaultCountryCode : ipGeoLocationState.ipGeoLocation.country_code2;
          ipGeoLocation = ipGeoLocationState.ipGeoLocation;
        }
      },
    );
  }

  Widget userAuthenticationBlocListener() {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, authenticationState) {
        if (authenticationState is Authenticating) {
          Get.back(); // Close loading dialog.
          goToVerifyPhoneNumber();
        }
      },
    );
  }

  Widget ipGeoLocationBlocBuilder() {
    return BlocBuilder<IPGeoLocationBloc, IPGeoLocationState>(
      builder: (context, ipGeoLocationState) {
        if (ipGeoLocationState is IPGeoLocationLoading) {
          return showLoading('location');
        }

        if (ipGeoLocationState is IPGeoLocationLoaded) {
          countryCodeString = ipGeoLocationState.ipGeoLocation.isNull ? defaultCountryCode : ipGeoLocationState.ipGeoLocation.country_code2;
          ipGeoLocation = ipGeoLocationState.ipGeoLocation;
          return authenticationBlocBuilder();
        }

        return showError();
      },
    );
  }

  Widget authenticationBlocBuilder() {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(buildWhen: (previousAuthenticationState, nextAuthenticationState) {
      return !(nextAuthenticationState is Authenticating);
    }, builder: (context, authenticationState) {
      if (authenticationState is AuthenticationsLoading) {
        return showLoading('Sign Up page');
      }

      if (authenticationState is AuthenticationsNotLoaded) {
        return signUpScreen();
      }

      return showError();
    });
  }

  Widget signUpScreen() {
    return GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
        child: Scaffold(
          appBar: appBar(),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              signUpTexts(),
              SizedBox(height: Get.height * 0.05),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Get.width * 0.2),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Row(
                        children: <Widget>[
                          countryCodePicker(),
                          mobileNoTextField(),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              signUpButton(),
            ],
          ),
        ));
  }

  Widget appBar() {
    return AppBar();
  }

  Widget signUpTexts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Sign Up',
          style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: Get.height * 0.05),
        Text(
          'Enter your mobile number and name: ',
          style: TextStyle(fontSize: 15.0),
        ),
      ],
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
      width: Get.width * 0.6,
      margin: EdgeInsetsDirectional.only(top: Get.height * 0.03),
      child: TextFormField(
        controller: mobileNoTextController,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp('[0-9]')),
        ],
        maxLength: 15,
        decoration: InputDecoration(hintText: 'Mobile Number'),
        autofocus: true,
        textAlign: TextAlign.left,
        keyboardType: TextInputType.phone,
        focusNode: nodeOne,
        validator: (value) {
          if (value.isEmpty) {
            return 'Mobile number is empty';
          }

          return null;
        },
      ),
    );
  }

  Widget signUpButton() {
    return RaisedButton(
      onPressed: signUp,
      animationDuration: Duration(milliseconds: 500),
      padding: EdgeInsets.symmetric(vertical: Get.width * 0.2, horizontal: Get.height * 0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
      child: Text('Sign Up'),
    );
  }

  Widget showLoading(String module) {
    return Center(
      child: Text('Loading $module...'),
    );
  }

  Widget showError() {
    return Center(
      child: Column(
        children: <Widget>[Text('An error has occurred. Please try again later.'), RaisedButton(onPressed: goToLoginPage)],
      ),
    );
  }

  getPhoneNumber() {
    String phoneNoInitials = '';

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
    authenticationBloc.add(RegisterUsingMobileNoEvent(mobileNo: mobileNumber, countryCode: !countryCode.isNull ? countryCode.code : countryCodeString, callback: (PreVerifyMobileNumberOTPResponse preVerifyMobileNumberOTPResponse) {}));
  }

  goToVerifyPhoneNumber() {
    Navigator.of(context).pushNamed('verify_phone_number_page');
  }
}
