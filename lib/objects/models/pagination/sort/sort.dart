import 'package:json_annotation/json_annotation.dart';
import 'package:lombok/lombok.dart';
import 'package:snschat_flutter/objects/models/index.dart';

part 'sort.g.dart';

@data
@JsonSerializable()
class Sort {

  @JsonKey(name: 'orders')
  List<Order> orders;

  Sort({this.orders});


  factory Sort.fromJson(Map<String, dynamic> json) => _$SortFromJson(json);

  Map<String, dynamic> toJson() => _$SortToJson(this);
}