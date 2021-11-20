import 'package:flutter/material.dart';
import 'package:ims_flutter/Screens/home_page.dart';
import 'package:ims_flutter/api/api.dart';
import 'package:ims_flutter/components/forms/cancelbtn.dart';
import 'package:ims_flutter/components/forms/login_form.dart';
import 'package:ims_flutter/components/forms/register_form.dart';
import 'package:ims_flutter/constants/constants.dart';
import 'package:ims_flutter/helpers/general_helpers.dart';

class LoginScreen extends StatefulWidget {
  static const id = 'login_screen';

  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  bool isLogin = true;
  late Animation<double> containerSize;
  late AnimationController animationController;
  Duration animationDuration = const Duration(milliseconds: 270);

  late final Map<String, String> _data = {
    "username": 'sande265',
    "password": 'sandesh1',
  };

  var loading = false;

  void onSubmit() async {
    setState(() {
      loading = true;
    });
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
      if (res == null) {
        _showToast(context, 'No Internet Connection.', Colors.red);
        setState(() {
          loading = false;
        });
      }
      if (res['message'] != null && res['token'] == null) {
        _showToast(context, res['message'], Colors.red);
        setState(() {
          loading = false;
        });
      } else {
        var decoded = await Api().decodeToken(res['token']);
        if (decoded != '') {
          _showToast(context, res['message'], Colors.green);
          Navigator.pushReplacementNamed(context, HomeScreen.id);
        }
      }
    }
  }

  handleChange(dynamic data, String type) {
    setState(() {
      _data[type] = data;
    });
  }

  @override
  void initState() {
    if (isAuthenticated()) {
      Navigator.pushNamed(context, HomeScreen.id);
    }
    super.initState();

    animationController =
        AnimationController(vsync: this, duration: animationDuration);
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    double viewInset = MediaQuery.of(context)
        .viewInsets
        .bottom; // we are using this to determine Keyboard is opened or not
    double defaultLoginSize = size.height - (size.height * 0.2);
    double defaultRegisterSize = size.height - (size.height * 0.1);

    containerSize = Tween<double>(
            begin: size.height * 0.1, end: defaultRegisterSize)
        .animate(
            CurvedAnimation(parent: animationController, curve: Curves.linear));

    return Scaffold(
      body: Stack(
        children: [
          // Lets add some decorations
          Positioned(
              top: 100,
              right: -50,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: kPrimaryColor),
              )),

          Positioned(
              top: -50,
              left: -50,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: kPrimaryColor),
              )),

          // Cancel Button
          CancelButton(
            isLogin: isLogin,
            animationDuration: animationDuration,
            size: size,
            animationController: animationController,
            tapEvent: () {
              isLogin
                  ? null
                  :
                  // returning null to disable the button
                  animationController.reverse();
              setState(() {
                isLogin = !isLogin;
              });
            },
          ),

          // Login Form
          LoginForm(
              isLogin: isLogin,
              animationDuration: animationDuration,
              size: size,
              callback: handleChange,
              onSubmit: onSubmit,
              processing: loading,
              defaultLoginSize: defaultLoginSize),

          // Register Container
          AnimatedBuilder(
            animation: animationController,
            builder: (context, child) {
              if (viewInset == 0 && isLogin) {
                return buildRegisterContainer();
              } else if (!isLogin) {
                return buildRegisterContainer();
              }

              // Returning empty container to hide the widget
              return Container();
            },
          ),

          // Register Form
          RegisterForm(
              isLogin: isLogin,
              animationDuration: animationDuration,
              size: size,
              callback: handleChange,
              onSubmit: onSubmit,
              processing: false,
              defaultLoginSize: defaultRegisterSize),
        ],
      ),
    );
  }

  Widget buildRegisterContainer() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: double.infinity,
        height: containerSize.value,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(100),
              topRight: Radius.circular(100),
            ),
            color: kBackgroundColor),
        alignment: Alignment.center,
        child: GestureDetector(
          onTap: !isLogin
              ? null
              : () {
                  animationController.forward();

                  setState(() {
                    isLogin = !isLogin;
                  });
                },
          child: isLogin
              ? const Text(
                  "Don't have an account? Sign up",
                  style: TextStyle(color: kPrimaryColor, fontSize: 18),
                )
              : null,
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
        duration: const Duration(milliseconds: 2000),
        action: SnackBarAction(
          label: 'X',
          onPressed: scaffold.hideCurrentSnackBar,
          textColor: Colors.white,
        ),
      ),
    );
  }
}
