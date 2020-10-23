// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_multimedia_list_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetMultimediaListRequest _$GetMultimediaListRequestFromJson(
    Map<String, dynamic> json) {
  return GetMultimediaListRequest(
    multimediaList:
        (json['multimediaList'] as List)?.map((e) => e as String)?.toList(),
  );
}

Map<String, dynamic> _$GetMultimediaListRequestToJson(
        GetMultimediaListRequest instance) =>
    <String, dynamic>{
      'multimediaList': instance.multimediaList,
    };

// **************************************************************************
// DataGenerator
// **************************************************************************

abstract class _$GetMultimediaListRequestLombok {
  /// Field
  List<String> multimediaList;

  /// Setter

  void setMultimediaList(List<String> multimediaList) {
    this.multimediaList = multimediaList;
  }

  /// Getter
  List<String> getMultimediaList() {
    return multimediaList;
  }
}
