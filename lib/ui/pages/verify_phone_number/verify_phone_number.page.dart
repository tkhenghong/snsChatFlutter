
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';
import 'package:snschat_flutter/general/functions/toast/show_toast.dart';
import 'package:snschat_flutter/general/ui-component/loading.dart';
import 'package:snschat_flutter/objects/models/index.dart';
import 'package:snschat_flutter/objects/rest/index.dart';
import 'package:snschat_flutter/state/bloc/bloc.dart';

class VerifyPhoneNumberPage extends StatefulWidget {
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

  AuthenticationBloc authenticationBloc;
  UserContactBloc userContactBloc;
  SettingsBloc settingsBloc;
  UserBloc userBloc;
  MultimediaBloc multimediaBloc;
  ConversationGroupBloc conversationGroupBloc;
  UnreadMessageBloc unreadMessageBloc;

  int pinFieldLength = 6;

  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    themePrimaryColor = Theme.of(context).primaryColor;

    authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    conversationGroupBloc = BlocProvider.of<ConversationGroupBloc>(context);
    unreadMessageBloc = BlocProvider.of<UnreadMessageBloc>(context);
    multimediaBloc = BlocProvider.of<MultimediaBloc>(context);
    userContactBloc = BlocProvider.of<UserContactBloc>(context);
    settingsBloc = BlocProvider.of<SettingsBloc>(context);
    userBloc = BlocProvider.of<UserBloc>(context);

    return multiBlocListener();
  }

  Widget multiBlocListener() {
    return MultiBlocListener(
      listeners: [
        authenticationBlocListener()
      ],
      child: authenticationBlocBuilder(),
    );
  }

  Widget authenticationBlocListener() {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, authenticationState) {
        if(authenticationState is AuthenticationsLoaded) { // If verification successful,
          Get.back();
          showToast('Verification successful.', Toast.LENGTH_SHORT);
          refreshUserData();
          goToChatGroupList();
        }
      },
    );
  }

  Widget authenticationBlocBuilder() {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      cubit: authenticationBloc,
      builder: (context, authenticationState) {
        if (authenticationState is Authenticating) {
          return Scaffold(
            appBar: appBar(authenticationState.mobileNumber),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                textsSection(authenticationState.mobileNumber, authenticationState.secureKeyword),
                wrongNumberButton(),
                pinTextField(authenticationState.mobileNumber, authenticationState.secureKeyword),
                Text('Enter $pinFieldLength-digit code'),
                // RaisedButton(onPressed: () {},  child: Text('Resend SMS'),), //In case you're able to resend SMS
                resendSMSButton(),
                // In case you request a lot of times but you never retrieved and entered the correct PIN
                callMeButton(),
              ],
            ),
          );
        }

        return showErrorPage();
      },
    );
  }

  Widget appBar(String mobileNumber) {
    return AppBar(
      title: Text('Verify $mobileNumber'),
      centerTitle: true,
    );
  }

  Widget textsSection(String mobileNumber, String secureKeyword) {
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
            onPressed: () {
              Navigator.pop(context);
            },
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

  Widget pinTextField(String mobileNumber, String secureKeyword) {
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
        decoration: UnderlineDecoration(textStyle: TextStyle(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.bold), color: Colors.black),
        onChanged: (pin) {
          if(pin.length == pinFieldLength) {
            verifyMobileNumber(pin, mobileNumber, secureKeyword);
          }
        },
        onSubmit: (pin) {
          showLoading("Verifying PIN...");
          // TODO: Verify phone by calling BlocEvent > call UserAuthentication API > goToChatGroupList
          verifyMobileNumber(pin, mobileNumber, secureKeyword);
          authenticationBloc.add(VerifyMobileNoEvent(mobileNo: mobileNumber, secureKeyword: secureKeyword, otpNumber: pin, callback: (UserAuthenticationResponse userAuthenticationResponse) {}));
        },
      ),
    );
  }

  Widget resendSMSButton() {
    return RaisedButton(
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

  refreshUserData() {
    print('verify_phone_number.dart refreshUserData()');
    userBloc.add(GetOwnUserEvent(callback: (User user) {}));
    settingsBloc.add(GetUserOwnSettingsEvent(callback: (Settings settings) {}));
    conversationGroupBloc.add(GetUserOwnConversationGroupsEvent(callback: (bool done) {}));
    unreadMessageBloc.add(GetUserPreviousUnreadMessagesEvent(callback: (bool done) {}));
    multimediaBloc.add(GetUserOwnProfilePictureMultimediaEvent(callback: (bool done) {}));
    userContactBloc.add(GetUserOwnUserContactsEvent(callback: (bool done) {}));
  }

  verifyMobileNumber(String pin, String mobileNumber, String secureKeyword) {
    showLoading("Verifying PIN...");
    authenticationBloc.add(VerifyMobileNoEvent(mobileNo: mobileNumber, secureKeyword: secureKeyword, otpNumber: pin, callback: (UserAuthenticationResponse userAuthenticationResponse) {}));
  }

  goToLoginPage() {
    Navigator.popUntil(context, ModalRoute.withName('/login_page'));
  }

  goToChatGroupList() {
    //Remove all pages and make chat_group_list_page be the only page
    Navigator.of(context).pushNamedAndRemoveUntil("tabs_page", (Route<dynamic> route) => false);
  }
}
