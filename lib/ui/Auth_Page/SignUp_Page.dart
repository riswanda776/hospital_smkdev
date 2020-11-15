import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:rumahsakit_smkdev/model/RadioJenisKelamin.dart';
import 'package:rumahsakit_smkdev/services/auth_services/auth_services.dart';
import 'package:rumahsakit_smkdev/services/database_services/database_services.dart';
import 'package:rumahsakit_smkdev/ui/Auth_Page/Login_Page.dart';
import 'package:rumahsakit_smkdev/ui/constant/constant.dart';
import 'package:rumahsakit_smkdev/ui/screens/HomeScreen.dart';

class SignUpPage extends StatefulWidget {
  final String caller;

  SignUpPage(this.caller);
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

GlobalKey<FormState> key = GlobalKey<FormState>();

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController namaControl = TextEditingController();
  TextEditingController emailControl = TextEditingController();
  TextEditingController passControl = TextEditingController();
  TextEditingController noControl = TextEditingController();

  bool isLoading = false;
  int groupValue;
  String selectedJenisKelamin;
  String message;

  @override
  void initState() {
    super.initState();
    groupValue = 1;
    selectedJenisKelamin = "Laki-Laki";
  }

  @override
  Widget build(BuildContext context) {
    setupScreenUtil(context);
    return Scaffold(
      body: Center(
        child: ListView(
          children: [
            appBar(context),
            Form(
                key: key,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: setHeight(50),
                    ),
                    buildLabel("Nama"),
                    buildTextField(
                      label: "Nama",
                      hint: "Tulis namamu disini",
                      controller: namaControl,
                    ),
                    buildLabel("Jenis Kelamin"),
                    buildRadioJenisKelamin(),
                    buildLabel("Email"),
                    buildTextField(
                        label: "Email",
                        hint: "Tulis emailmu disini",
                        controller: emailControl,
                        inputType: TextInputType.emailAddress),
                    buildLabel("Password"),
                    buildTextField(
                        label: "Password",
                        hint: "Tulis Passwordmu disini",
                        controller: passControl,
                        obscure: true),
                    buildLabel("Nomor Handphone"),
                    buildTextField(
                        label: "Nomor Handphone",
                        hint: "Tulis nomormu disini",
                        controller: noControl,
                        inputType: TextInputType.phone),
                  ],
                )),
            isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : buttonSignUp(),
            buttonSignIn()
          ],
        ),
      ),
    );
  }

  Padding buildRadioJenisKelamin() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: jenisKelaminChoice
            .map((e) => Row(
                  children: [
                    Radio(
                        value: e.index,
                        groupValue: groupValue,
                        onChanged: (value) {
                          setState(() {
                            groupValue = value;
                            selectedJenisKelamin = e.jenisKelamin;
                            print(selectedJenisKelamin);
                          });
                        }),
                    Text(e.jenisKelamin),
                  ],
                ))
            .toList(),
      ),
    );
  }

  SizedBox buttonSignIn() {
    return SizedBox(
      height: setHeight(150),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Sudah punya akun ?"),
          SizedBox(width: setWidth(10)),
          GestureDetector(
            onTap: () => Get.to(LoginPage(widget.caller)),
            child: Text(
              "Sign In",
              style: titleStyle.copyWith(
                  color: primaryColor, fontSize: setFontSize(43)),
            ),
          ),
        ],
      ),
    );
  }

  Padding buildTextField(
      {String label,
      String hint,
      TextEditingController controller,
      bool obscure = false,
      TextInputType inputType}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 2, 18, 5),
      child: TextFormField(
        autofocus: false,
        controller: controller,
        obscureText: obscure,
        keyboardType: inputType,
        validator: (value) {
          if (value.isEmpty) {
            return "${label} harus diisi";
          } else {
            return null;
          }
        },
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          hintText: hint,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  Padding buttonSignUp() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 8, 10, 5),
      child: SizedBox(
        height: setHeight(170),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FlatButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              color: primaryColor,
              onPressed: () async {
                /// jika semua field sudah diisi , tampilkan loading selama 3 detol
                if (key.currentState.validate()) {
                  setState(() {
                    isLoading = true;
                  });
                  await Future.delayed(Duration(seconds: 3));
                  try {
                    /// memanggil method signUp
                    final result = await AuthServices.signUpWithEmail(
                        emailControl.text, passControl.text);

                    if (result != null) {
                      /// jika signup berhasil, simpan data ke database
                      await Future.delayed(Duration(seconds: 3));
                      User user = Provider.of<User>(context, listen: false);
                      DatabaseServices.addUser(
                              user.uid,
                              namaControl.text,
                              selectedJenisKelamin,
                              noControl.text,
                              emailControl.text,
                              "")

                          /// jika halaman signUp dibuka dari home, bukan pas booking dokter,
                          /// maka navigate ke home, selain itu back ke halaman sebelumnya
                          .then((value) => widget.caller == "home"
                              ? Get.offAll(HomeScreen())
                              : Get.back());
                    } else {
                      setState(() {
                        isLoading = false;
                      });
                    }
                  } catch (e) {
                    setState(() {
                      isLoading = false;
                    });

                    switch (e.code) {
                      case 'invalid-email':
                        message = "Email tidak valid";
                        break;
                      case 'weak-password':
                        message = "Password terlalu pendek";
                        break;
                      case 'email-already-in-use':
                        message = "Email telah digunakan";
                        break;
                    }
                    Get.snackbar("Error", message,
                        backgroundColor: Colors.red, colorText: Colors.white);
                  }
                }
              },
              child: Text(
                "Daftar",
                style: TextStyle(color: Colors.white),
              )),
        ),
      ),
    );
  }

  Padding buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
      child: Text(
        label,
        style: TextStyle(fontSize: setFontSize(45)),
      ),
    );
  }

  Container appBar(BuildContext context) {
    return Container(
      height: setHeight(250),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  size: setHeight(120),
                ),
                onPressed: () {
                  Navigator.pop(context);
                }),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 25),
            child: Text(
              "Sign Up",
              style: TextStyle(fontSize: setFontSize(70)),
            ),
          ),
        ],
      ),
    );
  }
}
