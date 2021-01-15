import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:snschat_flutter/database/sembast/index.dart';
import 'package:snschat_flutter/general/index.dart';
import 'package:snschat_flutter/objects/models/index.dart';
import 'package:snschat_flutter/rest/index.dart';
import 'package:snschat_flutter/state/bloc/index.dart';
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
    } else if (event is UpdateSettingsEvent) {
      yield* _updateSettings(event);
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
      Settings settings;
      try {
        try {
          settings = await settingsAPIService.getUserOwnSettings();
        } catch (e) {
          // Failed to find user Settings from backend.
          settings = await settingsDBService.getSettingsOfAUser(event.user.id);

          if (!isObjectEmpty(settings)) {
            yield SettingsLoaded(settings);
            functionCallback(event, true);
          } else {
            throw Exception('Unable to load user settings.');
          }
        }
      } catch (e) {
        yield SettingsNotLoaded();
        functionCallback(event, false);
      }
    }
  }

  Stream<SettingsState> _editSettings(EditSettingsEvent event) async* {
    try {
      bool updated = await settingsAPIService.editSettings(event.updateSettingsRequest);

      if (!updated) {
        showToast('Error in updating settings. Please try again later,', Toast.LENGTH_LONG);
        throw Exception('Error in updating settings.');
      }

      Settings settings = await settingsAPIService.getUserOwnSettings();
      settingsDBService.editSettings(settings);

      if (state is SettingsLoaded) {
        yield SettingsLoaded(settings);
        functionCallback(event, true);
      }
    } catch (e) {
      functionCallback(event, false);
    }
  }

  Stream<SettingsState> _updateSettings(UpdateSettingsEvent event) async* {
    try {
      await settingsDBService.editSettings(event.settings);

      yield SettingsLoaded(event.settings);
      functionCallback(event, true);
    } catch (e) {
      functionCallback(event, false);
    }
  }

  // Only deletes Local DB's Settings**
  Stream<SettingsState> _deleteSettings(DeleteSettingsEvent event) async* {
    try {
      if (state is SettingsLoaded) {
        await settingsDBService.deleteSettings(event.settings.id);

        yield SettingsNotLoaded();
        functionCallback(event, true);
      }
    } catch (e) {
      functionCallback(event, false);
    }
  }

  Stream<SettingsState> _getSettingsOfTheUserEvent(GetUserOwnSettingsEvent event) async* {
    try {
      Settings settingsFromREST = await settingsAPIService.getUserOwnSettings();

      settingsDBService.addSettings(settingsFromREST);

      yield SettingsLoaded(settingsFromREST);
      functionCallback(event, settingsFromREST);
    } catch (e) {
      yield SettingsNotLoaded();
      functionCallback(event, null);
    }
  }

  Stream<SettingsState> _removeAllSettingsEvent(RemoveAllSettingsEvent event) async* {
    settingsDBService.deleteAllSettings();
    yield SettingsNotLoaded();
    functionCallback(event, true);
  }

  void functionCallback(event, value) {
    if (!isObjectEmpty(event) && !isObjectEmpty(event.callback)) {
      event.callback(value);
    }
  }
}
