import 'package:flutter_modular/flutter_modular.dart';
import 'package:transportation_mobile_app/app_common/views/security/login_page.dart';
import 'package:transportation_mobile_app/app_driver/driver_module.dart';

class AppModule extends Module {
  @override
  List<Bind> get binds => [];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/security/login', child: (_, args) => LoginPage()),
    ModuleRoute('/driver', module: DriverModule()),
  ];
}
