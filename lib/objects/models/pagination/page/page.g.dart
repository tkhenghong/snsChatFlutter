// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'page.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Page _$PageFromJson(Map<String, dynamic> json) {
  return Page(
    total: json['total'] as int,
    content: json['content'] as List,
    pageable: json['pageable'] == null
        ? null
        : Pageable.fromJson(json['pageable'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$PageToJson(Page instance) => <String, dynamic>{
      'total': instance.total,
      'content': instance.content,
      'pageable': instance.pageable,
    };

// **************************************************************************
// DataGenerator
// **************************************************************************

abstract class _$PageLombok {
  /// Field
  int total;
  List content;
  Pageable pageable;

  /// Setter

  void setTotal(int total) {
    this.total = total;
  }

  void setContent(List content) {
    this.content = content;
  }

  void setPageable(Pageable pageable) {
    this.pageable = pageable;
  }

  /// Getter
  int getTotal() {
    return total;
  }

  List getContent() {
    return content;
  }

  Pageable getPageable() {
    return pageable;
  }
}
