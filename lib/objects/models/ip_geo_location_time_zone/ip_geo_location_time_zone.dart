import 'package:json_annotation/json_annotation.dart';
import 'package:lombok/lombok.dart';

part 'ip_geo_location_time_zone.g.dart';

@data
@JsonSerializable()
class IPGeoLocationTimeZone {
  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'offset')
  int offset;

  @JsonKey(name: 'current_time')
  String current_time;

  @JsonKey(name: 'current_time_unix')
  double current_time_unix;

  @JsonKey(name: 'is_dst')
  bool is_dst;

  @JsonKey(name: 'dst_savings')
  int dst_savings;

  IPGeoLocationTimeZone({this.name, this.current_time, this.current_time_unix, this.dst_savings, this.is_dst, this.offset});

  factory IPGeoLocationTimeZone.fromJson(Map<String, dynamic> json) => _$IPGeoLocationTimeZoneFromJson(json);

  Map<String, dynamic> toJson() => _$IPGeoLocationTimeZoneToJson(this);
}
