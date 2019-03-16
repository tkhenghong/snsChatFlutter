import 'package:flutter/material.dart';
import 'package:snschat_flutter/ui/contacts/contacts.dart';
import 'package:snschat_flutter/ui/pages/chats/chat_group_list/chat_group_list_page.dart';
import 'package:snschat_flutter/ui/pages/chats/chat_info/chat_info_page.dart';
import 'package:snschat_flutter/ui/pages/chats/chat_room/chat_room_page.dart';
import 'package:snschat_flutter/ui/pages/login/login_page.dart';
import 'package:snschat_flutter/ui/pages/myself/myself_page.dart';
import 'package:snschat_flutter/ui/pages/privacy_notice/privacy_notice_page.dart';
import 'package:snschat_flutter/ui/pages/scan_qr_code/scan_qr_code_page.dart';
import 'package:snschat_flutter/ui/pages/settings/settings_page.dart';
import 'package:snschat_flutter/ui/pages/sign_up/sign_up_page.dart';
import 'package:snschat_flutter/ui/pages/tabs/tabs_page.dart';
import 'package:snschat_flutter/ui/pages/terms_and_conditions/terms_and_conditions_page.dart';
import 'package:snschat_flutter/ui/pages/verify_phone_number/verify_phone_number_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FLutter Chat Test App',
      theme: ThemeData(
//        fontFamily: 'OpenSans',
        brightness: Brightness.light,
        primaryColor: const Color(0xff000000),
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
      routes: {
        "login_page": (_) => new LoginPage(),
        "privacy_notice_page": (_) => new PrivacyNoticePage(),
        "sign_up_page": (_) => new SignUpPage(),
        "terms_and_conditions_page": (_) => TermsAndConditionsPage(),
        "verify_phone_number_page": (_) => VerifyPhoneNumberPage(),
        "tabs_page": (_) => TabsPage(),
        "chat_group_list_page": (_) => new ChatGroupListPage(),
        "scan_qr_code_page": (_) => new ScanQrCodePage(),
        "settings_page": (_) => new SettingsPage(),
        "myself_page": (_) => new MyselfPage(),
        "chat_room_page": (_) => new ChatRoomPage(),
        "chat_info_page": (_) => new ChatInfoPage(),
        "contacts_page": (_) => new ContactsPage(),
      },
    );
  }
}
