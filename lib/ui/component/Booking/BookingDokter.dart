import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:rumahsakit_smkdev/ui/Auth_Page/SignUp_Page.dart';
import 'package:rumahsakit_smkdev/ui/constant/constant.dart';
import 'package:rumahsakit_smkdev/ui/constant/constant_text.dart';
import 'package:rumahsakit_smkdev/ui/component/Booking/BookingConfirm.dart';
import 'package:rumahsakit_smkdev/ui/widget/BottomButton.dart';
import 'package:rumahsakit_smkdev/ui/widget/BottomSheet.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class BookingDoctor extends StatelessWidget {
  final Map<String, dynamic> dokter;
  BookingDoctor(this.dokter);
  @override
  Widget build(BuildContext context) {
    setupScreenUtil(context);
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      floatingActionButton: backButton(context),
      bottomNavigationBar:
          _buttonBuatJanji(context),
      body: Stack(
        children: [
          _fotoDokter(),
          _slidingUpPanel()
        ],
      ),
    );
  }

  SlidingUpPanel _slidingUpPanel() {
    return SlidingUpPanel(
          minHeight: setHeight(1000),
          maxHeight: deviceHeight(),
          panelBuilder: (sc) => dokterProfile(sc),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        );
  }

  CachedNetworkImage _fotoDokter() {
    return CachedNetworkImage(
          imageUrl: dokter['foto'],
          placeholder: (context, url) => Center(
            child: CircularProgressIndicator(),
          ),
          imageBuilder: (context, imageProvider) => Container(
            alignment: Alignment.center,
            height: setHeight(800),
            decoration: BoxDecoration(
                image:
                    DecorationImage(fit: BoxFit.cover, image: imageProvider)),
          ),
        );
  }

  Widget _buttonBuatJanji(BuildContext context) {
    return bottomButton(context, title: "Buat Janji", onTap: () {
      User user = Provider.of<User>(context, listen: false);
      if (user != null) {
        Get.to(BookingConfirmPage(dokter));
      } else {
        showCustomBottomSheet(context,
            height: setHeight(600),
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Text(bookingNoLoginAlert,
                  style: TextStyle(color: grayColor)),
            ), onPressed: () {
          Get.to(SignUpPage("booking"), transition: Transition.downToUp)
              .then((value) => Get.back());
        });
      }
    });
  }

  FloatingActionButton backButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.pop(context);
      },
      mini: true,
      child: Icon(
        Icons.arrow_back,
        color: Colors.black,
      ),
      backgroundColor: Colors.white,
    );
  }

 

  SizedBox buttonStyle(String text,
      {Color color, Color textColor, void Function() onPressed}) {
    return SizedBox(
        height: setHeight(140),
        width: setWidth(450),
        child: FlatButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            color: color,
            onPressed: onPressed,
            child: Text(
              text,
              style: TextStyle(color: textColor),
            )));
  }

  Padding buildTextField({String hint, TextEditingController controller}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 5, 18, 0),
      child: SizedBox(
        height: setHeight(120),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(8),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            hintText: hint,
          ),
        ),
      ),
    );
  }

  Padding title(String text) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 13, 18, 0),
      child: Text(
        text,
        style: titleStyle.copyWith(fontSize: setFontSize(40)),
      ),
    );
  }

  ListView dokterProfile(ScrollController sc) {
    return ListView(
      controller: sc,
      children: [
        dokterNameAndSpecialis(),
        jadwalDokter(),
        biografi(),
        kredensial(),
        afliansiAkademik()
      ],
    );
  }

  Column afliansiAkademik() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        titleContent("Afliansi Akademik"),
      ],
    );
  }

  Column kredensial() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [titleContent("Kredensial"), bodyContent('kredensial')],
    );
  }

  Column biografi() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [titleContent("Biografi"), bodyContent('biografi')],
    );
  }

  Column jadwalDokter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        titleContent("Jadwal"),
        listJadwal("Senin", 0),
        listJadwal("Selasa", 1),
        listJadwal("Rabu", 2),
      ],
    );
  }

  Padding listJadwal(String hari, int noTempat) {
    return Padding(
      padding: const EdgeInsets.only(left: 18, right: 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                hari,
                style: titleStyle.copyWith(
                    fontSize: setFontSize(40), color: grayColor),
              ),
              Text(
                dokter['jadwal']['hari'][hari],
                style: titleStyle.copyWith(
                    fontSize: setFontSize(40), color: grayColor),
              ),
            ],
          ),
          Text(
            dokter['jadwal']['tempat'][noTempat],
            style: colorStyle,
          ),
        ],
      ),
    );
  }

  Column dokterNameAndSpecialis() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 18, top: 10, bottom: 8),
          child: Text(
            dokter['nama'],
            style: titleStyle,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: 18,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.domain_verification_outlined,
                color: grayColor.withAlpha(500),
              ),
              SizedBox(
                width: setWidth(25),
              ),
              Text(
                dokter['spesialis'],
                style: colorStyle,
              )
            ],
          ),
        )
      ],
    );
  }

  /// Title content
  Widget titleContent(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 18, top: 25, bottom: 8),
      child: Text(
        text,
        style: titleStyle.copyWith(color: primaryColor),
      ),
    );
  }

  //// Text for body
  Widget bodyContent(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 18, right: 18),
      child: Text(dokter[text]),
    );
  }
}
