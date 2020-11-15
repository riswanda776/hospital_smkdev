import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rumahsakit_smkdev/services/database_services/database_services.dart';
import 'package:rumahsakit_smkdev/ui/constant/constant.dart';
import 'package:rumahsakit_smkdev/ui/widget/CustomDetailsPage.dart';

class FasilitasView extends StatefulWidget {
  const FasilitasView({
    Key key,
  }) : super(key: key);

  @override
  _FasilitasViewState createState() => _FasilitasViewState();
}

class _FasilitasViewState extends State<FasilitasView> {
  Stream<QuerySnapshot> getData;

  Stream<QuerySnapshot> getFasilitas() {
    return DatabaseServices.getFasilitas();
  }

  @override
  void initState() {
    super.initState();
    getData = getFasilitas();
  }

  /// Container untuk menampung list fasilitas

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [_textFasilitasDanLayanan(), _futureGetFasilitas()],
      ),
    );
  }

  Padding _textFasilitasDanLayanan() {
    return Padding(
      padding: const EdgeInsets.only(left: 18, top: 18, bottom: 8),
      child: Text(
        "Fasilitas & Layanan Terkini",
        style: titleStyle.copyWith(fontSize: setFontSize(55)),
      ),
    );
  }

  SizedBox _futureGetFasilitas() {
    return SizedBox(
      height: setHeight(670),
      child: StreamBuilder<QuerySnapshot>(
        stream: getData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (!snapshot.hasData) {
            return Text("Tidak ada data");
          } else if (snapshot.hasData) {
            return ListView(
                padding: EdgeInsets.all(8),
                scrollDirection: Axis.horizontal,
                physics: ClampingScrollPhysics(),
                shrinkWrap: true,
                children: snapshot.data.docs
                    .map((e) => _fasilitasItem(context, e.data()))
                    .toList());
          } else {
            return null;
          }
        },
      ),
    );
  }

  Widget _fasilitasItem(BuildContext context, Map<String, dynamic> data) {
    return GestureDetector(
      onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (context) => CustomDetailsPage(data))),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CachedNetworkImage(
          imageUrl: data['gambar'],
          placeholder: (context, url) => Center(
            child: CircularProgressIndicator(),
          ),
          imageBuilder: (context, imageProvider) => Container(
            height: setHeight(500),
            width: setWidth(460),
            decoration: BoxDecoration(
                image: DecorationImage(
                    colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.25), BlendMode.colorBurn),
                    fit: BoxFit.cover,
                    image: imageProvider),
                color: grayColor.withAlpha(500),
                borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.only(left: 10, bottom: 22),
              child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    data['nama'],
                    style: titleStyle.copyWith(
                        color: Colors.white, fontSize: setFontSize(50)),
                  )),
            ),
          ),
        ),
      ),
    );
  }
}
