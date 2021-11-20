import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:signature/signature.dart';

import 'package:enum_to_string/enum_to_string.dart';

enum InspectionInputType { Text, Image, Audio, Animation, Video, Menu }

class InspectionItem {
  static const APPROVED_DOCUMENT = "Approved Documents";

  String category;
  String name;
  List<dynamic> options;
  String value = "";
  String comments = "";
  InspectionInputType type;
  String format;
  Uint8List data;
  ui.Image image;
  List<Point> signaturePoints;

  InspectionItem(
      {this.category,
      this.name,
      this.options,
      this.type,
      this.format,
      this.value,
      this.comments = "",
      this.data});

  factory InspectionItem.fromJson(Map<String, dynamic> parsedJson) {
    return InspectionItem(
      category: parsedJson['category'],
      name: parsedJson['name'],
      options: List<dynamic>.from(parsedJson['options']),
      type: EnumToString.fromString(
          InspectionInputType.values, parsedJson['type']),
      format: parsedJson['format'],
      value: parsedJson['value'] == null ||
              parsedJson['value'] == "NA"
          ? ""
          : parsedJson['value'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'name': name,
      'options': options,
      'type': EnumToString.convertToString(type),
      'format': format,
      'value': value == null || value.isEmpty ? 'NA' : value,
      'comments': comments,
    };
  }
}

class InspectionMedia {
  final String name;
  final String value;
  final String format;

  InspectionMedia({this.name, this.value, this.format});

  static InspectionMedia fromInspectionItem(InspectionItem item) {
    return InspectionMedia(
        name: (item.category + "/" + item.name).replaceAll(" ", "_"),
        value: item.value,
        format: item.format);
  }
}

class InspectionConfig {
  List<String> categories;
  List<InspectionItem> items;
  Map<String, List<InspectionItem>> categoryItems;

  InspectionConfig(this.categories, this.items) {
    categoryItems = Map();
    for (String category in categories) {
      categoryItems[category] = [];
    }

    for (InspectionItem inspectionItem in items) {
      categoryItems[inspectionItem.category].add(inspectionItem);
    }
  }

  factory InspectionConfig.fromJson(Map<String, dynamic> parsedJson) {
    var categories = List<String>.from(parsedJson['categories'] as List);
    var inputsJson = parsedJson['reportItems'] as List;
    var inputs = inputsJson.map((i) => InspectionItem.fromJson(i)).toList();

    return InspectionConfig(categories, inputs);
  }
}
