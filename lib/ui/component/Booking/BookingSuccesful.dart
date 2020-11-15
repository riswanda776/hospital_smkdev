import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rumahsakit_smkdev/ui/constant/constant.dart';
import 'package:rumahsakit_smkdev/ui/screens/HomeScreen.dart';

class BookingSuccesful extends StatelessWidget {
  final String bookingKode;

  BookingSuccesful(this.bookingKode);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: deviceHeight(),
        width: deviceWidth(),
        decoration: BoxDecoration(
          color: primaryColor,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            iconSukses(),
            SizedBox(
              height: setHeight(40),
            ),
            Text(
              "Booking Sukses!",
              style: titleStyle.copyWith(
                  color: Colors.white, fontSize: setFontSize(70)),
            ),
            SizedBox(
              height: setHeight(50),
            ),
            Text(
              "Kode booking anda",
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(
              height: setHeight(20),
            ),
            kodeBooking(),
            SizedBox(
              height: setHeight(40),
            ),
            textCustomer(),
            SizedBox(
              height: setHeight(300),
            ),
            buttonLihatHistori(),
            SizedBox(
              height: setHeight(60),
            ),
            buttonToHome()
          ],
        ),
      ),
    );
  }

  GestureDetector buttonToHome() {
    return GestureDetector(
      onTap: () => Get.offAll(HomeScreen()),
      child: Text(
        "Tidak, kembali ke home",
        style: TextStyle(color: Colors.white.withOpacity(0.5)),
      ),
    );
  }

  Icon iconSukses() {
    return Icon(
      Icons.check_circle,
      color: Colors.white,
      size: setWidth(400),
    );
  }

  Text kodeBooking() {
    return Text(
      bookingKode,
      style: titleStyle.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: setFontSize(80)),
    );
  }

  Text textCustomer() {
    return Text(
      "Customer Service kami akan menghubungi\n anda untuk konfirmasi selanjutnya",
      textAlign: TextAlign.center,
      style: TextStyle(color: Colors.white, fontSize: setFontSize(35)),
    );
  }

  SizedBox buttonLihatHistori() {
    return SizedBox(
      height: setHeight(130),
      width: deviceWidth() * 0.8,
      child: FlatButton(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          onPressed: () {
            Get.offAll(HomeScreen(pageIndex: 3,));
          },
          child: Text(
            "Lihat Histori",
            style: titleStyle.copyWith(
                color: primaryColor, fontSize: setFontSize(45)),
          ),
          color: Colors.white),
    );
  }
}
