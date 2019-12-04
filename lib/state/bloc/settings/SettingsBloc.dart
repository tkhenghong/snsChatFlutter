import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:snschat_flutter/backend/rest/index.dart';
import 'package:snschat_flutter/database/sembast/index.dart';
import 'package:snschat_flutter/general/functions/validation_functions.dart';
import 'package:snschat_flutter/objects/index.dart';
import 'package:snschat_flutter/state/bloc/bloc.dart';
import 'package:snschat_flutter/state/bloc/settings/bloc.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {

  SettingsAPIService settingsAPIService = SettingsAPIService();
  SettingsDBService settingsDBService = SettingsDBService();

  @override
  SettingsState get initialState => SettingsLoading();

  @override
  Stream<SettingsState> mapEventToState(SettingsEvent event) async* {
    if (event is InitializeSettingsEvent) {
      yield* _initializeSettingsToState(event);
    } else if (event is AddSettingsEvent) {
      yield* _addSettings(event);
    } else if (event is EditSettingsEvent) {
      yield* _editSettings(event);
    } else if (event is DeleteSettingsEvent) {
      yield* _deleteSettings(event);
    }
  }

  Stream<SettingsState> _initializeSettingsToState(InitializeSettingsEvent event) async* {
    try {
      if (!isObjectEmpty(event.user)) {
        // TODO: get user from state using better way
        Settings settingsFromDB = await settingsDBService.getSettingsOfAUser(event.user.id);
        print("settingsFromDB.userId: " + settingsFromDB.userId);
        functionCallback(event, true);
        yield SettingsLoaded(settingsFromDB);
      } else {
        functionCallback(event, false);
        yield SettingsNotLoaded();
      }
    } catch (e) {
      functionCallback(event, false);
      yield SettingsNotLoaded();
    }
  }

  // Add Settings into REST, DB, and BLOC
  Stream<SettingsState> _addSettings(AddSettingsEvent event) async* {
    Settings newSettings;
    bool settingsSaved = false;
    if (state is SettingsLoaded) {
      newSettings = await settingsAPIService.addSettings(event.settings);

      if (!isObjectEmpty(newSettings)) {
        settingsSaved = await settingsDBService.addSettings(newSettings);

        if (settingsSaved) {
          functionCallback(event, newSettings);
          yield SettingsLoaded(newSettings);
        }
      }
    }

    if (isObjectEmpty(newSettings) || !settingsSaved) {
      functionCallback(event, null);
    }
  }

  Stream<SettingsState> _editSettings(EditSettingsEvent event) async* {
    bool updatedInREST = false;
    bool updated = false;
    if (state is SettingsLoaded) {
      updatedInREST = await settingsAPIService.editSettings(event.settings);

      if (updatedInREST) {
        updated = await settingsDBService.editSettings(event.settings);

        if (updated) {
          functionCallback(event, event.settings);
          yield SettingsLoaded(event.settings);
        }

        functionCallback(event, false);
      }
    }

    if (!updatedInREST || !updated) {
      functionCallback(event, false);
    }
  }

  Stream<SettingsState> _deleteSettings(DeleteSettingsEvent event) async* {
    if (state is SettingsLoaded) {
      bool settingsDeleted = await settingsDBService.deleteSettings(event.settings.id);

      if (!settingsDeleted) {
        functionCallback(event, false);
      } else {
        functionCallback(event, true);
        yield SettingsNotLoaded();
      }
    }
  }

  // To send response to those dispatched Actions
  void functionCallback(event, value) {
    if (!isObjectEmpty(event)) {
      event.callback(value);
    }
  }
}
