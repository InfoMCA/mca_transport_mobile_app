import 'package:flutter_modular/flutter_modular.dart';
import 'package:transportation_mobile_app/app_driver/views/home/home_page.dart';
import 'package:transportation_mobile_app/app_driver/views/home/permissions.dart';
import 'package:transportation_mobile_app/app_driver/views/report/agreement_page.dart';
import 'package:transportation_mobile_app/app_driver/views/report/picture/take_image_page_landscape.dart';
import 'package:transportation_mobile_app/app_driver/views/report/picture/take_image_page_portrait.dart';
import 'package:transportation_mobile_app/app_driver/views/report/picture/view_photo_details.dart';
import 'package:transportation_mobile_app/app_driver/views/report/report_page.dart';


class DriverModule extends Module {
  @override
  final List<Bind> binds = [
  ];

  @override
  final List<ModularRoute> routes = [
    // ChildRoute('/security/login', child: (_, args) => LoginPage()),
    ChildRoute('/home', child:(_, args) => HomePage()),
    ChildRoute('/home/permissions', child:(_, args) => PermissionRequests()),
    ChildRoute('/service/agreement', child:(_, args) => AgreementPage()),
    ChildRoute('/service/report', child:(_, args) => InspectionMainPage()),
    ChildRoute('/service/picture/portrait', child:(_, args) => TakePicturePortraitView()),
    ChildRoute('/service/picture/landscape', child:(_, args) => TakePictureLandscapeView()),
    ChildRoute('/service/picture/single-picture', child:(_, args) => PhotoDetails(args)),
  ];
}
