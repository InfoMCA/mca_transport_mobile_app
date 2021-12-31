import 'package:flutter/material.dart';
import 'package:transportation_mobile_app/app_common/utils/app_colors.dart';
import 'package:us_states/us_states.dart';

class USStatePicker extends StatefulWidget {
  Function(String value) onChange;

  USStatePicker({this.onChange});

  @override
  State<USStatePicker> createState() => _USStatePickerState();
}

class _USStatePickerState extends State<USStatePicker> {
  String _value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(child: Text("Select State"), flex: 1,),
        Flexible(
          flex: 1,
          child: Container(
            color: Colors.white,
            child: DropdownButton<String>(
              value: _value,
              isExpanded: true,
              style: TextStyle(color: Colors.black),
              items: <String>[...USStates.getAllAbbreviations()].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _value = value;
                });
                this.widget.onChange(value);
              },
            ),
          ),
        ),
      ],
    );
  }
}
