import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:transportation_mobile_app/app_common/controllers/login_controller.dart';
import 'package:transportation_mobile_app/app_driver/models/entities/globals.dart';
import 'package:transportation_mobile_app/app_common/utils/app_colors.dart';
import 'package:transportation_mobile_app/app_driver/utils/services/local_storage.dart';
import 'package:transportation_mobile_app/app_driver/utils/services/location_handler.dart';
import 'package:transportation_mobile_app/app_driver/views/report/handlers/lifecycle_handler.dart';
import 'package:transportation_mobile_app/app_driver/widgets/home/session_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String username = "No user";
  bool _isFetchingSessions = false;

  @override
  void initState() {
    super.initState();
    this.username = currentStaff.username;
    WidgetsBinding.instance
        .addObserver(LifecycleEventHandler(resumeCallBack: () async {
      await _refreshSessions();
    }));
    _refreshSessions();
    LocationHandler.start(username: this.username);
  }

  Future<void> _refreshSessions() async {
    try {
      _isFetchingSessions = true;
      print("_isFetchingSessions set to true");
      if (mounted) {
        setState(() {});
      }
      await refreshSessions().whenComplete(() {
        if (mounted) {
          setState(() {});
        }
      });
    } catch (e) {
      print(e);
    } finally {
      _isFetchingSessions = false;
      if (mounted) {
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => _refreshSessions(),
        child: Icon(
          Icons.autorenew_outlined,
          color: Colors.white,
        ),
        backgroundColor: AppColors.alizarinCrimson,
      ),
      appBar: AppBar(
        backgroundColor: AppColors.portGore,
        elevation: 0,
        actions: [
          Container(
            margin: EdgeInsets.only(right: 12.0),
            child: Center(
              child: Container(
                width: 24.0,
                height: 24.0,
                decoration: BoxDecoration(
                    color: AppColors.alizarinCrimson,
                    borderRadius: BorderRadius.circular(100.0)),
                child: Icon(
                  Icons.notifications,
                  color: AppColors.portGore,
                  size: 18.0,
                ),
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Logging out'),
                      content: Text(
                        "Do you want to continue?",
                        style: TextStyle(color: Colors.black),
                      ),
                      actions: <Widget>[
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Cancel'),
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  AppColors.portGoreDark)),
                        ),
                        ElevatedButton(
                          onPressed: _logout,
                          child: const Text('Log me out'),
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  AppColors.alizarinCrimson)),
                        ),
                      ],
                    );
                  });
            },
            child: Container(
              margin: EdgeInsets.only(right: 12.0),
              child: Center(
                child: Container(
                  width: 24.0,
                  height: 24.0,
                  decoration: BoxDecoration(
                      color: AppColors.alizarinCrimson,
                      borderRadius: BorderRadius.circular(100.0)),
                  child: Icon(
                    Icons.logout,
                    color: AppColors.portGore,
                    size: 18.0,
                  ),
                ),
              ),
            ),
          ),
        ],
        title: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: [
                          Container(
                              child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(username,
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                )),
                          ))
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        centerTitle: true,
      ),
      body: _isFetchingSessions
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(child: SessionPage()),
    );
  }

  Future<void> _logout() async {
    LoginController().logoff();
    // await NotificationHandler.stop();
    await LocalStorage.deleteAll();
    Modular.to.popUntil(ModalRoute.withName('/driver/home'));
    Modular.to.popAndPushNamed('/security/login');
  }
}
