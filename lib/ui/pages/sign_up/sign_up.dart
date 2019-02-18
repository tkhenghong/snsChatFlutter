import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new SignUpPageState();
  }
}

class SignUpPageState extends State<SignUpPage> {
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
    return new Material(
        child: new GestureDetector(
            // call this method here to hide soft keyboard
            onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
            child: new Scaffold(
              appBar: new AppBar(
                backgroundColor: Colors.transparent,
                iconTheme: IconThemeData(color: Colors.black),
                elevation: 0, //Set Shadow
              ),
              body: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Text(
                    "Sign Up",
                    style:
                        TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  new Padding(
                      padding: new EdgeInsets.symmetric(vertical: 10.00)),
                  new Text(
                    "Enter your mobile number and name: ",
                    style: TextStyle(
                        fontSize: 15.0, fontWeight: FontWeight.normal),
                    textAlign: TextAlign.center,
                  ),
                  new Padding(
                      padding: new EdgeInsets.symmetric(vertical: 10.00)),
                  new Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: new Column(
                      children: [
                        new TextField(
                          maxLength: 15,
                          decoration:
                              new InputDecoration(hintText: "Mobile Number"),
                          autofocus: true,
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          focusNode: nodeOne,
                          onSubmitted: (value) =>
                              FocusScope.of(context).requestFocus(nodeTwo),
                        ),
                        new TextField(
                          maxLength: 100,
                          decoration: new InputDecoration(hintText: "Name"),
                          autofocus: true,
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.text,
                          focusNode: nodeTwo,
                          textInputAction: TextInputAction.go,
                        ),
                      ],
                    ),
                  ),
                  new RaisedButton(
                    onPressed: () => print("You have pressed this button."),
                    textColor: Colors.white,
                    color: Colors.blue,
                    animationDuration: Duration(milliseconds: 500),
                    padding: EdgeInsets.only(
                        left: 70.0, right: 70.0, top: 15.0, bottom: 15.0),
                    shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.blue, width: 1.0),
                        borderRadius: BorderRadius.circular(50.0)),
                    child: new Text("Get Code"),
                  ),
                  new Padding(padding: new EdgeInsets.symmetric(vertical: 50.00)),
                ],
              ),
            )));
  }
}
