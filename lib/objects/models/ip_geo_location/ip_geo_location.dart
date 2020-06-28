import 'dart:convert';

import 'package:lombok/lombok.dart';
import 'package:snschat_flutter/general/functions/validation_functions.dart';

import '../index.dart';

@data
class IPGeoLocation {
  String ip;
  String continent_code;
  String continent_name;
  String country_code2;
  String country_code3;
  String country_name;
  String country_capital;
  String state_prov;
  String district;
  String city;
  String zipcode;
  String latitude;
  String longitude;
  bool is_eu;
  String calling_code;
  String country_tld;
  String languages;
  String country_flag;
  String geoname_id;
  String isp;
  String connection_type;
  String organization;
  IPGeoLocationCurrency currency;
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

  factory IPGeoLocation.fromJson(Map<String, dynamic> json) {
    IPGeoLocation ipGeoLocation = IPGeoLocation(
        // timeZone : json['time_zone'],
        calling_code: json['calling_code'],
        city: json['city'],
        connection_type: json['connection_type'],
        continent_code: json['continent_code'],
        continent_name: json['continent_name'],
        country_capital: json['country_capital'],
        country_code2: json['country_code2'],
        country_code3: json['country_code3'],
        country_flag: json['country_flag'],
        country_name: json['country_name'],
        country_tld: json['country_tld'],
        // currency : json['currency'],
        district: json['district'],
        geoname_id: json['geoname_id'],
        ip: json['ip'],
        is_eu: json['is_eu'],
        isp: json['isp'],
        languages: json['languages'],
        latitude: json['latitude'],
        longitude: json['longitude'],
        organization: json['organization'],
        state_prov: json['state_prov'],
        zipcode: json['zipcode']);

    var timeZoneFromJson = json['time_zone'];
    var currencyFromJson = json['currency'];

    IPGeoLocationTimeZone timeZone = IPGeoLocationTimeZone.fromJson(timeZoneFromJson);
    IPGeoLocationCurrency currency = IPGeoLocationCurrency.fromJson(currencyFromJson);

    ipGeoLocation.timeZone = timeZone;
    ipGeoLocation.currency = currency;

    return ipGeoLocation;
  }

  Map<String, dynamic> toJson() => {
        'ip': ip,
        'continent_code': continent_code,
        'continent_name': continent_name,
        'country_code2': country_code2,
        'country_code3': country_code3,
        'country_name': country_name,
        'country_capital': country_capital,
        'state_prov': state_prov,
        'district': district,
        'city': city,
        'zipcode': zipcode,
        'latitude': latitude,
        'longitude': longitude,
        'is_eu': is_eu,
        'calling_code': calling_code,
        'country_tld': country_tld,
        'languages': languages,
        'country_flag': country_flag,
        'geoname_id': geoname_id,
        'isp': isp,
        'connection_type': connection_type,
        'organization': organization,
        'currency': isObjectEmpty(currency) ? null : json.encode(currency.toJson()),
        'time_zone': isObjectEmpty(timeZone) ? null : json.encode(timeZone.toJson()),
      };
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
