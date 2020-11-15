import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:rumahsakit_smkdev/ui/Auth_Page/Login_Page.dart';
import 'package:rumahsakit_smkdev/ui/Auth_Page/SignUp_Page.dart';
import 'package:rumahsakit_smkdev/ui/constant/constant.dart';

class ProfileNotLogin extends StatefulWidget {
  const ProfileNotLogin({
    Key key,
  }) : super(key: key);

  @override
  _ProfileNotLoginState createState() => _ProfileNotLoginState();
}

class _ProfileNotLoginState extends State<ProfileNotLogin> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: deviceHeight() * 0.7,
        decoration: BoxDecoration(color: Colors.white),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [_buttonSignUp(), _buttonLogin()],
            ),
            _illustrasi()
          ],
        ),
      ),
    );
  }

  Center _illustrasi() {
    return Center(
      child: SizedBox(
        height: setHeight(800),
        width: setWidth(800),
        child: SvgPicture.asset("assets/login.svg"),
      ),
    );
  }

  Padding _buttonLogin() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: FlatButton(
          onPressed: () {
            Get.to(LoginPage("home"));
          },
          color: primaryColor,
          child: Text(
            "Login",
            style: TextStyle(color: Colors.white),
          )),
    );
  }

  Padding _buttonSignUp() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: OutlineButton(
        onPressed: () {
          Get.to(SignUpPage("home"));
        },
        child: Text("Sign Up"),
      ),
    );
  }
}
