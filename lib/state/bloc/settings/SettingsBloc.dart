import 'package:bloc/bloc.dart';
import 'package:snschat_flutter/backend/rest/index.dart';
import 'package:snschat_flutter/database/sembast/index.dart';
import 'package:snschat_flutter/general/functions/validation_functions.dart';
import 'package:snschat_flutter/objects/index.dart';
import 'package:snschat_flutter/state/bloc/settings/bloc.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsAPIService settingsAPIService = SettingsAPIService();
  SettingsDBService settingsDBService = SettingsDBService();

  @override
  SettingsState get initialState => SettingsLoading();

  @override
  Stream<SettingsState> mapEventToState(SettingsEvent event) async* {
    if (event is InitializeSettingssEvent) {
      yield* _initializeSettingssToState(event);
    } else if (event is AddSettingsToStateEvent) {
      yield* _addSettingsToState(event);
    } else if (event is EditSettingsToStateEvent) {
      yield* _editSettingsToState(event);
    } else if (event is DeleteSettingsToStateEvent) {
      yield* _deleteSettingsToState(event);
    } else if (event is ChangeSettingsEvent) {
      yield* _changeSettings(event);
    }
  }

  Stream<SettingsState> _initializeSettingssToState(InitializeSettingssEvent event) async* {
    try {
      List<Settings> settingsListFromDB = await settingsDBService.getAllSettings();

      print("settingsListFromDB.length: " + settingsListFromDB.length.toString());

      yield SettingssLoaded(settingsListFromDB);

      functionCallback(event, true);
    } catch (e) {
      functionCallback(event, false);
    }
  }

  Stream<SettingsState> _addSettingsToState(AddSettingsToStateEvent event) async* {
    if (state is SettingssLoaded) {
      List<Settings> existingSettingsList = (state as SettingssLoaded).settingsList;

      existingSettingsList.removeWhere((Settings existingSettings) => existingSettings.id == event.settings.id);

      existingSettingsList.add(event.settings);

      functionCallback(event, event.settings);
      yield SettingssLoaded(existingSettingsList);
    }
  }

  Stream<SettingsState> _editSettingsToState(EditSettingsToStateEvent event) async* {
    if (state is SettingssLoaded) {
      List<Settings> existingSettingsList = (state as SettingssLoaded).settingsList;

      existingSettingsList.removeWhere((Settings existingSettings) => existingSettings.id == event.settings.id);

      existingSettingsList.add(event.settings);

      functionCallback(event, event.settings);
      yield SettingssLoaded(existingSettingsList);
    }
  }

  Stream<SettingsState> _deleteSettingsToState(DeleteSettingsToStateEvent event) async* {
    if (state is SettingssLoaded) {
      List<Settings> existingSettingsList = (state as SettingssLoaded).settingsList;

      existingSettingsList.removeWhere((Settings existingSettings) => existingSettings.id == event.settings.id);

      functionCallback(event, true);
      yield SettingssLoaded(existingSettingsList);
    }
  }

  Stream<SettingsState> _changeSettings(ChangeSettingsEvent event) async* {

    Settings newSettings = await settingsAPIService.addSettings(event.settings);

    if (isObjectEmpty(newSettings)) {
      functionCallback(event, false);
    }

    bool settingsSaved = await settingsDBService.addSettings(newSettings);

    if (!settingsSaved) {
      functionCallback(event, false);
    }

    add(AddSettingsToStateEvent(settings: newSettings, callback: (Settings settings) {}));
  }

  // To send response to those dispatched Actions
  void functionCallback(event, value) {
    if (!isObjectEmpty(event)) {
      event.callback(value);
    }
  }
}
