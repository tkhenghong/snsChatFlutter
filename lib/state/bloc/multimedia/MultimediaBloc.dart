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
    if (event is InitializeMultimediasEvent) {
      yield* _initializeMultimediasToState(event);
    } else if (event is AddMultimediaToStateEvent) {
      yield* _addMultimediaToState(event);
    } else if (event is EditMultimediaToStateEvent) {
      yield* _editMultimediaToState(event);
    } else if (event is DeleteMultimediaToStateEvent) {
      yield* _deleteMultimediaToState(event);
    } else if (event is SendMultimediaEvent) {
      yield* _uploadMultimedia(event);
    }
  }

  Stream<MultimediaState> _initializeMultimediasToState(InitializeMultimediasEvent event) async* {
    try {
      List<Multimedia> multimediaListFromDB = await multimediaDBService.getAllMultimedia();

      print("multimediaListFromDB.length: " + multimediaListFromDB.length.toString());

      yield MultimediasLoaded(multimediaListFromDB);

      functionCallback(event, true);
    } catch (e) {
      functionCallback(event, false);
    }
  }

  Stream<MultimediaState> _addMultimediaToState(AddMultimediaToStateEvent event) async* {
    if (state is MultimediasLoaded) {
      List<Multimedia> existingMultimediaList = (state as MultimediasLoaded).multimediaList;

      existingMultimediaList.removeWhere((Multimedia existingMultimedia) => existingMultimedia.id == event.multimedia.id);

      existingMultimediaList.add(event.multimedia);

      functionCallback(event, event.multimedia);
      yield MultimediasLoaded(existingMultimediaList);
    }
  }

  Stream<MultimediaState> _editMultimediaToState(EditMultimediaToStateEvent event) async* {
    if (state is MultimediasLoaded) {
      List<Multimedia> existingMultimediaList = (state as MultimediasLoaded).multimediaList;

      existingMultimediaList.removeWhere((Multimedia existingMultimedia) => existingMultimedia.id == event.multimedia.id);

      existingMultimediaList.add(event.multimedia);

      functionCallback(event, event.multimedia);
      yield MultimediasLoaded(existingMultimediaList);
    }
  }

  Stream<MultimediaState> _deleteMultimediaToState(DeleteMultimediaToStateEvent event) async* {
    if (state is MultimediasLoaded) {
      List<Multimedia> existingMultimediaList = (state as MultimediasLoaded).multimediaList;

      existingMultimediaList.removeWhere((Multimedia existingMultimedia) => existingMultimedia.id == event.multimedia.id);

      functionCallback(event, true);
      yield MultimediasLoaded(existingMultimediaList);
    }
  }

  Stream<MultimediaState> _uploadMultimedia(SendMultimediaEvent event) async* {

    Multimedia newMultimedia = await multimediaAPIService.addMultimedia(event.multimedia);

    if (isObjectEmpty(newMultimedia)) {
      functionCallback(event, false);
    }

    bool multimediaSaved = await multimediaDBService.addMultimedia(newMultimedia);

    if (!multimediaSaved) {
      functionCallback(event, false);
    }

    add(AddMultimediaToStateEvent(multimedia: newMultimedia, callback: (Multimedia multimedia) {}));
  }

  // To send response to those dispatched Actions
  void functionCallback(event, value) {
    if (!isObjectEmpty(event)) {
      event.callback(value);
    }
  }
}
