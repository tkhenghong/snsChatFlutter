import 'package:bloc/bloc.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:snschat_flutter/general/functions/validation_functions.dart';
import 'package:snschat_flutter/service/permissions/PermissionService.dart';
import 'package:snschat_flutter/state/bloc/phoneStorageContacts/bloc.dart';

// TODO: To be used in select contact page
class PhoneStorageContactBloc extends Bloc<PhoneStorageContactEvent, PhoneStorageContactState> {
  PermissionService permissionService = PermissionService();

  @override
  PhoneStorageContactState get initialState => PhoneStorageContactLoading();

  @override
  Stream<PhoneStorageContactState> mapEventToState(PhoneStorageContactEvent event) async* {
    if (event is GetPhoneStorageContactsEvent) {
      yield* _initializePhoneStorageContactsToState(event);
    }
  }

  Stream<PhoneStorageContactState> _initializePhoneStorageContactsToState(GetPhoneStorageContactsEvent event) async* {
    try {
      bool contactAccessGranted = await permissionService.requestContactPermission();
      List<Contact> phoneContactList = [];

      if (state is PhoneStorageContactsLoaded) {
        phoneContactList = (state as PhoneStorageContactsLoaded).phoneStorageContactList;
      }

      if (contactAccessGranted) {
        Iterable<Contact> contacts = await ContactsService.getContacts();
        Iterable<Contact> filteredContacts = contacts.where((Contact contact) {
          bool phoneNoIsEligible = false;
          contact.phones.forEach((Item phoneNumber) {
            // 7 should be the shortest international number in the world
            if (phoneNumber.value.length > 6) {
              phoneNoIsEligible = true;
            }
          });

          return phoneNoIsEligible;
        });
        phoneContactList = filteredContacts.toList(growable: true);
        phoneContactList.sort((a, b) => a.displayName.compareTo(b.displayName));

        // Dart way of removing duplicates. // https://stackoverflow.com/questions/12030613/how-to-delete-duplicates-in-a-dart-list-list-distinct
        phoneContactList = phoneContactList.toList();
        if (!isObjectEmpty(event)) {
          yield PhoneStorageContactsLoaded(phoneContactList);
          event.callback(true);
        }
      } else {
        if (!isObjectEmpty(event)) {
          yield PhoneStorageContactsNotLoaded();
          event.callback(false);
        }
      }
    } catch (e) {
      debugPrint('Error in GetPhoneStorageContactsEvent');
      yield PhoneStorageContactsNotLoaded();
      event.callback(false);
    }
  }

  // To send response to those dispatched Actions
  void functionCallback(event, value) {
    if (!isObjectEmpty(event)) {
      event.callback(value);
    }
  }
}
