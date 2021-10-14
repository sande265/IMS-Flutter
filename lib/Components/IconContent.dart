import 'package:flutter/material.dart';

class IconContent extends StatelessWidget {
  IconContent({required this.icon, required this.text, required this.itemValue});

  final IconData icon;
  final String text;
  final String itemValue;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(
            icon,
            size: 50.0,
          ),
          Column(
            children: [
              Row(
                children: [
                  Text(
                  text,
                  style: TextStyle(
                    fontSize: 18.0, color: Color(0xff8d8e98),
                  ),
                ),
                ]
              ),
              Row(
                  children: [
                    Text(
                      itemValue,
                      style: TextStyle(
                        fontSize: 24.0, color: Color(0xff8d8e98), fontWeight: FontWeight.w900,
                      ),
                    ),
                  ]
              ),
            ],
          )
        ],
      ),
    );
  }
}