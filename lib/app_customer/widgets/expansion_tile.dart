import 'package:flutter/material.dart';

class FormExpansionTile extends StatelessWidget {
  final String title;
  final List<Widget> children;

  FormExpansionTile({
    @required this.title,
    @required this.children,
    Key key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
        collapsedTextColor: Colors.black45,
        childrenPadding: EdgeInsets.symmetric(horizontal: 15),
        onExpansionChanged: (isExpanded) {
          if (isExpanded) {
            Future.delayed(Duration(milliseconds: 200)).then((value) {
              Scrollable.ensureVisible(context,
                  duration: Duration(milliseconds: 200));
            });
          }
        },
        title: Text(this.title),
        children: this.children);
  }
}
