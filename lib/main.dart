import 'package:flutter/material.dart';
import 'package:snschat_flutter/ui/pages/chat_group_list/chat_group_list.dart';
import 'package:snschat_flutter/ui/pages/login/login.dart';
import 'package:snschat_flutter/ui/pages/privacy_notice/privacy_notice.dart';
import 'package:snschat_flutter/ui/pages/scan_qr_code/scan_qr_code_page.dart';
import 'package:snschat_flutter/ui/pages/settings/settings.dart';
import 'package:snschat_flutter/ui/pages/sign_up/sign_up.dart';
import 'package:snschat_flutter/ui/pages/tabs/tabs.dart';
import 'package:snschat_flutter/ui/pages/terms_and_conditions/terms_and_conditions.dart';
import 'package:snschat_flutter/ui/pages/verify_phone_number/verify_phone_number.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
//      title: 'SNS众聊',
      theme: ThemeData(
        fontFamily: 'OpenSans',
        brightness: Brightness.light,
        primaryColor: const Color(0xff26a2d4),
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
      routes: {
        "privacy_notice_page": (_) => new PrivacyNoticePage(),
        "sign_up_page": (_) => new SignUpPage(),
        "terms_and_conditions_page": (_) => TermsAndConditionsPage(),
        "verify_phone_number_page": (_) => VerifyPhoneNumberPage(),
        "tabs_page": (_) => TabsPage(),
        "chat_group_list_page": (_) => new ChatGroupListPage(),
        "scan_qr_code_page": (_) => new ScanQrCodePage(),
        "settings_page": (_) => new SettingsPage()
      },
    );
  }
}
