//Jaguar ORM
import 'package:jaguar_query/jaguar_query.dart';
import 'package:jaguar_orm/jaguar_orm.dart';

part 'package:snschat_flutter/database/sqflite/repositories/settings/settings.jorm.dart';

class Settings {

  Settings({this.id, this.notification});

  Settings.make(this.id, this.notification);

  String id;
  bool notification;

  @override
  String toString() {
    return 'Settings{id: $id, notification: $notification}';
  }
}

@GenBean()
class SettingsBean extends Bean<Settings> with _SettingsBean {
  SettingsBean(Adapter adapter) : super(adapter);

  final String tableName = 'settings';

  @override
  // TODO: implement fields
  Map<String, Field> get fields => null;

  @override
  Settings fromMap(Map map) {
    // TODO: implement fromMap
    return null;
  }

  @override
  List<SetColumn> toSetColumns(Settings model, {bool update = false, Set<String> only}) {
    // TODO: implement toSetColumns
    return null;
  }



}