import 'package:bloc/bloc.dart';
import 'package:get/get.dart';
import 'package:snschat_flutter/database/sembast/index.dart';
import 'package:snschat_flutter/environments/development/variables.dart' as globals;
import 'package:snschat_flutter/general/index.dart';
import 'package:snschat_flutter/objects/models/index.dart';
import 'package:snschat_flutter/objects/rest/index.dart';
import 'package:snschat_flutter/rest/index.dart';
import 'package:snschat_flutter/service/file/CustomFileService.dart';

import 'bloc.dart';

class MultimediaBloc extends Bloc<MultimediaEvent, MultimediaState> {
  MultimediaBloc() : super(MultimediaLoading());

  String REST_URL = globals.REST_URL;

  MultimediaAPIService multimediaAPIService = Get.find();
  UserContactAPIService userContactAPIService = Get.find();
  MultimediaDBService multimediaDBService = Get.find();
  CustomFileService customFileService = Get.find();

  @override
  Stream<MultimediaState> mapEventToState(MultimediaEvent event) async* {
    if (event is InitializeMultimediaEvent) {
      yield* _initializeMultimediaToState(event);
    } else if (event is UpdateMultimediaEvent) {
      yield* _updateMultimedia(event);
    } else if (event is GetUserOwnProfilePictureMultimediaEvent) {
      yield* _getUserOwnProfilePictureMultimediaEvent(event);
    } else if (event is GetUserContactsMultimediaEvent) {
      yield* _getUserContactsMultimediaEvent(event);
    } else if (event is GetMessagesMultimediaEvent) {
      yield* _getMessagesMultimediaEvent(event);
    } else if (event is RemoveAllMultimediaEvent) {
      yield* _removeAllMultimediaEvent(event);
    }
  }

  Stream<MultimediaState> _initializeMultimediaToState(InitializeMultimediaEvent event) async* {
    if (state is MultimediaLoading || state is MultimediaNotLoaded) {
      try {
        List<Multimedia> multimediaListFromDB = [];

        yield MultimediaLoaded(multimediaListFromDB);
        functionCallback(event, true);
      } catch (e) {
        yield MultimediaNotLoaded();
        functionCallback(event, false);
      }
    }
  }

  /// Add multimedia list into multimedia state and local DB.
  Stream<MultimediaState> _updateMultimedia(UpdateMultimediaEvent event) async* {
    try {
      if (state is MultimediaLoaded) {
        multimediaDBService.addMultimediaList(event.multimediaList);

        yield* updateMultimediaLoadedState(updatedMultimediaList: event.multimediaList);
        functionCallback(event, true);
      }
    } catch (e) {
      functionCallback(event, false);
    }
  }

  Stream<MultimediaState> _getUserOwnProfilePictureMultimediaEvent(GetUserOwnProfilePictureMultimediaEvent event) async* {
    try {
      if (state is MultimediaLoaded) {
        Multimedia multimediaFromServer = await multimediaAPIService.getSingleMultimedia(event.ownUserContactMultimediaId);

        // Loads the file into the local directory.
        customFileService.retrieveMultimediaFile(multimediaFromServer, '$REST_URL/userContact/profilePhoto');

        if (!multimediaFromServer.isNull) {
          multimediaDBService.addMultimedia(multimediaFromServer);

          yield* updateMultimediaLoadedState(multimedia: multimediaFromServer);
          functionCallback(event, true);
        }
      }
    } catch (e) {
      functionCallback(event, false);
    }
  }

  Stream<MultimediaState> _getUserContactsMultimediaEvent(GetUserContactsMultimediaEvent event) async* {
    try {
      if (state is MultimediaLoaded) {
        List<Multimedia> multimediaList = (state as MultimediaLoaded).multimediaList;

        if (!event.userContactList.isNullOrBlank && event.userContactList.isNotEmpty) {
          List<String> multimediaIDList = event.userContactList.map((e) => e.profilePicture).toList();
          List<Multimedia> multimediaListFromServer = await multimediaAPIService.getMultimediaList(GetMultimediaListRequest(multimediaList: multimediaIDList));

          await multimediaDBService.addMultimediaList(multimediaListFromServer);
          if (!multimediaListFromServer.isNullOrBlank && multimediaListFromServer.isNotEmpty) {
            for (int i = 0; i < multimediaListFromServer.length; i++) {
              multimediaList.removeWhere((Multimedia existingMultimedia) => existingMultimedia.id == multimediaListFromServer[i].id);
            }
            multimediaList.addAll(multimediaListFromServer);
          }
        }

        yield MultimediaLoaded(multimediaList);
        functionCallback(event, true);
      }
    } catch (e) {
      functionCallback(event, false);
    }
  }

  /// Get multimedia list of the Multimedia.
  /// Note: Multimedia normally doesn't update it's content.
  Stream<MultimediaState> _getMessagesMultimediaEvent(GetMessagesMultimediaEvent event) async* {
    try {
      if (state is MultimediaLoaded) {
        List<String> wantedMultimediaIds = event.chatMessageList.map((chatMessage) => chatMessage.multimediaId).toList();

        // Trim empty Strings.
        wantedMultimediaIds.removeWhere((multimediaId) => isObjectEmpty(multimediaId) || multimediaId.isNullOrBlank);

        if (!event.chatMessageList.isNullOrBlank && event.chatMessageList.isNotEmpty) {
          List<Multimedia> existingMultimediaList = await multimediaDBService.getMultimediaList(wantedMultimediaIds);

          // Find any leftover multimedia list that does not exist in local DB yet.
          wantedMultimediaIds.removeWhere((multimediaId) => existingMultimediaList.any((existingMultimedia) => existingMultimedia.id == multimediaId));

          if(wantedMultimediaIds.length > 0) {
            List<Multimedia> multimediaListFromServer = await multimediaAPIService.getMultimediaList(GetMultimediaListRequest(multimediaList: wantedMultimediaIds));

            // Combine both local and backend list together.
            multimediaListFromServer.addAll(existingMultimediaList);

            yield* updateMultimediaLoadedState(updatedMultimediaList: multimediaListFromServer);
            functionCallback(event, true);
          }
        }
      }
    } catch (e) {
      functionCallback(event, false);
    }
  }

  Stream<MultimediaState> _removeAllMultimediaEvent(RemoveAllMultimediaEvent event) async* {
    multimediaDBService.deleteAllMultimedia();
    yield MultimediaNotLoaded();
    functionCallback(event, true);
  }

  Stream<MultimediaState> updateMultimediaLoadedState({List<Multimedia> updatedMultimediaList, Multimedia multimedia}) async* {
    if (state is MultimediaLoaded) {
      List<Multimedia> existingMultimedia = (state as MultimediaLoaded).multimediaList;

      if (!isObjectEmpty(updatedMultimediaList)) {
        updatedMultimediaList.forEach((updatedMultimedia) {
          existingMultimedia.removeWhere((existingMultimedia) => updatedMultimedia.id == existingMultimedia.id);
        });

        existingMultimedia.addAll(updatedMultimediaList);
      }

      if (!isObjectEmpty(multimedia)) {
        existingMultimedia.removeWhere((existingMultimedia) => multimedia.id == existingMultimedia.id);

        existingMultimedia.add(multimedia);
      }

      yield MultimediaLoading();
      yield MultimediaLoaded(existingMultimedia);
    } else {
      yield MultimediaLoaded(updatedMultimediaList);
    }
  }

  // To send response to those dispatched Actions
  void functionCallback(event, value) {
    if (!isObjectEmpty(event)) {
      event?.callback(value);
    }
  }
}
