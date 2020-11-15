import 'package:flutter/material.dart';
import 'package:rumahsakit_smkdev/model/contact_model.dart';
import 'package:rumahsakit_smkdev/ui/constant/constant.dart';
import 'package:url_launcher/url_launcher.dart';

String email;
String phoneNumber;

/// --------------------
/// Method to open email
/// --------------------
openMail() async {
  final Uri params = Uri(
    scheme: 'mailto',
    path: email,
    query:
        'subject=Pengaduan&body=Tulis kritik dan saranmu disini !', //add subject and body here
  );

  var url = params.toString();
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

/// -------------------------
/// Method to open phone call
/// -------------------------
void makeCall() async {
  print(phoneNumber);
  if (await canLaunch(phoneNumber)) {
    await launch(phoneNumber);
  } else {
    throw 'Could not call';
  }
}

Widget contactAndFeedback() {
  return FutureBuilder<Contact>(
    future: loadContact(),
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        email = snapshot.data.email;
        phoneNumber = "tel:${snapshot.data.telepon}";

        return Padding(
          padding: const EdgeInsets.only(top: 20, left: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Kontak & Pengaduan",
                style: titleStyle,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 8),
                child: Row(
                  children: [
                    Icon(
                      Icons.location_pin,
                      color: grayColor.withAlpha(500),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            snapshot.data.nama,
                            style:
                                titleStyle.copyWith(fontSize: setFontSize(40)),
                          ),
                          Text(
                            snapshot.data.alamat,
                            style: colorStyle,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _customRow(snapshot.data.email, Icons.mail_outline,
                      () => openMail())),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    _customRow(
                        snapshot.data.telepon, Icons.phone, () => makeCall()),
                    SizedBox(
                      width: setWidth(50),
                    ),
                    _customRow(snapshot.data.telepon,
                        Icons.phone_android_outlined, () => makeCall()),
                  ],
                ),
              )
            ],
          ),
        );
      } else {
        return Center(
          child: CircularProgressIndicator(),
        );
      }
    },
  );
}

GestureDetector _customRow(String text, IconData icon, void Function() onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Row(
      children: [
        Icon(
          icon,
          color: grayColor.withAlpha(500),
        ),
        SizedBox(
          width: setWidth(25),
        ),
        Text(
          text,
          style: colorStyle,
        ),
      ],
    ),
  );
}
