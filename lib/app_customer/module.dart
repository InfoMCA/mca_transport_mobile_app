import 'package:flutter_modular/flutter_modular.dart';
import 'package:transportation_mobile_app/app_customer/views/home/dashboard.dart';

class CustomerModule extends Module {
  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, args) => Dashboard())
  ];
}
