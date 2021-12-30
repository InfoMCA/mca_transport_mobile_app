import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:transportation_mobile_app/app_driver/utils/app_colors.dart';

class DigitalInputErrorMenu extends StatelessWidget {
  final String error;

  const DigitalInputErrorMenu({Key key, this.error}) : super(key: key);

  Widget build(BuildContext context) {
    return Container(
      child: Container(
        child: Container(
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        child: CircleAvatar(
                          backgroundColor: AppColors.portGore,
                          child: Container(
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.error,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 14,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            child: Text(
                              error,
                              style: GoogleFonts.montserrat(
                                fontSize: 14.67,
                                fontWeight: FontWeight.w600,
                                color: AppColors.alizarinCrimson,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                height: 10,
              ),
              Container(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
