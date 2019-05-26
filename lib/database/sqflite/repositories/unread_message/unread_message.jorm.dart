// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unread_message.dart';

// **************************************************************************
// BeanGenerator
// **************************************************************************

abstract class _UnreadMessageBean implements Bean<UnreadMessage> {
  final id = StrField('id');
  final conversationId = StrField('conversation_id');
  final lastMessage = StrField('last_message');
  final date = IntField('date');
  final count = IntField('count');
  Map<String, Field> _fields;
  Map<String, Field> get fields => _fields ??= {
        id.name: id,
        conversationId.name: conversationId,
        lastMessage.name: lastMessage,
        date.name: date,
        count.name: count,
      };
  UnreadMessage fromMap(Map map) {
    UnreadMessage model = UnreadMessage();
    model.id = adapter.parseValue(map['id']);
    model.conversationId = adapter.parseValue(map['conversation_id']);
    model.lastMessage = adapter.parseValue(map['last_message']);
    model.date = adapter.parseValue(map['date']);
    model.count = adapter.parseValue(map['count']);

    return model;
  }

  List<SetColumn> toSetColumns(UnreadMessage model,
      {bool update = false, Set<String> only, bool onlyNonNull = false}) {
    List<SetColumn> ret = [];

    if (only == null && !onlyNonNull) {
      ret.add(id.set(model.id));
      ret.add(conversationId.set(model.conversationId));
      ret.add(lastMessage.set(model.lastMessage));
      ret.add(date.set(model.date));
      ret.add(count.set(model.count));
    } else if (only != null) {
      if (only.contains(id.name)) ret.add(id.set(model.id));
      if (only.contains(conversationId.name))
        ret.add(conversationId.set(model.conversationId));
      if (only.contains(lastMessage.name))
        ret.add(lastMessage.set(model.lastMessage));
      if (only.contains(date.name)) ret.add(date.set(model.date));
      if (only.contains(count.name)) ret.add(count.set(model.count));
    } else /* if (onlyNonNull) */ {
      if (model.id != null) {
        ret.add(id.set(model.id));
      }
      if (model.conversationId != null) {
        ret.add(conversationId.set(model.conversationId));
      }
      if (model.lastMessage != null) {
        ret.add(lastMessage.set(model.lastMessage));
      }
      if (model.date != null) {
        ret.add(date.set(model.date));
      }
      if (model.count != null) {
        ret.add(count.set(model.count));
      }
    }

    return ret;
  }

  Future<void> createTable({bool ifNotExists = false}) async {
    final st = Sql.create(tableName, ifNotExists: ifNotExists);
    st.addStr(id.name, primary: true, isNullable: false);
    st.addStr(conversationId.name, isNullable: true);
    st.addStr(lastMessage.name, isNullable: true);
    st.addInt(date.name, isNullable: true);
    st.addInt(count.name, isNullable: true);
    return adapter.createTable(st);
  }

  Future<dynamic> insert(UnreadMessage model,
      {bool cascade = false,
      bool onlyNonNull = false,
      Set<String> only}) async {
    final Insert insert = inserter
        .setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));
    return adapter.insert(insert);
  }

  Future<void> insertMany(List<UnreadMessage> models,
      {bool onlyNonNull = false, Set<String> only}) async {
    final List<List<SetColumn>> data = models
        .map((model) =>
            toSetColumns(model, only: only, onlyNonNull: onlyNonNull))
        .toList();
    final InsertMany insert = inserters.addAll(data);
    await adapter.insertMany(insert);
    return;
  }

  Future<dynamic> upsert(UnreadMessage model,
      {bool cascade = false,
      Set<String> only,
      bool onlyNonNull = false}) async {
    final Upsert upsert = upserter
        .setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));
    return adapter.upsert(upsert);
  }

  Future<void> upsertMany(List<UnreadMessage> models,
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

  Future<int> update(UnreadMessage model,
      {bool cascade = false,
      bool associate = false,
      Set<String> only,
      bool onlyNonNull = false}) async {
    final Update update = updater
        .where(this.id.eq(model.id))
        .setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));
    return adapter.update(update);
  }

  Future<void> updateMany(List<UnreadMessage> models,
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

  Future<UnreadMessage> find(String id,
      {bool preload = false, bool cascade = false}) async {
    final Find find = finder.where(this.id.eq(id));
    return await findOne(find);
  }

  Future<int> remove(String id) async {
    final Remove remove = remover.where(this.id.eq(id));
    return adapter.remove(remove);
  }

  Future<int> removeMany(List<UnreadMessage> models) async {
// Return if models is empty. If this is not done, all records will be removed!
    if (models == null || models.isEmpty) return 0;
    final Remove remove = remover;
    for (final model in models) {
      remove.or(this.id.eq(model.id));
    }
    return adapter.remove(remove);
  }
}
