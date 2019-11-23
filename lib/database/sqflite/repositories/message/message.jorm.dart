//// GENERATED CODE - DO NOT MODIFY BY HAND
//
//part of 'message.dart';
//
//// **************************************************************************
//// BeanGenerator
//// **************************************************************************
//
//abstract class _MessageBean implements Bean<Message> {
//  final id = StrField('id');
//  final conversationId = StrField('conversation_id');
//  final senderId = StrField('sender_id');
//  final senderName = StrField('sender_name');
//  final senderMobileNo = StrField('sender_mobile_no');
//  final receiverId = StrField('receiver_id');
//  final receiverName = StrField('receiver_name');
//  final receiverMobileNo = StrField('receiver_mobile_no');
//  final type = StrField('type');
//  final status = StrField('status');
//  final message = StrField('message');
//  final multimediaId = StrField('multimedia_id');
//  final timestamp = StrField('timestamp');
//  Map<String, Field> _fields;
//  Map<String, Field> get fields => _fields ??= {
//        id.name: id,
//        conversationId.name: conversationId,
//        senderId.name: senderId,
//        senderName.name: senderName,
//        senderMobileNo.name: senderMobileNo,
//        receiverId.name: receiverId,
//        receiverName.name: receiverName,
//        receiverMobileNo.name: receiverMobileNo,
//        type.name: type,
//        status.name: status,
//        message.name: message,
//        multimediaId.name: multimediaId,
//        timestamp.name: timestamp,
//      };
//  Message fromMap(Map map) {
//    Message model = Message();
//    model.id = adapter.parseValue(map['id']);
//    model.conversationId = adapter.parseValue(map['conversation_id']);
//    model.senderId = adapter.parseValue(map['sender_id']);
//    model.senderName = adapter.parseValue(map['sender_name']);
//    model.senderMobileNo = adapter.parseValue(map['sender_mobile_no']);
//    model.receiverId = adapter.parseValue(map['receiver_id']);
//    model.receiverName = adapter.parseValue(map['receiver_name']);
//    model.receiverMobileNo = adapter.parseValue(map['receiver_mobile_no']);
//    model.type = adapter.parseValue(map['type']);
//    model.status = adapter.parseValue(map['status']);
//    model.message = adapter.parseValue(map['message']);
//    model.multimediaId = adapter.parseValue(map['multimedia_id']);
//    model.timestamp = adapter.parseValue(map['timestamp']);
//
//    return model;
//  }
//
//  List<SetColumn> toSetColumns(Message model,
//      {bool update = false, Set<String> only, bool onlyNonNull = false}) {
//    List<SetColumn> ret = [];
//
//    if (only == null && !onlyNonNull) {
//      ret.add(id.set(model.id));
//      ret.add(conversationId.set(model.conversationId));
//      ret.add(senderId.set(model.senderId));
//      ret.add(senderName.set(model.senderName));
//      ret.add(senderMobileNo.set(model.senderMobileNo));
//      ret.add(receiverId.set(model.receiverId));
//      ret.add(receiverName.set(model.receiverName));
//      ret.add(receiverMobileNo.set(model.receiverMobileNo));
//      ret.add(type.set(model.type));
//      ret.add(status.set(model.status));
//      ret.add(message.set(model.message));
//      ret.add(multimediaId.set(model.multimediaId));
//      ret.add(timestamp.set(model.timestamp));
//    } else if (only != null) {
//      if (only.contains(id.name)) ret.add(id.set(model.id));
//      if (only.contains(conversationId.name))
//        ret.add(conversationId.set(model.conversationId));
//      if (only.contains(senderId.name)) ret.add(senderId.set(model.senderId));
//      if (only.contains(senderName.name))
//        ret.add(senderName.set(model.senderName));
//      if (only.contains(senderMobileNo.name))
//        ret.add(senderMobileNo.set(model.senderMobileNo));
//      if (only.contains(receiverId.name))
//        ret.add(receiverId.set(model.receiverId));
//      if (only.contains(receiverName.name))
//        ret.add(receiverName.set(model.receiverName));
//      if (only.contains(receiverMobileNo.name))
//        ret.add(receiverMobileNo.set(model.receiverMobileNo));
//      if (only.contains(type.name)) ret.add(type.set(model.type));
//      if (only.contains(status.name)) ret.add(status.set(model.status));
//      if (only.contains(message.name)) ret.add(message.set(model.message));
//      if (only.contains(multimediaId.name))
//        ret.add(multimediaId.set(model.multimediaId));
//      if (only.contains(timestamp.name))
//        ret.add(timestamp.set(model.timestamp));
//    } else /* if (onlyNonNull) */ {
//      if (model.id != null) {
//        ret.add(id.set(model.id));
//      }
//      if (model.conversationId != null) {
//        ret.add(conversationId.set(model.conversationId));
//      }
//      if (model.senderId != null) {
//        ret.add(senderId.set(model.senderId));
//      }
//      if (model.senderName != null) {
//        ret.add(senderName.set(model.senderName));
//      }
//      if (model.senderMobileNo != null) {
//        ret.add(senderMobileNo.set(model.senderMobileNo));
//      }
//      if (model.receiverId != null) {
//        ret.add(receiverId.set(model.receiverId));
//      }
//      if (model.receiverName != null) {
//        ret.add(receiverName.set(model.receiverName));
//      }
//      if (model.receiverMobileNo != null) {
//        ret.add(receiverMobileNo.set(model.receiverMobileNo));
//      }
//      if (model.type != null) {
//        ret.add(type.set(model.type));
//      }
//      if (model.status != null) {
//        ret.add(status.set(model.status));
//      }
//      if (model.message != null) {
//        ret.add(message.set(model.message));
//      }
//      if (model.multimediaId != null) {
//        ret.add(multimediaId.set(model.multimediaId));
//      }
//      if (model.timestamp != null) {
//        ret.add(timestamp.set(model.timestamp));
//      }
//    }
//
//    return ret;
//  }
//
//  Future<void> createTable({bool ifNotExists = false}) async {
//    final st = Sql.create(tableName, ifNotExists: ifNotExists);
//    st.addStr(id.name, primary: true, isNullable: false);
//    st.addStr(conversationId.name, isNullable: true);
//    st.addStr(senderId.name, isNullable: true);
//    st.addStr(senderName.name, isNullable: true);
//    st.addStr(senderMobileNo.name, isNullable: true);
//    st.addStr(receiverId.name, isNullable: true);
//    st.addStr(receiverName.name, isNullable: true);
//    st.addStr(receiverMobileNo.name, isNullable: true);
//    st.addStr(type.name, isNullable: true);
//    st.addStr(status.name, isNullable: true);
//    st.addStr(message.name, isNullable: true);
//    st.addStr(multimediaId.name, isNullable: true);
//    st.addStr(timestamp.name, isNullable: true);
//    return adapter.createTable(st);
//  }
//
//  Future<dynamic> insert(Message model,
//      {bool cascade = false,
//      bool onlyNonNull = false,
//      Set<String> only}) async {
//    final Insert insert = inserter
//        .setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));
//    return adapter.insert(insert);
//  }
//
//  Future<void> insertMany(List<Message> models,
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
//  Future<dynamic> upsert(Message model,
//      {bool cascade = false,
//      Set<String> only,
//      bool onlyNonNull = false}) async {
//    final Upsert upsert = upserter
//        .setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));
//    return adapter.upsert(upsert);
//  }
//
//  Future<void> upsertMany(List<Message> models,
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
//  Future<int> update(Message model,
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
//  Future<void> updateMany(List<Message> models,
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
//  Future<Message> find(String id,
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
//  Future<int> removeMany(List<Message> models) async {
//// Return if models is empty. If this is not done, all records will be removed!
//    if (models == null || models.isEmpty) return 0;
//    final Remove remove = remover;
//    for (final model in models) {
//      remove.or(this.id.eq(model.id));
//    }
//    return adapter.remove(remove);
//  }
//}
