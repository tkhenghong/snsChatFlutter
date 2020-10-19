// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Order _$OrderFromJson(Map<String, dynamic> json) {
  return Order(
    direction: _$enumDecodeNullable(_$DirectionEnumMap, json['direction']),
    property: json['property'] as String,
    ignoreCase: json['ignoreCase'] as bool,
    nullHandling:
        _$enumDecodeNullable(_$NullHandlingEnumMap, json['nullHandling']),
  );
}

Map<String, dynamic> _$OrderToJson(Order instance) => <String, dynamic>{
      'direction': _$DirectionEnumMap[instance.direction],
      'property': instance.property,
      'ignoreCase': instance.ignoreCase,
      'nullHandling': _$NullHandlingEnumMap[instance.nullHandling],
    };

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$DirectionEnumMap = {
  Direction.ASC: 'ASC',
  Direction.DESC: 'DESC',
};

const _$NullHandlingEnumMap = {
  NullHandling.NATIVE: 'NATIVE',
  NullHandling.NULLS_FIRST: 'NULLS_FIRST',
  NullHandling.NULLS_LAST: 'NULLS_LAST',
};

// **************************************************************************
// DataGenerator
// **************************************************************************

abstract class _$OrderLombok {
  /// Field
  Direction direction;
  String property;
  bool ignoreCase;
  NullHandling nullHandling;

  /// Setter

  void setDirection(Direction direction) {
    this.direction = direction;
  }

  void setProperty(String property) {
    this.property = property;
  }

  void setIgnoreCase(bool ignoreCase) {
    this.ignoreCase = ignoreCase;
  }

  void setNullHandling(NullHandling nullHandling) {
    this.nullHandling = nullHandling;
  }

  /// Getter
  Direction getDirection() {
    return direction;
  }

  String getProperty() {
    return property;
  }

  bool getIgnoreCase() {
    return ignoreCase;
  }

  NullHandling getNullHandling() {
    return nullHandling;
  }
}
