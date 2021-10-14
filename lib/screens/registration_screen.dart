import 'package:flash_chat/Components/MaterialButtons.dart';
import 'package:flash_chat/constants.dart';
import 'package:flutter/material.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'register_screen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Hero(
              tag: 'logo_trans',
              child: Container(
                height: 200.0,
                child: Image.asset('images/logo.png'),
              ),
            ),
            SizedBox(
              height: 48.0,
            ),
            TextField(
                onChanged: (value) {
                  //Do something with the user input.
                },
                decoration: kInputFieldDecoration.copyWith(
                  hintText: 'Enter Your Username',
                  labelText: 'Username',
                )),
            SizedBox(
              height: 8.0,
            ),
            TextField(
                onChanged: (value) {
                  //Do something with the user input.
                },
                decoration: kInputFieldDecoration.copyWith(
                  hintText: 'Enter Your Password',
                  labelText: 'Password',
                )),
            SizedBox(
              height: 24.0,
            ),
            MaterialButtons(
              loading: false,
              title: 'Register',
              color: Colors.blueAccent,
              onPressed: () => {},
            ),
          ],
        ),
      ),
    );
  }
}
