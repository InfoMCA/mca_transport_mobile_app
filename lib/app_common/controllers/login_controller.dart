
import 'dart:developer';
import 'dart:io';

import 'package:flutter_modular/flutter_modular.dart';
import 'package:transportation_mobile_app/app_common/models/entities/auth_user.dart';
import 'package:transportation_mobile_app/app_driver/models/entities/globals.dart';
import 'package:transportation_mobile_app/app_driver/utils/encryption.dart';
import 'package:transportation_mobile_app/app_driver/utils/interfaces/admin_interface.dart';
import 'package:transportation_mobile_app/app_driver/utils/services/local_storage.dart';

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
          role: response.userRole
        );
        LocalStorage.saveObject(type: ObjectType.driver, object: currentStaff);
        Modular.to.popAndPushNamed(currentStaff.role.getModuleRoute());
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

