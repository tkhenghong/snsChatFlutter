import 'package:json_annotation/json_annotation.dart';
import 'package:lombok/lombok.dart';
import 'package:snschat_flutter/objects/models/index.dart';

part 'page_info.g.dart';

/// Based on Page object's implementation of Spring Boot.
@data
@JsonSerializable()
class PageInfo {

  @JsonKey(name: 'content')
  List<dynamic> content;

  @JsonKey(name: 'pageable')
  Pageable pageable;

  @JsonKey(name: 'totalElements')
  int totalElements;

  @JsonKey(name: 'totalPages')
  int totalPages;

  @JsonKey(name: 'last')
  bool last;

  @JsonKey(name: 'size')
  int size;

  @JsonKey(name: 'number')
  int number;

  @JsonKey(name: 'numberOfElements')
  int numberOfElements;

  @JsonKey(name: 'first')
  bool first;

  @JsonKey(name: 'empty')
  bool empty;

  PageInfo({this.totalElements, this.totalPages, this.last, this.size, this.number, this.numberOfElements, this.first, this.empty, this.content, this.pageable});

  factory PageInfo.fromJson(Map<String, dynamic> json) => _$PageInfoFromJson(json);

  Map<String, dynamic> toJson() => _$PageInfoToJson(this);
}
