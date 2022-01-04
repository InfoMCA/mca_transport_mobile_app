import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:location/location.dart';
import 'package:transportation_mobile_app/app_driver/utils/interfaces/admin_interface.dart';

class LocationHandler {
  static bool _isLocationServiceStarted = false;
  static StreamSubscription _locationSubscription;
  static bool _serviceEnabled;
  static String _username;

  static void start({@required String username}) async {
    _username = username;
    if (_isLocationServiceStarted) {
      return;
    }
    try {
      Location location = new Location();
      PermissionStatus _permissionGranted;
      _permissionGranted = await location.hasPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        bool isPermissionGranted = await _showPermissionsView();
        if (!isPermissionGranted) {
          return;
        }
      }
      _serviceEnabled = await location.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await location.requestService();
        if (!_serviceEnabled) {
          return;
        }
      }
      location.changeSettings(
        interval: 60 * 1000,
        distanceFilter: 10,
        accuracy: LocationAccuracy.balanced,
      );
      _locationSubscription = location.onLocationChanged.listen((newData) {
        AdminInterface().updateLocation(
            username: _username,
            latitude: newData.latitude.toString(),
            longitude: newData.longitude.toString());
      });
      _isLocationServiceStarted = true;
    } catch (e, s) {
      log("Error in location handler: " + e.toString(), stackTrace: s);
    }
  }

  void stop() {
    if (_locationSubscription != null && _isLocationServiceStarted) {
      _locationSubscription.cancel();
    }
    _isLocationServiceStarted = false;
  }

  static Future<bool> _showPermissionsView() async {
    return await Modular.to.pushNamed("/driver/home/permissions");
  }
}
