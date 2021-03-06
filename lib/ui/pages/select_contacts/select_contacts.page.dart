import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:snschat_flutter/environments/development/variables.dart' as globals;
import 'package:snschat_flutter/general/index.dart';
import 'package:snschat_flutter/objects/models/index.dart';
import 'package:snschat_flutter/objects/rest/index.dart';
import 'package:snschat_flutter/service/index.dart';
import 'package:snschat_flutter/state/bloc/index.dart';

import '../index.dart';
import 'CustomSearchDelegate.dart';

class SelectContactsPage extends StatefulWidget {
  final ConversationGroupType chatGroupType;

  SelectContactsPage({this.chatGroupType});

  @override
  State<StatefulWidget> createState() {
    return new SelectContactsPageState();
  }
}

// TODO: Make Alphabet scroll
// WhatsApp closes the search function when multi select
class SelectContactsPageState extends State<SelectContactsPage> {
  bool firstTime = true;
  bool isLoading = true;
  List<UserContact> userContacts = [];
  List<Contact> phoneStorageContacts = [];

  // contactLoaded is true
  bool contactLoaded = false;
  bool checkboxesLoaded = false;

  double header1 = globals.header1;
  double header2 = globals.header2;
  double header3 = globals.header3;
  double header4 = globals.header4;
  double header5 = globals.header5;
  double header6 = globals.header6;

  String title = "";
  String subtitle = "";

  UserContact ownUserContact;
  User ownUser;

  List<Contact> selectedContacts = [];
  List<UserContact> selectedUserContacts = [];
  Map<String, bool> contactCheckBoxes = {};

  RefreshController _refreshController;
  ScrollController scrollController;

  CustomFileService fileService = Get.find();

  UserContactBloc userContactBloc;
  ConversationGroupBloc conversationGroupBloc;
  PhoneStorageContactBloc phoneStorageContactBloc;

  @override
  initState() {
    super.initState();
    _refreshController = new RefreshController();
    scrollController = new ScrollController();
  }

  @override
  void dispose() {
    super.dispose();
    _refreshController.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    userContactBloc = BlocProvider.of<UserContactBloc>(context);
    conversationGroupBloc = BlocProvider.of<ConversationGroupBloc>(context);
    phoneStorageContactBloc = BlocProvider.of<PhoneStorageContactBloc>(context);

    if (!contactLoaded) {
      getContacts();
      contactLoaded = true;
    }
    setConversationType(widget.chatGroupType);

    if (firstTime) {
      initialize();
      firstTime = false;
    }

    return Scaffold(
      appBar: appBar(),
      body: multiBlocListener(),
      bottomNavigationBar: _bottomAppBar(),
      floatingActionButton: _floatingActionButton(),
    );
  }

  initialize() {
    userContactBloc.add(GetUserOwnUserContactEvent(callback: (bool done) {}));
    userContactBloc.add(InitializeUserContactsEvent(callback: (bool done) {}));
  }

  Widget appBar() {
    return AppBar(
        title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                style: TextStyle(fontSize: header1),
              ),
              Text(
                subtitle,
                style: TextStyle(fontSize: header2, fontWeight: FontWeight.w300),
              )
            ],
          ),
        ),
        Tooltip(
          message: "Next",
          child: InkWell(
            borderRadius: BorderRadius.circular(30.0),
            child: Padding(
              padding: EdgeInsets.all(15.0),
              child: Icon(Icons.check),
            ),
            onTap: () {
              goToGroupNamePage();
            },
          ),
        ),
      ],
    ));
  }

  Widget multiBlocListener() {
    return MultiBlocListener(listeners: [
      phoneStorageContactBlocListener(),
      userBlocListener(),
      userContactBlocListener(),
    ], child: userBlocBuilder());
  }

  Widget phoneStorageContactBlocListener() {
    return BlocListener<PhoneStorageContactBloc, PhoneStorageContactState>(
      listener: (context, phoneStorageContactState) {},
    );
  }

  Widget userBlocListener() {
    return BlocListener<UserBloc, UserState>(
      listener: (context, userState) {},
    );
  }

  Widget userContactBlocListener() {
    return BlocListener<UserContactBloc, UserContactState>(
      listener: (context, userContactState) {
        if (userContactState is UserContactsLoaded) {
          ownUserContact = userContactState.ownUserContact;
        }
      },
    );
  }

  Widget userBlocBuilder() {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, userState) {
        if (userState is UserLoading) {
          return showLoadingContactsPage();
        }

        if (userState is UserLoaded) {
          if (!isObjectEmpty(userState.user)) {
            ownUser = userState.user;
            return userContactBlocBuilder();
          }
        }

        return showErrorPage();
      },
    );
  }

  Widget userContactBlocBuilder() {
    return BlocBuilder<UserContactBloc, UserContactState>(
      builder: (context, userContactState) {
        if (userContactState is UserContactsLoading) {
          return showLoadingContactsPage();
        }

        if (userContactState is UserContactsLoaded) {
          if (!isObjectEmpty(userContactState.ownUserContact)) {
            ownUserContact = userContactState.ownUserContact;
            userContacts = userContactState.userContactList;
            return phoneStorageContactBlocBuilder();
          }
        }

        return showErrorPage();
      },
    );
  }

  Widget phoneStorageContactBlocBuilder() {
    return BlocBuilder<PhoneStorageContactBloc, PhoneStorageContactState>(
      builder: (context, phoneStorageContactState) {
        if (phoneStorageContactState is PhoneStorageContactLoading) {
          return showLoadingContactsPage();
        }

        if (phoneStorageContactState is PhoneStorageContactsLoaded) {
          phoneStorageContacts = phoneStorageContactState.phoneStorageContactList;
          setupCheckBoxes();

          return mainBody();
        }

        if (phoneStorageContactState is PhoneStorageContactsNotLoaded) {
          return showNoContactPermissionPage();
        }

        return showErrorPage();
      },
    );
  }

  Widget mainBody() {
    if (phoneStorageContacts.isEmpty) {
      return showNoContactPage();
    } else {
      // Filter own mobile no.
      phoneStorageContacts.removeWhere((element) {
        return isOwnUserContact(element);
      });
      return showSelectContactPageContent();
    }
  }

  Widget showNoContactPage() {
    return SmartRefresher(
      controller: _refreshController,
      enablePullDown: true,
      physics: BouncingScrollPhysics(),
      onRefresh: onRefresh,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'No contact in your phone storage. Create a few to start a conversation!',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget showSelectContactPageContent() {
    return SmartRefresher(
      controller: _refreshController,
      enablePullDown: true,
      physics: BouncingScrollPhysics(),
      onRefresh: onRefresh,
      child: ListView(
        controller: scrollController,
        children: phoneStorageContacts.map((Contact contact) {
          return Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[needSelectMultipleContacts() ? showContactWithCheckBox(contact) : showContactWithoutCheckbox(contact)],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget showLoadingContactsPage() {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text('Reading contacts from storage....'),
        SizedBox(
          height: Get.height * 0.05,
        ),
        CircularProgressIndicator(),
      ],
    ));
  }

  Widget showContactWithCheckBox(Contact contact) {
    return CheckboxListTile(
      title: Text(
        contact.displayName,
        softWrap: true,
        style: TextStyle(fontSize: header3),
      ),
      subtitle: Text(
        'Hey There! I am using PocketChat.',
        softWrap: true,
        style: TextStyle(fontSize: header4),
      ),
      value: contactCheckBoxes[contact.displayName],
      onChanged: (bool value) {
        if (widget.chatGroupType == ConversationGroupType.Group) {
          showSelectPhoneNumberDialog(contact, checked: value);
        }
      },
      secondary: contactCircleAvatar(contact),
    );
  }

  Widget showContactWithoutCheckbox(Contact contact) {
    return ListTile(
      title: Text(
        contact.displayName,
        softWrap: true,
        style: TextStyle(fontSize: header3),
      ),
      subtitle: Text(
        'Hey There! I am using PocketChat.',
        softWrap: true,
        style: TextStyle(fontSize: header4),
      ),
      onTap: () {
        if (widget.chatGroupType == ConversationGroupType.Personal) {
          showSelectPhoneNumberDialog(contact);
        }
      },
      leading: contactCircleAvatar(contact),
    );
  }

  Widget contactCircleAvatar(Contact contact) {
    return CircleAvatar(radius: Get.width * 0.06, backgroundImage: contact.avatar.isNotEmpty ? MemoryImage(contact.avatar) : AssetImage('lib/ui/images/blank_black.png'), child: Text(contact.avatar.isEmpty ? contact.displayName[0] : ''));
  }

  Widget showErrorPage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            'Error in getting phone storage contacts. Please try again.',
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }

  Widget showNoContactPermissionPage() {
    return Center(
        child: Column(
      children: <Widget>[
        Text(
          'Unable to read contacts from storage. Please grant contact permission first.',
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 10.0,
        ),
        RaisedButton(
          onPressed: () => getContacts(),
          child: Text('Grant Contact Permission'),
        )
      ],
    ));
  }

  BottomAppBar _bottomAppBar() {
    return BottomAppBar(
      shape: CircularNotchedRectangle(),
    );
  }

  FloatingActionButton _floatingActionButton() {
    return FloatingActionButton(
      child: Icon(Icons.search),
      onPressed: () => showSearch(context: context, delegate: CustomSearchDelegate()),
    );
  }

  showSelectPhoneNumberDialog(Contact contact, {bool checked}) {
    List<String> phoneNumberList = getContactMobileNumber(contact);

    if (widget.chatGroupType == ConversationGroupType.Group && !isObjectEmpty(checked) && !checked) {
      removeGroupUserContact(contact, phoneNumberList, checked);
    } else {
      if (phoneNumberList.length > 1) {
        Get.dialog(
            SimpleDialog(
                title: Center(
                  child: Text('Please select a phone number: '),
                ),
                children: <Widget>[
                  // Flutter ListView in a SimpleDialog:
                  // https://stackoverflow.com/questions/50095763
                  Container(
                    // padding: EdgeInsets.only(left: Get.width * 0.05, right: Get.width * 0.05, top: Get.height * 0.3, bottom: Get.height * 0.3),
                    height: Get.height * 0.3,
                    width: Get.width * 0.9,
                    child: Column(
                      children: <Widget>[
                        ListView.builder(
                            physics: BouncingScrollPhysics(),
                            itemCount: phoneNumberList.length,
                            itemBuilder: (BuildContext context, int index) => ListTile(
                                title: Text(
                                  phoneNumberList[index],
                                  softWrap: true,
                                ),
                                onTap: () {
                                  managePhoneNumber(contact, phoneNumberList[0], checked: checked);
                                }),
                            shrinkWrap: true),
                      ],
                    ),
                  ),
                ]),
            barrierDismissible: true,
            useRootNavigator: true);
      } else if (phoneNumberList.length == 1) {
        managePhoneNumber(contact, phoneNumberList[0], checked: checked);
      } else {
        Get.dialog(
            Dialog(
              child: Center(
                child: Column(
                  children: [
                    Text('No mobile number found under this contact. Please add mobile number.'),
                    FlatButton(onPressed: () => Get.back(), child: Text('Ok')),
                  ],
                ),
              ),
            ),
            barrierDismissible: true);
      }
    }
  }

  /// Manage the phone number acquired from showSelectPhoneNumberDialog().
  managePhoneNumber(Contact contact, String mobileNo, {bool checked}) {
    if (widget.chatGroupType == ConversationGroupType.Personal) {
      createPersonalConversationGroup(contact, mobileNo);
    } else if (widget.chatGroupType == ConversationGroupType.Group) {
      addGroupUserContact(contact, mobileNo, checked);
    }
    Get.back(); // Close showSelectPhoneNumberDialog()
  }

  createPersonalConversationGroup(Contact contact, String mobileNumber) {
    showLoadingDialog('Loading personal conversation....');
    userContactBloc.add(GetUserContactByMobileNoEvent(
        mobileNo: mobileNumber,
        callback: (UserContact userContact) {
          if (!isObjectEmpty(userContact)) {
            conversationGroupBloc.add(CreateConversationGroupEvent(
                createConversationGroupRequest: CreateConversationGroupRequest(
                  name: contact.displayName,
                  conversationGroupType: ConversationGroupType.Personal,
                  description: null,
                  memberIds: [userContact.id, ownUserContact.id],
                  adminMemberIds: [ownUserContact.id, userContact.id],
                ),
                callback: (ConversationGroup conversationGroup) {
                  if (!isObjectEmpty(conversationGroup)) {
                    Get.back(); // Close select phone number pop up.
                    Get.back(); // Close loading indicator.
                    goToChatRoomPage(conversationGroup);
                  }
                }));
          }
        }));
  }

  addGroupUserContact(Contact contact, String mobileNumber, bool checked) {
    if (checked) {
      // Check and add user contact and Contact
      userContactBloc.add(GetUserContactByMobileNoEvent(
          mobileNo: mobileNumber,
          callback: (UserContact userContact) {
            if (!isObjectEmpty(userContact)) {
              selectedContacts.add(contact);
              selectedUserContacts.add(userContact);
              setState(() {
                contactCheckBoxes[contact.displayName] = checked;
              });
            }
          }));
    } else {
      // Uncheck and remove user contact and Contact
      selectedContacts.removeWhere((element) => element == contact);
      selectedUserContacts.removeWhere((element) => element.mobileNo == mobileNumber);
      setState(() {
        contactCheckBoxes[contact.displayName] = checked;
      });
    }
  }

  /// Remove a group user contact
  removeGroupUserContact(Contact contact, List<String> phoneNumberList, bool checked) {
    // Uncheck and remove user contact and Contact
    selectedContacts.removeWhere((element) => element == contact);
    phoneNumberList.forEach((phoneNumber) {
      selectedUserContacts.removeWhere((element) => element.mobileNo == phoneNumber);
    });
    setState(() {
      contactCheckBoxes[contact.displayName] = checked;
    });
  }

  bool contactIsSelected(Contact contact) {
    return selectedContacts.any((Contact selectedContact) => selectedContact.displayName == contact.displayName);
  }

  bool needSelectMultipleContacts() {
    return widget.chatGroupType != ConversationGroupType.Personal;
  }

  setupCheckBoxes() {
    if (!checkboxesLoaded) {
      phoneStorageContacts.forEach((contact) {
        contactCheckBoxes[contact.displayName] = false;
      });
      checkboxesLoaded = true;
    }
  }

  getContacts() async {
    phoneStorageContactBloc.add(GetPhoneStorageContactsEvent(callback: (bool success) {
      success ? _refreshController.refreshCompleted() : _refreshController.refreshFailed();
    }));
  }

  setConversationType(ConversationGroupType chatGroupType) async {
    switch (chatGroupType) {
      case ConversationGroupType.Personal:
        title = 'Create Personal Chat';
        subtitle = 'Select a contact below.';
        break;
      case ConversationGroupType.Group:
        title = 'Create Group Chat';
        subtitle = 'Select a few contacts below.';
        break;
      case ConversationGroupType.Broadcast:
        title = 'Broadcast';
        subtitle = 'Select a few contacts below.';
        break;
      default:
        title = 'Unknown Chat';
        subtitle = 'Error. Please go back and select again.';
        break;
    }
  }

  onRefresh() async {
    getContacts();
  }

  List<String> getContactMobileNumber(Contact contact) {
    List<String> primaryNo = [];
    if (!isObjectEmpty(contact.phones) && contact.phones.isNotEmpty) {
      contact.phones.forEach((phoneNo) {
        primaryNo.add(phoneNo.value);
      });
    } else {
      // No phone number and the display name is the phone number itself
      // Reason: No contact.phones when the mobile number doesn't have a name on it
      String mobileNo = contact.displayName.replaceAll(new RegExp(r"\s+\b|\b\s|\s|\b"), "");
      primaryNo.add(mobileNo);
    }

    if (isObjectEmpty(primaryNo) || primaryNo.isEmpty) {
      Get.snackbar('Unable to get the User\'s phone number.', 'Please edit your phone number to proper phone number format and try again.');
    }

    return primaryNo;
  }

  bool isOwnUserContact(Contact contact) {
    List<String> mobileNoList = getContactMobileNumber(contact);
    int countryCodeLength = ownUser.countryCode.length;
    String strippedOwnUserContactMobileNo = ownUserContact.mobileNo.substring(countryCodeLength);
    return mobileNoList.indexWhere((element) => element.contains(strippedOwnUserContactMobileNo)) > -1;
  }

  goToGroupNamePage() {
    Navigator.push(context, MaterialPageRoute(builder: ((context) => GroupNamePage(selectedUserContacts: selectedUserContacts, selectedContacts: selectedContacts))));
  }

  goToChatRoomPage(ConversationGroup conversationGroup) {
    // Go to chat room page
    Navigator.pop(context); //pop loading dialog
    Navigator.of(context).pushNamedAndRemoveUntil('tabs_page', (Route<dynamic> route) => false);
    // Navigator.of(context).pushReplacementNamed(ChatRoomPage(conversationGroup));
    Navigator.push(context, MaterialPageRoute(builder: ((context) => ChatRoomPage(conversationGroup.id))));
  }
}
