import 'package:bloc/bloc.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:snschat_flutter/general/functions/validation_functions.dart';
import 'package:snschat_flutter/service/permissions/PermissionService.dart';
import 'package:snschat_flutter/state/bloc/phoneStorageContacts/bloc.dart';

class PhoneStorageContactBloc extends Bloc<PhoneStorageContactEvent, PhoneStorageContactState> {
  PermissionService permissionService = PermissionService();

  @override
  PhoneStorageContactState get initialState => PhoneStorageContactLoading();

  @override
  Stream<PhoneStorageContactState> mapEventToState(PhoneStorageContactEvent event) async* {
    if (event is GetPhoneStorageContactsEvent) {
      yield* _initializePhoneStorageContactsToState(event);
    } else if (event is SearchPhoneStorageContactEvent) {
      yield* _searchPhoneStorageContactEvent(event);
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

  Stream<PhoneStorageContactState> _searchPhoneStorageContactEvent(SearchPhoneStorageContactEvent event) async* {
    List<Contact> phoneStorageContactList = [];
    List<Contact> contactSearchResultList = [];

    if (state is PhoneStorageContactsLoaded) {
      phoneStorageContactList = (state as PhoneStorageContactsLoaded).phoneStorageContactList;
    }

    List<Contact> searchResultBasedOnName = phoneStorageContactList.where((Contact contact) {
      return contact.displayName == event.searchTerm.toString() ||
          contact.givenName == event.searchTerm.toString() ||
          contact.middleName == event.searchTerm.toString() ||
          contact.familyName == event.searchTerm.toString() ||
          contact.company == event.searchTerm.toString() ||
          contact.jobTitle == event.searchTerm.toString();
    }).toList();

    contactSearchResultList = [contactSearchResultList, searchResultBasedOnName].expand((x) => x).toList();

    yield PhoneStorageContactsLoaded(
        phoneStorageContactList, contactSearchResultList); // display current found results first (appear faster)

    List<Contact> searchResultBasedOnPhoneNumber = phoneStorageContactList.where((Contact contact) {
      bool phoneFound = false;
      contact.phones.forEach((phone) {
        if (phone.value == event.searchTerm.toString()) {
          phoneFound = true;
          return;
        }
      });
      return phoneFound;
    }).toList();

    contactSearchResultList = [contactSearchResultList, searchResultBasedOnName, searchResultBasedOnPhoneNumber].expand((x) => x).toList();

    yield PhoneStorageContactsLoaded(phoneStorageContactList, contactSearchResultList); // again
  }

  // To send response to those dispatched Actions
  void functionCallback(event, value) {
    if (!isObjectEmpty(event)) {
      event.callback(value);
    }
  }
}
