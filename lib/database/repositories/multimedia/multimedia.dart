import 'dart:io';
import 'dart:typed_data';

//Jaguar ORM
import 'package:jaguar_query/jaguar_query.dart';
import 'package:jaguar_orm/jaguar_orm.dart';

part 'package:snschat_flutter/database/repositories/multimedia/multimedia.jorm.dart';

class Multimedia {
  // Image, Video, Gifs, Sticker, Recording, links

  Multimedia({this.id, this.localUrl, this.remoteUrl, this.thumbnail, this.imageData, this.imageFile});

  Multimedia.make(this.id, this.localUrl, this.remoteUrl, this.thumbnail, this.imageData, this.imageFile);

  @PrimaryKey()
  String id;

  @Column(isNullable: true)
  String localUrl;

  @Column(isNullable: true)
  String remoteUrl;

  @Column(isNullable: true)
  String thumbnail;

  @Column(isNullable: true)
  String imageData; // Uint8List object

  @Column(isNullable: true)
  String imageFile; // File object

  @override
  String toString() {
    return 'Multimedia{id: $id, localUrl: $localUrl, remoteUrl: $remoteUrl, thumbnail: $thumbnail, imageData: $imageData, imageFile: $imageFile}';
  }


// KS put
// mediaCheckPoint
// mediaPercentage
// But I don't think I really need this, or I need to save this into database

}

@GenBean()
class MultimediaBean extends Bean<Multimedia> with _MultimediaBean {
  MultimediaBean(Adapter adapter) : super(adapter);

  final String tableName = 'multimedia';

  @override
  // TODO: implement fields
  Map<String, Field> get fields => null;

  @override
  Multimedia fromMap(Map map) {
    // TODO: implement fromMap
    return null;
  }

  @override
  List<SetColumn> toSetColumns(Multimedia model, {bool update = false, Set<String> only}) {
    // TODO: implement toSetColumns
    return null;
  }

}




