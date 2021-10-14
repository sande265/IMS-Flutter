import 'package:flash_chat/Components/MaterialButtons.dart';
import 'package:flash_chat/api/Api.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/screens/home_page.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Map<String, String> _data = {
    "username": '',
    "password": '',
  };

  var loading = false;

  void onSubmit() async {
    if (_data['username'] == '') {
      _showToast(context, 'Username is Required.', Colors.red);
      setState(() {
        loading = false;
      });
    } else if (_data['password'] == '') {
      _showToast(context, 'Password is Required.', Colors.red);
      setState(() {
        loading = false;
      });
    } else {
      var res = await Api().postData({
        'username': _data['username'],
        'password': _data['password'],
      }, '/login');
      if (res['message'] != null && res['token'] == null) {
        _showToast(context, res['message'], Colors.red);
        setState(() {
          loading = false;
        });
      } else {
        var decoded = await Api().decodeToken(res['token']);
        if (decoded != '') {
          _showToast(context, res['message'], Colors.green);
          Navigator.pushNamed(context, HomePage.id);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
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
                height: 150.0,
                child: Image.asset('images/logo.png'),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            TextField(
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
              ),
              decoration: kInputFieldDecoration.copyWith(
                hintText: 'Enter Your Username',
                labelText: 'Username',
              ),
              onChanged: (value) {
                _data['username'] = value;
              },
            ),
            SizedBox(
              height: 8.0,
            ),
            TextFormField(
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
              textAlign: TextAlign.center,
              onChanged: (value) {
                _data['password'] = value;
              },
              style: TextStyle(
                color: Colors.black,
              ),
              decoration: kInputFieldDecoration.copyWith(
                hintText: 'Enter Your Password',
                labelText: 'Password',
              ),
            ),
            SizedBox(
              height: 13.5,
            ),
            MaterialButtons(
                title: 'Login',
                loading: loading,
                color: Colors.lightBlueAccent,
                onPressed: () async {
                  setState(() {
                    loading = true;
                  });
                  onSubmit();
                }),
          ],
        ),
      ),
    );
  }

  void _showToast(BuildContext context, message, color) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text('$message'),
        backgroundColor: color,
        action:
            SnackBarAction(label: 'X', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }
}
