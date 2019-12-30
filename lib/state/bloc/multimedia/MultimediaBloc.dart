import 'package:bloc/bloc.dart';
import 'package:snschat_flutter/backend/rest/index.dart';
import 'package:snschat_flutter/database/sembast/index.dart';
import 'package:snschat_flutter/general/functions/validation_functions.dart';
import 'package:snschat_flutter/objects/index.dart';
import 'package:snschat_flutter/state/bloc/multimedia/bloc.dart';

class MultimediaBloc extends Bloc<MultimediaEvent, MultimediaState> {
  MultimediaAPIService multimediaAPIService = MultimediaAPIService();
  MultimediaDBService multimediaDBService = MultimediaDBService();

  @override
  MultimediaState get initialState => MultimediaLoading();

  @override
  Stream<MultimediaState> mapEventToState(MultimediaEvent event) async* {
    if (event is InitializeMultimediaEvent) {
      yield* _initializeMultimediaToState(event);
    } else if (event is AddMultimediaEvent) {
      yield* _addMultimedia(event);
    } else if (event is EditMultimediaEvent) {
      yield* _editMultimedia(event);
    } else if (event is DeleteMultimediaEvent) {
      yield* _deleteMultimedia(event);
    } else if (event is SendMultimediaEvent) {
      yield* _uploadMultimedia(event);
    } else if (event is GetUserProfilePictureMultimediaEvent) {
      yield* _getUserProfilePictureMultimediaEvent(event);
    } else if (event is GetConversationGroupsMultimediaEvent) {
      yield* _getConversationGroupsMultimediaEvent(event);
    } else if (event is GetUserContactsMultimediaEvent) {
      yield* _getUserContactsMultimediaEvent(event);
    }
  }

  Stream<MultimediaState> _initializeMultimediaToState(InitializeMultimediaEvent event) async* {
    if (state is MultimediaLoading || state is MultimediaNotLoaded) {
      try {
        List<Multimedia> multimediaListFromDB = await multimediaDBService.getAllMultimedia();

        if (isObjectEmpty(multimediaListFromDB)) {
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

  Stream<MultimediaState> _addMultimedia(AddMultimediaEvent event) async* {
    Multimedia multimediaFromServer;
    bool saved = false;

    // Avoid readding existing multimedia
    if (isStringEmpty(event.multimedia.id)) {
      multimediaFromServer = await multimediaAPIService.addMultimedia(event.multimedia);
    } else {
      multimediaFromServer = event.multimedia;
    }

    if (!isObjectEmpty(multimediaFromServer)) {
      saved = await multimediaDBService.addMultimedia(multimediaFromServer);
      if (saved) {
        List<Multimedia> existingMultimediaList = [];
        if (state is MultimediaLoaded) {
          existingMultimediaList = (state as MultimediaLoaded).multimediaList;
        }

        existingMultimediaList.removeWhere((Multimedia existingMultimedia) => existingMultimedia.id == event.multimedia.id);

        existingMultimediaList.add(event.multimedia);

        yield MultimediaLoaded(existingMultimediaList);
        functionCallback(event, multimediaFromServer);
      }
    }

    if (isObjectEmpty(multimediaFromServer) || !saved) {
      functionCallback(event, null);
    }
  }

  Stream<MultimediaState> _editMultimedia(EditMultimediaEvent event) async* {
    bool updatedInREST = false;
    bool updated = false;

    if (state is MultimediaLoaded) {
      updatedInREST = await multimediaAPIService.editMultimedia(event.multimedia);

      if (updatedInREST) {
        updated = await multimediaDBService.editMultimedia(event.multimedia);
        if (updated) {
          List<Multimedia> existingMultimediaList = (state as MultimediaLoaded).multimediaList;

          existingMultimediaList.removeWhere((Multimedia existingMultimedia) => existingMultimedia.id == event.multimedia.id);

          existingMultimediaList.add(event.multimedia);

          yield MultimediaLoaded(existingMultimediaList);
          functionCallback(event, event.multimedia);
        }
      }
    }

    if (!updatedInREST || !updated) {
      functionCallback(event, null);
    }
  }

  Stream<MultimediaState> _deleteMultimedia(DeleteMultimediaEvent event) async* {
    bool deletedInREST = false;
    bool deleted = false;

    if (state is MultimediaLoaded) {
      deletedInREST = await multimediaAPIService.deleteMultimedia(event.multimedia.id);

      if (deletedInREST) {
        deleted = await multimediaDBService.deleteMultimedia(event.multimedia.id);
        if (deleted) {
          List<Multimedia> existingMultimediaList = (state as MultimediaLoaded).multimediaList;

          existingMultimediaList.removeWhere((Multimedia existingMultimedia) => existingMultimedia.id == event.multimedia.id);

          yield MultimediaLoaded(existingMultimediaList);
          functionCallback(event, true);
        }
      }
    }

    if (!deletedInREST || !deleted) {
      functionCallback(event, false);
    }
  }

  // No need
  Stream<MultimediaState> _uploadMultimedia(SendMultimediaEvent event) async* {
    Multimedia newMultimedia = await multimediaAPIService.addMultimedia(event.multimedia);

    if (isObjectEmpty(newMultimedia)) {
      functionCallback(event, false);
    }

    bool multimediaSaved = await multimediaDBService.addMultimedia(newMultimedia);

    if (!multimediaSaved) {
      functionCallback(event, false);
    }

    add(AddMultimediaEvent(multimedia: newMultimedia, callback: (Multimedia multimedia) {}));
  }

  Stream<MultimediaState> _getUserProfilePictureMultimediaEvent(GetUserProfilePictureMultimediaEvent event) async* {
    List<Multimedia> multimediaList = [];

    if (state is MultimediaLoaded) {
      multimediaList = (state as MultimediaLoaded).multimediaList;
    }

    // Get user profile picture
    Multimedia multimediaFromServer = await multimediaAPIService.getMultimediaOfAUser(event.user.id);

    if (!isObjectEmpty(multimediaFromServer)) {
      // Update DB
      Multimedia userMultimedia = await multimediaDBService.getSingleMultimedia(multimediaFromServer.id);
      if (!isObjectEmpty(userMultimedia)) {
        multimediaDBService.addMultimedia(multimediaFromServer);
      } else {
        multimediaDBService.editMultimedia(multimediaFromServer);
      }

      // Update State
      multimediaList.removeWhere((Multimedia existingMultimedia) => existingMultimedia.id == multimediaFromServer.id);
      multimediaList.add(multimediaFromServer);
    }

    yield MultimediaLoaded(multimediaList);
    functionCallback(event, true);
  }

  Stream<MultimediaState> _getConversationGroupsMultimediaEvent(GetConversationGroupsMultimediaEvent event) async* {
    List<Multimedia> multimediaList = [];

    if (state is MultimediaLoaded) {
      multimediaList = (state as MultimediaLoaded).multimediaList;
    }

    if (!isObjectEmpty(event.conversationGroupList) && event.conversationGroupList.length > 0) {
      for (ConversationGroup conversationGroup in event.conversationGroupList) {
        List<Multimedia> multimediaListFromServer = await multimediaAPIService.getAllMultimediaOfAConversationGroup(conversationGroup.id);

        if (!isObjectEmpty(multimediaListFromServer) && multimediaListFromServer.length > 0) {
          // Update DB
          for (Multimedia multimediaFromServer in multimediaListFromServer) {
            Multimedia existingConversationGroupMultimedia = await multimediaDBService.getSingleMultimedia(multimediaFromServer.id);
            if (!isObjectEmpty(existingConversationGroupMultimedia)) {
              multimediaDBService.editMultimedia(multimediaFromServer);
            } else {
              multimediaDBService.addMultimedia(multimediaFromServer);
            }

            // Update State
            multimediaList.removeWhere((Multimedia existingMultimedia) => existingMultimedia.id == multimediaFromServer.id);
          }

          // Update State
          multimediaList = [multimediaList, multimediaListFromServer].expand((x) => x).toList();
        }
      }
    }

    yield MultimediaLoaded(multimediaList);
    functionCallback(event, true);
  }

  Stream<MultimediaState> _getUserContactsMultimediaEvent(GetUserContactsMultimediaEvent event) async* {
    List<Multimedia> multimediaList = [];

    if (state is MultimediaLoaded) {
      multimediaList = (state as MultimediaLoaded).multimediaList;
    }

    if (!isObjectEmpty(event.userContactList) && event.userContactList.length > 0) {
      for (UserContact userContact in event.userContactList) {
        Multimedia userContactMultimedia = await multimediaAPIService.getMultimediaOfAUserContact(userContact.id);

        if (!isObjectEmpty(userContactMultimedia)) {
          // Update DB
          Multimedia existingUserContactMultimedia = await multimediaDBService.getSingleMultimedia(userContactMultimedia.id);
          if (!isObjectEmpty(existingUserContactMultimedia)) {
            multimediaDBService.editMultimedia(userContactMultimedia);
          } else {
            multimediaDBService.addMultimedia(userContactMultimedia);
          }

          // Update State
          multimediaList.removeWhere((Multimedia existingMultimedia) => existingMultimedia.id == userContactMultimedia.id);
          multimediaList.add(userContactMultimedia);
        }
      }
    }

    yield MultimediaLoaded(multimediaList);
    functionCallback(event, true);
  }

  // To send response to those dispatched Actions
  void functionCallback(event, value) {
    if (!isObjectEmpty(event)) {
      event.callback(value);
    }
  }
}
