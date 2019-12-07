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
      yield* _initializeMultimediasToState(event);
    } else if (event is AddMultimediaEvent) {
      yield* _addMultimediaToState(event);
    } else if (event is EditMultimediaEvent) {
      yield* _editMultimediaToState(event);
    } else if (event is DeleteMultimediaEvent) {
      yield* _deleteMultimediaToState(event);
    } else if (event is SendMultimediaEvent) {
      yield* _uploadMultimedia(event);
    }
  }

  Stream<MultimediaState> _initializeMultimediasToState(InitializeMultimediaEvent event) async* {
    try {
      List<Multimedia> multimediaListFromDB = await multimediaDBService.getAllMultimedia();

      print("multimediaListFromDB.length: " + multimediaListFromDB.length.toString());

      yield MultimediaLoaded(multimediaListFromDB);

      functionCallback(event, true);
    } catch (e) {
      functionCallback(event, false);
    }
  }

  Stream<MultimediaState> _addMultimediaToState(AddMultimediaEvent event) async* {
    if (state is MultimediaLoaded) {
      Multimedia multimediaFromServer;
      bool saved = false;

      multimediaFromServer = await multimediaAPIService.addMultimedia(event.multimedia);

      if (!isObjectEmpty(multimediaFromServer)) {
        saved = await multimediaDBService.addMultimedia(multimediaFromServer);
        if (saved) {
          List<Multimedia> existingMultimediaList = (state as MultimediaLoaded).multimediaList;
          existingMultimediaList.add(event.multimedia);

          yield MultimediaLoaded(existingMultimediaList);
          functionCallback(event, multimediaFromServer);
        }
      }

      if (isObjectEmpty(multimediaFromServer) || !saved) {
        functionCallback(event, null);
      }
    }
  }

  Stream<MultimediaState> _editMultimediaToState(EditMultimediaEvent event) async* {
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

          functionCallback(event, event.multimedia);
          yield MultimediaLoaded(existingMultimediaList);
        }
      }
    }

    if (!updatedInREST || !updated) {
      functionCallback(event, null);
    }
  }

  Stream<MultimediaState> _deleteMultimediaToState(DeleteMultimediaEvent event) async* {
    bool deletedInREST = false;
    bool deleted = false;

    if (state is MultimediaLoaded) {
      deletedInREST = await multimediaAPIService.deleteMultimedia(event.multimedia.id);

      if (deletedInREST) {
        deleted = await multimediaDBService.deleteMultimedia(event.multimedia.id);
        if (deleted) {
          List<Multimedia> existingMultimediaList = (state as MultimediaLoaded).multimediaList;

          existingMultimediaList.removeWhere((Multimedia existingMultimedia) => existingMultimedia.id == event.multimedia.id);

          functionCallback(event, true);
          yield MultimediaLoaded(existingMultimediaList);
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

  // To send response to those dispatched Actions
  void functionCallback(event, value) {
    if (!isObjectEmpty(event)) {
      event.callback(value);
    }
  }
}
