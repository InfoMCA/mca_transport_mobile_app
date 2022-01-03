import 'package:flutter_modular/flutter_modular.dart';
import 'package:transportation_mobile_app/app_common/views/security/login_page.dart';
import 'package:transportation_mobile_app/app_customer/module.dart';
import 'package:transportation_mobile_app/app_driver/module.dart';

class AppModule extends Module {
  @override
  final List<ModularRoute> routes = [
    ChildRoute('/security/login', child: (_, args) => LoginPage()),
    ModuleRoute('/driver', module: DriverModule()),
    ModuleRoute('/customer', module: CustomerModule()),
  ];
}
