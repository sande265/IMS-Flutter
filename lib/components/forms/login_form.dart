import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ims_flutter/components/extras/rounded_button.dart';
import 'package:ims_flutter/components/extras/rounded_input.dart';
import 'package:ims_flutter/components/extras/rounded_password_input.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({
    Key? key,
    required this.isLogin,
    required this.animationDuration,
    required this.size,
    required this.defaultLoginSize,
    required this.callback,
    required this.onSubmit,
    required this.processing,
  }) : super(key: key);

  final bool isLogin;
  final Duration animationDuration;
  final Size size;
  final double defaultLoginSize;
  final Function callback;
  final Function onSubmit;
  final bool processing;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: isLogin ? 1.0 : 0.0,
      duration: animationDuration * 4,
      child: Align(
        alignment: Alignment.center,
        child: SizedBox(
          width: size.width,
          height: defaultLoginSize,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                const Text(
                  'Welcome Back',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24
                  ),
                ),

                SizedBox(height: 40),

                SvgPicture.asset('assets/images/login.svg'),

                SizedBox(height: 40),

                RoundedInput(icon: Icons.mail, hint: 'Username', callback: callback, name: 'username',),

                RoundedPasswordInput(hint: 'Password', name: 'password', callback: callback,),

                SizedBox(height: 10),

                RoundedButton(title: 'LOGIN', callback: onSubmit, processing: processing,),

                SizedBox(height: 10),

              ],
            ),
          ),
        ),
      ),
    );
  }
}