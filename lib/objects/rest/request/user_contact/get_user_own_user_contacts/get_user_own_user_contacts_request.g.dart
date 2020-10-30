// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_user_own_user_contacts_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetUserOwnUserContactsRequest _$GetUserOwnUserContactsRequestFromJson(
    Map<String, dynamic> json) {
  return GetUserOwnUserContactsRequest(
    searchTerm: json['searchTerm'] as String,
    pageable: json['pageable'] == null
        ? null
        : Pageable.fromJson(json['pageable'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$GetUserOwnUserContactsRequestToJson(
        GetUserOwnUserContactsRequest instance) =>
    <String, dynamic>{
      'searchTerm': instance.searchTerm,
      'pageable': instance.pageable,
    };

// **************************************************************************
// DataGenerator
// **************************************************************************

abstract class _$GetUserOwnUserContactsRequestLombok {
  /// Field
  String searchTerm;
  Pageable pageable;

  /// Setter

  void setSearchTerm(String searchTerm) {
    this.searchTerm = searchTerm;
  }

  void setPageable(Pageable pageable) {
    this.pageable = pageable;
  }

  /// Getter
  String getSearchTerm() {
    return searchTerm;
  }

  Pageable getPageable() {
    return pageable;
  }
}
