import 'package:flutter/material.dart';
import 'package:transportation_mobile_app/app_driver/widgets/report/text_widget.dart';

enum ButtonColor {
  primary,
  accent,
  transparent,
}

class ButtonWidget extends StatelessWidget {
  final Function onTap;
  final double width;
  final double height;
  final Decoration decoration;
  final Widget leftChild;
  final Widget child;
  final Widget rightChild;
  final String text;
  final Color color;
  final Color backgroudColor;
  final Color splashColor;
  final ButtonColor buttonColor;

  const ButtonWidget({
    Key key,
    this.onTap,
    this.width = 321,
    this.height = 47,
    this.decoration,
    this.text = "",
    this.rightChild,
    this.child,
    this.leftChild,
    this.color,
    this.backgroudColor,
    this.splashColor,
    this.buttonColor = ButtonColor.primary,
  }) : super(key: key);

  ButtonWidget.icon({
    Key key,
    Function onTap,
    double width = 321,
    double height = 47,
    Decoration decoration,
    String text = "",
    Color color,
    Color backgroundColor,
    Color splashColor,
    ButtonColor buttonColor = ButtonColor.primary,
    @required Widget icon,
  }) : this(
          key: key,
          onTap: onTap,
          width: width,
          height: height,
          decoration: decoration,
          text: text,
          color: color,
          backgroudColor: backgroundColor,
          splashColor: splashColor,
          leftChild: Padding(
            padding: EdgeInsets.only(right: 10),
            child: icon,
          ),
          buttonColor: buttonColor,
        );

  ButtonWidget.outline({
    Key key,
    Function onTap,
    double width,
    double height,
    Decoration decoration,
    String text = "",
    Color color,
    Color splashColor,
  }) : this(
          key: key,
          onTap: onTap,
          width: width,
          height: height,
          decoration: decoration,
          text: text,
          color: color,
          splashColor: splashColor,
          buttonColor: ButtonColor.transparent,
        );

  Color getBackGroundColor(BuildContext context) {
    if (backgroudColor != null) return backgroudColor;

    switch (buttonColor) {
      case ButtonColor.primary:
        return Theme.of(context).primaryColor;
      case ButtonColor.accent:
        return Theme.of(context).colorScheme.secondary;
      case ButtonColor.transparent:
        return Theme.of(context).primaryColor.withOpacity(0);
      default:
        return Theme.of(context).primaryColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    final backgroudColorValue = getBackGroundColor(context);
    final splashColorValue = splashColor ??
        (buttonColor == ButtonColor.primary
            ? Theme.of(context).colorScheme.secondary
            : Theme.of(context).primaryColor);

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: backgroudColorValue,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          splashColor: splashColorValue.withOpacity(0.2),
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              leftChild ?? SizedBox.shrink(),
              child ??
                  Container(
                    alignment: Alignment.center,
                    child: TextWidget.button(
                      text,
                      textAlign: TextAlign.center,
                      color: color,
                    ),
                  ),
              rightChild ?? SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}
