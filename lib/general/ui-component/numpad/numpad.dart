import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Numpad extends StatelessWidget {
  final Function(int) onNumberPadClicked;
  final Function onRemoveSingleNumber;
  final Function onClearAllNumbers;
  final Function onSubmit;

  final Color buttonsHighlightColor = Colors.transparent;
  final ShapeBorder numPadInkWellShapeBorder = RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0));
  final Decoration numPadShapeDecoration = BoxDecoration(border: Border.all(width: 0.1), borderRadius: BorderRadius.circular(16.0));
  final TextStyle numPadTextStyle = TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold);

  Numpad({this.onNumberPadClicked, this.onRemoveSingleNumber, this.onClearAllNumbers, this.onSubmit});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      // height: Get.height * 0.5,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              number(1),
              number(2),
              number(3),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              number(4),
              number(5),
              number(6),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              number(7),
              number(8),
              number(9),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [removeNumber(), number(0), submit()],
          )
        ],
      ),
    );
  }

  Widget number(int number) {
    return Container(
      width: Get.width * 0.25,
      height: Get.height * 0.1,
      margin: EdgeInsets.all(5.0),
      decoration: numPadShapeDecoration,
      child: InkWell(
        customBorder: numPadInkWellShapeBorder,
        highlightColor: buttonsHighlightColor,
        onTap: () {
          onNumberPadClicked(number);
        },
        child: Center(
          child: Text(
            number.toString(),
            style: numPadTextStyle,
          ),
        ),
      ),
    );
  }

  Widget removeNumber() {
    return Container(
      width: Get.width * 0.25,
      height: Get.height * 0.1,
      margin: EdgeInsets.all(5.0),
      decoration: numPadShapeDecoration,
      child: InkWell(
        customBorder: numPadInkWellShapeBorder,
        highlightColor: buttonsHighlightColor,
        onTap: () {
          onRemoveSingleNumber();
        },
        onLongPress: () {
          onClearAllNumbers();
        },
        child: Center(
          child: Text(
            '<',
            style: numPadTextStyle,
          ),
        ),
      ),
    );
  }

  Widget submit() {
    return Container(
      width: Get.width * 0.25,
      height: Get.height * 0.1,
      margin: EdgeInsets.all(5.0),
      decoration: numPadShapeDecoration,
      child: InkWell(
        customBorder: numPadInkWellShapeBorder,
        highlightColor: buttonsHighlightColor,
        onTap: () {
          onSubmit();
        },
        child: Center(
          child: Text(
            'OK',
            style: numPadTextStyle,
          ),
        ),
      ),
    );
  }
}
