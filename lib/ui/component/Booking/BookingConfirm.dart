import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rumahsakit_smkdev/provider/select_pasien_provider.dart';
import 'package:rumahsakit_smkdev/services/database_services/database_services.dart';
import 'package:rumahsakit_smkdev/ui/constant/constant.dart';
import 'package:rumahsakit_smkdev/ui/component/Booking/BookingSuccesful.dart';
import 'package:rumahsakit_smkdev/ui/component/Booking/SelectPasienPage.dart';
import 'package:rumahsakit_smkdev/ui/widget/BottomButton.dart';

class BookingConfirmPage extends StatefulWidget {
  final Map<String, dynamic> data;
  BookingConfirmPage(this.data);
  @override
  _BookingConfirmPageState createState() => _BookingConfirmPageState();
}

class _BookingConfirmPageState extends State<BookingConfirmPage> {
  String namaPasien;
  String jenisKelamin;
  String status;

  DateTime tglBookingDokter = DateTime.now();
  DateTime tglBooking = DateTime.now();

  final pesanController = TextEditingController();

  String kodeBooking;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    final pasien = Provider.of<SelectPasienProvider>(context);
    namaPasien = pasien.nama;
    jenisKelamin = pasien.jenisKelamin;
    status = pasien.status;

    return Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: buttonConfirm(context, user),
        appBar: _appBar(),
        body: ListView(
          children: [
            buildDokterProfile(),
            Divider(
              color: grayColor.withOpacity(0.2),
              height: setHeight(35),
              thickness: setHeight(10),
            ),
            _textBookingDetail(),
            SizedBox(
              height: setHeight(40),
            ),
            buildSelectedPasien(),
            buildTanggal(),
            buildPesan()
          ],
        ));
  }

  Padding _textBookingDetail() {
    return Padding(
            padding: const EdgeInsets.fromLTRB(18, 10, 18, 5),
            child: Text(
              "Booking Detail",
              style: titleStyle.copyWith(
                  color: primaryColor, fontSize: setFontSize(50)),
            ),
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
        "Booking Confirm",
        style: titleStyle.copyWith(color: Colors.black),
      ),
      elevation: 0,
    );
  }

  Widget buttonConfirm(BuildContext context, User user) {
    return bottomButton(context, title: "Konfirmasi", onTap: () async {
      int lastTime = DateTime.now().millisecondsSinceEpoch;
      kodeBooking = "B" + lastTime.toString().substring(7);
      print(kodeBooking);

      if (namaPasien == null) {
        Get.snackbar("Pasien belum dipilih", "Pilih pasien terlebih dahulu",
            colorText: Colors.white,
            backgroundColor: Colors.red,
            duration: Duration(milliseconds: 1500));
      } else {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              Future.delayed(Duration(seconds: 3), () {
                DatabaseServices.addBookingDokter(
                  kodeBooking: kodeBooking,
                  uid: user.uid,
                  namaDokter: widget.data['nama'],
                  fotoDokter: widget.data['foto'],
                  spesialisDokter: widget.data['spesialis'],
                  namaPasien: namaPasien,
                  jenisKelamin: jenisKelamin,
                  status: status,
                  tanggalBookingDokter: tglBookingDokter,
                  tanggalBooking: tglBooking,
                  pesan: pesanController.text,
                );

                Get.back();
                Get.off(BookingSuccesful(kodeBooking));
              });
              return AlertDialog(
                title: Row(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(
                      width: setWidth(100),
                    ),
                    Text("Membooking..",
                        style: TextStyle(
                          fontSize: setFontSize(50),
                        )),
                  ],
                ),
              );
            });
      }
    });
  }

  Padding buildPesan() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 10, 18, 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Pesan",
            style: titleStyle.copyWith(
                color: grayColor, fontSize: setFontSize(40)),
          ),
          TextField(
            controller: pesanController,
            textInputAction: TextInputAction.done,
            maxLines: 3,
            decoration: InputDecoration(
                hintText: "pesan",
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
          ),
        ],
      ),
    );
  }

  Padding buildTanggal() {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: GestureDetector(
        onTap: () async {
          final picked = await showDatePicker(
              context: context,
              locale: Locale("id", "ID"),
              currentDate: DateTime.now(),
              initialDate: DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime(2030));

          if (picked != null)
            setState(() {
              tglBookingDokter = picked;
            });
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Booking Tanggal",
              style: titleStyle.copyWith(
                  fontSize: setFontSize(40), color: Colors.black),
            ),
            Row(
              children: [
                Text(
                  DateFormat("EEEE, d MMM, yyyy", "id_ID")
                      .format(tglBookingDokter),
                  style: titleStyle.copyWith(
                      fontSize: setFontSize(40), color: Colors.orange),
                ),
                SizedBox(
                  width: setWidth(20),
                ),
                Icon(
                  Icons.calendar_today_outlined,
                  color: primaryColor,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Container buildSelectedPasien() {
    return Container(
      color: grayColor.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Consumer<SelectPasienProvider>(
              builder: (context, pasien, child) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Booking untuk",
                    style: titleStyle.copyWith(
                        color: Colors.black, fontSize: setFontSize(40)),
                  ),
                  Text(
                    pasien.nama ?? "",
                    style: colorStyle.copyWith(fontSize: setFontSize(40)),
                  ),
                  Text(
                    pasien.jenisKelamin ?? "",
                    style: colorStyle.copyWith(fontSize: setFontSize(40)),
                  ),
                  Text(
                    pasien.status ?? "",
                    style: colorStyle.copyWith(fontSize: setFontSize(40)),
                  )
                ],
              ),
            ),
            GestureDetector(
              onTap: () => Get.to(SelectPasienPage()),
              child: Text(
                "Ganti Pasien",
                style:
                    TextStyle(color: primaryColor, fontSize: setFontSize(40)),
              ),
            )
          ],
        ),
      ),
    );
  }

  Padding buildDokterProfile() {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CachedNetworkImage(
              imageUrl: widget.data['foto'],
              placeholder: (context, url) => CircularProgressIndicator(),
              imageBuilder: (context, imageProvider) => SizedBox(
                    height: setHeight(200),
                    width: setHeight(200),
                    child: CircleAvatar(
                      backgroundImage: imageProvider,
                    ),
                  )),
          SizedBox(
            width: setWidth(80),
          ),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.data['nama'],
                  maxLines: 2,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  style: titleStyle.copyWith(fontSize: setFontSize(50)),
                ),
                SizedBox(
                  height: setHeight(10),
                ),
                Text(widget.data['spesialis']),
              ],
            ),
          )
        ],
      ),
    );
  }
}
