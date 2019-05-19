// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// BeanGenerator
// **************************************************************************

abstract class _UserBean implements Bean<User> {
  final id = StrField('id');
  final displayName = StrField('display_name');
  final realName = StrField('real_name');
  final userId = StrField('user_id');
  final mobileNo = StrField('mobile_no');
  final settings = StrField('settings');
  final googleSignIn = StrField('google_sign_in');
  final firebaseAuth = StrField('firebase_auth');
  final firebaseUser = StrField('firebase_user');
  Map<String, Field> _fields;
  Map<String, Field> get fields => _fields ??= {
        id.name: id,
        displayName.name: displayName,
        realName.name: realName,
        userId.name: userId,
        mobileNo.name: mobileNo,
        settings.name: settings,
        googleSignIn.name: googleSignIn,
        firebaseAuth.name: firebaseAuth,
        firebaseUser.name: firebaseUser,
      };
  User fromMap(Map map) {
    User model = User();
    model.id = adapter.parseValue(map['id']);
    model.displayName = adapter.parseValue(map['display_name']);
    model.realName = adapter.parseValue(map['real_name']);
    model.userId = adapter.parseValue(map['user_id']);
    model.mobileNo = adapter.parseValue(map['mobile_no']);
    model.settings = adapter.parseValue(map['settings']);
    model.googleSignIn = adapter.parseValue(map['google_sign_in']);
    model.firebaseAuth = adapter.parseValue(map['firebase_auth']);
    model.firebaseUser = adapter.parseValue(map['firebase_user']);

    return model;
  }

  List<SetColumn> toSetColumns(User model,
      {bool update = false, Set<String> only}) {
    List<SetColumn> ret = [];

    if (only == null) {
      ret.add(id.set(model.id));
      ret.add(displayName.set(model.displayName));
      ret.add(realName.set(model.realName));
      ret.add(userId.set(model.userId));
      ret.add(mobileNo.set(model.mobileNo));
      ret.add(settings.set(model.settings));
      ret.add(googleSignIn.set(model.googleSignIn));
      ret.add(firebaseAuth.set(model.firebaseAuth));
      ret.add(firebaseUser.set(model.firebaseUser));
    } else {
      if (only.contains(id.name)) ret.add(id.set(model.id));
      if (only.contains(displayName.name))
        ret.add(displayName.set(model.displayName));
      if (only.contains(realName.name)) ret.add(realName.set(model.realName));
      if (only.contains(userId.name)) ret.add(userId.set(model.userId));
      if (only.contains(mobileNo.name)) ret.add(mobileNo.set(model.mobileNo));
      if (only.contains(settings.name)) ret.add(settings.set(model.settings));
      if (only.contains(googleSignIn.name))
        ret.add(googleSignIn.set(model.googleSignIn));
      if (only.contains(firebaseAuth.name))
        ret.add(firebaseAuth.set(model.firebaseAuth));
      if (only.contains(firebaseUser.name))
        ret.add(firebaseUser.set(model.firebaseUser));
    }

    return ret;
  }

  Future<void> createTable({bool ifNotExists: false}) async {
    final st = Sql.create(tableName, ifNotExists: ifNotExists);
    st.addStr(id.name, primary: true, isNullable: false);
    st.addStr(displayName.name, isNullable: true);
    st.addStr(realName.name, isNullable: true);
    st.addStr(userId.name, isNullable: true);
    st.addStr(mobileNo.name, isNullable: true);
    st.addStr(settings.name, isNullable: true);
    st.addStr(googleSignIn.name, isNullable: true);
    st.addStr(firebaseAuth.name, isNullable: true);
    st.addStr(firebaseUser.name, isNullable: true);
    return adapter.createTable(st);
  }

  Future<dynamic> insert(User model) async {
    final Insert insert = inserter.setMany(toSetColumns(model));
    return adapter.insert(insert);
  }

  Future<void> insertMany(List<User> models) async {
    final List<List<SetColumn>> data =
        models.map((model) => toSetColumns(model)).toList();
    final InsertMany insert = inserters.addAll(data);
    await adapter.insertMany(insert);
    return;
  }

  Future<dynamic> upsert(User model) async {
    final Upsert upsert = upserter.setMany(toSetColumns(model));
    return adapter.upsert(upsert);
  }

  Future<void> upsertMany(List<User> models) async {
    final List<List<SetColumn>> data = [];
    for (var i = 0; i < models.length; ++i) {
      var model = models[i];
      data.add(toSetColumns(model).toList());
    }
    final UpsertMany upsert = upserters.addAll(data);
    await adapter.upsertMany(upsert);
    return;
  }

  Future<int> update(User model, {Set<String> only}) async {
    final Update update = updater
        .where(this.id.eq(model.id))
        .setMany(toSetColumns(model, only: only));
    return adapter.update(update);
  }

  Future<void> updateMany(List<User> models) async {
    final List<List<SetColumn>> data = [];
    final List<Expression> where = [];
    for (var i = 0; i < models.length; ++i) {
      var model = models[i];
      data.add(toSetColumns(model).toList());
      where.add(this.id.eq(model.id));
    }
    final UpdateMany update = updaters.addAll(data, where);
    await adapter.updateMany(update);
    return;
  }

  Future<User> find(String id,
      {bool preload: false, bool cascade: false}) async {
    final Find find = finder.where(this.id.eq(id));
    return await findOne(find);
  }

  Future<int> remove(String id) async {
    final Remove remove = remover.where(this.id.eq(id));
    return adapter.remove(remove);
  }

  Future<int> removeMany(List<User> models) async {
    final Remove remove = remover;
    for (final model in models) {
      remove.or(this.id.eq(model.id));
    }
    return adapter.remove(remove);
  }
}
