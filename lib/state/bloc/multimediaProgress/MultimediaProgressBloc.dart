import 'package:bloc/bloc.dart';

import 'package:snschat_flutter/database/sembast/index.dart';
import 'package:snschat_flutter/general/index.dart';
import 'package:snschat_flutter/objects/index.dart';
import 'package:snschat_flutter/service/index.dart';
import 'bloc.dart';

class MultimediaProgressBloc extends Bloc<MultimediaProgressEvent, MultimediaProgressState> {
  PermissionService permissionService = PermissionService();
  MultimediaProgressDBService multimediaProgressDBService = MultimediaProgressDBService();

  @override
  MultimediaProgressState get initialState => MultimediaProgressLoading();

  @override
  Stream<MultimediaProgressState> mapEventToState(MultimediaProgressEvent event) async* {
    if (event is InitializeMultimediaProgressEvent) {
      yield* _initializeMultimediaProgressToState(event);
    } else if (event is CreateMultimediaProgressEvent) {
      yield* _createMultimediaProgressToState(event);
    } else if (event is UpdateMultimediaProgressEvent) {
      yield* _updateMultimediaProgressToState(event);
    } else if (event is SearchMultimediaProgressEvent) {
      yield* _searchMultimediaProgressEvent(event);
    }
  }

  Stream<MultimediaProgressState> _initializeMultimediaProgressToState(InitializeMultimediaProgressEvent event) async* {
    if (state is MultimediaProgressLoading || state is MultimediaProgressNotLoaded) {
      try {
        List<MultimediaProgress> multimediaProgressListFromDB = await multimediaProgressDBService.getAllMultimediaProgress();

        if (isObjectEmpty(multimediaProgressListFromDB)) {
          yield MultimediaProgressNotLoaded();
          functionCallback(event, false);
        } else {
          yield MultimediaProgressLoaded(multimediaProgressListFromDB);
          functionCallback(event, true);
        }
      } catch (e) {
        yield MultimediaProgressNotLoaded();
        functionCallback(event, false);
      }
    }
  }

  Stream<MultimediaProgressState> _createMultimediaProgressToState(CreateMultimediaProgressEvent event) async* {
    MultimediaProgress newMultimediaProgress = event.multimediaProgress;
    List<MultimediaProgress> multimediaProgressList = [];
    bool multimediaProgressSaved = false;

    if (state is MultimediaProgressLoaded) {
      multimediaProgressList = (state as MultimediaProgressLoaded).multimediaProgressList;
      if (!isObjectEmpty(newMultimediaProgress)) {
        multimediaProgressSaved = await multimediaProgressDBService.addMultimediaProgress(newMultimediaProgress);

        if (multimediaProgressSaved) {
          multimediaProgressList.removeWhere(
              (MultimediaProgress existingMultimediaProgress) => existingMultimediaProgress.multimediaId == event.multimediaProgress.multimediaId);

          multimediaProgressList.add(event.multimediaProgress);

          yield MultimediaProgressLoaded(multimediaProgressList);
          functionCallback(event, newMultimediaProgress);
        }
      }
    }

    if (isObjectEmpty(newMultimediaProgress) || !multimediaProgressSaved) {
      yield MultimediaProgressNotLoaded();
      functionCallback(event, null);
    }
  }

  Stream<MultimediaProgressState> _updateMultimediaProgressToState(UpdateMultimediaProgressEvent event) async* {
    MultimediaProgress newMultimediaProgress = event.multimediaProgress;
    List<MultimediaProgress> multimediaProgressList = [];
    bool multimediaProgressSaved = false;

    if (state is MultimediaProgressLoaded) {
      multimediaProgressList = (state as MultimediaProgressLoaded).multimediaProgressList;
      if (!isObjectEmpty(newMultimediaProgress)) {
        multimediaProgressSaved = await multimediaProgressDBService.addMultimediaProgress(newMultimediaProgress);

        if (multimediaProgressSaved) {
          multimediaProgressList.removeWhere(
                  (MultimediaProgress existingMultimediaProgress) => existingMultimediaProgress.multimediaId == event.multimediaProgress.multimediaId);

          multimediaProgressList.add(event.multimediaProgress);

          yield MultimediaProgressLoading();
          yield MultimediaProgressLoaded(multimediaProgressList);
          functionCallback(event, newMultimediaProgress);
        }
      }
    }

    if (isObjectEmpty(newMultimediaProgress) || !multimediaProgressSaved) {
      yield MultimediaProgressNotLoaded();
      functionCallback(event, null);
    }
  }

  Stream<MultimediaProgressState> _searchMultimediaProgressEvent(SearchMultimediaProgressEvent event) async* {
  }

  // To send response to those dispatched Actions
  void functionCallback(event, value) {
    if (!isObjectEmpty(event)) {
      event.callback(value);
    }
  }
}
