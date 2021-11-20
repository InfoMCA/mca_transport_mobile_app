import 'dart:async';
import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:location/location.dart';
import 'package:transportation_mobile_app/models/interfaces/admin_interface.dart';

class LocationHandler {
  static bool _isLocationServiceStarted = false;
  static StreamSubscription _locationSubscription;
  static bool _serviceEnabled;
  static String _username;

  static void start(
      {@required String username}) async {
    _username = username;
    if (_isLocationServiceStarted) {
      return;
    }
    try {
      Location location = new Location();
      PermissionStatus _permissionGranted;
      _serviceEnabled = await location.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await location.requestService();
        if (!_serviceEnabled) {
          return;
        }
      }
      _permissionGranted = await location.hasPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        location.enableBackgroundMode(enable: true);
        _permissionGranted = await location.requestPermission();
        if (_permissionGranted != PermissionStatus.granted) {
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
          longitude: newData.longitude.toString()
        );
      });
      _isLocationServiceStarted = true;
    } catch (e) {
      log(e);
    }
  }

  void stop() {
    if (_locationSubscription != null && _isLocationServiceStarted) {
      _locationSubscription.cancel();
    }
    _isLocationServiceStarted = false;
  }
}
