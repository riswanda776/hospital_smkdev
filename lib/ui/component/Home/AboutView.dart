import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rumahsakit_smkdev/services/database_services/database_services.dart';
import 'package:rumahsakit_smkdev/ui/component/More/TentangKamiPage.dart';
import 'package:rumahsakit_smkdev/ui/constant/constant.dart';
import 'package:rumahsakit_smkdev/ui/component/Booking/BookingDokter.dart';

class AboutView extends StatefulWidget {
  const AboutView({
    Key key,
  }) : super(key: key);

  @override
  _AboutViewState createState() => _AboutViewState();
}

class _AboutViewState extends State<AboutView> {
  Stream<QuerySnapshot> getData;
  Stream<QuerySnapshot> getDokter() {
    return DatabaseServices.getDokter();
  }

  @override
  void initState() {
    super.initState();
    getData = getDokter();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: deviceHeight() * 0.9,
      color: primaryColor,
      child: Column(
        children: [
          _header(),
          _hospitalImage(),
          _listDokter()
        ],
      ),
    );
  }
 

  Padding _header() {
    return Padding(
          padding: const EdgeInsets.only(
            top: 25,
            right: 10,
            left: 10,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text("Tentang Kami",
                  style: titleStyle.copyWith(color: Colors.white)),
              GestureDetector(
                onTap: () => Get.to(TentangKamiPage()),
                                child: Text(
                  "Selengkapnya",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        );
  }

  CachedNetworkImage _hospitalImage() {
    return CachedNetworkImage(
          imageUrl:
              "https://asset.kompas.com/crops/mOKFrYHlSTM6SEt4aD9PIXZnJE0=/0x5:593x400/750x500/data/photo/2020/03/16/5e6ee88f78835.jpg",
          placeholder: (context, url) => Center(
            child: CircularProgressIndicator(),
          ),
          imageBuilder: (context, imageProvider) => Padding(
            padding: const EdgeInsets.all(18.0),
            child: Stack(
              children: [
                Container(
                    height: setHeight(600),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      image: DecorationImage(
                          fit: BoxFit.cover, image: imageProvider),
                      borderRadius: BorderRadius.circular(10),
                    )),
              ],
            ),
          ),
        );
  }
  

  /// load ada from firestore and throw to _doctorProfile
  SizedBox _listDokter() {
    return SizedBox(
          height: deviceWidth() * 0.8,
          child: StreamBuilder<QuerySnapshot>(
            stream: getData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              } else if (!snapshot.hasData) {
                return Center(
                  child: Text('No data'),
                );
              }
              if (snapshot.hasData) {
                return ListView(
                  padding: EdgeInsets.all(10),
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  children: snapshot.data.docs
                      .map((e) => _doctorProfile(context, e.data()))
                      .toList(),
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        );
  }


  /// Custom card for show list doctor
  Padding _doctorProfile(BuildContext context, Map<String, dynamic> dokter) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(

        width: setWidth(400),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: Colors.white),
        child: InkWell(
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => BookingDoctor(
                        dokter,
                      ))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CachedNetworkImage(
                imageUrl: dokter['foto'],
                placeholder: (context, url) =>
                    Center(child: CircularProgressIndicator()),
                imageBuilder: (context, imageProvider) => Container(
                  height: 135,
                  decoration: BoxDecoration(
                      color: grayColor,
                      image: DecorationImage(
                          fit: BoxFit.cover, image: imageProvider),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dokter['nama'],
                      style: titleStyle.copyWith(fontSize: setFontSize(40)),
                    ),
                    SizedBox(
                      height: setHeight(30),
                    ),
                    Text(
                      dokter['spesialis'],
                      style: TextStyle(
                          color: grayColor.withAlpha(200),
                          fontSize: setFontSize(35)),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
