import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rumahsakit_smkdev/provider/select_pasien_provider.dart';
import 'package:rumahsakit_smkdev/services/auth_services/auth_services.dart';
import 'package:rumahsakit_smkdev/ui/component/Profile/ProfileHasLogin.dart';
import 'package:rumahsakit_smkdev/ui/component/Profile/ProfileNotLogin.dart';
import 'package:rumahsakit_smkdev/ui/constant/constant.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    return Stack(
      children: [
        Container(
          color: primaryColor,
          child: SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(22.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Profile",
                      style: titleStyle.copyWith(
                          color: Colors.white, fontSize: setFontSize(80)),
                    ),

                    /// jika user sudah login tampilkan button signOut 
                    user != null ? buttonSignOut(context) : SizedBox(),
                  ],
                ),
              ),
            ),
          ),
        ),

        /// jika user sudah login tampilkan Page ProfileHasLogin
        user != null ? ProfileHasLogin() : ProfileNotLogin(),
      ],
    );
  }

  IconButton buttonSignOut(BuildContext context) {
    final pasien = Provider.of<SelectPasienProvider>(context);
    return IconButton(
        onPressed: () {
          Get.dialog(AlertDialog(
            title: Text("Apakah kamu yakin ingin keluar?"),
            actions: [
              FlatButton(onPressed: () => Get.back(), child: Text("Batal")),
              FlatButton(
                  onPressed: () {
                    Get.back();
                    buildDialogSignOut(context);
                    pasien.selectPasien(null, null, null);
                  },
                  child: Text("YA"))
            ],
          ));
        },
        icon: Icon(
          Icons.logout,
          color: Colors.white,
        ));
  }

  Future buildDialogSignOut(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        Future.delayed(Duration(seconds: 3), () {
          AuthServices.signOut();
          Get.back();
        });
        return AlertDialog(
          content: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircularProgressIndicator(),
              SizedBox(
                width: setWidth(100),
              ),
              Text("Sedang Keluar..")
            ],
          ),
        );
      },
    );
  }
}
