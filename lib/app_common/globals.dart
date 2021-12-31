import 'package:flutter/material.dart';

void showSnackBar(
    {BuildContext context, String text, Color backgroundColor = Colors.red}) {
  SnackBar snackbar =
      SnackBar(backgroundColor: backgroundColor, content: Text(text));
  ScaffoldMessenger.of(context).showSnackBar(snackbar);
}
