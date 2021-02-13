import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';

import 'package:snschat_flutter/general/index.dart';
import 'package:snschat_flutter/objects/models/index.dart';

class DateRangePicker extends StatefulWidget {
  final DateRange selectedDateRange;
  final Function(DateRange) onDateRangeSelected;
  final Function(DateRange) onCustomDateRangeSelected;

  DateRangePicker({this.selectedDateRange, this.onDateRangeSelected, this.onCustomDateRangeSelected});

  @override
  State<StatefulWidget> createState() {
    return new DateRangePickerState();
  }
}

class DateRangePickerState extends State<DateRangePicker> {
  DateFormat dateFormat = DateFormat('d MMM yy');

  Map<int, DateRange> dateRanges2 = Map();

  DateRange selectedDateRange = dateRanges.first;
  int selectedDateRangeIndex = 0;

  ShapeBorder fullRoundedBorder = RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0));
  EdgeInsets labelsPadding = EdgeInsets.symmetric(vertical: Get.height * 0.03);
  EdgeInsets buttonsPadding = EdgeInsets.symmetric(horizontal: Get.width * 0.01);
  Color activeColor = Color(0xFFDDE5FE);
  Color notActiveColor = Color(0xFFF6F6F6);
  Color customBlueColor = Color(0xFF000DAE);
  TextStyle dateRangeLabelTextStyle = TextStyle();
  TextStyle customDateRangeLabelTextStyle = TextStyle();
  TextStyle dateRangeButtonTextStyle = TextStyle(color: Color(0xFF000DAE));

  @override
  void initState() {
    super.initState();
    assignDateRanges();
    setupSelectedDateRange();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * 0.5,
      child: Material(
        color: Get.theme.canvasColor,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Get.width * 0.03),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  dateRangeLabel(),
                  Spacer(),
                  closeButton(),
                ],
              ),
              dateRangeWidgets(),
              line(),
              customDateRangeLabel(),
              customDateRanges(),
            ],
          ),
        ),
      ),
    );
  }

  Widget dateRangeLabel() {
    return Padding(
      padding: labelsPadding,
      child: Text(
        'Transaction history up to 90 days only',
        style: dateRangeLabelTextStyle,
      ),
    );
  }

  Widget closeButton() {
    return IconButton(
      icon: Icon(
        Icons.close,
        color: customBlueColor,
      ),
      onPressed: goBack,
    );
  }

  Widget customDateRangeLabel() {
    return Padding(
      padding: labelsPadding,
      child: Text(
        'Custom date range',
        style: customDateRangeLabelTextStyle,
      ),
    );
  }

  Widget dateRangeWidgets() {
    List<Widget> firstRowWidgets = [];
    List<Widget> secondRowWidgets = [];

    for (int i = 0; i < 3; i++) {
      firstRowWidgets.add(dateRangeTag(i, dateRanges2[i]));
    }

    for (int i = 3; i < dateRanges2.length; i++) {
      secondRowWidgets.add(dateRangeTag(i, dateRanges2[i]));
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: firstRowWidgets,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: secondRowWidgets,
        ),
      ],
    );
  }

  bool isSelected(int index) {
    return selectedDateRangeIndex == index;
  }

  Widget dateRangeTag(int index, DateRange dateRange) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: Get.width * 0.01),
        child: RaisedButton(
          elevation: 0.0,
          focusElevation: 0.0,
          color: isSelected(index) ? activeColor : notActiveColor,
          padding: EdgeInsets.symmetric(horizontal: Get.width * 0.01),
          child: Text(
            dateRange.name,
            style: TextStyle(
              fontSize: 12.0,
              color: isSelected(index) ? Color(0xFF000DAE) : Color(0xFFB5B5B5),
            ),
          ),
          onPressed: () {
            setDateRange(index);
            widget.onDateRangeSelected(dateRanges2[index]);
          },
        ),
      ),
    );
  }

  Widget customDateRanges() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        customStartDateButton(),
        Text(
          '-',
          style: dateRangeButtonTextStyle,
        ),
        customEndDateButton(),
      ],
    );
  }

  Widget customStartDateButton() {
    return Expanded(
      child: Padding(
        padding: buttonsPadding,
        child: RaisedButton(
            padding: buttonsPadding,
            elevation: 0.0,
            color: activeColor,
            focusElevation: 0.0,
            highlightColor: Colors.transparent,
            onPressed: setCustomDateRange,
            child: Text(
              dateFormat.format(selectedDateRange.dateTimeRange.start.toLocal()),
              style: dateRangeButtonTextStyle,
            )),
      ),
    );
  }

  Widget customEndDateButton() {
    return Expanded(
      child: Padding(
        padding: buttonsPadding,
        child: RaisedButton(
            padding: buttonsPadding,
            elevation: 0.0,
            color: activeColor,
            focusElevation: 0.0,
            highlightColor: Colors.transparent,
            onPressed: setCustomDateRange,
            child: Text(
              dateFormat.format(selectedDateRange.dateTimeRange.end.toLocal()),
              style: dateRangeButtonTextStyle,
            )),
      ),
    );
  }

  Widget line() {
    return Container(decoration: BoxDecoration(border: Border(bottom: BorderSide(color: notActiveColor, width: 1.0))));
  }

  assignDateRanges() {
    for (int i = 0; i < dateRanges.length; i++) {
      dateRanges2.putIfAbsent(i, () => dateRanges[i]);
    }
  }

  setupSelectedDateRange() {
    for (int i = 0; i < dateRanges.length; i++) {
      if (widget.selectedDateRange == dateRanges[i]) {
        setDateRange(i);
      }
    }
  }

  int isDateRangePredefined(DateTimeRange dateTimeRange) {
    for (int i = 0; i < dateRanges.length; i++) {
      if (dateTimeRange == dateRanges2[i].dateTimeRange) {
        return i;
      }
    }
    return -1;
  }

  setDateRange(int index) {
    setState(() {
      selectedDateRange = dateRanges2[index];
      selectedDateRangeIndex = index;
    });
  }

  setCustomDateRange() async {
    DateRange customDateRange;
    DateTimeRange dateTimeRange = await showDateRangePicker(
      context: Get.context,
      currentDate: selectedDateRange.dateTimeRange.end,
      firstDate: Jiffy().subtract(days: 90),
      lastDate: DateTime.now(),
    );

    if (!isObjectEmpty(dateTimeRange)) {
      DateTimeRange readjustedDateTimeRange = DateTimeRange(start: Jiffy(dateTimeRange.start).startOf(Units.DAY), end: Jiffy(dateTimeRange.end).endOf(Units.DAY));
      int predefinedDateRangeIndex = isDateRangePredefined(readjustedDateTimeRange);
      if (predefinedDateRangeIndex == -1) {
        customDateRange = DateRange(name: 'Custom', dateTimeRange: dateTimeRange);
      } else {
        setDateRange(predefinedDateRangeIndex); // Mark RaisedButtons.
        customDateRange = dateRanges2[predefinedDateRangeIndex];
      }

      widget.onCustomDateRangeSelected(customDateRange);

      // Change custom dates labels.
      setState(() {
        selectedDateRange = customDateRange;
      });
    }
  }

  goBack() {
    Get.back();
  }
}
