import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:transportation_mobile_app/utils/theme.dart';

class AppWidget extends StatelessWidget with ThemeMixin {
  final String initialRoute;

  AppWidget({this.initialRoute = "/security/login"});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MCA Management UI',
      theme: getTheme(context),
      initialRoute: this.initialRoute,
    ).modular();
  }
}
