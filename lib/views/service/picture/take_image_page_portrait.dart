import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:transportation_mobile_app/models/entities/inspection_item.dart';
import 'package:transportation_mobile_app/models/entities/modular-args.dart';
import 'package:transportation_mobile_app/utils/app_colors.dart';

class TakePicturePortraitView extends StatefulWidget {
  final String position;
  final String dirPath;

  TakePicturePortraitView({this.position, this.dirPath});

  @override
  _TakePicturePortraitViewState createState() =>
      _TakePicturePortraitViewState();
}

class _TakePicturePortraitViewState extends State<TakePicturePortraitView> {
  final CameraLensDirection _direction = CameraLensDirection.back;
  CameraController _camera;
  InspectionItem item;

  @override
  void initState() {
    _initializeCamera();
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  Future<CameraDescription> getCamera(CameraLensDirection dir) async {
    return await availableCameras().then(
      (List<CameraDescription> cameras) => cameras.firstWhere(
        (CameraDescription camera) => camera.lensDirection == dir,
      ),
    );
  }

  void _initializeCamera() async {
    final description = await getCamera(_direction);

    _camera = CameraController(
      description,
      defaultTargetPlatform == TargetPlatform.iOS
          ? ResolutionPreset.low
          : ResolutionPreset.medium,
    );
    await _camera.initialize().then((value) => setState(() {}));
  }

  @override
  void dispose() {
    super.dispose();
    if (_camera != null) {
      _camera.dispose();
    }
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    if (item == null) {
      item = ModalRoute
          .of(context)
          .settings
          .arguments as InspectionItem;
    }
    var screen = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.portGore,
        title: Text(
          "Take Picture",
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xffeeeeee),
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors.alizarinCrimson),
          color: const Color(0xff7099b2),
          onPressed: () {
            Modular.to.pop(InspectionItem());
          },
        ),
      ),
      body: Stack(
        children: [
          _buildImage(screen),
          Align(
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
              onTap: () => _takePicture(),
              child: Container(
                width: double.infinity,
                height: 100.0,
                color: Colors.black.withOpacity(0.5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 60.0,
                      height: 60.0,
                      padding: EdgeInsets.all(4.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(1000.0),
                          border: Border.all(color: Colors.white, width: 4.0)),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(1000.0)),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildImage(Size screen) {
    return Container(
      constraints: const BoxConstraints.expand(),
      child: _camera == null
          ? Container(
              color: const Color(0xff112a39),
              child: Center(
                child: Text(
                  'Initializing Camera...',
                  style: GoogleFonts.montserrat(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xffeeeeee),
                  ),
                ),
              ),
            )
          : Stack(
              fit: StackFit.expand,
              children: <Widget>[
                CameraPreview(_camera),
              ],
            ),
    );
  }

  Future<void> _takePicture() async {
    try {
      await _camera.takePicture().then((file) {
        print("Capture Image on " + file.path);
        item.value = file.path;
        Modular.to
            .pushReplacementNamed('single-picture',
            arguments: PhotoDetailsArgs(item, true));
      });
    } on CameraException catch (e) {
      print(e.toString());
      return;
    }
  }
}
