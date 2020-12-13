import 'package:country_code_picker/country_code_picker.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:get/get.dart';
import 'package:snschat_flutter/environments/development/variables.dart' as globals;
import 'package:snschat_flutter/general/index.dart';
import 'package:snschat_flutter/objects/models/index.dart';
import 'package:snschat_flutter/objects/rest/index.dart';
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
  String DEFAULT_COUNTRY_CODE = globals.DEFAULT_COUNTRY_CODE;

  IPGeoLocation ipGeoLocation;
  CountryCode countryCode;
  String countryCodeString;
  String mobileNumber;

  AuthenticationBloc authenticationBloc;

  final _formKey = GlobalKey<FormState>();
  TextEditingController mobileNoTextController;

  @override
  void initState() {
    super.initState();
    mobileNoTextController = new TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    mobileNoTextController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);

    return SafeArea(child: GestureDetector(onTap: () => FocusScope.of(context).requestFocus(FocusNode()), child: Material(child: multiBlocListeners())));
  }

  Widget multiBlocListeners() => MultiBlocListener(listeners: [
        userAuthenticationBlocListener(),
      ], child: ipGeoLocationBlocBuilder());

  Widget userAuthenticationBlocListener() {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state is Authenticating) {
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

        if (ipGeoLocationState is IPGeoLocationNotLoaded) {
          countryCodeString = DEFAULT_COUNTRY_CODE;

          return userAuthenticationBlocBuilder();
        }

        if (ipGeoLocationState is IPGeoLocationLoaded) {
          countryCodeString = isObjectEmpty(ipGeoLocationState.ipGeoLocation) ? DEFAULT_COUNTRY_CODE : ipGeoLocationState.ipGeoLocation.country_code2;
          ipGeoLocation = ipGeoLocationState.ipGeoLocation;
          return userAuthenticationBlocBuilder();
        }

        return showError();
      },
    );
  }

  Widget userAuthenticationBlocBuilder() {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      buildWhen: (previousAuthenticationState, nextAuthenticationState) {
        return !(nextAuthenticationState is Authenticating || nextAuthenticationState is AuthenticationsLoaded);
      },
      builder: (context, authenticationState) {
        if (authenticationState is AuthenticationsLoading) {
          return showLoading('login page');
        }

        if (authenticationState is AuthenticationsNotLoaded) {
          return mainBody();
        }

        return showError();
      },
    );
  }

  Widget mainBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(height: Get.height * 0.15),
        loginText(),
        SizedBox(
          height: Get.height * 0.1,
        ),
        mobileNumberTextField(),
        signInButton(),
        SizedBox(
          height: Get.height * 0.05,
        ),
        Text('Don\'t have account yet?'),
        signUpButton(),
        SizedBox(
          height: Get.height * 0.1,
        ),
        contactSupportButton(),
        termsAndConditionsButton(),
        privacyNoticeButton(),
      ],
    );
  }

  Widget loginText() {
    return Text(
      'Login',
      style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
    );
  }

  Widget mobileNumberTextField() {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            countryCodePickerField(),
            Container(
              width: Get.width * 0.5,
              margin: EdgeInsetsDirectional.only(top: Get.height * 0.03),
              child: Form(
                  key: _formKey,
                  child: TextFormField(
                    controller: mobileNoTextController,
                    validator: validateMobileNo,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                    ],
                    maxLength: 15,
                    decoration: InputDecoration(hintText: 'Mobile Number'),
                    autofocus: true,
                    textAlign: TextAlign.left,
                    keyboardType: TextInputType.phone,
                    onChanged: getPhoneNumber(),
                    onFieldSubmitted: (text) {
                      _signIn();
                    },
                  )),
            ),
          ],
        ),
      ],
    );
  }

  Widget countryCodePickerField() {
    return CountryCodePicker(
      initialSelection: countryCodeString,
      alignLeft: false,
      showCountryOnly: false,
      showFlag: true,
      showOnlyCountryWhenClosed: false,
      favorite: [countryCodeString],
      onChanged: onCountryPickerChanged,
    );
  }

  Widget signInButton() {
    return RaisedButton(
      child: Text('Sign In'),
      onPressed: _signIn,
      padding: EdgeInsets.symmetric(vertical: Get.height * 0.025, horizontal: Get.width * 0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
    );
  }

  Widget signUpButton() {
    return FlatButton(
        child: Text(
          'Sign Up Now',
        ),
        onPressed: goToSignUp);
  }

  Widget contactSupportButton() {
    return Container(
      height: Get.height * 0.03,
      child: FlatButton(
        child: Text('Contact Support'),
        onPressed: () => goToContactSupport(),
      ),
    );
  }

  Widget termsAndConditionsButton() {
    return Container(
      height: Get.height * 0.03,
      child: FlatButton(
        onPressed: () => goToTermsAndConditions(),
        child: Text('Terms and Conditions'),
      ),
    );
  }

  Widget privacyNoticeButton() {
    return Container(
      height: Get.height * 0.03,
      child: FlatButton(
        onPressed: () => goToPrivacyNotice(),
        child: Text('Privacy Notice'),
      ),
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
        children: <Widget>[Text('Login page error. Please try restart the app.'), RaisedButton(onPressed: Phoenix.rebirth(context))],
      ),
    );
  }

  String validateMobileNo(value) {
    if (value.isEmpty) {
      return 'Please enter your phone number';
    }
    if (value.length < 8) {
      return 'Please enter a valid phone number format';
    }

    return null;
  }

  onCountryPickerChanged(CountryCode countryCode) {
    this.countryCode = countryCode;
    this.countryCodeString = countryCode.code;
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

  goToVerifyPhoneNumber() {
    Navigator.of(context).pushNamed('verify_phone_number_page');
  }

  goToSignUp() {
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

  goToTermsAndConditions() {
    Navigator.of(context).pushNamed('terms_and_conditions_page');
  }

  goToPrivacyNotice() {
    Navigator.of(context).pushNamed('privacy_notice_page');
  }

  _signIn() async {
    if (!_formKey.currentState.validate()) {
      return;
    }

    showCenterLoadingIndicator();

    getPhoneNumber();

    authenticationBloc.add(LoginUsingMobileNumberEvent(mobileNo: mobileNumber, countryCode: !countryCode.isNull ? countryCode.code : countryCodeString, callback: (PreVerifyMobileNumberOTPResponse preVerifyMobileNumberOTPResponse) {}));
  }
}
