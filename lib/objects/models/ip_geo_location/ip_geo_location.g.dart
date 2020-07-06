// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ip_geo_location.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IPGeoLocation _$IPGeoLocationFromJson(Map<String, dynamic> json) {
  return IPGeoLocation(
    timeZone: json['timeZone'] == null
        ? null
        : IPGeoLocationTimeZone.fromJson(
            json['timeZone'] as Map<String, dynamic>),
    calling_code: json['calling_code'] as String,
    city: json['city'] as String,
    connection_type: json['connection_type'] as String,
    continent_code: json['continent_code'] as String,
    continent_name: json['continent_name'] as String,
    country_capital: json['country_capital'] as String,
    country_code2: json['country_code2'] as String,
    country_code3: json['country_code3'] as String,
    country_flag: json['country_flag'] as String,
    country_name: json['country_name'] as String,
    country_tld: json['country_tld'] as String,
    currency: json['currency'] == null
        ? null
        : IPGeoLocationCurrency.fromJson(
            json['currency'] as Map<String, dynamic>),
    district: json['district'] as String,
    geoname_id: json['geoname_id'] as String,
    ip: json['ip'] as String,
    is_eu: json['is_eu'] as bool,
    isp: json['isp'] as String,
    languages: json['languages'] as String,
    latitude: json['latitude'] as String,
    longitude: json['longitude'] as String,
    organization: json['organization'] as String,
    state_prov: json['state_prov'] as String,
    zipcode: json['zipcode'] as String,
  );
}

Map<String, dynamic> _$IPGeoLocationToJson(IPGeoLocation instance) =>
    <String, dynamic>{
      'ip': instance.ip,
      'continent_code': instance.continent_code,
      'continent_name': instance.continent_name,
      'country_code2': instance.country_code2,
      'country_code3': instance.country_code3,
      'country_name': instance.country_name,
      'country_capital': instance.country_capital,
      'state_prov': instance.state_prov,
      'district': instance.district,
      'city': instance.city,
      'zipcode': instance.zipcode,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'is_eu': instance.is_eu,
      'calling_code': instance.calling_code,
      'country_tld': instance.country_tld,
      'languages': instance.languages,
      'country_flag': instance.country_flag,
      'geoname_id': instance.geoname_id,
      'isp': instance.isp,
      'connection_type': instance.connection_type,
      'organization': instance.organization,
      'currency': instance.currency,
      'timeZone': instance.timeZone,
    };

// **************************************************************************
// DataGenerator
// **************************************************************************

abstract class _$IPGeoLocationLombok {
  /// Field
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

  /// Setter

  void setIp(String ip) {
    this.ip = ip;
  }

  void setContinent_code(String continent_code) {
    this.continent_code = continent_code;
  }

  void setContinent_name(String continent_name) {
    this.continent_name = continent_name;
  }

  void setCountry_code2(String country_code2) {
    this.country_code2 = country_code2;
  }

  void setCountry_code3(String country_code3) {
    this.country_code3 = country_code3;
  }

  void setCountry_name(String country_name) {
    this.country_name = country_name;
  }

  void setCountry_capital(String country_capital) {
    this.country_capital = country_capital;
  }

  void setState_prov(String state_prov) {
    this.state_prov = state_prov;
  }

  void setDistrict(String district) {
    this.district = district;
  }

  void setCity(String city) {
    this.city = city;
  }

  void setZipcode(String zipcode) {
    this.zipcode = zipcode;
  }

  void setLatitude(String latitude) {
    this.latitude = latitude;
  }

  void setLongitude(String longitude) {
    this.longitude = longitude;
  }

  void setIs_eu(bool is_eu) {
    this.is_eu = is_eu;
  }

  void setCalling_code(String calling_code) {
    this.calling_code = calling_code;
  }

  void setCountry_tld(String country_tld) {
    this.country_tld = country_tld;
  }

  void setLanguages(String languages) {
    this.languages = languages;
  }

  void setCountry_flag(String country_flag) {
    this.country_flag = country_flag;
  }

  void setGeoname_id(String geoname_id) {
    this.geoname_id = geoname_id;
  }

  void setIsp(String isp) {
    this.isp = isp;
  }

  void setConnection_type(String connection_type) {
    this.connection_type = connection_type;
  }

  void setOrganization(String organization) {
    this.organization = organization;
  }

  void setCurrency(IPGeoLocationCurrency currency) {
    this.currency = currency;
  }

  void setTimeZone(IPGeoLocationTimeZone timeZone) {
    this.timeZone = timeZone;
  }

  /// Getter
  String getIp() {
    return ip;
  }

  String getContinent_code() {
    return continent_code;
  }

  String getContinent_name() {
    return continent_name;
  }

  String getCountry_code2() {
    return country_code2;
  }

  String getCountry_code3() {
    return country_code3;
  }

  String getCountry_name() {
    return country_name;
  }

  String getCountry_capital() {
    return country_capital;
  }

  String getState_prov() {
    return state_prov;
  }

  String getDistrict() {
    return district;
  }

  String getCity() {
    return city;
  }

  String getZipcode() {
    return zipcode;
  }

  String getLatitude() {
    return latitude;
  }

  String getLongitude() {
    return longitude;
  }

  bool getIs_eu() {
    return is_eu;
  }

  String getCalling_code() {
    return calling_code;
  }

  String getCountry_tld() {
    return country_tld;
  }

  String getLanguages() {
    return languages;
  }

  String getCountry_flag() {
    return country_flag;
  }

  String getGeoname_id() {
    return geoname_id;
  }

  String getIsp() {
    return isp;
  }

  String getConnection_type() {
    return connection_type;
  }

  String getOrganization() {
    return organization;
  }

  IPGeoLocationCurrency getCurrency() {
    return currency;
  }

  IPGeoLocationTimeZone getTimeZone() {
    return timeZone;
  }
}
