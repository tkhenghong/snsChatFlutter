import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:get/get.dart';
import 'package:snschat_flutter/database/sembast/index.dart';
import 'package:snschat_flutter/general/index.dart';
import 'package:snschat_flutter/objects/models/index.dart';
import 'package:snschat_flutter/rest/index.dart';
import 'package:snschat_flutter/state/bloc/bloc.dart';
import 'package:snschat_flutter/state/bloc/settings/bloc.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(SettingsLoading());

  SettingsAPIService settingsAPIService = Get.find();
  SettingsDBService settingsDBService = Get.find();

  @override
  Stream<SettingsState> mapEventToState(SettingsEvent event) async* {
    if (event is InitializeSettingsEvent) {
      yield* _initializeSettingsToState(event);
    } else if (event is EditSettingsEvent) {
      yield* _editSettings(event);
    } else if (event is DeleteSettingsEvent) {
      yield* _deleteSettings(event);
    } else if (event is GetUserOwnSettingsEvent) {
      yield* _getSettingsOfTheUserEvent(event);
    } else if (event is RemoveAllSettingsEvent) {
      yield* _removeAllSettingsEvent(event);
    }
  }

  Stream<SettingsState> _initializeSettingsToState(InitializeSettingsEvent event) async* {
    if (state is SettingsLoading || state is SettingsNotLoaded) {
      Settings settingsFromDB;
      try {
        if (!event.user.isNull) {
          // TODO: get user from state using better way
          settingsFromDB = await settingsDBService.getSettingsOfAUser(event.user.id);

          if (!settingsFromDB.isNull) {
            yield SettingsLoaded(settingsFromDB);
            functionCallback(event, true);
          } else {
            yield SettingsNotLoaded();
            functionCallback(event, false);
          }
        } else {
          yield SettingsNotLoaded();
          functionCallback(event, false);
        }
      } catch (e) {
        yield SettingsNotLoaded();
        functionCallback(event, false);
      }
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
          yield SettingsLoaded(event.settings);
          functionCallback(event, event.settings);
        }

        functionCallback(event, false);
      }
    }

    if (!updatedInREST || !updated) {
      functionCallback(event, false);
    }
  }

  // Only deletes Local DB's Settings**
  Stream<SettingsState> _deleteSettings(DeleteSettingsEvent event) async* {
    if (state is SettingsLoaded) {
      bool settingsDeleted = await settingsDBService.deleteSettings(event.settings.id);

      if (!settingsDeleted) {
        functionCallback(event, false);
      } else {
        yield SettingsNotLoaded();
        functionCallback(event, true);
      }
    }
  }

  // Used during login to initialize Settings after having the User Initialized
  Stream<SettingsState> _getSettingsOfTheUserEvent(GetUserOwnSettingsEvent event) async* {
    Settings settingsFromREST;
    bool savedIntoDB;

    settingsFromREST = await settingsAPIService.getUserOwnSettings();

    await settingsDBService.deleteSettings(settingsFromREST.id);

    savedIntoDB = await settingsDBService.addSettings(settingsFromREST);

    if (!settingsFromREST.isNull && savedIntoDB) {
      yield SettingsLoaded(settingsFromREST);
      functionCallback(event, settingsFromREST);
    }

    if (settingsFromREST.isNull || !savedIntoDB) {
      yield SettingsNotLoaded();
      functionCallback(event, null);
    }
  }

  Stream<SettingsState> _removeAllSettingsEvent(RemoveAllSettingsEvent event) async* {
    settingsDBService.deleteAllSettings();
    yield SettingsNotLoaded();
    functionCallback(event, true);
  }

  // To send response to those dispatched Actions
  void functionCallback(event, value) {
    if (!isObjectEmpty(event)) {
      event?.callback(value);
    }
  }
}
