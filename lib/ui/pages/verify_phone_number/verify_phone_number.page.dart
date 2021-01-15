import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';
import 'package:snschat_flutter/environments/development/variables.dart' as globals;
import 'package:snschat_flutter/general/enums/index.dart';
import 'package:snschat_flutter/general/enums/verification_mode.enum.dart';
import 'package:snschat_flutter/general/functions/toast/show_toast.dart';
import 'package:snschat_flutter/general/ui-component/loading.dart';
import 'package:snschat_flutter/objects/rest/index.dart';
import 'package:snschat_flutter/state/bloc/index.dart';

class VerifyPhoneNumberPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new VerifyPhoneNumberState();
  }
}

class VerifyPhoneNumberState extends State<VerifyPhoneNumberPage> {
  String DEFAULT_COUNTRY_CODE = globals.DEFAULT_COUNTRY_CODE;

  AuthenticationBloc authenticationBloc;

  TextEditingController textEditingController;

  int pinFieldLength = 6;

  String mobileNumber = '';
  String countryCode = '';
  String secureKeyword = '';
  String emailAddress = '';
  VerificationMode verificationMode = VerificationMode.Login;
  String maskedEmailAddress = '';
  String maskedMobileNumber = '';

  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    textEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);

    countryCode = DEFAULT_COUNTRY_CODE;

    return SafeArea(
        child: WillPopScope(
      onWillPop: goBack,
      child: GestureDetector(onTap: () => FocusScope.of(context).requestFocus(FocusNode()), child: Material(child: multiBlocListeners())),
    ));
  }

  Widget multiBlocListeners() {
    return MultiBlocListener(
      listeners: [authenticationBlocListener()],
      child: authenticationBlocBuilder(),
    );
  }

  Widget authenticationBlocListener() {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, authenticationState) {
        if (authenticationState is AuthenticationsLoaded) {
          Get.back(); // Close loading dialog.
          showToast('Verification successful.', Toast.LENGTH_SHORT);
          goToChatGroupList();
        }
      },
    );
  }

  Widget authenticationBlocBuilder() {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      buildWhen: (previousAuthenticationState, nextAuthenticationState) {
        return !(nextAuthenticationState is AuthenticationsLoaded);
      },
      builder: (context, authenticationState) {
        if (authenticationState is Authenticating) {
          mobileNumber = authenticationState.mobileNumber;
          countryCode = authenticationState.countryCode;
          secureKeyword = authenticationState.secureKeyword;
          emailAddress = authenticationState.emailAddress;
          verificationMode = authenticationState.verificationMode;
          maskedEmailAddress = authenticationState.maskedEmailAddress;
          maskedMobileNumber = authenticationState.maskedMobileNumber;
          return mainBody();
        }

        return showErrorPage();
      },
    );
  }

  Widget mainBody() {
    return Scaffold(
      appBar: appBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          textsSection(),
          wrongNumberButton(),
          pinTextField(),
          Text('Enter $pinFieldLength-digit code'),
          // RaisedButton(onPressed: () {},  child: Text('Resend SMS'),), //In case you're able to resend SMS
          resendSMSButton(),
          // In case you request a lot of times but you never retrieved and entered the correct PIN
          callMeButton(),
        ],
      ),
    );
  }

  Widget appBar() {
    return AppBar(
      title: Text('Verify $mobileNumber'),
      centerTitle: true,
    );
  }

  Widget textsSection() {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('We have sent and SMS with a code to '),
            Text(
              mobileNumber,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('The secure keyword is'),
            Text(
              secureKeyword,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ));
  }

  Widget showErrorPage() {
    return Center(
      child: Column(
        children: <Widget>[
          Text('Error when trying to verify your phone number. Please go to previous page to do it again.'),
          RaisedButton(
            child: Text('Go back'),
            onPressed: goBack,
          )
        ],
      ),
    );
  }

  Widget wrongNumberButton() {
    return FlatButton(
      child: Text(
        'Wrong number?',
        style: TextStyle(color: Colors.black),
      ),
      onPressed: () => goToLoginPage(),
    );
  }

  Widget pinTextField() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Get.height * 0.1),
      // PIN Text Field: https://pub.dev/packages/pin_input_text_field
      // Auto "Enter" when all PIN text fields have values
      child: PinInputTextField(
        pinLength: pinFieldLength,
        autoFocus: true,
        textInputAction: TextInputAction.go,
        controller: textEditingController,
        enabled: true,
        keyboardType: TextInputType.number,
        decoration: UnderlineDecoration(
            textStyle: TextStyle(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.bold), colorBuilder: PinListenColorBuilder(Colors.black, Colors.black), obscureStyle: ObscureStyle(isTextObscure: true, obscureText: '*')),
        onChanged: onPinTextFieldChanged,
        onSubmit: verifyPin,
      ),
    );
  }

  onPinTextFieldChanged(pin) {
    if (pin.length == pinFieldLength) {
      verifyMobileNumber(pin);
    }
  }

  verifyPin(pin) {
    showLoadingDialog("Verifying PIN...");
    verifyMobileNumber(pin);
  }

  Widget resendSMSButton() {
    return RaisedButton(
      onPressed: resendVerifySMS,
      child: Text('Resend SMS in 7 hours'),
    );
  }

  Widget callMeButton() {
    return RaisedButton(
      onPressed: callMobileNumber,
      child: Text('Call me'),
    );
  }

  verifyMobileNumber(String pin) {
    showLoadingDialog("Verifying PIN...");
    authenticationBloc.add(VerifyMobileNoEvent(mobileNo: mobileNumber, secureKeyword: secureKeyword, otpNumber: pin, callback: (UserAuthenticationResponse userAuthenticationResponse) {}));
  }

  resendVerifySMS() {
    if (verificationMode == VerificationMode.Login) {
      authenticationBloc.add(LoginUsingMobileNumberEvent(mobileNo: mobileNumber, countryCode: countryCode, callback: (PreVerifyMobileNumberOTPResponse preVerifyMobileNumberOTPResponse) {}));
    } else if (verificationMode == VerificationMode.SignUp) {
      authenticationBloc.add(RegisterUsingMobileNoEvent(mobileNo: mobileNumber, countryCode: countryCode, callback: (PreVerifyMobileNumberOTPResponse preVerifyMobileNumberOTPResponse) {}));
    }
  }

  callMobileNumber() {
    showToast('Coming soon.', Toast.LENGTH_LONG);
  }

  goToLoginPage() {
    Navigator.popUntil(context, ModalRoute.withName('login_page'));
  }

  Future<bool> goBack() async {
    authenticationBloc.add(RemoveAllAuthenticationsEvent(callback: (bool done) {}));
    return Future.value(true);
  }

  goToChatGroupList() {
    //Remove all pages and make chat_group_list_page be the only page.
    Navigator.of(context).pushNamedAndRemoveUntil("tabs_page", (Route<dynamic> route) => false);
  }
}
