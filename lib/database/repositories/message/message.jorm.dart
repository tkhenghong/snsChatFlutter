// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// BeanGenerator
// **************************************************************************

abstract class _MessageBean implements Bean<Message> {
  final id = StrField('id');
  final conversationId = StrField('conversation_id');
  final recipient = StrField('recipient');
  final type = StrField('type');
  final status = StrField('status');
  final message = StrField('message');
  final multimedia = StrField('multimedia');
  Map<String, Field> _fields;
  Map<String, Field> get fields => _fields ??= {
        id.name: id,
        conversationId.name: conversationId,
        recipient.name: recipient,
        type.name: type,
        status.name: status,
        message.name: message,
        multimedia.name: multimedia,
      };
  Message fromMap(Map map) {
    Message model = Message();
    model.id = adapter.parseValue(map['id']);
    model.conversationId = adapter.parseValue(map['conversation_id']);
    model.recipient = adapter.parseValue(map['recipient']);
    model.type = adapter.parseValue(map['type']);
    model.status = adapter.parseValue(map['status']);
    model.message = adapter.parseValue(map['message']);
    model.multimedia = adapter.parseValue(map['multimedia']);

    return model;
  }

  List<SetColumn> toSetColumns(Message model,
      {bool update = false, Set<String> only}) {
    List<SetColumn> ret = [];

    if (only == null) {
      ret.add(id.set(model.id));
      ret.add(conversationId.set(model.conversationId));
      ret.add(recipient.set(model.recipient));
      ret.add(type.set(model.type));
      ret.add(status.set(model.status));
      ret.add(message.set(model.message));
      ret.add(multimedia.set(model.multimedia));
    } else {
      if (only.contains(id.name)) ret.add(id.set(model.id));
      if (only.contains(conversationId.name))
        ret.add(conversationId.set(model.conversationId));
      if (only.contains(recipient.name))
        ret.add(recipient.set(model.recipient));
      if (only.contains(type.name)) ret.add(type.set(model.type));
      if (only.contains(status.name)) ret.add(status.set(model.status));
      if (only.contains(message.name)) ret.add(message.set(model.message));
      if (only.contains(multimedia.name))
        ret.add(multimedia.set(model.multimedia));
    }

    return ret;
  }

  Future<void> createTable({bool ifNotExists: false}) async {
    final st = Sql.create(tableName, ifNotExists: ifNotExists);
    st.addStr(id.name, primary: true, isNullable: false);
    st.addStr(conversationId.name, isNullable: true);
    st.addStr(recipient.name, isNullable: true);
    st.addStr(type.name, isNullable: true);
    st.addStr(status.name, isNullable: true);
    st.addStr(message.name, isNullable: true);
    st.addStr(multimedia.name, isNullable: true);
    return adapter.createTable(st);
  }

  Future<dynamic> insert(Message model) async {
    final Insert insert = inserter.setMany(toSetColumns(model));
    return adapter.insert(insert);
  }

  Future<void> insertMany(List<Message> models) async {
    final List<List<SetColumn>> data =
        models.map((model) => toSetColumns(model)).toList();
    final InsertMany insert = inserters.addAll(data);
    await adapter.insertMany(insert);
    return;
  }

  Future<dynamic> upsert(Message model) async {
    final Upsert upsert = upserter.setMany(toSetColumns(model));
    return adapter.upsert(upsert);
  }

  Future<void> upsertMany(List<Message> models) async {
    final List<List<SetColumn>> data = [];
    for (var i = 0; i < models.length; ++i) {
      var model = models[i];
      data.add(toSetColumns(model).toList());
    }
    final UpsertMany upsert = upserters.addAll(data);
    await adapter.upsertMany(upsert);
    return;
  }

  Future<int> update(Message model, {Set<String> only}) async {
    final Update update = updater
        .where(this.id.eq(model.id))
        .setMany(toSetColumns(model, only: only));
    return adapter.update(update);
  }

  Future<void> updateMany(List<Message> models) async {
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

  Future<Message> find(String id,
      {bool preload: false, bool cascade: false}) async {
    final Find find = finder.where(this.id.eq(id));
    return await findOne(find);
  }

  Future<int> remove(String id) async {
    final Remove remove = remover.where(this.id.eq(id));
    return adapter.remove(remove);
  }

  Future<int> removeMany(List<Message> models) async {
    final Remove remove = remover;
    for (final model in models) {
      remove.or(this.id.eq(model.id));
    }
    return adapter.remove(remove);
  }
}
