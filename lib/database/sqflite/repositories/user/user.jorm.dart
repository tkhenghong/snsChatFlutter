//// GENERATED CODE - DO NOT MODIFY BY HAND
//
//part of 'user.dart';
//
//// **************************************************************************
//// BeanGenerator
//// **************************************************************************
//
//abstract class _UserBean implements Bean<User> {
//  final id = StrField('id');
//  final displayName = StrField('display_name');
//  final realName = StrField('real_name');
//  final mobileNo = StrField('mobile_no');
//  final googleAccountId = StrField('google_account_id');
//  Map<String, Field> _fields;
//  Map<String, Field> get fields => _fields ??= {
//        id.name: id,
//        displayName.name: displayName,
//        realName.name: realName,
//        mobileNo.name: mobileNo,
//        googleAccountId.name: googleAccountId,
//      };
//  User fromMap(Map map) {
//    User model = User();
//    model.id = adapter.parseValue(map['id']);
//    model.displayName = adapter.parseValue(map['display_name']);
//    model.realName = adapter.parseValue(map['real_name']);
//    model.mobileNo = adapter.parseValue(map['mobile_no']);
//    model.googleAccountId = adapter.parseValue(map['google_account_id']);
//
//    return model;
//  }
//
//  List<SetColumn> toSetColumns(User model,
//      {bool update = false, Set<String> only, bool onlyNonNull = false}) {
//    List<SetColumn> ret = [];
//
//    if (only == null && !onlyNonNull) {
//      ret.add(id.set(model.id));
//      ret.add(displayName.set(model.displayName));
//      ret.add(realName.set(model.realName));
//      ret.add(mobileNo.set(model.mobileNo));
//      ret.add(googleAccountId.set(model.googleAccountId));
//    } else if (only != null) {
//      if (only.contains(id.name)) ret.add(id.set(model.id));
//      if (only.contains(displayName.name))
//        ret.add(displayName.set(model.displayName));
//      if (only.contains(realName.name)) ret.add(realName.set(model.realName));
//      if (only.contains(mobileNo.name)) ret.add(mobileNo.set(model.mobileNo));
//      if (only.contains(googleAccountId.name))
//        ret.add(googleAccountId.set(model.googleAccountId));
//    } else /* if (onlyNonNull) */ {
//      if (model.id != null) {
//        ret.add(id.set(model.id));
//      }
//      if (model.displayName != null) {
//        ret.add(displayName.set(model.displayName));
//      }
//      if (model.realName != null) {
//        ret.add(realName.set(model.realName));
//      }
//      if (model.mobileNo != null) {
//        ret.add(mobileNo.set(model.mobileNo));
//      }
//      if (model.googleAccountId != null) {
//        ret.add(googleAccountId.set(model.googleAccountId));
//      }
//    }
//
//    return ret;
//  }
//
//  Future<void> createTable({bool ifNotExists = false}) async {
//    final st = Sql.create(tableName, ifNotExists: ifNotExists);
//    st.addStr(id.name, primary: true, isNullable: false);
//    st.addStr(displayName.name, isNullable: true);
//    st.addStr(realName.name, isNullable: true);
//    st.addStr(mobileNo.name, isNullable: true);
//    st.addStr(googleAccountId.name, isNullable: true);
//    return adapter.createTable(st);
//  }
//
//  Future<dynamic> insert(User model,
//      {bool cascade = false,
//      bool onlyNonNull = false,
//      Set<String> only}) async {
//    final Insert insert = inserter
//        .setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));
//    return adapter.insert(insert);
//  }
//
//  Future<void> insertMany(List<User> models,
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
//  Future<dynamic> upsert(User model,
//      {bool cascade = false,
//      Set<String> only,
//      bool onlyNonNull = false}) async {
//    final Upsert upsert = upserter
//        .setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));
//    return adapter.upsert(upsert);
//  }
//
//  Future<void> upsertMany(List<User> models,
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
//  Future<int> update(User model,
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
//  Future<void> updateMany(List<User> models,
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
//  Future<User> find(String id,
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
//  Future<int> removeMany(List<User> models) async {
//// Return if models is empty. If this is not done, all records will be removed!
//    if (models == null || models.isEmpty) return 0;
//    final Remove remove = remover;
//    for (final model in models) {
//      remove.or(this.id.eq(model.id));
//    }
//    return adapter.remove(remove);
//  }
//}
