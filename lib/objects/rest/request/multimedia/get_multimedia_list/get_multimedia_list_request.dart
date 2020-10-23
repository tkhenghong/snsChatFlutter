import 'package:json_annotation/json_annotation.dart';
import 'package:lombok/lombok.dart';

part 'get_multimedia_list_request.g.dart';

@data
@JsonSerializable()
class GetMultimediaListRequest {
  @JsonKey(name: 'multimediaList')
  List<String> multimediaList;

  GetMultimediaListRequest({this.multimediaList});

  factory GetMultimediaListRequest.fromJson(Map<String, dynamic> json) => _$GetMultimediaListRequestFromJson(json);

  Map<String, dynamic> toJson() => _$GetMultimediaListRequestToJson(this);
}