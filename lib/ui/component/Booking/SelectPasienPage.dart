import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:rumahsakit_smkdev/model/RadioJenisKelamin.dart';
import 'package:rumahsakit_smkdev/provider/select_pasien_provider.dart';
import 'package:rumahsakit_smkdev/services/database_services/database_services.dart';
import 'package:rumahsakit_smkdev/ui/constant/constant.dart';
import 'package:rumahsakit_smkdev/ui/widget/BottomSheet.dart';

class ListItem<T> {
  bool isSelected = false; //Selection property to highlight or not
  T data; //Data of the user
  ListItem(this.data); //Constructor to assign the data
}

class SelectPasienPage extends StatefulWidget {
  @override
  _SelectPasienPageState createState() => _SelectPasienPageState();
}

class _SelectPasienPageState extends State<SelectPasienPage> {
  int selectedRadio;

  int groupValue;
  String selectedJenisKelamin;
  @override
  void initState() {
    super.initState();
    selectedRadio = 0;
    groupValue = 1;
    selectedJenisKelamin = "Laki-Laki";
  }

  setSelectedRadio(int val) {}

  List<String> listStatus = [
    "Saya sendiri",
    "Anak",
    "Istri / Suami",
    "Orang Tua",
    "Saudara",
  ];
  String status;

  List<ListItem<String>> list;

  GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    final value = Provider.of<SelectPasienProvider>(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      resizeToAvoidBottomPadding: true,
      floatingActionButton: FloatingActionButton(
        onPressed: () => bottomSheetRegister(context),
        child: Icon(Icons.add),
      ),
      backgroundColor: Colors.white,
      appBar: _appBar(),
      body: _listPasien(user, value),
    );
  }

  AppBar _appBar() {
    return AppBar(
      backgroundColor: Colors.white,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: Colors.black,
        ),
        onPressed: () => Get.back(),
      ),
      title: Text(
        "Ganti Pasien",
        style: titleStyle.copyWith(color: Colors.black),
      ),
      elevation: 1,
    );
  }

  Widget _listPasien(
      User user, SelectPasienProvider value) {
    return GetBuilder<DatabaseServices>(
      init: DatabaseServices(),
      builder: (controller) => FutureBuilder(
        future: controller.getPasien(user.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView.separated(
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: snapshot.data.length,
              separatorBuilder: (context, index) => Divider(),
              itemBuilder: (context, index) {
                Map<String, dynamic> data = snapshot.data[index].data();
                return InkWell(
                  onTap: () {
                    String nama = data['nama'];
                    String jenisKelamin = data['jeniskelamin'];
                    String status = data['status'];
                    value.selectPasien(nama, jenisKelamin, status);

                    print(value.nama);
                    Get.back();
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(18, 8, 18, 5),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    "Nama :  ${snapshot.data[index].data()['nama']}"),
                                Text(
                                    "Jenis Kelamin : ${snapshot.data[index].data()['jeniskelamin']}"),
                                Text(
                                    "Status : ${snapshot.data[index].data()['status']}"),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  /// tambah pasien baru
  Future bottomSheetRegister(BuildContext context) {
    User user = Provider.of<User>(context, listen: false);

    String nama;
    List<String> listStatus = [
      "Saya sendiri",
      "Anak",
      "Istri / Suami",
      "Orang Tua",
      "Saudara",
    ];
    String status;

    return showCustomBottomSheet(context, height: deviceHeight() * 0.7,
        onPressed: () {
      if (_key.currentState.validate()) {
        DatabaseServices.addPasien(
            user.uid, nama, selectedJenisKelamin, status);
        Get.back();
        setState(() {});
      } else {
        print("error");
      }
    },
        child: StatefulBuilder(
          builder: (context, stateSetter) => Padding(
              padding: const EdgeInsets.all(18.0),
              child: Form(
                key: _key,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Text tambah pasien
                      Padding(
                          padding: const EdgeInsets.fromLTRB(8, 5, 8, 15),
                          child: Text(
                            "Tambah Info Pasien Baru",
                            style: titleStyle.copyWith(
                                color: primaryColor, fontSize: setFontSize(55)),
                          )),

                      Text(
                        "Nama *",
                        style: subTitleStyle,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Nama wajib diisi";
                          } else {
                            return null;
                          }
                        },
                        onChanged: (value) => nama = value,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            hintText: "Nama",
                            contentPadding: EdgeInsets.all(8)),
                      ),

                      SizedBox(
                        height: setHeight(50),
                      ),

                      Text(
                        "Jenis Kelamin *",
                        style: subTitleStyle,
                      ),
                      Row(
                          children: jenisKelaminChoice
                              .map((e) => Row(
                                    children: [
                                      Radio(
                                          value: e.index,
                                          groupValue: groupValue,
                                          onChanged: (value) {
                                            stateSetter(() {
                                              groupValue = value;
                                              selectedJenisKelamin =
                                                  e.jenisKelamin;
                                              print(selectedJenisKelamin);
                                            });
                                          }),
                                      Text(e.jenisKelamin),
                                    ],
                                  ))
                              .toList()),

                      SizedBox(
                        height: setHeight(20),
                      ),

                      Text(
                        "Status *",
                        style: subTitleStyle,
                      ),
                      DropdownButton(
                          value: status,
                          hint: Text("Pilih Salah Satu"),
                          items: listStatus
                              .map((status) => DropdownMenuItem(
                                    child: Text(status),
                                    value: status,
                                  ))
                              .toList(),
                          onChanged: (value) {
                            stateSetter(() {
                              status = value;
                            });
                          }),
                    ]),
              )),
        ));
  }
}
