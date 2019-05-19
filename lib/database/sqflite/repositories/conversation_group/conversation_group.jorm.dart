// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation_group.dart';

// **************************************************************************
// BeanGenerator
// **************************************************************************

abstract class _ConversationBean implements Bean<Conversation> {
  final id = StrField('id');
  final name = StrField('name');
  final type = StrField('type');
  final groupPhoto = StrField('group_photo');
  final description = StrField('description');
  final block = BoolField('block');
  final notificationExpireDate = IntField('notification_expire_date');
  final contacts = StrField('contacts');
  final unreadMessage = StrField('unread_message');
  Map<String, Field> _fields;
  Map<String, Field> get fields => _fields ??= {
        id.name: id,
        name.name: name,
        type.name: type,
        groupPhoto.name: groupPhoto,
        description.name: description,
        block.name: block,
        notificationExpireDate.name: notificationExpireDate,
        contacts.name: contacts,
        unreadMessage.name: unreadMessage,
      };
  Conversation fromMap(Map map) {
    Conversation model = Conversation();
    model.id = adapter.parseValue(map['id']);
    model.name = adapter.parseValue(map['name']);
    model.type = adapter.parseValue(map['type']);
    model.groupPhoto = adapter.parseValue(map['group_photo']);
    model.description = adapter.parseValue(map['description']);
    model.block = adapter.parseValue(map['block']);
    model.notificationExpireDate =
        adapter.parseValue(map['notification_expire_date']);
    model.contacts = adapter.parseValue(map['contacts']);
    model.unreadMessage = adapter.parseValue(map['unread_message']);

    return model;
  }

  List<SetColumn> toSetColumns(Conversation model,
      {bool update = false, Set<String> only}) {
    List<SetColumn> ret = [];

    if (only == null) {
      ret.add(id.set(model.id));
      ret.add(name.set(model.name));
      ret.add(type.set(model.type));
      ret.add(groupPhoto.set(model.groupPhoto));
      ret.add(description.set(model.description));
      ret.add(block.set(model.block));
      ret.add(notificationExpireDate.set(model.notificationExpireDate));
      ret.add(contacts.set(model.contacts));
      ret.add(unreadMessage.set(model.unreadMessage));
    } else {
      if (only.contains(id.name)) ret.add(id.set(model.id));
      if (only.contains(name.name)) ret.add(name.set(model.name));
      if (only.contains(type.name)) ret.add(type.set(model.type));
      if (only.contains(groupPhoto.name))
        ret.add(groupPhoto.set(model.groupPhoto));
      if (only.contains(description.name))
        ret.add(description.set(model.description));
      if (only.contains(block.name)) ret.add(block.set(model.block));
      if (only.contains(notificationExpireDate.name))
        ret.add(notificationExpireDate.set(model.notificationExpireDate));
      if (only.contains(contacts.name)) ret.add(contacts.set(model.contacts));
      if (only.contains(unreadMessage.name))
        ret.add(unreadMessage.set(model.unreadMessage));
    }

    return ret;
  }

  Future<void> createTable({bool ifNotExists: false}) async {
    final st = Sql.create(tableName, ifNotExists: ifNotExists);
    st.addStr(id.name, primary: true, isNullable: false);
    st.addStr(name.name, isNullable: true);
    st.addStr(type.name, isNullable: true);
    st.addStr(groupPhoto.name, isNullable: true);
    st.addStr(description.name, isNullable: true);
    st.addBool(block.name, isNullable: true);
    st.addInt(notificationExpireDate.name, isNullable: true);
    st.addStr(contacts.name, isNullable: true);
    st.addStr(unreadMessage.name, isNullable: true);
    return adapter.createTable(st);
  }

  Future<dynamic> insert(Conversation model) async {
    final Insert insert = inserter.setMany(toSetColumns(model));
    return adapter.insert(insert);
  }

  Future<void> insertMany(List<Conversation> models) async {
    final List<List<SetColumn>> data =
        models.map((model) => toSetColumns(model)).toList();
    final InsertMany insert = inserters.addAll(data);
    await adapter.insertMany(insert);
    return;
  }

  Future<dynamic> upsert(Conversation model) async {
    final Upsert upsert = upserter.setMany(toSetColumns(model));
    return adapter.upsert(upsert);
  }

  Future<void> upsertMany(List<Conversation> models) async {
    final List<List<SetColumn>> data = [];
    for (var i = 0; i < models.length; ++i) {
      var model = models[i];
      data.add(toSetColumns(model).toList());
    }
    final UpsertMany upsert = upserters.addAll(data);
    await adapter.upsertMany(upsert);
    return;
  }

  Future<int> update(Conversation model, {Set<String> only}) async {
    final Update update = updater
        .where(this.id.eq(model.id))
        .setMany(toSetColumns(model, only: only));
    return adapter.update(update);
  }

  Future<void> updateMany(List<Conversation> models) async {
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

  Future<Conversation> find(String id,
      {bool preload: false, bool cascade: false}) async {
    final Find find = finder.where(this.id.eq(id));
    return await findOne(find);
  }

  Future<int> remove(String id) async {
    final Remove remove = remover.where(this.id.eq(id));
    return adapter.remove(remove);
  }

  Future<int> removeMany(List<Conversation> models) async {
    final Remove remove = remover;
    for (final model in models) {
      remove.or(this.id.eq(model.id));
    }
    return adapter.remove(remove);
  }
}
