// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pageable.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Pageable _$PageableFromJson(Map<String, dynamic> json) {
  return Pageable(
    sort: json['sort'] == null
        ? null
        : Sort.fromJson(json['sort'] as Map<String, dynamic>),
    page: json['page'] as int,
    size: json['size'] as int,
  );
}

Map<String, dynamic> _$PageableToJson(Pageable instance) => <String, dynamic>{
      'sort': instance.sort,
      'page': instance.page,
      'size': instance.size,
    };

// **************************************************************************
// DataGenerator
// **************************************************************************

abstract class _$PageableLombok {
  /// Field
  Sort sort;
  int page;
  int size;
  Sort defaultSort;

  /// Setter

  void setSort(Sort sort) {
    this.sort = sort;
  }

  void setPage(int page) {
    this.page = page;
  }

  void setSize(int size) {
    this.size = size;
  }

  /// Getter
  Sort getSort() {
    return sort;
  }

  int getPage() {
    return page;
  }

  int getSize() {
    return size;
  }

  Sort getDefaultSort() {
    return defaultSort;
  }
}
