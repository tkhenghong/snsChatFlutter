import 'package:flutter/material.dart';

// A model to have a name and the values for the date range.
// Not using JSON annotations as DateTimeRange cannot be serialized.
class DateRange {
  String name;

  DateTimeRange dateTimeRange;

  DateRange({this.name, this.dateTimeRange});
}
