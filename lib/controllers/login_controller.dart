
import 'dart:developer';
import 'dart:io';

import 'package:flutter_modular/flutter_modular.dart';
import 'package:transportation_mobile_app/models/entities/auth_user.dart';
import 'package:transportation_mobile_app/models/entities/globals.dart';
import 'package:transportation_mobile_app/models/interfaces/admin_interface.dart';
import 'package:transportation_mobile_app/utils/local_storage.dart';
import 'package:transportation_mobile_app/utils/encryption.dart';

class LoginController {
  Future<AppResp> loginWithUsernameAndPassword(String email, String password) async {
    AppResp response;
    try {
      String encodedP = Encryption().encrypt(password);
      response = await AdminInterface().checkLoginCredentials(email, encodedP);
      if (response.statusCode == HttpStatus.ok) {
        currentStaff = AuthUserModel(
          username: email,
          sessions: response.sessionsList,
        );
        LocalStorage.saveObject(type: ObjectType.driver, object: currentStaff);
        Modular.to.popAndPushNamed('/home');
      } else {
        currentStaff = null;
      }
      return response;
    } catch (e) {
      log(e);
      return response;
    }
  }

  logoff() async {
    try {
      currentStaff = null;
      await LocalStorage.deleteAll();
      log("User logged out successfully");
    } catch(e) {
      print(e);
    }
  }
}

