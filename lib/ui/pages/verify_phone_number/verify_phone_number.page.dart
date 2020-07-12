import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';
import 'package:snschat_flutter/general/ui-component/loading.dart';
import 'package:snschat_flutter/objects/rest/index.dart';
import 'package:snschat_flutter/state/bloc/authentication/bloc.dart';

class VerifyPhoneNumberPage extends StatefulWidget {
  PreVerifyMobileNumberOTPResponse preVerifyMobileNumberOTPResponse;

  VerifyPhoneNumberPage({this.preVerifyMobileNumberOTPResponse});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new VerifyPhoneNumberState();
  }
}

class VerifyPhoneNumberState extends State<VerifyPhoneNumberPage> {
  TextEditingController textEditingController;
  PinDecoration pinDecoration;

  Color themePrimaryColor;

  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    String phoneNo = widget.preVerifyMobileNumberOTPResponse.mobileNumber;
    String secureKeyword = widget.preVerifyMobileNumberOTPResponse.secureKeyword;
    DateTime tokenExpiryTime = widget.preVerifyMobileNumberOTPResponse.tokenExpiryTime;

    themePrimaryColor = Theme.of(context).primaryColor;
    return Scaffold(
      appBar: AppBar(
        title: Text('Verify ' + phoneNo),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('Verify ' + phoneNo),
          RichText(
              text: TextSpan(
                  style: TextStyle(
                    inherit: true,
                  ),
                  children: <TextSpan>[
                TextSpan(text: 'We have sent and SMS with a code to ', style: TextStyle(color: themePrimaryColor)),
                TextSpan(text: phoneNo.toString(), style: TextStyle(inherit: true, color: themePrimaryColor, fontWeight: FontWeight.bold)),
                TextSpan(text: 'The secure keyword is: $secureKeyword.', style: TextStyle(inherit: true, color: themePrimaryColor, fontWeight: FontWeight.bold)),
                // TODO: Add other types of error messages for different situations
                // TextSpan(text: 'Can\'t send an SMS with your code because you\'ve tried to register '),
                // TextSpan(text: phoneNo.toString(), style: TextStyle(inherit: true, fontWeight: FontWeight.bold)),
                // TextSpan(text: ' recently. Request a call or wait before requesting an SMS. '),
              ])),
          FlatButton(
            child: Text(
              'Wrong number?',
              style: TextStyle(color: Colors.black),
            ),
            onPressed: goToLoginPage(),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 70.0),
            // PIN Text Field: https://pub.dev/packages/pin_input_text_field
            // Auto "Enter" when all PIN text fields have values
            child: pinTextField(),
          ),
          Text('Enter 4-digit code'),
//          RaisedButton(onPressed: () {},  child: Text('Resend SMS'),), //In case youre able to resend SMS
          resendSMSButton(),
          // In case you request a lot of times but you never retreived and entered the correct PIN
          callMeButton(),
        ],
      ),
    );
  }

  Widget pinTextField() {
    return PinInputTextField(
      pinLength: 4,
      autoFocus: true,
      textInputAction: TextInputAction.go,
      controller: textEditingController,
      enabled: true,
      keyboardType: TextInputType.number,
      decoration: UnderlineDecoration(textStyle: TextStyle(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.bold), color: Colors.black),
      onSubmit: (pin) {
        showLoading("Verifying PIN...");
        // TODO: Verify phone by calling BlocEvent > call UserAuthentication API > goToChatGroupList
        BlocProvider.of<AuthenticationBloc>(Get.context).add(VerifyMobileNoEvent(mobileNo: widget.preVerifyMobileNumberOTPResponse.mobileNumber, secureKeyword: widget.preVerifyMobileNumberOTPResponse.secureKeyword, otpNumber: pin));
        Future.delayed(Duration(milliseconds: 1000), () {
          //Delay 1 second to simulate something loading
          Get.back();
          goToChatGroupList();
        });
      },
    );
  }

  Widget resendSMSButton() {
    RaisedButton(
      onPressed: () {},
      child: Text('Resend SMS in 7 hours'),
    );
  }

  Widget callMeButton() {
    return RaisedButton(
      onPressed: () {},
      child: Text('Call me'),
    );
  }

  goToLoginPage() {
    Get.offNamed('/login_page');
  }

  goToChatGroupList() {
    //Remove all pages and make chat_group_list_page be the only page
    Get.offAndToNamed('tabs_page');
  }
}
