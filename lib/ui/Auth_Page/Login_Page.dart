import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:rumahsakit_smkdev/services/auth_services/auth_services.dart';

import 'package:rumahsakit_smkdev/ui/constant/constant.dart';

class LoginPage extends StatefulWidget {
  final String caller;
  LoginPage(this.caller);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  GlobalKey<FormState> _key = GlobalKey<FormState>();
  String message;

  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
        floatingActionButton: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        backgroundColor: Colors.white,
        body: Center(
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 20),
            shrinkWrap: true,
            children: [
              _logoSmkDev(),
              SizedBox(
                height: setHeight(150),
              ),
              _textWelcome(),
              SizedBox(
                height: setHeight(100),
              ),
              _form(),
              SizedBox(
                height: setHeight(60),
              ),
              _isLoading
                  ? Center(child: CircularProgressIndicator())

                  /// button login
                  : Container(
                      height: setHeight(150),
                      width: setHeight(150),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: primaryColor),
                      child: IconButton(
                        icon: Icon(Icons.arrow_forward),
                        color: Colors.white,
                        onPressed: () async {
                          /// jika semua field sudah diisi maka loading,
                          if (_key.currentState.validate()) {
                            print(emailController.text);
                            try {
                              setState(() {
                                _isLoading = true;
                              });

                              /// loading selama 3 detik
                              await Future.delayed(Duration(seconds: 3));
                              final user = await AuthServices.signInEmail(
                                  emailController.text,
                                  passwordController.text);
                              if (user != null) {
                                /// jika page login dibuka dari home, bukan dari booking dokter, maka back ke halaman sebelumnya,
                                /// selain itu back 2 kali
                                if (widget.caller == "home") {
                                  Get.back();
                                } else {
                                  Get.back();
                                  Get.back();
                                }
                              }
                            } catch (e) {
                              setState(() {
                                _isLoading = false;
                              });

                              /// validasi user
                              switch (e.code) {
                                case 'invalid-email':
                                  message = "Email tidak valid";
                                  break;
                                case 'wrong-password':
                                  message = "Password salah";
                                  break;
                                case 'user-not-found':
                                  message = "User tidak ditemukan";
                                  break;
                              }

                              /// jika error tampilkan snackbar
                              Get.snackbar("Error", message,
                                  backgroundColor: Colors.red,
                                  colorText: Colors.white);
                              print(e.code);
                            }
                          }
                        },
                      ),
                    ),
            ],
          ),
        ));
  }

  Widget _textWelcome() {
    return Text(
      "Selamat Datang\nDi Rumah Sakit SMKDEV",
      style: TextStyle(fontSize: setFontSize(55)),
    );
  }

  Widget _logoSmkDev() {
    return SizedBox(
      height: setHeight(100),
      width: setWidth(100),
      child: Image.asset("assets/logo/smkdev-long.png"),
    );
  }

  Widget _form() {
    return Form(
      key: _key,
      child: Column(
        children: [
          TextFormField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            autofocus: false,
            validator: (value) {
              if (value.isEmpty) {
                return "Email harus diisi";
              } else {
                return null;
              }
            },
            decoration: InputDecoration(
              hintText: 'Email',
              contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            ),
          ),
          SizedBox(
            height: setHeight(40),
          ),
          TextFormField(
            autofocus: false,
            obscureText: true,
            controller: passwordController,
            validator: (value) {
              if (value.isEmpty) {
                return "Password harus diisi";
              } else {
                return null;
              }
            },
            decoration: InputDecoration(
              hintText: 'Password',
              contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            ),
          ),
        ],
      ),
    );
  }
}
