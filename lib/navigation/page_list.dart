
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snschat_flutter/ui/pages/index.dart';

class NavigationPage {
  String routeName;
  Widget routePage;

  NavigationPage({this.routeName, this.routePage});
}

List<NavigationPage> navigationPageList = [
  NavigationPage(routeName: 'login_page', routePage: LoginPage()),
  NavigationPage(routeName: 'privacy_notice_page', routePage: PrivacyNoticePage()),
  NavigationPage(routeName: 'sign_up_page', routePage: SignUpPage()),
  NavigationPage(routeName: 'terms_and_conditions_page', routePage: TermsAndConditionsPage()),
  NavigationPage(routeName: 'verify_phone_number_page', routePage: VerifyPhoneNumberPage()),
  NavigationPage(routeName: 'tabs_page', routePage: TabsPage()),
  NavigationPage(routeName: 'chat_group_list_page', routePage: ChatGroupListPage()),
  NavigationPage(routeName: 'scan_qr_code_page', routePage: ScanQrCodePage()),
  NavigationPage(routeName: 'settings_page', routePage: SettingsPage()),
  NavigationPage(routeName: 'myself_page', routePage: MyselfPage()),
  NavigationPage(routeName: 'chat_room_page', routePage: ChatRoomPage()),
  NavigationPage(routeName: 'chat_info_page', routePage: ChatInfoPage()),
  NavigationPage(routeName: 'contacts_page', routePage: SelectContactsPage()),
  NavigationPage(routeName: 'photo_view_page', routePage: PhotoViewPage()),
  NavigationPage(routeName: 'video_player_page', routePage: VideoPlayerPage()),
];

final List<GetPage> getPageList = [];
final Map<String, WidgetBuilder> routeList = new Map();

/// Generate a list of page routes for GetX state management.
List<GetPage> generateGetPageList() {
  navigationPageList.forEach((element) {
    getPageList.add(GetPage(name: element.routeName, page: () => element.routePage));
  });

  return getPageList;
}

/// Generate a list of page routes for main Flutter navigation.
Map<String, WidgetBuilder> generateRoutes() {
  if (routeList.isEmpty) {
    navigationPageList.forEach((element) {
      routeList.putIfAbsent(element.routeName, () => (_) => element.routePage);
    });
  }

  return routeList;
}