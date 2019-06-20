import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snschat_flutter/state/bloc/WholeApp/WholeAppBloc.dart';
import 'package:snschat_flutter/state/bloc/WholeApp/WholeAppEvent.dart';

class SignUpPage extends StatefulWidget {
  String mobileNo;

  SignUpPage({this.mobileNo});

  @override
  State<StatefulWidget> createState() {
    return new SignUpPageState();
  }
}

class SignUpPageState extends State<SignUpPage> {
  WholeAppBloc wholeAppBloc;
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameTextController = new TextEditingController();
  TextEditingController mobileNoTextController = new TextEditingController();

  FocusNode nodeOne = FocusNode();
  FocusNode nodeTwo = FocusNode();

  @override
  void dispose() {
    // TODO: implement dispose
    nodeOne.dispose();
    nodeTwo.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final WholeAppBloc _wholeAppBloc = BlocProvider.of<WholeAppBloc>(context);
    wholeAppBloc = _wholeAppBloc;
    mobileNoTextController.text = widget.mobileNo;
    return Material(
        child: GestureDetector(
            // call this method here to hide soft keyboard
            onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                iconTheme: IconThemeData(color: Colors.black),
                elevation: 0, //Set Shadow
              ),
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Sign Up",
                    style:
                        TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  Padding(padding: EdgeInsets.symmetric(vertical: 10.00)),
                  Text(
                    "Enter your mobile number and name: ",
                    style: TextStyle(
                        fontSize: 15.0, fontWeight: FontWeight.normal),
                    textAlign: TextAlign.center,
                  ),
                  Padding(padding: EdgeInsets.symmetric(vertical: 10.00)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: mobileNoTextController,
                            cursorColor: Colors.black,
                            style: TextStyle(color: Colors.black),
                            inputFormatters: [
                              BlacklistingTextInputFormatter(
                                  RegExp('[\\.|\\,]')),
                            ],
                            maxLength: 15,
                            decoration:
                                InputDecoration(hintText: "Mobile Number"),
                            autofocus: true,
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            focusNode: nodeOne,
                            onFieldSubmitted: (value) {
                              FocusScope.of(context).requestFocus(nodeTwo);
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Mobile number is empty";
                              }
                            },
                          ),
                          TextFormField(
                            controller: nameTextController,
                            cursorColor: Colors.black,
                            style: TextStyle(color: Colors.black),
                            textCapitalization: TextCapitalization.words,
                            maxLength: 100,
                            decoration: InputDecoration(hintText: "Name"),
                            autofocus: true,
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.text,
                            focusNode: nodeTwo,
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (value) {},
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Name is empty";
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  RaisedButton(
                    onPressed: () => signUp(),
                    textColor: Colors.white,
                    color: Colors.black,
                    highlightColor: Colors.black54,
                    splashColor: Colors.grey,
                    animationDuration: Duration(milliseconds: 500),
                    padding: EdgeInsets.only(
                        left: 70.0, right: 70.0, top: 15.0, bottom: 15.0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0)),
                    child: Text("Get Code"),
                  ),
                  Padding(padding: EdgeInsets.symmetric(vertical: 50.00)),
                ],
              ),
            )));
  }

  signUp() async {
    if (_formKey.currentState.validate()) {
      wholeAppBloc.dispatch(UserSignUpEvent(
          callback: () {},
          mobileNo: mobileNoTextController.value.text,
          realName: nameTextController.value.text));
    }
  }
}
