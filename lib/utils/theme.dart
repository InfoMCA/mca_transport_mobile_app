import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:transportation_mobile_app/utils/hex_color.dart';

abstract class WalletUiTheme {}

abstract class ThemeMixin {
  ThemeData getTheme(BuildContext context) {
    final primaryIconColor = HexColor('#FFFFFF');
    final iconColor = HexColor('#7099b2');
    final secondaryColor = HexColor('#84939d');
    final backgroundColor = HexColor('#112A39');
    final primaryColor = HexColor('#315FD6');
    final accentColor = HexColor('#F5A623');

    return ThemeData(
      textTheme: GoogleFonts.poppinsTextTheme(
        TextTheme(
          bodyText1: TextStyle(
            color: primaryIconColor,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          bodyText2: TextStyle(
            color: secondaryColor,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          subtitle1: TextStyle(
            color: primaryIconColor,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          subtitle2: TextStyle(
            color: secondaryColor,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          button: TextStyle(
            color: primaryIconColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      iconTheme: IconThemeData(
        color: iconColor,
      ),
      primaryIconTheme: IconThemeData(
        color: primaryIconColor,
      ),
      backgroundColor: backgroundColor,
      primaryColor: primaryColor,
      floatingActionButtonTheme: FloatingActionButtonThemeData(backgroundColor: accentColor),
    );
  }
}
