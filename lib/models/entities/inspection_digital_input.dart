import 'package:flutter/material.dart';

class DigitalInputMenu {
  String title;
  String category;
  String routeEdit;
  String routeView;
  bool showPreview;
  // List<String> routes;

  DigitalInputMenu(
      {@required this.title,
      @required this.category,
      @required this.showPreview,
      @required this.routeEdit,
      @required this.routeView}) {
    routeView = routeView ?? routeEdit;
  }
}
