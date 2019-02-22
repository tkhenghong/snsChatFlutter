import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:snschat_flutter/general/functions/validations.dart';

class PinEntryTextField extends StatefulWidget {
  int fields;
  Function onSubmit;
  double fieldWidth;
  double fontSize;
  bool isTextObscure;
  bool showFieldAsBox;

  PinEntryTextField(
      {this.fields: 4,
      this.onSubmit,
      this.fieldWidth: 40.0,
      this.fontSize: 20.0,
      this.isTextObscure: false,
      this.showFieldAsBox: false})
      : assert(fields > 0);

  @override
  State createState() {
    return PinEntryTextFieldState();
  }
}

class PinEntryTextFieldState extends State<PinEntryTextField> {
  List<String> _pin;
  List<FocusNode> _focusNodes;
  List<TextEditingController> _textControllers;

  @override
  void initState() {
    super.initState();
    _pin = List<String>(widget.fields);
    _focusNodes = List<FocusNode>(widget.fields);
    _textControllers = List<TextEditingController>(widget.fields);
  }

  @override
  void dispose() {
    _focusNodes.forEach((FocusNode f) => f.dispose());
    _textControllers.forEach((TextEditingController t) => t.dispose());
  }

  void clearTextFields() {
    _textControllers.forEach(
        (TextEditingController tEditController) => tEditController.clear());
  }

  Widget buildTextField(int i, BuildContext context) {
    _focusNodes[i] = FocusNode();
    _textControllers[i] = TextEditingController();

    return Container(
      width: widget.fieldWidth,
      margin: EdgeInsets.only(right: 10.0),
      child: TextField(
        inputFormatters: [
          new BlacklistingTextInputFormatter(new RegExp('[\\.|\\,]')),
        ],
        key: Key(i.toString()),
        controller: _textControllers[i],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: widget.fontSize),
        focusNode: _focusNodes[i],
        obscureText: widget.isTextObscure,
        decoration: InputDecoration(
            counterText: "",
            border: widget.showFieldAsBox
                ? OutlineInputBorder(borderSide: BorderSide(width: 2.0))
                : null),
        onChanged: (String str) {
          _pin[i] = str;
          if (!isObjectEmpty(str)) {
            if (_pin[_pin.length - 1] != null) {
              // If last array element is non zero == finish filling
              FocusScope.of(context).requestFocus(_focusNodes[0]);
              widget.onSubmit(_pin.join()); // submit!

              // Clear _pin array
              for (int i = 0; i < _pin.length; i++) {
                _pin[i] = null;
              }
              i = 0;
            } else {
              FocusScope.of(context).requestFocus(_focusNodes[i + 1]);
            }
          } else {
            clearTextFields();
            FocusScope.of(context).requestFocus(_focusNodes[0]);
            ;
          }
        },
        onSubmitted: (String str) {
          clearTextFields();
          widget.onSubmit(_pin.join());
        },
      ),
    );
  }

  Widget generateTextFields(BuildContext context) {
    List<Widget> textFields = List.generate(widget.fields, (int i) {
      return buildTextField(i, context);
    });

    FocusScope.of(context).requestFocus(_focusNodes[0]);

    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        verticalDirection: VerticalDirection.down,
        children: textFields);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: generateTextFields(context),
    );
  }
}
