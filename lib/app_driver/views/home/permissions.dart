import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:transportation_mobile_app/app_common/utils/app_colors.dart';

class PermissionRequests extends StatefulWidget {
  @override
  State<PermissionRequests> createState() => _PermissionRequestsState();
}

class _PermissionRequestsState extends State<PermissionRequests> {
  bool permissionsGranted = false;

  @override
  Widget build(BuildContext context) {
    if (permissionsGranted) {
      Modular.to.pop(true);
    }
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Location permissions needed',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            Image.asset(
              "assets/1_Splash_1_Image1.png",
              height: 150,
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "My Car Transport collects location data to enable a more "
              "precise job assignment based on your geo-location. "
              "Your location will be collected while this app is running in "
              "the background, and it will stop collecting location data "
              "once you close the application.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: double.maxFinite,
              height: 70,
              child: ElevatedButton(
                onPressed: () async {
                  if (await Permission.location.isGranted) {
                    Modular.to.pop(true);
                    return;
                  }
                  PermissionStatus status = await Permission.location.request();
                  if (status == PermissionStatus.granted) {
                    Modular.to.pop(true);
                  }
                },
                child: const Text(
                  'Give permissions',
                ),
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(AppColors.alizarinCrimson)),
              ),
            ),
            Container(
                width: double.maxFinite,
                height: 70,
                child: TextButton(
                  onPressed: () async {
                    Modular.to.pop(true);
                  },
                  child: const Text("Don't allow",
                      style: TextStyle(color: Colors.black)),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.white)),
                )),
          ],
        ),
      ),
    );
  }
}
