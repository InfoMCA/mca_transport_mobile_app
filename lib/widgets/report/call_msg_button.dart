import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:transportation_mobile_app/utils/app_colors.dart';
import 'package:transportation_mobile_app/utils/app_images.dart';

class CallMsgButton extends StatelessWidget {
  final onTap;

  CallMsgButton({this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 16, 0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          child: Center(
            child: Container(
              height: 30.0,
              width: 30.0,
              decoration: BoxDecoration(
                  color: AppColors.alizarinCrimson,
                  borderRadius: BorderRadius.circular(100.0)),
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: SvgPicture.asset(AppImages.phoneMsg,
                    height: 15.0, width: 15.0),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
