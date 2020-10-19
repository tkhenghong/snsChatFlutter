// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sort.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Sort _$SortFromJson(Map<String, dynamic> json) {
  return Sort(
    orders: (json['orders'] as List)
        ?.map(
            (e) => e == null ? null : Order.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$SortToJson(Sort instance) => <String, dynamic>{
      'orders': instance.orders,
    };

// **************************************************************************
// DataGenerator
// **************************************************************************

abstract class _$SortLombok {
  /// Field
  List<Order> orders;

  /// Setter

  void setOrders(List<Order> orders) {
    this.orders = orders;
  }

  /// Getter
  List<Order> getOrders() {
    return orders;
  }
}
