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
    } else if (event is GetConversationGroupsMultimediaEvent) {
      yield* _getConversationGroupsMultimediaEvent(event);
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
        List<Multimedia> multimediaListFromDB = await multimediaDBService.getAllMultimedia();

        if (multimediaListFromDB.isEmpty) {
          yield MultimediaNotLoaded();
          functionCallback(event, false);
        } else {
          yield MultimediaLoaded(multimediaListFromDB);
          functionCallback(event, true);
        }
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
        List<Multimedia> multimediaList = (state as MultimediaLoaded).multimediaList;

        await multimediaDBService.addMultimediaList(event.multimediaList);

        for (int i = 0; i < event.multimediaList.length; i++) {
          multimediaList.removeWhere((Multimedia existingMultimedia) => existingMultimedia.id == event.multimediaList[i].id);
        }

        multimediaList.addAll(event.multimediaList);

        yield MultimediaLoaded(multimediaList);
        functionCallback(event, true);
      }
    } catch (e) {
      functionCallback(event, false);
    }
  }

  Stream<MultimediaState> _getUserOwnProfilePictureMultimediaEvent(GetUserOwnProfilePictureMultimediaEvent event) async* {
    try {
      if (state is MultimediaLoaded) {
        List<Multimedia> multimediaList = (state as MultimediaLoaded).multimediaList;

        Multimedia multimediaFromServer = await multimediaAPIService.getSingleMultimedia(event.ownUserContactMultimediaId);

        // Auto loads the file into the local directory.
        customFileService.retrieveMultimediaFile(multimediaFromServer, '$REST_URL/userContact/profilePhoto');

        if (!multimediaFromServer.isNull) {
          // Update DB
          Multimedia userMultimedia = await multimediaDBService.getSingleMultimedia(multimediaFromServer.id);
          bool savedInDB = await multimediaDBService.addMultimedia(userMultimedia);

          if (!savedInDB) {
            throw Exception('Unable to get user own profile picture multimedia.');
          }

          // Update State
          multimediaList.removeWhere((Multimedia existingMultimedia) => existingMultimedia.id == multimediaFromServer.id);
          multimediaList.add(multimediaFromServer);
        }

        yield MultimediaLoaded(multimediaList);
        functionCallback(event, true);
      }
    } catch (e) {
      functionCallback(event, false);
    }
  }

  Stream<MultimediaState> _getConversationGroupsMultimediaEvent(GetConversationGroupsMultimediaEvent event) async* {
    try {
      if (state is MultimediaLoaded) {
        List<Multimedia> multimediaList = (state as MultimediaLoaded).multimediaList;

        if (!event.conversationGroupList.isNullOrBlank && event.conversationGroupList.isNotEmpty) {
          List<String> multimediaIDList = event.conversationGroupList.map((e) => e.groupPhoto).toList();
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

  Stream<MultimediaState> _getMessagesMultimediaEvent(GetMessagesMultimediaEvent event) async* {
    try {
      if (state is MultimediaLoaded) {
        List<Multimedia> multimediaList = (state as MultimediaLoaded).multimediaList;

        if (!event.chatMessageList.isNullOrBlank && event.chatMessageList.isNotEmpty) {
          List<String> multimediaIDList = event.chatMessageList.map((e) => e.multimediaId).toList();
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

  Stream<MultimediaState> _removeAllMultimediaEvent(RemoveAllMultimediaEvent event) async* {
    multimediaDBService.deleteAllMultimedia();
    yield MultimediaNotLoaded();
    functionCallback(event, true);
  }

  // To send response to those dispatched Actions
  void functionCallback(event, value) {
    if (!isObjectEmpty(event)) {
      event?.callback(value);
    }
  }
}
