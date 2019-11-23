//// GENERATED CODE - DO NOT MODIFY BY HAND
//
//part of 'settings.dart';
//
//// **************************************************************************
//// BeanGenerator
//// **************************************************************************
//
//abstract class _SettingsBean implements Bean<Settings> {
//  final id = StrField('id');
//  final userId = StrField('user_id');
//  final notification = BoolField('notification');
//  Map<String, Field> _fields;
//  Map<String, Field> get fields => _fields ??= {
//        id.name: id,
//        userId.name: userId,
//        notification.name: notification,
//      };
//  Settings fromMap(Map map) {
//    Settings model = Settings();
//    model.id = adapter.parseValue(map['id']);
//    model.userId = adapter.parseValue(map['user_id']);
//    model.notification = adapter.parseValue(map['notification']);
//
//    return model;
//  }
//
//  List<SetColumn> toSetColumns(Settings model,
//      {bool update = false, Set<String> only, bool onlyNonNull = false}) {
//    List<SetColumn> ret = [];
//
//    if (only == null && !onlyNonNull) {
//      ret.add(id.set(model.id));
//      ret.add(userId.set(model.userId));
//      ret.add(notification.set(model.notification));
//    } else if (only != null) {
//      if (only.contains(id.name)) ret.add(id.set(model.id));
//      if (only.contains(userId.name)) ret.add(userId.set(model.userId));
//      if (only.contains(notification.name))
//        ret.add(notification.set(model.notification));
//    } else /* if (onlyNonNull) */ {
//      if (model.id != null) {
//        ret.add(id.set(model.id));
//      }
//      if (model.userId != null) {
//        ret.add(userId.set(model.userId));
//      }
//      if (model.notification != null) {
//        ret.add(notification.set(model.notification));
//      }
//    }
//
//    return ret;
//  }
//
//  Future<void> createTable({bool ifNotExists = false}) async {
//    final st = Sql.create(tableName, ifNotExists: ifNotExists);
//    st.addStr(id.name, primary: true, isNullable: false);
//    st.addStr(userId.name, isNullable: true);
//    st.addBool(notification.name, isNullable: true);
//    return adapter.createTable(st);
//  }
//
//  Future<dynamic> insert(Settings model,
//      {bool cascade = false,
//      bool onlyNonNull = false,
//      Set<String> only}) async {
//    final Insert insert = inserter
//        .setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));
//    return adapter.insert(insert);
//  }
//
//  Future<void> insertMany(List<Settings> models,
//      {bool onlyNonNull = false, Set<String> only}) async {
//    final List<List<SetColumn>> data = models
//        .map((model) =>
//            toSetColumns(model, only: only, onlyNonNull: onlyNonNull))
//        .toList();
//    final InsertMany insert = inserters.addAll(data);
//    await adapter.insertMany(insert);
//    return;
//  }
//
//  Future<dynamic> upsert(Settings model,
//      {bool cascade = false,
//      Set<String> only,
//      bool onlyNonNull = false}) async {
//    final Upsert upsert = upserter
//        .setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));
//    return adapter.upsert(upsert);
//  }
//
//  Future<void> upsertMany(List<Settings> models,
//      {bool onlyNonNull = false, Set<String> only}) async {
//    final List<List<SetColumn>> data = [];
//    for (var i = 0; i < models.length; ++i) {
//      var model = models[i];
//      data.add(
//          toSetColumns(model, only: only, onlyNonNull: onlyNonNull).toList());
//    }
//    final UpsertMany upsert = upserters.addAll(data);
//    await adapter.upsertMany(upsert);
//    return;
//  }
//
//  Future<int> update(Settings model,
//      {bool cascade = false,
//      bool associate = false,
//      Set<String> only,
//      bool onlyNonNull = false}) async {
//    final Update update = updater
//        .where(this.id.eq(model.id))
//        .setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));
//    return adapter.update(update);
//  }
//
//  Future<void> updateMany(List<Settings> models,
//      {bool onlyNonNull = false, Set<String> only}) async {
//    final List<List<SetColumn>> data = [];
//    final List<Expression> where = [];
//    for (var i = 0; i < models.length; ++i) {
//      var model = models[i];
//      data.add(
//          toSetColumns(model, only: only, onlyNonNull: onlyNonNull).toList());
//      where.add(this.id.eq(model.id));
//    }
//    final UpdateMany update = updaters.addAll(data, where);
//    await adapter.updateMany(update);
//    return;
//  }
//
//  Future<Settings> find(String id,
//      {bool preload = false, bool cascade = false}) async {
//    final Find find = finder.where(this.id.eq(id));
//    return await findOne(find);
//  }
//
//  Future<int> remove(String id) async {
//    final Remove remove = remover.where(this.id.eq(id));
//    return adapter.remove(remove);
//  }
//
//  Future<int> removeMany(List<Settings> models) async {
//// Return if models is empty. If this is not done, all records will be removed!
//    if (models == null || models.isEmpty) return 0;
//    final Remove remove = remover;
//    for (final model in models) {
//      remove.or(this.id.eq(model.id));
//    }
//    return adapter.remove(remove);
//  }
//}
