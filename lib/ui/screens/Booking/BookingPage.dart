import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rumahsakit_smkdev/services/database_services/database_services.dart';
import 'package:rumahsakit_smkdev/ui/constant/constant.dart';
import 'package:rumahsakit_smkdev/ui/component/Booking/BookingDokter.dart';

class BookingPage extends StatefulWidget {
  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Booking",
          style: titleStyle.copyWith(
              color: Colors.black, fontSize: setFontSize(70)),
        ),
      ),
      body: _dokterListTile(),
    );
  }

  /// load data dari firestore dan ditampung di ListTile
  StreamBuilder<QuerySnapshot> _dokterListTile() {
    return StreamBuilder<QuerySnapshot>(
        stream: getData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData) {
            return ListView(
                children: snapshot.data.docs
                    .map((e) => Container(
                          child: InkWell(
                            onTap: () {
                              print(e.data());
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => BookingDoctor(
                                            e.data(),
                                          )));
                            },
                            child: ListTile(
                              leading: CachedNetworkImage(
                                imageUrl: e.data()['foto'],
                                placeholder: (context, url) =>
                                    CircularProgressIndicator(),
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  height: setHeight(130),
                                  width: setWidth(130),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: grayColor.withAlpha(300),
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                      )),
                                ),
                              ),
                              title: Text(
                                e.data()['nama'],
                                style: titleStyle.copyWith(
                                    fontSize: setFontSize(45)),
                              ),
                              subtitle: Text(e.data()['spesialis']),
                            ),
                          ),
                        ))
                    .toList());
          } else {
            return CircularProgressIndicator();
          }
        });
  }
}
