import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RectangularButton extends StatelessWidget {
  final backgroundColor;
  final onTap;
  final text;
  final textColor;

  RectangularButton(
      {@required this.backgroundColor,
      @required this.onTap,
      @required this.text,
      @required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48.0,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.0), color: backgroundColor),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Center(
            child: Text(
              text,
              style: TextStyle(color: textColor),
            ),
          ),
        ),
      ),
    );
  }
}
