import 'package:flutter/material.dart';
import 'package:ims_flutter/components/extras/input_container.dart';
import 'package:ims_flutter/constants/constants.dart';

class RoundedInput extends StatelessWidget {
  const RoundedInput({
    Key? key,
    required this.icon,
    required this.hint,
    required this.callback,
    required this.name,
  }) : super(key: key);

  final IconData icon;
  final String hint;
  final Function callback;
  final String name;

  @override
  Widget build(BuildContext context) {
    return InputContainer(
      child: TextField(
        onChanged: (val) {
          callback(val, name);
        },
        controller: TextEditingController()..text = 'sande265',
        cursorColor: kPrimaryColor,
        decoration: InputDecoration(
          icon: Icon(icon, color: kPrimaryColor),
          hintText: hint,
          border: InputBorder.none
        ),
      ));
  }
}