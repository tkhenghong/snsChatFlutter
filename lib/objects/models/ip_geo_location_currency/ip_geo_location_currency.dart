import 'package:json_annotation/json_annotation.dart';
import 'package:lombok/lombok.dart';

part 'ip_geo_location_currency.g.dart';

@data
@JsonSerializable()
class IPGeoLocationCurrency {
  @JsonKey(name: 'code')
  String code;

  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'symbol')
  String symbol;

  IPGeoLocationCurrency({this.code, this.name, this.symbol});

  factory IPGeoLocationCurrency.fromJson(Map<String, dynamic> json) => _$IPGeoLocationCurrencyFromJson(json);

  Map<String, dynamic> toJson() => _$IPGeoLocationCurrencyToJson(this);
}
