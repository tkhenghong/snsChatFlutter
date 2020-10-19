import 'package:json_annotation/json_annotation.dart';
import 'package:lombok/lombok.dart';
import 'package:snschat_flutter/objects/models/index.dart';

part 'order.g.dart';

@data
@JsonSerializable()
class Order {
  @JsonKey(name: 'direction')
  Direction direction;

  @JsonKey(name: 'property')
  String property;

  @JsonKey(name: 'ignoreCase')
  bool ignoreCase;

  @JsonKey(name: 'nullHandling')
  NullHandling nullHandling;

  Order({this.direction, this.property, this.ignoreCase = false, this.nullHandling = NullHandling.NATIVE});

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);

  Map<String, dynamic> toJson() => _$OrderToJson(this);
}
