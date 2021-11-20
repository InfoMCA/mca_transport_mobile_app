import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:transportation_mobile_app/models/entities/globals.dart';
import 'package:transportation_mobile_app/utils/app_colors.dart';
import 'package:transportation_mobile_app/utils/app_images.dart';
import 'package:transportation_mobile_app/utils/interfaces/admin_interface.dart';

import '../../controllers/login_controller.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Color switch1Color = const Color(0xff24485e);
  bool isShowPassword = false;
  bool isKeepMeLogIn = false;
  String username = "";
  String password = "";

  TextEditingController usernameController;
  TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController();
    passwordController = TextEditingController();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [header(), loginPart()],
      ),
    ));
  }

  Widget loginPart() {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 22.0),
        child: Column(
          children: [
            SizedBox(
              height: 20.0,
            ),
            Container(
              height: 60.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.0),
                border: Border.all(color: AppColors.mystique, width: 1.5),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    Icon(
                      CupertinoIcons.person,
                      color: Colors.black,
                    ),
                    SizedBox(
                      width: 12.0,
                    ),
                    Flexible(
                      flex: 1,
                      child: TextFormField(
                        enableSuggestions: false,
                        autocorrect: false,
                        controller: usernameController,
                        style: TextStyle(color: Colors.black),
                        cursorColor: Colors.black,
                        onChanged: (value) {
                          username = value;
                          setState(() {});
                        },
                        decoration: InputDecoration(
                          hintText: "Username",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 12.0,
                    ),
                    Container(
                      child: username.isEmpty
                          ? Container(
                              height: 24.0,
                              width: 24.0,
                            )
                          : SvgPicture.asset(
                              AppImages.rightCircle,
                              height: 24.0,
                              width: 24.0,
                            ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Container(
              height: 60.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.0),
                border: Border.all(color: AppColors.mystique, width: 1.5),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    Icon(
                      CupertinoIcons.lock,
                      color: Colors.black,
                    ),
                    SizedBox(
                      width: 12.0,
                    ),
                    Flexible(
                      flex: 1,
                      child: TextField(
                        enableSuggestions: false,
                        autocorrect: false,
                        controller: passwordController,
                        obscureText: !isShowPassword,
                        style: TextStyle(color: Colors.black),
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                          hintText: "password",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 12.0,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isShowPassword = !isShowPassword;
                        });
                      },
                      child: Icon(
                        isShowPassword
                            ? CupertinoIcons.eye_slash_fill
                            : CupertinoIcons.eye_fill,
                        color: Colors.black,
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isKeepMeLogIn = !isKeepMeLogIn;
                    });
                  },
                  child: _customCheckBox(),
                ),
                SizedBox(
                  width: 4.0,
                ),
                Text(
                  "Keep me logged in",
                  style: TextStyle(
                      color: AppColors.silverChalice,
                      fontWeight: FontWeight.bold),
                ),
                Spacer(),
                Text(
                  "Forgot password ?",
                  style: TextStyle(
                      color: AppColors.silverChalice,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(
              height: 20.0,
            ),
            _button(
                text: "LOGIN",
                backgroundColor: AppColors.alizarinCrimson,
                onTap: handleLogin),
          ],
        ),
      ),
    );
  }

  static Widget _button(
      {var text, var backgroundColor, VoidCallback onTap, var textColor}) {
    textColor = textColor ?? Colors.white;
    return Container(
      height: 48.0,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.0), color: backgroundColor),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Center(
            child: Text(
              text,
              style: TextStyle(color: textColor),
            ),
          ),
        ),
      ),
    );
  }

  Widget _customCheckBox() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.0),
        color: AppColors.gallery,
      ),
      height: 20.0,
      width: 20.0,
      child: Center(
        child: Icon(
          Icons.check,
          color: isKeepMeLogIn ? Colors.red : Colors.transparent,
          size: 16.0,
        ),
      ),
    );
  }

  Widget header() {
    return Stack(
      children: [
        Container(
          height: 360.0,
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage(AppImages.carBackground),
            fit: BoxFit.cover,
          )),
        ),
        Container(
          color: Colors.black.withOpacity(1.0),
        ),
        Container(
            child: Center(
                child: Image.asset(
          AppImages.logo,
          height: 360.0,
          width: 140.0,
          color: Colors.white,
        ))),
      ],
    );
  }

  void handleLogin() async {
    print("handleLogin clicked");
    var username = usernameController.text;
    var password = passwordController.text;

    if (username == null || username.isEmpty) {
      showSnackBar(text: "username can not be empty", context: context);
      return;
    }
    if (password == null || password.isEmpty) {
      showSnackBar(text: "password can not be empty", context: context);
      return;
    }
    AppResp response = await LoginController()
        .loginWithUsernameAndPassword(username, password);
    if (response.statusCode != HttpStatus.ok) {
      SnackBar snackBar = SnackBar(
          backgroundColor: Colors.red,
          content: Text(response.message ?? "Username or Password incorrect"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
