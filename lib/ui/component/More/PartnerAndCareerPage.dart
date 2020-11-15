import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rumahsakit_smkdev/ui/component/More/SearchPartnerCareer.dart';
import 'package:rumahsakit_smkdev/ui/constant/constant.dart';
import 'package:rumahsakit_smkdev/ui/widget/CustomContainerBox.dart';
import 'package:rumahsakit_smkdev/ui/widget/CustomDetailsPage.dart';

class PartnerCareerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: [_titleAndSearchBar(), _partner(), _lowongan()],
      ),
    );
  }

  Padding _lowongan() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 18, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Lowongan",
            style: titleStyle,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("PartnerAndLowongan")
                  .where('kategori', isEqualTo: 'Lowongan')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasData) {
                  return Column(
                      children: snapshot.data.docs
                          .map((e) => customContainerBox(context, e.data()))
                          .toList());
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Column _partner() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 0),
          child: Text(
            "Partner",
            style: titleStyle,
          ),
        ),
        SizedBox(
          height: setHeight(500),
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("PartnerAndLowongan")
                .where('kategori', isEqualTo: 'Partner')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasData) {
                return ListView(
                    padding: EdgeInsets.fromLTRB(5, 8, 5, 8),
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    children: snapshot.data.docs
                        .map((e) => buildPartner(e.data()))
                        .toList());
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
      ],
    );
  }

//// Widget untuk menampilkan list partner
  Widget buildPartner(Map<String, dynamic> data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: GestureDetector(
        onTap: () => Get.to(
          CustomDetailsPage(data),
        ),
        child: CachedNetworkImage(
          imageUrl: data['gambar'],
          placeholder: (context, url) => Center(
            child: CircularProgressIndicator(),
          ),
          imageBuilder: (context, imageProvider) => Container(
            height: setHeight(500),
            width: setHeight(450),
            decoration: BoxDecoration(
                image:
                    DecorationImage(fit: BoxFit.contain, image: imageProvider),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: grayColor.withOpacity(0.5))),
          ),
        ),
      ),
    );
  }

  Padding _titleAndSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                  icon: Icon(Icons.arrow_back), onPressed: () => Get.back()),
              Text(
                "Partner & Career",
                style: titleStyle.copyWith(fontSize: setFontSize(75)),
              ),
            ],
          ),
          SizedBox(
            height: setHeight(40),
          ),
          SizedBox(
            height: setHeight(110),
            child: GestureDetector(
              onTap: () => Get.to(SearchPartnerCareer()),
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: "Search Partner & Lowongan",
                  enabled: false,
                  contentPadding: EdgeInsets.fromLTRB(30.0, 10.0, 20.0, 0.0),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
