import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:snschat_flutter/general/index.dart';
import 'package:snschat_flutter/objects/models/index.dart';
import 'package:snschat_flutter/objects/rest/index.dart';
import 'package:snschat_flutter/service/index.dart';
import 'package:snschat_flutter/state/bloc/bloc.dart';

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
  bool isLoading = true;

  // contactLoaded is true
  bool contactLoaded = false;
  bool checkboxesLoaded = false;

  String title = "";
  String subtitle = "";

  UserContact ownUserContact;

  List<Contact> selectedContacts = [];
  Map<String, bool> contactCheckBoxes = {};

  RefreshController _refreshController;
  ScrollController scrollController;

  CustomFileService fileService = Get.find();
  ImageService imageService = Get.find();

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

    return Scaffold(
      appBar: appBar(),
      body: multiBlocListener(),
      bottomNavigationBar: _bottomAppBar(),
      floatingActionButton: _floatingActionButton(),
    );
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
                style: TextStyle(fontSize: 18.0),
              ),
              Text(
                subtitle,
                style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w300),
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
    ], child: userContactBlocBuilder());
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

  Widget userContactBlocBuilder() {
    return BlocBuilder<UserContactBloc, UserContactState>(
      builder: (context, userContactState) {
        if (userContactState is UserContactsLoading) {
          return showLoadingContactsPage();
        }

        if (userContactState is UserContactsLoaded) {
          if (!isObjectEmpty(userContactState.ownUserContact)) {
            ownUserContact = userContactState.ownUserContact;
            return phoneStorageContactBlocBuilder();
          }
        }

        return showErrorPage('userContactBlocBuilder()');
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
          if (!checkboxesLoaded) {
            setupCheckBoxes(phoneStorageContactState.phoneStorageContactList);
            checkboxesLoaded = true;
          }

          if (phoneStorageContactState.phoneStorageContactList.length == 0) {
            return showNoContactPage();
          } else {
            return showSelectContactPageContent(phoneStorageContactState.phoneStorageContactList);
          }
        }

        if (phoneStorageContactState is PhoneStorageContactsNotLoaded) {
          return showNoContactPermissionPage();
        }

        return showErrorPage('phoneStorageContactBlocBuilder()');
      },
    );
  }

  Widget showSelectContactPageContent(List<Contact> contacts) {
    return SmartRefresher(
      controller: _refreshController,
      enablePullDown: true,
      physics: BouncingScrollPhysics(),
      onRefresh: () => onRefresh(),
      child: ListView(
        controller: scrollController,
        children: contacts.map((Contact contact) {
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
          height: 10.0,
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
      ),
      subtitle: Text(
        'Hey There! I am using PocketChat.',
        softWrap: true,
      ),
      value: contactCheckBoxes[contact.displayName],
      onChanged: (bool value) {
        if (contactIsSelected(contact)) {
          selectedContacts.remove(contact);
        } else {
          selectedContacts.add(contact);
        }
        setState(() {
          contactCheckBoxes[contact.displayName] = value;
        });
      },
      secondary: CircleAvatar(
        backgroundImage: contact.avatar.isNotEmpty ? MemoryImage(contact.avatar) : NetworkImage(''),
        child: contact.avatar.isEmpty ? Text(contact.displayName[0]) : Text(''),
        radius: 20.0,
      ),
    );
  }

  Widget showContactWithoutCheckbox(Contact contact) {
    return ListTile(
      title: Text(
        contact.displayName,
        softWrap: true,
      ),
      subtitle: Text(
        'Hey There! I am using PocketChat.',
        softWrap: true,
      ),
      onTap: () {
        if (widget.chatGroupType == ConversationGroupType.Personal) {
          List<String> phoneNumberList = getUserContactMobileNumber(contact);

          if (phoneNumberList.length > 1) {
            showSelectPhoneNumberDialog(contact.displayName, phoneNumberList);
          } else if (phoneNumberList.length == 1) {
            createPersonalConversationGroup(phoneNumberList[0], contact.displayName);
          } else {
            Get.dialog(
                Dialog(
                  child: Center(
                    child: Text('No mobile number found under this contact. Please add mobile number.'),
                  ),
                ),
                barrierDismissible: false);
          }
        }
      },
      leading: CircleAvatar(
        backgroundImage: contact.avatar.isNotEmpty ? MemoryImage(contact.avatar) : NetworkImage(''),
        child: contact.avatar.isEmpty
            ? Text(
                contact.displayName[0],
              )
            : Text(
                '',
              ),
        radius: 20.0,
      ),
    );
  }

  Widget showErrorPage(String source) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            'Error in getting phone storage contacts. Please try again.',
            textAlign: TextAlign.center,
          ),
          Text(source)
        ],
      ),
    );
  }

  Widget showNoContactPage() {
    return Center(
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
    );
  }

  Widget showNoContactPermissionPage() {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
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
          child: Text("Grant Contact Permission"),
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

  showSelectPhoneNumberDialog(String contactName, List<String> mobileNumbers) {
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
                        itemCount: mobileNumbers.length,
                        itemBuilder: (BuildContext context, int index) => ListTile(
                            title: Text(
                              mobileNumbers[index],
                              softWrap: true,
                            ),
                            onTap: () {
                              createPersonalConversationGroup(mobileNumbers[index], contactName);
                            }),
                        shrinkWrap: true),
                  ],
                ),
              ),
            ]),
        barrierDismissible: true,
        useRootNavigator: true);
  }

  createPersonalConversationGroup(String mobileNumber, String contactName) {
    userContactBloc.add(GetUserContactByMobileNoEvent(
        mobileNo: mobileNumber,
        callback: (UserContact userContact) {
          if (!isObjectEmpty(userContact)) {
            conversationGroupBloc.add(CreateConversationGroupEvent(
                createConversationGroupRequest: CreateConversationGroupRequest(
                  name: contactName,
                  conversationGroupType: ConversationGroupType.Personal,
                  description: null,
                  memberIds: [userContact.id, ownUserContact.id],
                  adminMemberIds: [ownUserContact.id],
                ),
                callback: (ConversationGroup conversationGroup) {
                  if (!isObjectEmpty(conversationGroup)) {
                    Get.back(); // Close select phone number pop up
                    goToChatRoomPage(conversationGroup);
                  }
                }));
          }
        }));
  }

  bool contactIsSelected(Contact contact) {
    return selectedContacts.any((Contact selectedContact) => selectedContact.displayName == contact.displayName);
  }

  bool needSelectMultipleContacts() {
    return widget.chatGroupType != ConversationGroupType.Personal;
  }

  setupCheckBoxes(List<Contact> contacts) {
    contacts.forEach((contact) {
      contactCheckBoxes[contact.displayName] = false;
    });
  }

  getContacts() async {
    phoneStorageContactBloc.add(GetPhoneStorageContactsEvent(callback: (bool success) {
      success ? _refreshController.refreshCompleted() : _refreshController.refreshFailed();
    }));
  }

  setConversationType(ConversationGroupType chatGroupType) async {
    switch (chatGroupType) {
      case ConversationGroupType.Personal:
        title = "Create Personal Chat";
        subtitle = "Select a contact below.";
        break;
      case ConversationGroupType.Group:
        title = "Create Group Chat";
        subtitle = "Select a few contacts below.";
        break;
      case ConversationGroupType.Broadcast:
        title = "Broadcast";
        subtitle = "Select a few contacts below.";
        break;
      default:
        title = "Unknown Chat";
        subtitle = "Error. Please go back and select again.";
        break;
    }
  }

  onRefresh() async {
    getContacts();
  }

  List<String> getUserContactMobileNumber(Contact contact) {
    List<String> primaryNo = [];
    if (contact.phones.length > 0) {
      contact.phones.forEach((phoneNo) {
        primaryNo.add(phoneNo.value);
      });
    } else {
      // No phone number and the display name is the phone number itself
      // Reason: No contact.phones when the mobile number doesn't have a name on it
      String mobileNo = contact.displayName.replaceAll(new RegExp(r"\s+\b|\b\s|\s|\b"), "");
      primaryNo.add(mobileNo);
    }

    if (primaryNo.length == 0) {
      Get.snackbar('Unable to get the User\'s phone number.', 'Please edit your phone number to proper phone number format and try again.');
    }

    return primaryNo;
  }

  goToGroupNamePage() {
    Navigator.push(context, MaterialPageRoute(builder: ((context) => GroupNamePage(selectedContacts: selectedContacts))));
  }

  goToChatRoomPage(ConversationGroup conversationGroup) {
    // Go to chat room page
    Navigator.pop(context); //pop loading dialog
    Navigator.of(context).pushNamedAndRemoveUntil('tabs_page', (Route<dynamic> route) => false);
    // Navigator.of(context).pushReplacementNamed(ChatRoomPage(conversationGroup));
    Navigator.push(context, MaterialPageRoute(builder: ((context) => ChatRoomPage(conversationGroup))));
  }
}
