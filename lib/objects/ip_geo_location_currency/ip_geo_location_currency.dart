import 'package:lombok/lombok.dart';

@data
class IPGeoLocationCurrency {
  String code;
  String name;
  String symbol;

  IPGeoLocationCurrency({this.code, this.name, this.symbol});

  IPGeoLocationCurrency.fromJson(Map<String, dynamic> json)
      : code = json['code'],
        name = json['name'],
        symbol = json['symbol'];

  Map<String, dynamic> toJson() => {
        'code': code,
        'name': name,
        'symbol': symbol,
      };
}
