// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'userContact.dart';

// **************************************************************************
// BeanGenerator
// **************************************************************************

abstract class _UserContactBean implements Bean<UserContact> {
  final id = StrField('id');
  final displayName = StrField('display_name');
  final realName = StrField('real_name');
  final userId = StrField('user_id');
  final mobileNo = StrField('mobile_no');
  final lastSeenDate = StrField('last_seen_date');
  final block = BoolField('block');
  final photo = StrField('photo');
  Map<String, Field> _fields;
  Map<String, Field> get fields => _fields ??= {
        id.name: id,
        displayName.name: displayName,
        realName.name: realName,
        userId.name: userId,
        mobileNo.name: mobileNo,
        lastSeenDate.name: lastSeenDate,
        block.name: block,
        photo.name: photo,
      };
  UserContact fromMap(Map map) {
    UserContact model = UserContact();
    model.id = adapter.parseValue(map['id']);
    model.displayName = adapter.parseValue(map['display_name']);
    model.realName = adapter.parseValue(map['real_name']);
    model.userId = adapter.parseValue(map['user_id']);
    model.mobileNo = adapter.parseValue(map['mobile_no']);
    model.lastSeenDate = adapter.parseValue(map['last_seen_date']);
    model.block = adapter.parseValue(map['block']);
    model.photo = adapter.parseValue(map['photo']);

    return model;
  }

  List<SetColumn> toSetColumns(UserContact model,
      {bool update = false, Set<String> only}) {
    List<SetColumn> ret = [];

    if (only == null) {
      ret.add(id.set(model.id));
      ret.add(displayName.set(model.displayName));
      ret.add(realName.set(model.realName));
      ret.add(userId.set(model.userId));
      ret.add(mobileNo.set(model.mobileNo));
      ret.add(lastSeenDate.set(model.lastSeenDate));
      ret.add(block.set(model.block));
      ret.add(photo.set(model.photo));
    } else {
      if (only.contains(id.name)) ret.add(id.set(model.id));
      if (only.contains(displayName.name))
        ret.add(displayName.set(model.displayName));
      if (only.contains(realName.name)) ret.add(realName.set(model.realName));
      if (only.contains(userId.name)) ret.add(userId.set(model.userId));
      if (only.contains(mobileNo.name)) ret.add(mobileNo.set(model.mobileNo));
      if (only.contains(lastSeenDate.name))
        ret.add(lastSeenDate.set(model.lastSeenDate));
      if (only.contains(block.name)) ret.add(block.set(model.block));
      if (only.contains(photo.name)) ret.add(photo.set(model.photo));
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
    st.addStr(lastSeenDate.name, isNullable: true);
    st.addBool(block.name, isNullable: true);
    st.addStr(photo.name, isNullable: true);
    return adapter.createTable(st);
  }

  Future<dynamic> insert(UserContact model) async {
    final Insert insert = inserter.setMany(toSetColumns(model));
    return adapter.insert(insert);
  }

  Future<void> insertMany(List<UserContact> models) async {
    final List<List<SetColumn>> data =
        models.map((model) => toSetColumns(model)).toList();
    final InsertMany insert = inserters.addAll(data);
    await adapter.insertMany(insert);
    return;
  }

  Future<dynamic> upsert(UserContact model) async {
    final Upsert upsert = upserter.setMany(toSetColumns(model));
    return adapter.upsert(upsert);
  }

  Future<void> upsertMany(List<UserContact> models) async {
    final List<List<SetColumn>> data = [];
    for (var i = 0; i < models.length; ++i) {
      var model = models[i];
      data.add(toSetColumns(model).toList());
    }
    final UpsertMany upsert = upserters.addAll(data);
    await adapter.upsertMany(upsert);
    return;
  }

  Future<int> update(UserContact model, {Set<String> only}) async {
    final Update update = updater
        .where(this.id.eq(model.id))
        .setMany(toSetColumns(model, only: only));
    return adapter.update(update);
  }

  Future<void> updateMany(List<UserContact> models) async {
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

  Future<UserContact> find(String id,
      {bool preload: false, bool cascade: false}) async {
    final Find find = finder.where(this.id.eq(id));
    return await findOne(find);
  }

  Future<int> remove(String id) async {
    final Remove remove = remover.where(this.id.eq(id));
    return adapter.remove(remove);
  }

  Future<int> removeMany(List<UserContact> models) async {
    final Remove remove = remover;
    for (final model in models) {
      remove.or(this.id.eq(model.id));
    }
    return adapter.remove(remove);
  }
}
