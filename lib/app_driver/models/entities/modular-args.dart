import 'package:flutter/material.dart';
import 'package:transportation_mobile_app/app_driver/models/entities/inspection_item.dart';

class PhotoDetailsArgs {
  bool isEditable;
  InspectionItem item;
  InspectionItem itemIssues;

  PhotoDetailsArgs(
      {@required this.item,
      this.isEditable,
      @required this.itemIssues});
}
