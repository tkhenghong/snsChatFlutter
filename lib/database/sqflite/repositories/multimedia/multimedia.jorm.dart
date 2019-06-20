// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'multimedia.dart';

// **************************************************************************
// BeanGenerator
// **************************************************************************

abstract class _MultimediaBean implements Bean<Multimedia> {
  final id = StrField('id');
  final localFullFileUrl = StrField('local_full_file_url');
  final localThumbnailUrl = StrField('local_thumbnail_url');
  final remoteThumbnailUrl = StrField('remote_thumbnail_url');
  final remoteFullFileUrl = StrField('remote_full_file_url');
  final imageDataId = StrField('image_data_id');
  final imageFileId = StrField('image_file_id');
  final messageId = StrField('message_id');
  final userContactId = StrField('user_contact_id');
  final conversationId = StrField('conversation_id');
  Map<String, Field> _fields;
  Map<String, Field> get fields => _fields ??= {
        id.name: id,
        localFullFileUrl.name: localFullFileUrl,
        localThumbnailUrl.name: localThumbnailUrl,
        remoteThumbnailUrl.name: remoteThumbnailUrl,
        remoteFullFileUrl.name: remoteFullFileUrl,
        imageDataId.name: imageDataId,
        imageFileId.name: imageFileId,
        messageId.name: messageId,
        userContactId.name: userContactId,
        conversationId.name: conversationId,
      };
  Multimedia fromMap(Map map) {
    Multimedia model = Multimedia();
    model.id = adapter.parseValue(map['id']);
    model.localFullFileUrl = adapter.parseValue(map['local_full_file_url']);
    model.localThumbnailUrl = adapter.parseValue(map['local_thumbnail_url']);
    model.remoteThumbnailUrl = adapter.parseValue(map['remote_thumbnail_url']);
    model.remoteFullFileUrl = adapter.parseValue(map['remote_full_file_url']);
    model.imageDataId = adapter.parseValue(map['image_data_id']);
    model.imageFileId = adapter.parseValue(map['image_file_id']);
    model.messageId = adapter.parseValue(map['message_id']);
    model.userContactId = adapter.parseValue(map['user_contact_id']);
    model.conversationId = adapter.parseValue(map['conversation_id']);

    return model;
  }

  List<SetColumn> toSetColumns(Multimedia model,
      {bool update = false, Set<String> only, bool onlyNonNull = false}) {
    List<SetColumn> ret = [];

    if (only == null && !onlyNonNull) {
      ret.add(id.set(model.id));
      ret.add(localFullFileUrl.set(model.localFullFileUrl));
      ret.add(localThumbnailUrl.set(model.localThumbnailUrl));
      ret.add(remoteThumbnailUrl.set(model.remoteThumbnailUrl));
      ret.add(remoteFullFileUrl.set(model.remoteFullFileUrl));
      ret.add(imageDataId.set(model.imageDataId));
      ret.add(imageFileId.set(model.imageFileId));
      ret.add(messageId.set(model.messageId));
      ret.add(userContactId.set(model.userContactId));
      ret.add(conversationId.set(model.conversationId));
    } else if (only != null) {
      if (only.contains(id.name)) ret.add(id.set(model.id));
      if (only.contains(localFullFileUrl.name))
        ret.add(localFullFileUrl.set(model.localFullFileUrl));
      if (only.contains(localThumbnailUrl.name))
        ret.add(localThumbnailUrl.set(model.localThumbnailUrl));
      if (only.contains(remoteThumbnailUrl.name))
        ret.add(remoteThumbnailUrl.set(model.remoteThumbnailUrl));
      if (only.contains(remoteFullFileUrl.name))
        ret.add(remoteFullFileUrl.set(model.remoteFullFileUrl));
      if (only.contains(imageDataId.name))
        ret.add(imageDataId.set(model.imageDataId));
      if (only.contains(imageFileId.name))
        ret.add(imageFileId.set(model.imageFileId));
      if (only.contains(messageId.name))
        ret.add(messageId.set(model.messageId));
      if (only.contains(userContactId.name))
        ret.add(userContactId.set(model.userContactId));
      if (only.contains(conversationId.name))
        ret.add(conversationId.set(model.conversationId));
    } else /* if (onlyNonNull) */ {
      if (model.id != null) {
        ret.add(id.set(model.id));
      }
      if (model.localFullFileUrl != null) {
        ret.add(localFullFileUrl.set(model.localFullFileUrl));
      }
      if (model.localThumbnailUrl != null) {
        ret.add(localThumbnailUrl.set(model.localThumbnailUrl));
      }
      if (model.remoteThumbnailUrl != null) {
        ret.add(remoteThumbnailUrl.set(model.remoteThumbnailUrl));
      }
      if (model.remoteFullFileUrl != null) {
        ret.add(remoteFullFileUrl.set(model.remoteFullFileUrl));
      }
      if (model.imageDataId != null) {
        ret.add(imageDataId.set(model.imageDataId));
      }
      if (model.imageFileId != null) {
        ret.add(imageFileId.set(model.imageFileId));
      }
      if (model.messageId != null) {
        ret.add(messageId.set(model.messageId));
      }
      if (model.userContactId != null) {
        ret.add(userContactId.set(model.userContactId));
      }
      if (model.conversationId != null) {
        ret.add(conversationId.set(model.conversationId));
      }
    }

    return ret;
  }

  Future<void> createTable({bool ifNotExists = false}) async {
    final st = Sql.create(tableName, ifNotExists: ifNotExists);
    st.addStr(id.name, primary: true, isNullable: false);
    st.addStr(localFullFileUrl.name, isNullable: true);
    st.addStr(localThumbnailUrl.name, isNullable: true);
    st.addStr(remoteThumbnailUrl.name, isNullable: true);
    st.addStr(remoteFullFileUrl.name, isNullable: true);
    st.addStr(imageDataId.name, isNullable: true);
    st.addStr(imageFileId.name, isNullable: true);
    st.addStr(messageId.name, isNullable: true);
    st.addStr(userContactId.name, isNullable: true);
    st.addStr(conversationId.name, isNullable: true);
    return adapter.createTable(st);
  }

  Future<dynamic> insert(Multimedia model,
      {bool cascade = false,
      bool onlyNonNull = false,
      Set<String> only}) async {
    final Insert insert = inserter
        .setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));
    return adapter.insert(insert);
  }

  Future<void> insertMany(List<Multimedia> models,
      {bool onlyNonNull = false, Set<String> only}) async {
    final List<List<SetColumn>> data = models
        .map((model) =>
            toSetColumns(model, only: only, onlyNonNull: onlyNonNull))
        .toList();
    final InsertMany insert = inserters.addAll(data);
    await adapter.insertMany(insert);
    return;
  }

  Future<dynamic> upsert(Multimedia model,
      {bool cascade = false,
      Set<String> only,
      bool onlyNonNull = false}) async {
    final Upsert upsert = upserter
        .setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));
    return adapter.upsert(upsert);
  }

  Future<void> upsertMany(List<Multimedia> models,
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

  Future<int> update(Multimedia model,
      {bool cascade = false,
      bool associate = false,
      Set<String> only,
      bool onlyNonNull = false}) async {
    final Update update = updater
        .where(this.id.eq(model.id))
        .setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));
    return adapter.update(update);
  }

  Future<void> updateMany(List<Multimedia> models,
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

  Future<Multimedia> find(String id,
      {bool preload = false, bool cascade = false}) async {
    final Find find = finder.where(this.id.eq(id));
    return await findOne(find);
  }

  Future<int> remove(String id) async {
    final Remove remove = remover.where(this.id.eq(id));
    return adapter.remove(remove);
  }

  Future<int> removeMany(List<Multimedia> models) async {
// Return if models is empty. If this is not done, all records will be removed!
    if (models == null || models.isEmpty) return 0;
    final Remove remove = remover;
    for (final model in models) {
      remove.or(this.id.eq(model.id));
    }
    return adapter.remove(remove);
  }
}
