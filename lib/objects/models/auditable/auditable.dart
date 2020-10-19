import 'package:json_annotation/json_annotation.dart';
import 'package:lombok/lombok.dart';

part 'auditable.g.dart';

@data
@JsonSerializable()
class Auditable {
  @JsonKey(name: 'createdBy')
  String createdBy;

  @JsonKey(name: 'createdDate')
  DateTime createdDate;

  @JsonKey(name: 'lastModifiedBy')
  String lastModifiedBy;

  @JsonKey(name: 'lastModifiedDate')
  DateTime lastModifiedDate;

  @JsonKey(name: 'version')
  int version;

  Auditable({this.createdBy, this.createdDate, this.lastModifiedBy, this.lastModifiedDate, this.version});

  factory Auditable.fromJson(Map<String, dynamic> json) => _$AuditableFromJson(json);

  Map<String, dynamic> toJson() => _$AuditableToJson(this);
}
