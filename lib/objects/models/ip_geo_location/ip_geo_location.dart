import 'package:json_annotation/json_annotation.dart';
import 'package:lombok/lombok.dart';

import '../index.dart';

part 'ip_geo_location.g.dart';

@data
@JsonSerializable()
class IPGeoLocation {
  @JsonKey(name: 'ip')
  String ip;

  @JsonKey(name: 'continent_code')
  String continent_code;

  @JsonKey(name: 'continent_name')
  String continent_name;

  @JsonKey(name: 'country_code2')
  String country_code2;

  @JsonKey(name: 'country_code3')
  String country_code3;

  @JsonKey(name: 'country_name')
  String country_name;

  @JsonKey(name: 'country_capital')
  String country_capital;

  @JsonKey(name: 'state_prov')
  String state_prov;

  @JsonKey(name: 'district')
  String district;

  @JsonKey(name: 'city')
  String city;

  @JsonKey(name: 'zipcode')
  String zipcode;

  @JsonKey(name: 'latitude')
  String latitude;

  @JsonKey(name: 'longitude')
  String longitude;

  @JsonKey(name: 'is_eu')
  bool is_eu;

  @JsonKey(name: 'calling_code')
  String calling_code;

  @JsonKey(name: 'country_tld')
  String country_tld;

  @JsonKey(name: 'languages')
  String languages;

  @JsonKey(name: 'country_flag')
  String country_flag;

  @JsonKey(name: 'geoname_id')
  String geoname_id;

  @JsonKey(name: 'isp')
  String isp;

  @JsonKey(name: 'connection_type')
  String connection_type;

  @JsonKey(name: 'organization')
  String organization;

  @JsonKey(name: 'currency')
  IPGeoLocationCurrency currency;

  @JsonKey(name: 'timeZone')
  IPGeoLocationTimeZone timeZone;

  IPGeoLocation(
      {this.timeZone,
      this.calling_code,
      this.city,
      this.connection_type,
      this.continent_code,
      this.continent_name,
      this.country_capital,
      this.country_code2,
      this.country_code3,
      this.country_flag,
      this.country_name,
      this.country_tld,
      this.currency,
      this.district,
      this.geoname_id,
      this.ip,
      this.is_eu,
      this.isp,
      this.languages,
      this.latitude,
      this.longitude,
      this.organization,
      this.state_prov,
      this.zipcode});

  factory IPGeoLocation.fromJson(Map<String, dynamic> json) => _$IPGeoLocationFromJson(json);

  Map<String, dynamic> toJson() => _$IPGeoLocationToJson(this);
}

// {
//   "ip":"60.49.60.41",
//   "continent_code":"AS",
//   "continent_name":"Asia",
//   "country_code2":"MY",
//   "country_code3":"MYS",
//   "country_name":"Malaysia",
//   "country_capital":"Kuala Lumpur",
//   "state_prov":"Wilayah Persekutuan",
//   "district":"KL Sentral",
//   "city":"Kuala Lumpur",
//   "zipcode":"50470",
//   "latitude":"3.13675",
//   "longitude":"101.69100",
//   "is_eu":false,
//   "calling_code":"+60",
//   "country_tld":".my",
//   "languages":"ms-MY,en,zh,ta,te,ml,pa,th",
//   "country_flag":"https://ipgeolocation.io/static/flags/my_64.png",
//   "geoname_id":"1735161",
//   "isp":"Tmnet, Telekom Malaysia Bhd.",
//   "connection_type":"dsl",
//   "organization":"Tmnet, Telekom Malaysia Bhd.",
//   "currency":{
//      "code":"MYR",
//      "name":"Malaysian Ringgit",
//      "symbol":"RM"
//   },
//   "time_zone":{
//      "name":"Asia/Kuala_Lumpur",
//      "offset":8,
//      "current_time":"2019-10-31 14:14:40.206+0800",
//      "current_time_unix":1572502480.206,
//      "is_dst":false,
//      "dst_savings":0
//   }
//}
// This object is used to get the full details of the IPGeoLocation object returned by https://ipgeolocation.io/
