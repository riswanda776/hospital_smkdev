import 'package:flutter/material.dart';
import 'package:rumahsakit_smkdev/model/jadwal_buka.dart';
import 'package:rumahsakit_smkdev/ui/constant/constant.dart';
import 'package:rumahsakit_smkdev/ui/screens/Maps/Maps.dart';

class LocationView extends StatefulWidget {
  const LocationView({
    Key key,
  }) : super(key: key);

  @override
  _LocationViewState createState() => _LocationViewState();
}

class _LocationViewState extends State<LocationView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: setHeight(1600),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _temuiKami(),
          _maps(context),
          _listJadwal(),
        ],
      ),
    );
  }

  // list jadwal buka, load ffom json
  FutureBuilder<List<JadwalBuka>> _listJadwal() {
    return FutureBuilder<List<JadwalBuka>>(
            future: getJadwal(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      JadwalBuka data = snapshot.data[index];
                      return Padding(
                        padding: const EdgeInsets.only(
                            top: 10, right: 18, left: 18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data.namaTempat,
                              style: titleStyle.copyWith(
                                  fontSize: setFontSize(43)),
                            ),
                            Text(data.alamat),
                            Text(data.jadwal1),
                            Text(
                              data.jadwal2,
                            ),
                          ],
                        ),
                      );
                    });
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            });
  }


  
  Padding _temuiKami() {
    return Padding(
          padding: const EdgeInsets.only(top: 15, left: 18, right: 15),
          child: Text(
            "Temui Kami",
            style: titleStyle,
          ),
        );
  }

  Padding _maps(BuildContext context) {
    return Padding(
          padding: const EdgeInsets.all(15.0),
          child: GestureDetector(
            onTap: () => Navigator.push(
                context, MaterialPageRoute(builder: (context) => Maps())),
            child: Container(
              height: setHeight(500),
              decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage("assets/20201103_135228.jpg")),
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
        );
  }
}
