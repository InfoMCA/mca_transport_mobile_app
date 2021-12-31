import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:transportation_mobile_app/app_common/app_widget.dart';
import 'package:transportation_mobile_app/app_common/module.dart';
import 'package:transportation_mobile_app/app_common/models/entities/auth_user.dart';
import 'package:transportation_mobile_app/app_driver/utils/services/local_storage.dart';

import 'app_driver/models/entities/globals.dart';

Future<void> _loadConfigFile() async {
  String configJson =
      await rootBundle.loadString('assets/inspection_config.json');
  setInspectionConfig(configJson);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DotEnv.load(fileName: ".env");
  await _loadConfigFile();
  try {
    String object = await LocalStorage.getObject(ObjectType.driver);
    if (object == null || object.isEmpty) {
      log("No user found, proceeding to login page");
    } else {
      currentStaff = AuthUserModel.fromJson(json.decode(object));
    }
  } catch (e) {
    log(e.toString());
    log("Error deserializing user", stackTrace: e.stackTrace);
  }
  runApp(ModularApp(
    child: AppWidget(
        initialRoute:
            currentStaff?.role?.getModuleRoute() ?? "/security/login"),
    module: AppModule(),
  ));
}
