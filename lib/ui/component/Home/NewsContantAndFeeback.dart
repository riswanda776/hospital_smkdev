import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rumahsakit_smkdev/services/database_services/database_services.dart';
import 'package:rumahsakit_smkdev/ui/component/Home/ContactView.dart';
import 'package:rumahsakit_smkdev/ui/constant/constant.dart';
import 'package:rumahsakit_smkdev/ui/widget/CustomDetailsPage.dart';

class ContactAndFeedback extends StatefulWidget {
  @override
  _ContactAndFeedbackState createState() => _ContactAndFeedbackState();
}

class _ContactAndFeedbackState extends State<ContactAndFeedback> {
  Stream<QuerySnapshot> getData;

  Stream<QuerySnapshot> getBerita() {
    return DatabaseServices.getBerita();
  }

  @override
  void initState() {
    super.initState();
    getData = getBerita();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: setHeight(1600),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _textBeritaTerbaru(),
          _berita(),
          contactAndFeedback()
        ],
      ),
    );
  } 

  /// load berita dari firestore
  SizedBox _berita() {
    return SizedBox(
          height: setHeight(700),
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
                } else if (snapshot.hasData) {
                  return ListView(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.all(9),
                    children: snapshot.data.docs
                        .map((e) => newsBox(e.data()))
                        .toList(),
                  );
                } else {
                  return CircularProgressIndicator();
                }
              }),
        );
  }

  Padding _textBeritaTerbaru() {
    return Padding(
          padding: const EdgeInsets.only(top: 35, left: 20, bottom: 20),
          child: Text(
            "Berita Terbaru",
            style: titleStyle,
          ),
        );
  }


 /// Container untuk menampung berita
  Padding newsBox(Map<String, dynamic> berita) {
    return Padding(
      padding: const EdgeInsets.only(left: 11, right: 11),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CustomDetailsPage(berita)));
        },
        child: Container(
          height: setHeight(200),
          width: setWidth(710),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              border: newsBorder),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CachedNetworkImage(
                imageUrl: berita['gambar'],
                placeholder: (context, url) =>
                    Center(child: CircularProgressIndicator()),
                imageBuilder: (context, imageProvider) => Container(
                  height: setHeight(370),
                  decoration: BoxDecoration(
                    color: grayColor,
                    image: DecorationImage(
                        fit: BoxFit.cover, image: imageProvider),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10)),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0, top: 10, right: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(berita['Judul'],
                        maxLines: 2,
                        style: titleStyle.copyWith(fontSize: setFontSize(38))),
                    SizedBox(
                      height: setHeight(25),
                    ),
                    Text(
                      berita['isi'],
                      style: colorStyle.copyWith(fontSize: setFontSize(30)),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
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
