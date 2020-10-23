import 'package:country_code_picker/country_code_picker.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  bool deviceLocated = false;

  double deviceWidth;
  double deviceHeight;

  String DEFAULT_COUNTRY_CODE = globals.DEFAULT_COUNTRY_CODE;

  IPGeoLocation ipGeoLocation;
  CountryCode countryCode;
  String countryCodeString;
  String mobileNumber;

  // Color themePrimaryColor;

  AuthenticationBloc authenticationBloc;
  WebSocketBloc webSocketBloc;

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
    deviceWidth = MediaQuery.of(context).size.width;
    deviceHeight = MediaQuery.of(context).size.height;

    // themePrimaryColor = Theme.of(context).textTheme.title.color;

    authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    webSocketBloc = BlocProvider.of<WebSocketBloc>(context);

    return GestureDetector(
        // Detect user touch out of the text fields
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        // Focuses on nothing, means disable focus and hide keyboard
        child: Material(
          child: ipGeoLocationBlocBuilder(),
        ));
  }

  Widget ipGeoLocationBlocBuilder() {
    return BlocBuilder<IPGeoLocationBloc, IPGeoLocationState>(
      builder: (context, ipGeoLocationState) {
        if (ipGeoLocationState is IPGeoLocationLoading || ipGeoLocationState is IPGeoLocationNotLoaded) {
          countryCodeString = DEFAULT_COUNTRY_CODE;
          deviceLocated = false;

          if (ipGeoLocationState is IPGeoLocationLoading) {
            return showLoading();
          } else if (ipGeoLocationState is IPGeoLocationNotLoaded) {
            return multiBlocListener();
          }
        } else if (ipGeoLocationState is IPGeoLocationLoaded) {
          deviceLocated = true;
          countryCodeString =
              ipGeoLocationState.ipGeoLocation.isNull ? DEFAULT_COUNTRY_CODE : ipGeoLocationState.ipGeoLocation.country_code2;
          ipGeoLocation = ipGeoLocationState.ipGeoLocation;
          return multiBlocListener();
        }

        return showError();
      },
    );
  }

  Widget multiBlocListener() => MultiBlocListener(listeners: [
        ipGeoLocationBlocListener(),
        userBlocListener(),
        userAuthenticationBlocListener(),
      ], child: loginScreen());

  Widget loginScreen() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(padding: EdgeInsets.symmetric(vertical: 70.0)),
        loginText(),
        Padding(padding: EdgeInsets.symmetric(vertical: 20.0)),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 20.0),
                    ),
                    countryCodePickerField(),
                    Container(
                      width: deviceWidth * 0.5,
                      margin: EdgeInsetsDirectional.only(top: deviceHeight * 0.03),
                      child: Form(key: _formKey, child: mobileNumberTextField()),
                    ),
                  ],
                ),
              ],
            )),
        signInButton(),
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
        Text('Don\'t have account yet?'),
        signUpButton(),
        Padding(padding: EdgeInsets.symmetric(vertical: 15.00)),
        contactSupportButton(),
        Padding(padding: EdgeInsets.symmetric(vertical: 5.00)),
        termsAndConditionsButton(),
        Padding(padding: EdgeInsets.symmetric(vertical: 5.00)),
        privacyNoticeButton(),
      ],
    );
  }

  Widget ipGeoLocationBlocListener() {
    return BlocListener<IPGeoLocationBloc, IPGeoLocationState>(
      listener: (context, state) {},
    );
  }

  Widget userBlocListener() {
    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {},
    );
  }

  Widget userAuthenticationBlocListener() {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state is Authenticating) {
          Get.back();
          goToVerifyPhoneNumber();
        }
      },
    );
  }

  Widget loginText() {
    return Text(
      'Login',
      style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
      textAlign: TextAlign.center,
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

  Widget mobileNumberTextField() {
    return TextFormField(
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
    );
  }

  Widget signInButton() {
    return RaisedButton(
      child: Text('Sign In'),
      onPressed: () => _signIn(),
      // textColor: Colors.white,
      // splashColor: Colors.grey,
      animationDuration: Duration(milliseconds: 500),
      padding: EdgeInsets.only(left: 70.0, right: 70.0, top: 15.0, bottom: 15.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
    );
  }

  Widget signUpButton() {
    return FlatButton(
        onPressed: () => goToSignUp(),
        child: Text(
          'Sign Up Now',
          // style: TextStyle(color: themePrimaryColor),
        ));
  }

  Widget contactSupportButton() {
    return Container(
      height: Get.height * 0.03,
      child: FlatButton(
        onPressed: () => goToContactSupport(),
        child: Text('Contact Support'),
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

  Widget showLoading() {
    return Center(
      child: Text('Loading...'),
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
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: ((context) => SignUpPage(mobileNo: mobileNoTextController.value.text, countryCodeString: countryCodeString))));
  }

  goToContactSupport() async {
    String now = formatDate(new DateTime.now(), [dd, '/', mm, '/', yyyy]);
    String linebreak = '%0D%0A';
    String url = 'mailto:<tkhenghong@gmail.com>?subject=Request for Contact Support ' +
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

    authenticationBloc.add(LoginUsingMobileNumberEvent(
        mobileNo: mobileNumber, callback: (PreVerifyMobileNumberOTPResponse preVerifyMobileNumberOTPResponse) {}));
  }

  _signInWithFacebook() {
    showToast('Coming soon.', Toast.LENGTH_SHORT);
  }

  _signInWithApple() {
    showToast('Coming soon.', Toast.LENGTH_SHORT);
  }

  _signInWithTwitter() {
    showToast('Coming soon.', Toast.LENGTH_SHORT);
  }
}
