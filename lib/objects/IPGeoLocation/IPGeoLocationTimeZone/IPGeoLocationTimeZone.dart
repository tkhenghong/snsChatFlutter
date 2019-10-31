class IPGeoLocationTimeZone {
  String name;
  int offset;
  String current_time;
  double current_time_unix;
  bool is_dst;
  int dst_savings;

  IPGeoLocationTimeZone({this.name, this.current_time, this.current_time_unix, this.dst_savings, this.is_dst, this.offset});

  IPGeoLocationTimeZone.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        current_time = json['current_time'],
        current_time_unix = json['current_time_unix'],
        dst_savings = json['dst_savings'],
        is_dst = json['is_dst'],
        offset = json['offset'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'current_time': current_time,
        'current_time_unix': current_time_unix,
        'dst_savings': dst_savings,
        'is_dst': is_dst,
        'offset': offset,
      };
}
