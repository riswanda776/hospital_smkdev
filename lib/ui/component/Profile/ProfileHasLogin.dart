import 'dart:io';

import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:rumahsakit_smkdev/services/database_services/database_services.dart';
import 'package:rumahsakit_smkdev/ui/component/Profile/Details_Booking.dart';
import 'package:rumahsakit_smkdev/ui/constant/constant.dart';
import 'package:rumahsakit_smkdev/ui/widget/CustomDetailsPage.dart';

class ProfileHasLogin extends StatefulWidget {
  @override
  _ProfileHasLoginState createState() => _ProfileHasLoginState();
}

class _ProfileHasLoginState extends State<ProfileHasLogin> {
  String image;

  /// Method untuk mendapatkan image dari gallery
  Future<File> getImage() async {
    final picker = await ImagePicker().getImage(source: ImageSource.gallery);
    return File(picker.path);
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    return FutureBuilder<DocumentSnapshot>(
      future: DatabaseServices.getUser(user.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: CircularProgressIndicator(
            backgroundColor: Colors.white,
          ));
        }
        if (snapshot.hasError) {
          return Text("error");
        }
        if (snapshot.hasData) {
          DocumentSnapshot data = snapshot.data;
          return Stack(
            children: [
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: deviceHeight() * 0.65,
                  width: deviceWidth(),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20))),
                  child: tabController(data, user),
                ),
              ),

              /// Profile Picture
              Positioned(
                left: deviceWidth() * 0.35,
                bottom: deviceHeight() * 0.57,
                child: Center(
                  child: GestureDetector(
                    onTap: () async {
                      File file = await getImage();
                      image = await DatabaseServices.uploadImage(file);
                      await DatabaseServices.addPhoto(user.uid, image);
                      print(image);
                      setState(() {});
                    },

                    /// jika foto tidak null, tampilkan foto
                    child: data['photo'] != ""
                        ? Container(
                            height: setHeight(300),
                            width: setHeight(300),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: grayColor,
                            ),
                            child: CachedNetworkImage(
                              imageUrl: data['photo'],
                              placeholder: (context, url) => Center(
                                child: CircularProgressIndicator(),
                              ),
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: grayColor,
                                    image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover)),
                              ),
                            ))

                        //// jika null, tampilkan foto default
                        : Container(
                            height: setHeight(300),
                            width: setHeight(300),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white,
                                image: DecorationImage(
                                    image: AssetImage(
                                      "assets/prof.png",
                                    ),
                                    fit: BoxFit.cover)),
                          ),
                  ),
                ),
              )
            ],
          );
        } else {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.white,
            ),
          );
        }
      },
    );
  }

  DefaultTabController tabController(DocumentSnapshot data, User user) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [_userInfo(data), _tabBar(), _tabbarView(user)],
      ),
    );
  }

  Padding _userInfo(DocumentSnapshot data) {
    return Padding(
      padding: const EdgeInsets.only(top: 70),
      child: Column(
        children: [
          Text(
            data['nama'],
            style: titleStyle.copyWith(fontSize: setFontSize(45)),
          ),
          Text(data['jeniskelamin']),
          Text(
            data['nomor'],
            style: colorStyle,
          )
        ],
      ),
    );
  }

  Expanded _tabbarView(User user) {
    return Expanded(
      child: TabBarView(
        children: [_notifikasi(), _historiBooking(user)],
      ),
    );
  }

  Padding _tabBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 5),
      child: Container(
        height: setHeight(130),
        decoration: BoxDecoration(
          color: grayColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Padding(
          padding: const EdgeInsets.all(3.0),
          child: TabBar(
              indicator: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(4)),
              labelStyle: titleStyle.copyWith(
                  fontSize: setFontSize(45), color: Colors.black),
              labelColor: Colors.black,
              indicatorColor: Colors.blue,
              tabs: [
                Tab(
                  text: "Notifikasi",
                ),
                Badge(
                  badgeColor: Colors.orangeAccent,
                  badgeContent: Text(
                    "3",
                    style: TextStyle(color: Colors.white),
                  ),
                  animationType: BadgeAnimationType.slide,
                  child: Tab(
                    text: "Histori Booking",
                  ),
                )
              ]),
        ),
      ),
    );
  }

  GetBuilder<DatabaseServices> _notifikasi() {
    return GetBuilder<DatabaseServices>(
      init: DatabaseServices(),
      builder: (controller) => FutureBuilder(
        future: controller.getEventPromoLimit(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView.builder(
                physics: ClampingScrollPhysics(),
                shrinkWrap: true,
                itemCount: snapshot.data.length,
                itemBuilder: (context, i) {
                  return _customListTile(snapshot.data[i].data(), () {
                    Get.to(CustomDetailsPage(snapshot.data[i].data()));
                  });
                });
          }
        },
      ),
    );
  }

  Widget _historiBooking(User user) {
    return GetBuilder<DatabaseServices>(
      init: DatabaseServices(),
      builder: (controller) => FutureBuilder(
        future: controller.getHistoryBooking("booking", user.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> data = snapshot.data[index].data();
                  print(data['namaPasien']);
                  return _customListTile(
                    data,
                    () => Get.to(DetailsBooking(data)),
                  );
                });
          }
        },
      ),
    );
  }

  Widget _customListTile(
    Map<String, dynamic> data,
    void Function() onTap,
  ) {
    DateTime tanggalBookingDokter;
    IconData iconData;

    DateTime tglBooking;
    String waktuBooking;

    /// Cek waktu booking
    if (data['tanggalBookingDokter'] != null) {
      tanggalBookingDokter = data['tanggalBookingDokter'].toDate();
      tglBooking = data['tanggalBooking'].toDate();
      Duration selisihWaktu = tglBooking.difference(DateTime.now());

      if (selisihWaktu.inMinutes > -61) {
        waktuBooking = selisihWaktu.inMinutes.toString() + " menit yang lalu";
      } else if (selisihWaktu.inHours > -25) {
        waktuBooking = selisihWaktu.inHours.toString() + " jam yang lalu";
      } else {
        waktuBooking = selisihWaktu.inDays.toString() + " hari yang lalu";
      }

      //// Validasi Icon
    } else {
      if (data['kategori'] == "Event") {
        iconData = Icons.event_available;
      } else {
        iconData = Icons.store;
      }
    }

    return InkWell(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: data['fotoDokter'] != null

                      /// jika foto fokter ada, tampilkan foto dokter,
                      /// selain itu tampilkan icon
                      ? CachedNetworkImage(
                          imageUrl: data['fotoDokter'],
                          imageBuilder: (context, imageProvider) => SizedBox(
                            height: setHeight(130),
                            width: setHeight(130),
                            child: CircleAvatar(
                              backgroundImage: imageProvider,
                              backgroundColor: primaryColor,
                            ),
                          ),
                        )
                      : SizedBox(
                          height: setHeight(130),
                          width: setHeight(130),
                          child: CircleAvatar(
                            backgroundColor: whiteBlueColor,
                            child: Icon(iconData),
                          ),
                        ),
                ),
                SizedBox(
                  width: setWidth(5),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 5, bottom: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data['namaDokter'] ?? data['kategori'],
                          style: subTitleStyle,
                        ),
                        Text(
                          data['spesialis'] ?? data['Judul'],
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          style: TextStyle(fontSize: setFontSize(35)),
                        ),
                        SizedBox(
                          height: setHeight(60),
                        ),
                        Text(
                          tglBooking != null
                              ? waktuBooking.substring(1)
                              : "2 jam yang lalu",
                          style: colorStyle.copyWith(fontSize: setFontSize(35)),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          tanggalBookingDokter != null
              ? chipsStatus(tanggalBookingDokter)
              : SizedBox(),
        ],
      ),
    );
  }

  Widget chipsStatus(DateTime tanggalBooking) {
    String hitungHariBooking =
        (tanggalBooking.difference(DateTime.now()).inDays + 1).toString();

    int perbedaanHari = tanggalBooking.difference(DateTime.now()).inDays;

    return DateTime.now().isBefore(tanggalBooking)
        ? chipsItem("${hitungHariBooking} Hari Lagi", Colors.orangeAccent)
        : perbedaanHari == 0
            ? chipsItem("Hari Ini", primaryColor)
            : chipsItem("Selesai", Colors.green);
  }

  Padding chipsItem(String status, Color color) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 2, 10, 2),
          child: Text(
            status,
            style: subTitleStyle.copyWith(
                fontSize: setFontSize(33), color: Colors.white),
          ),
        ),
      ),
    );
  }
}
