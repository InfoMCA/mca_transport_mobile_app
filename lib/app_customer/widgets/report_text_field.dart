import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class ReportTextField extends StatelessWidget {
  final TextInputType inputType;
  final bool isEnabled;
  final bool onlyCaps;
  final int maxLength;
  final String initialValue;
  final Function(String newValue) onChange;

  const ReportTextField({
    Key key,
    this.inputType: TextInputType.text,
    this.isEnabled,
    this.onlyCaps,
    this.initialValue,
    this.maxLength = 999,
    this.onChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
          color: Colors.white,
          border: Border.all(color: Colors.black26, width: 1.0)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
        child: TextFormField(
          enabled: this.isEnabled,
          initialValue: initialValue,
          keyboardType: inputType,
          maxLines: 1,
          maxLength: maxLength,
          inputFormatters: [if (onlyCaps) UpperCaseTextFormatter()],
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
          obscureText: false,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintStyle: TextStyle(
              color: Colors.white,
            ),
          ),
          onChanged: onChange,
        ),
      ),
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
