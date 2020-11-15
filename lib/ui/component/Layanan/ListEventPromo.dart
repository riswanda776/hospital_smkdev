
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rumahsakit_smkdev/services/database_services/database_services.dart';
import 'package:rumahsakit_smkdev/ui/constant/constant.dart';
import 'package:rumahsakit_smkdev/ui/widget/CustomContainerBox.dart';


class ListEventPromo extends StatefulWidget {
  const ListEventPromo({
    Key key,
  }) : super(key: key);

  @override
  _ListEventPromoState createState() => _ListEventPromoState();
}

class _ListEventPromoState extends State<ListEventPromo> {
  Stream<QuerySnapshot> getData;

  Stream<QuerySnapshot> getEventPromo() {
    return DatabaseServices.getEventPromo();
  }

  @override
  void initState() {
    super.initState();
    getData = getEventPromo();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _textEventPromo(),
          _getEventPromo()
        ],
      ),
    );
  }
 

 /// load data dari firestore dan dikirim ke widget customContainer untuk menampilkan data
  StreamBuilder<QuerySnapshot> _getEventPromo() {
    return StreamBuilder<QuerySnapshot>(
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
                  padding: EdgeInsets.only(bottom: 18),
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  children: snapshot.data.docs
                      .map((e) => customContainerBox(context, e.data()))
                      .toList(),
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            });
  }

  Padding _textEventPromo() {
    return Padding(
          padding: const EdgeInsets.only(top: 18, left: 18, bottom: 8),
          child: Text(
            "Event & Promo",
            style: titleStyle.copyWith(fontSize: setFontSize(55)),
          ),
        );
  }
}
