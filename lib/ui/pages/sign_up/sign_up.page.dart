import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:snschat_flutter/environments/development/variables.dart' as globals;
import 'package:snschat_flutter/general/index.dart';
import 'package:snschat_flutter/objects/models/index.dart';
import 'package:snschat_flutter/objects/rest/index.dart';
import 'package:snschat_flutter/state/bloc/index.dart';

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
  TextEditingController mobileNoTextController;
  FocusNode nodeOne;

  IPGeoLocation ipGeoLocation;
  CountryCode countryCode;
  String countryCodeString;
  String mobileNumber;

  @override
  void initState() {
    super.initState();
    mobileNoTextController = new TextEditingController();
    nodeOne = FocusNode();
    mobileNoTextController.text = widget.mobileNo.isNotEmpty ? widget.mobileNo : null;
  }

  @override
  void dispose() {
    mobileNoTextController.dispose();
    nodeOne.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ipGeoLocationBloc = BlocProvider.of<IPGeoLocationBloc>(context);
    authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    return SafeArea(child: GestureDetector(onTap: () => FocusScope.of(context).requestFocus(new FocusNode()), child: Material(child: multiBlocListeners())));
  }

  Widget multiBlocListeners() => MultiBlocListener(
        listeners: [ipGeoLocationBlocListener(), userAuthenticationBlocListener()],
        child: ipGeoLocationBlocBuilder(),
      );

  Widget ipGeoLocationBlocListener() {
    return BlocListener<IPGeoLocationBloc, IPGeoLocationState>(
      listener: (context, ipGeoLocationState) {
        if (ipGeoLocationState is IPGeoLocationLoaded) {
          countryCodeString =  isObjectEmpty(ipGeoLocationState.ipGeoLocation) ? defaultCountryCode : ipGeoLocationState.ipGeoLocation.country_code2;
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
          countryCodeString =  isObjectEmpty(ipGeoLocationState.ipGeoLocation) ? defaultCountryCode : ipGeoLocationState.ipGeoLocation.country_code2;
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
        return mainBody();
      }

      return showError();
    });
  }

  Widget mainBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        appBar(),
        SizedBox(height: Get.height * 0.1),
        signUpTexts(),
        SizedBox(height: Get.height * 0.05),
        mobileNumberTextField(),
        signUpButton(),
      ],
    );
  }

  Widget appBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [IconButton(icon: Icon(Icons.keyboard_arrow_left), onPressed: goBack)],
    );
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
          'Please enter your mobile number.',
          style: TextStyle(fontSize: 15.0),
        ),
      ],
    );
  }

  Widget mobileNumberTextField() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        countryCodePicker(),
        mobileNoTextField(),
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
      width: Get.width * 0.5,
      margin: EdgeInsetsDirectional.only(top: Get.height * 0.03),
      child: Form(
          key: _formKey,
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
            validator: validateSignUpForm,
          )),
    );
  }

  String validateSignUpForm(value) {
    if (isStringEmpty(value)) {
      return 'Mobile number is empty.';
    }

    return null;
  }

  Widget signUpButton() {
    return RaisedButton(
      onPressed: signUp,
      animationDuration: Duration(milliseconds: 500),
      padding: EdgeInsets.symmetric(vertical: Get.height * 0.025, horizontal: Get.width * 0.2),
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
        children: <Widget>[Text('An error has occurred. Please try again later.'), RaisedButton(onPressed: goBack)],
      ),
    );
  }

  getPhoneNumber() {
    String phoneNoInitials = '';

    if (isObjectEmpty(countryCode) && !isObjectEmpty(ipGeoLocation)) {
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

  signUp() {
    if (!_formKey.currentState.validate()) {
      return;
    }

    getPhoneNumber();
    showCenterLoadingIndicatorDialog();
    authenticationBloc
        .add(RegisterUsingMobileNoEvent(mobileNo: mobileNumber, countryCode: !isObjectEmpty(countryCode) ? countryCode.code : countryCodeString, callback: (PreVerifyMobileNumberOTPResponse preVerifyMobileNumberOTPResponse) {}));
  }

  goToVerifyPhoneNumber() {
    Navigator.of(context).pushNamed('verify_phone_number_page');
  }

  goBack() {
    Navigator.of(context).pop();
  }
}
