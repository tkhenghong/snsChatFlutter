import 'package:json_annotation/json_annotation.dart';
import 'package:lombok/lombok.dart';
import 'package:snschat_flutter/objects/models/index.dart';

part 'pageable.g.dart';

@data
@JsonSerializable()
class Pageable {
  @JsonKey(name: 'sort')
  Sort sort;

  @JsonKey(name: 'page')
  int page;

  @JsonKey(name: 'size')
  int size;

  final Sort defaultSort = Sort(orders: [Order(direction: Direction.ASC, property: 'lastModifiedDate')]);

  Pageable({this.sort, this.page, this.size});

  factory Pageable.fromJson(Map<String, dynamic> json) => _$PageableFromJson(json);

  Map<String, dynamic> toJson() => _$PageableToJson(this);
}
