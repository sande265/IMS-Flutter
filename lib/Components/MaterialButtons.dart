import 'package:flutter/material.dart';

class MaterialButtons extends StatelessWidget {
  final Color color;
  final String title;
  final Function onPressed;
  final bool loading;

  MaterialButtons(
      {required this.title, required this.color, required this.onPressed, required this.loading});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: color,
        borderRadius: BorderRadius.circular(30.0),
        child: loading ? Center(
          heightFactor: 1.3,
          child: CircularProgressIndicator(
            color: Colors.white,
          ),
        ) : MaterialButton(
          onPressed: () => {onPressed()},
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            title,
          ),
        ),
      ),
    );
  }
}
