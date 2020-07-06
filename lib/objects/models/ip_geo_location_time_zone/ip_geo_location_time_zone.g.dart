// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ip_geo_location_time_zone.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IPGeoLocationTimeZone _$IPGeoLocationTimeZoneFromJson(
    Map<String, dynamic> json) {
  return IPGeoLocationTimeZone(
    name: json['name'] as String,
    current_time: json['current_time'] as String,
    current_time_unix: (json['current_time_unix'] as num)?.toDouble(),
    dst_savings: json['dst_savings'] as int,
    is_dst: json['is_dst'] as bool,
    offset: json['offset'] as int,
  );
}

Map<String, dynamic> _$IPGeoLocationTimeZoneToJson(
        IPGeoLocationTimeZone instance) =>
    <String, dynamic>{
      'name': instance.name,
      'offset': instance.offset,
      'current_time': instance.current_time,
      'current_time_unix': instance.current_time_unix,
      'is_dst': instance.is_dst,
      'dst_savings': instance.dst_savings,
    };

// **************************************************************************
// DataGenerator
// **************************************************************************

abstract class _$IPGeoLocationTimeZoneLombok {
  /// Field
  String name;
  int offset;
  String current_time;
  double current_time_unix;
  bool is_dst;
  int dst_savings;

  /// Setter

  void setName(String name) {
    this.name = name;
  }

  void setOffset(int offset) {
    this.offset = offset;
  }

  void setCurrent_time(String current_time) {
    this.current_time = current_time;
  }

  void setCurrent_time_unix(double current_time_unix) {
    this.current_time_unix = current_time_unix;
  }

  void setIs_dst(bool is_dst) {
    this.is_dst = is_dst;
  }

  void setDst_savings(int dst_savings) {
    this.dst_savings = dst_savings;
  }

  /// Getter
  String getName() {
    return name;
  }

  int getOffset() {
    return offset;
  }

  String getCurrent_time() {
    return current_time;
  }

  double getCurrent_time_unix() {
    return current_time_unix;
  }

  bool getIs_dst() {
    return is_dst;
  }

  int getDst_savings() {
    return dst_savings;
  }
}
