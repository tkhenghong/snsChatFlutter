// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ip_geo_location_currency.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IPGeoLocationCurrency _$IPGeoLocationCurrencyFromJson(
    Map<String, dynamic> json) {
  return IPGeoLocationCurrency(
    code: json['code'] as String,
    name: json['name'] as String,
    symbol: json['symbol'] as String,
  );
}

Map<String, dynamic> _$IPGeoLocationCurrencyToJson(
        IPGeoLocationCurrency instance) =>
    <String, dynamic>{
      'code': instance.code,
      'name': instance.name,
      'symbol': instance.symbol,
    };

// **************************************************************************
// DataGenerator
// **************************************************************************

abstract class _$IPGeoLocationCurrencyLombok {
  /// Field
  String code;
  String name;
  String symbol;

  /// Setter

  void setCode(String code) {
    this.code = code;
  }

  void setName(String name) {
    this.name = name;
  }

  void setSymbol(String symbol) {
    this.symbol = symbol;
  }

  /// Getter
  String getCode() {
    return code;
  }

  String getName() {
    return name;
  }

  String getSymbol() {
    return symbol;
  }
}
