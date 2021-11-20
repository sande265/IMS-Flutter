import 'package:flutter/material.dart';
import 'package:ims_flutter/components/extras/input_container.dart';
import 'package:ims_flutter/constants/constants.dart';

class RoundedPasswordInput extends StatefulWidget {
  const RoundedPasswordInput({
    Key? key,
    required this.hint,
    required this.callback,
    required this.name,
  }) : super(key: key);

  final String hint;
  final Function callback;
  final String name;

  @override
  _RoundedPasswordInputState createState() => _RoundedPasswordInputState();
}

class _RoundedPasswordInputState extends State<RoundedPasswordInput> {

  bool _passwordVisible = false;

  @override
  void initState() {
    _passwordVisible = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InputContainer(
        child: TextField(
          cursorColor: kPrimaryColor,
          textAlignVertical: TextAlignVertical.center,
          controller: TextEditingController()..text = 'sandesh1',
          onChanged: (val) {
            widget.callback(val, widget.name);
          },
          obscureText: !_passwordVisible,
          decoration: InputDecoration(
            icon: const Icon(Icons.lock, color: kPrimaryColor),
            hintText: widget.hint,
            border: InputBorder.none,
            // suffixIcon: const Icon(Icons.remove_red_eye, color: Colors.black,),
            suffixIcon: IconButton(
              icon: Icon(
                // Based on passwordVisible state choose the icon
                _passwordVisible
                    ? Icons.visibility
                    : Icons.visibility_off,
                color: Theme.of(context).primaryColorDark,
              ),
              onPressed: () {
                // Update the state i.e. toogle the state of passwordVisible variable
                setState(() {
                  _passwordVisible = !_passwordVisible;
                });
              },
            ),
          ),
        ),
    );
  }
}