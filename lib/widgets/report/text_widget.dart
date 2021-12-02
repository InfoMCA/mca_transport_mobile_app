import 'package:flutter/material.dart';

enum TextWidgetType {
  text,
  title,
  subTitle,
  fieldLabel,
  button,
}

class TextWidget extends StatelessWidget {
  final double fontSize;
  final Color color;
  final String text;
  final TextAlign textAlign;
  final FontWeight fontWeight;
  final TextWidgetType textWidgetType;

  const TextWidget(
    this.text, {
    Key key,
    this.fontSize,
    this.color,
    this.textAlign,
    this.fontWeight,
    this.textWidgetType = TextWidgetType.text,
  }) : super(key: key);

  TextWidget.title(
    String text, {
    Key key,
    Color color,
    TextAlign textAlign = TextAlign.center,
    FontWeight fontWeight,
    double fontSize,
  }) : this(
          text,
          key: key,
          color: color,
          textAlign: textAlign,
          fontWeight: fontWeight,
          fontSize: fontSize,
          textWidgetType: TextWidgetType.title,
        );

  TextWidget.subTitle(
    String text, {
    Key key,
    Color color,
    TextAlign textAlign = TextAlign.center,
    FontWeight fontWeight,
    double fontSize,
  }) : this(
          text,
          key: key,
          color: color,
          textAlign: textAlign,
          fontWeight: fontWeight,
          fontSize: fontSize,
          textWidgetType: TextWidgetType.subTitle,
        );

  TextWidget.fieldLabel(
    String text, {
    Key key,
    Color color,
    TextAlign textAlign = TextAlign.center,
    FontWeight fontWeight,
    double fontSize,
  }) : this(
          text,
          key: key,
          color: color,
          textAlign: textAlign,
          fontWeight: fontWeight,
          fontSize: fontSize,
          textWidgetType: TextWidgetType.fieldLabel,
        );

  TextWidget.appBarTitle(
    String text, {
    Key key,
    Color color,
    TextAlign textAlign = TextAlign.center,
    FontWeight fontWeight,
    double fontSize,
  }) : this(
          text,
          key: key,
          color: color,
          textAlign: textAlign,
          fontWeight: fontWeight,
          fontSize: fontSize,
          textWidgetType: TextWidgetType.title,
        );

  TextWidget.button(
    String text, {
    Key key,
    Color color,
    TextAlign textAlign,
    FontWeight fontWeight,
    double fontSize,
  }) : this(
          text,
          key: key,
          color: color,
          textAlign: textAlign,
          fontWeight: fontWeight,
          fontSize: fontSize,
          textWidgetType: TextWidgetType.button,
        );

  TextStyle getStyleDefault(BuildContext context) {
    switch (textWidgetType) {
      case TextWidgetType.text:
        return Theme.of(context).textTheme.bodyText1;
      case TextWidgetType.title:
        return Theme.of(context).textTheme.subtitle1;
      case TextWidgetType.subTitle:
        return Theme.of(context).textTheme.subtitle2;
      case TextWidgetType.button:
        return Theme.of(context).textTheme.button;
      case TextWidgetType.fieldLabel:
        return Theme.of(context).textTheme.subtitle1.merge(
              TextStyle(fontSize: 14),
            );
      default:
        throw Exception();
    }
  }

  @override
  Widget build(BuildContext context) {
    final styleDefault = getStyleDefault(context);
    return Text(
      text,
      textAlign: textAlign,
      style: styleDefault.apply(
        color: color,
        fontSizeFactor: fontSize == null ? 1 : fontSize / styleDefault.fontSize,
        fontWeightDelta: fontWeight == null
            ? 0
            : fontWeight.index - styleDefault.fontWeight.index,
      ),
    );
  }
}
