// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'page.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Page _$PageFromJson(Map<String, dynamic> json) {
  return Page(
    totalElements: json['totalElements'] as int,
    totalPages: json['totalPages'] as int,
    last: json['last'] as bool,
    size: json['size'] as int,
    number: json['number'] as int,
    numberOfElements: json['numberOfElements'] as int,
    first: json['first'] as bool,
    empty: json['empty'] as bool,
    content: json['content'] as List,
    pageable: json['pageable'] == null
        ? null
        : Pageable.fromJson(json['pageable'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$PageToJson(Page instance) => <String, dynamic>{
      'content': instance.content,
      'pageable': instance.pageable,
      'totalElements': instance.totalElements,
      'totalPages': instance.totalPages,
      'last': instance.last,
      'size': instance.size,
      'number': instance.number,
      'numberOfElements': instance.numberOfElements,
      'first': instance.first,
      'empty': instance.empty,
    };

// **************************************************************************
// DataGenerator
// **************************************************************************

abstract class _$PageLombok {
  /// Field
  List content;
  Pageable pageable;
  int totalElements;
  int totalPages;
  bool last;
  int size;
  int number;
  int numberOfElements;
  bool first;
  bool empty;

  /// Setter

  void setContent(List content) {
    this.content = content;
  }

  void setPageable(Pageable pageable) {
    this.pageable = pageable;
  }

  void setTotalElements(int totalElements) {
    this.totalElements = totalElements;
  }

  void setTotalPages(int totalPages) {
    this.totalPages = totalPages;
  }

  void setLast(bool last) {
    this.last = last;
  }

  void setSize(int size) {
    this.size = size;
  }

  void setNumber(int number) {
    this.number = number;
  }

  void setNumberOfElements(int numberOfElements) {
    this.numberOfElements = numberOfElements;
  }

  void setFirst(bool first) {
    this.first = first;
  }

  void setEmpty(bool empty) {
    this.empty = empty;
  }

  /// Getter
  List getContent() {
    return content;
  }

  Pageable getPageable() {
    return pageable;
  }

  int getTotalElements() {
    return totalElements;
  }

  int getTotalPages() {
    return totalPages;
  }

  bool getLast() {
    return last;
  }

  int getSize() {
    return size;
  }

  int getNumber() {
    return number;
  }

  int getNumberOfElements() {
    return numberOfElements;
  }

  bool getFirst() {
    return first;
  }

  bool getEmpty() {
    return empty;
  }
}
