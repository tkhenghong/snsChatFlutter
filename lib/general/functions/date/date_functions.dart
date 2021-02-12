import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:snschat_flutter/objects/models/index.dart';

/// Using Jiffy, inspired by Moment.js to format and date manipulations.
/// https://pub.dev/packages/jiffy
List<DateRange> dateRanges = [
  DateRange(
      name: 'Today',
      dateTimeRange: DateTimeRange(
        start: Jiffy().startOf(Units.DAY),
        end: Jiffy().endOf(Units.DAY),
      )),
  DateRange(
    name: 'Yesterday',
    dateTimeRange: DateTimeRange(
        start: (Jiffy()
          ..subtract(days: 1)
          ..startOf(Units.DAY))
            .dateTime,
        end: (Jiffy()
          ..subtract(days: 1)
          ..endOf(Units.DAY))
            .dateTime),
  ),
  DateRange(
    name: 'Last 7 days',
    dateTimeRange: DateTimeRange(
      start: (Jiffy()
        ..subtract(weeks: 1)
        ..startOf(Units.DAY))
          .dateTime,
      end: Jiffy().endOf(Units.DAY),
    ),
  ),
  DateRange(
    name: 'Last 30 days',
    dateTimeRange: DateTimeRange(
      start: (Jiffy()
        ..subtract(days: 30)
        ..startOf(Units.DAY))
          .dateTime,
      end: Jiffy().endOf(Units.DAY),
    ),
  ),
  DateRange(
    name: 'Last 90 days',
    dateTimeRange: DateTimeRange(
      start: (Jiffy()
        ..subtract(days: 90)
        ..startOf(Units.DAY))
          .dateTime,
      end: Jiffy().endOf(Units.DAY),
    ),
  ),
];
