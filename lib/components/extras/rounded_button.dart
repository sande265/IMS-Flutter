import 'package:flutter/material.dart';
import 'package:ims_flutter/constants/constants.dart';

class RoundedButton extends StatelessWidget {
  const RoundedButton({
    Key? key,
    required this.title,
    required this.callback,
    required this.processing,
  }) : super(key: key);

  final String title;
  final Function callback;
  final bool processing;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ElevatedButton(
      child: processing
          ? const Text('loading')
          : Text(title),
      onPressed: () {
        callback();
      },
      style: ElevatedButton.styleFrom(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        primary: Colors.white,
        onPrimary: kPrimaryColor,
        textStyle: const TextStyle(fontSize: 20),
        minimumSize: const Size(250.0, 50.0),
      ),
    );
  }
}
