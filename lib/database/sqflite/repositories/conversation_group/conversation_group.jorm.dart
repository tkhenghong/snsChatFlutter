// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation_group.dart';

// **************************************************************************
// BeanGenerator
// **************************************************************************

abstract class _ConversationBean implements Bean<Conversation> {
  final id = StrField('id');
  final userId = StrField('user_id');
  final name = StrField('name');
  final type = StrField('type');
  final groupPhotoId = StrField('group_photo_id');
  final unreadMessageId = StrField('unread_message_id');
  final description = StrField('description');
  final block = BoolField('block');
  final notificationExpireDate = IntField('notification_expire_date');
  final timestamp = StrField('timestamp');
  Map<String, Field> _fields;
  Map<String, Field> get fields => _fields ??= {
        id.name: id,
        userId.name: userId,
        name.name: name,
        type.name: type,
        groupPhotoId.name: groupPhotoId,
        unreadMessageId.name: unreadMessageId,
        description.name: description,
        block.name: block,
        notificationExpireDate.name: notificationExpireDate,
        timestamp.name: timestamp,
      };
  Conversation fromMap(Map map) {
    Conversation model = Conversation();
    model.id = adapter.parseValue(map['id']);
    model.userId = adapter.parseValue(map['user_id']);
    model.name = adapter.parseValue(map['name']);
    model.type = adapter.parseValue(map['type']);
    model.groupPhotoId = adapter.parseValue(map['group_photo_id']);
    model.unreadMessageId = adapter.parseValue(map['unread_message_id']);
    model.description = adapter.parseValue(map['description']);
    model.block = adapter.parseValue(map['block']);
    model.notificationExpireDate =
        adapter.parseValue(map['notification_expire_date']);
    model.timestamp = adapter.parseValue(map['timestamp']);

    return model;
  }

  List<SetColumn> toSetColumns(Conversation model,
      {bool update = false, Set<String> only, bool onlyNonNull = false}) {
    List<SetColumn> ret = [];

    if (only == null && !onlyNonNull) {
      ret.add(id.set(model.id));
      ret.add(userId.set(model.userId));
      ret.add(name.set(model.name));
      ret.add(type.set(model.type));
      ret.add(groupPhotoId.set(model.groupPhotoId));
      ret.add(unreadMessageId.set(model.unreadMessageId));
      ret.add(description.set(model.description));
      ret.add(block.set(model.block));
      ret.add(notificationExpireDate.set(model.notificationExpireDate));
      ret.add(timestamp.set(model.timestamp));
    } else if (only != null) {
      if (only.contains(id.name)) ret.add(id.set(model.id));
      if (only.contains(userId.name)) ret.add(userId.set(model.userId));
      if (only.contains(name.name)) ret.add(name.set(model.name));
      if (only.contains(type.name)) ret.add(type.set(model.type));
      if (only.contains(groupPhotoId.name))
        ret.add(groupPhotoId.set(model.groupPhotoId));
      if (only.contains(unreadMessageId.name))
        ret.add(unreadMessageId.set(model.unreadMessageId));
      if (only.contains(description.name))
        ret.add(description.set(model.description));
      if (only.contains(block.name)) ret.add(block.set(model.block));
      if (only.contains(notificationExpireDate.name))
        ret.add(notificationExpireDate.set(model.notificationExpireDate));
      if (only.contains(timestamp.name))
        ret.add(timestamp.set(model.timestamp));
    } else /* if (onlyNonNull) */ {
      if (model.id != null) {
        ret.add(id.set(model.id));
      }
      if (model.userId != null) {
        ret.add(userId.set(model.userId));
      }
      if (model.name != null) {
        ret.add(name.set(model.name));
      }
      if (model.type != null) {
        ret.add(type.set(model.type));
      }
      if (model.groupPhotoId != null) {
        ret.add(groupPhotoId.set(model.groupPhotoId));
      }
      if (model.unreadMessageId != null) {
        ret.add(unreadMessageId.set(model.unreadMessageId));
      }
      if (model.description != null) {
        ret.add(description.set(model.description));
      }
      if (model.block != null) {
        ret.add(block.set(model.block));
      }
      if (model.notificationExpireDate != null) {
        ret.add(notificationExpireDate.set(model.notificationExpireDate));
      }
      if (model.timestamp != null) {
        ret.add(timestamp.set(model.timestamp));
      }
    }

    return ret;
  }

  Future<void> createTable({bool ifNotExists = false}) async {
    final st = Sql.create(tableName, ifNotExists: ifNotExists);
    st.addStr(id.name, primary: true, isNullable: false);
    st.addStr(userId.name, isNullable: true);
    st.addStr(name.name, isNullable: true);
    st.addStr(type.name, isNullable: true);
    st.addStr(groupPhotoId.name, isNullable: true);
    st.addStr(unreadMessageId.name, isNullable: true);
    st.addStr(description.name, isNullable: true);
    st.addBool(block.name, isNullable: true);
    st.addInt(notificationExpireDate.name, isNullable: true);
    st.addStr(timestamp.name, isNullable: true);
    return adapter.createTable(st);
  }

  Future<dynamic> insert(Conversation model,
      {bool cascade = false,
      bool onlyNonNull = false,
      Set<String> only}) async {
    final Insert insert = inserter
        .setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));
    return adapter.insert(insert);
  }

  Future<void> insertMany(List<Conversation> models,
      {bool onlyNonNull = false, Set<String> only}) async {
    final List<List<SetColumn>> data = models
        .map((model) =>
            toSetColumns(model, only: only, onlyNonNull: onlyNonNull))
        .toList();
    final InsertMany insert = inserters.addAll(data);
    await adapter.insertMany(insert);
    return;
  }

  Future<dynamic> upsert(Conversation model,
      {bool cascade = false,
      Set<String> only,
      bool onlyNonNull = false}) async {
    final Upsert upsert = upserter
        .setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));
    return adapter.upsert(upsert);
  }

  Future<void> upsertMany(List<Conversation> models,
      {bool onlyNonNull = false, Set<String> only}) async {
    final List<List<SetColumn>> data = [];
    for (var i = 0; i < models.length; ++i) {
      var model = models[i];
      data.add(
          toSetColumns(model, only: only, onlyNonNull: onlyNonNull).toList());
    }
    final UpsertMany upsert = upserters.addAll(data);
    await adapter.upsertMany(upsert);
    return;
  }

  Future<int> update(Conversation model,
      {bool cascade = false,
      bool associate = false,
      Set<String> only,
      bool onlyNonNull = false}) async {
    final Update update = updater
        .where(this.id.eq(model.id))
        .setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));
    return adapter.update(update);
  }

  Future<void> updateMany(List<Conversation> models,
      {bool onlyNonNull = false, Set<String> only}) async {
    final List<List<SetColumn>> data = [];
    final List<Expression> where = [];
    for (var i = 0; i < models.length; ++i) {
      var model = models[i];
      data.add(
          toSetColumns(model, only: only, onlyNonNull: onlyNonNull).toList());
      where.add(this.id.eq(model.id));
    }
    final UpdateMany update = updaters.addAll(data, where);
    await adapter.updateMany(update);
    return;
  }

  Future<Conversation> find(String id,
      {bool preload = false, bool cascade = false}) async {
    final Find find = finder.where(this.id.eq(id));
    return await findOne(find);
  }

  Future<int> remove(String id) async {
    final Remove remove = remover.where(this.id.eq(id));
    return adapter.remove(remove);
  }

  Future<int> removeMany(List<Conversation> models) async {
// Return if models is empty. If this is not done, all records will be removed!
    if (models == null || models.isEmpty) return 0;
    final Remove remove = remover;
    for (final model in models) {
      remove.or(this.id.eq(model.id));
    }
    return adapter.remove(remove);
  }
}
