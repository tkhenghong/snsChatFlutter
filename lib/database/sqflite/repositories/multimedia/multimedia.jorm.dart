// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'multimedia.dart';

// **************************************************************************
// BeanGenerator
// **************************************************************************

abstract class _MultimediaBean implements Bean<Multimedia> {
  final id = StrField('id');
  final localUrl = StrField('local_url');
  final remoteUrl = StrField('remote_url');
  final thumbnail = StrField('thumbnail');
  final imageData = StrField('image_data');
  final imageFile = StrField('image_file');
  Map<String, Field> _fields;
  Map<String, Field> get fields => _fields ??= {
        id.name: id,
        localUrl.name: localUrl,
        remoteUrl.name: remoteUrl,
        thumbnail.name: thumbnail,
        imageData.name: imageData,
        imageFile.name: imageFile,
      };
  Multimedia fromMap(Map map) {
    Multimedia model = Multimedia();
    model.id = adapter.parseValue(map['id']);
    model.localUrl = adapter.parseValue(map['local_url']);
    model.remoteUrl = adapter.parseValue(map['remote_url']);
    model.thumbnail = adapter.parseValue(map['thumbnail']);
    model.imageData = adapter.parseValue(map['image_data']);
    model.imageFile = adapter.parseValue(map['image_file']);

    return model;
  }

  List<SetColumn> toSetColumns(Multimedia model,
      {bool update = false, Set<String> only}) {
    List<SetColumn> ret = [];

    if (only == null) {
      ret.add(id.set(model.id));
      ret.add(localUrl.set(model.localUrl));
      ret.add(remoteUrl.set(model.remoteUrl));
      ret.add(thumbnail.set(model.thumbnail));
      ret.add(imageData.set(model.imageData));
      ret.add(imageFile.set(model.imageFile));
    } else {
      if (only.contains(id.name)) ret.add(id.set(model.id));
      if (only.contains(localUrl.name)) ret.add(localUrl.set(model.localUrl));
      if (only.contains(remoteUrl.name))
        ret.add(remoteUrl.set(model.remoteUrl));
      if (only.contains(thumbnail.name))
        ret.add(thumbnail.set(model.thumbnail));
      if (only.contains(imageData.name))
        ret.add(imageData.set(model.imageData));
      if (only.contains(imageFile.name))
        ret.add(imageFile.set(model.imageFile));
    }

    return ret;
  }

  Future<void> createTable({bool ifNotExists: false}) async {
    final st = Sql.create(tableName, ifNotExists: ifNotExists);
    st.addStr(id.name, primary: true, isNullable: false);
    st.addStr(localUrl.name, isNullable: true);
    st.addStr(remoteUrl.name, isNullable: true);
    st.addStr(thumbnail.name, isNullable: true);
    st.addStr(imageData.name, isNullable: true);
    st.addStr(imageFile.name, isNullable: true);
    return adapter.createTable(st);
  }

  Future<dynamic> insert(Multimedia model) async {
    final Insert insert = inserter.setMany(toSetColumns(model));
    return adapter.insert(insert);
  }

  Future<void> insertMany(List<Multimedia> models) async {
    final List<List<SetColumn>> data =
        models.map((model) => toSetColumns(model)).toList();
    final InsertMany insert = inserters.addAll(data);
    await adapter.insertMany(insert);
    return;
  }

  Future<dynamic> upsert(Multimedia model) async {
    final Upsert upsert = upserter.setMany(toSetColumns(model));
    return adapter.upsert(upsert);
  }

  Future<void> upsertMany(List<Multimedia> models) async {
    final List<List<SetColumn>> data = [];
    for (var i = 0; i < models.length; ++i) {
      var model = models[i];
      data.add(toSetColumns(model).toList());
    }
    final UpsertMany upsert = upserters.addAll(data);
    await adapter.upsertMany(upsert);
    return;
  }

  Future<int> update(Multimedia model, {Set<String> only}) async {
    final Update update = updater
        .where(this.id.eq(model.id))
        .setMany(toSetColumns(model, only: only));
    return adapter.update(update);
  }

  Future<void> updateMany(List<Multimedia> models) async {
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

  Future<Multimedia> find(String id,
      {bool preload: false, bool cascade: false}) async {
    final Find find = finder.where(this.id.eq(id));
    return await findOne(find);
  }

  Future<int> remove(String id) async {
    final Remove remove = remover.where(this.id.eq(id));
    return adapter.remove(remove);
  }

  Future<int> removeMany(List<Multimedia> models) async {
    final Remove remove = remover;
    for (final model in models) {
      remove.or(this.id.eq(model.id));
    }
    return adapter.remove(remove);
  }
}
