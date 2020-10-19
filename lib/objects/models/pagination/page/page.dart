import 'package:json_annotation/json_annotation.dart';
import 'package:lombok/lombok.dart';
import 'package:snschat_flutter/objects/models/index.dart';

part 'page.g.dart';

/// Based on Page object's implementation of Spring Boot.
@data
@JsonSerializable()
class Page {
  @JsonKey(name: 'total')
  int total;

  @JsonKey(name: 'content')
  List<dynamic> content;

  @JsonKey(name: 'pageable')
  Pageable pageable;

  Page({this.total, this.content, this.pageable});

  factory Page.fromJson(Map<String, dynamic> json) => _$PageFromJson(json);

  Map<String, dynamic> toJson() => _$PageToJson(this);
}
