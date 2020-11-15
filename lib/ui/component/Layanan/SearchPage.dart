import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rumahsakit_smkdev/services/database_services/database_services.dart';
import 'package:rumahsakit_smkdev/ui/constant/constant.dart';
import 'package:rumahsakit_smkdev/ui/widget/CustomDetailsPage.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final database = FirebaseFirestore.instance;
  String searchString;
  TextEditingController searchController = TextEditingController();
  QuerySnapshot snapshotData;
  bool isSearch = false;
  Map<String, dynamic> data;
  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      final text = searchController.text.toLowerCase();
      searchController.value = searchController.value.copyWith(
        text: text,
        selection:
            TextSelection(baseOffset: text.length, extentOffset: text.length),
        composing: TextRange.empty,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    if (searchController.text.isEmpty) {
      setState(() {
        isSearch = false;
      });
    }
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: primaryColor,
          title: GetBuilder<DatabaseServices>(
            init: DatabaseServices(),
            builder: (controller) => TextField(
              cursorColor: Colors.white,
              autofocus: true,
              style: TextStyle(color: Colors.white),
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: "Search here",
                hintStyle: TextStyle(color: Colors.white),
                contentPadding: EdgeInsets.all(8),
                border: InputBorder.none,
              ),
              controller: searchController,
              onChanged: (value) {
                if (searchController.text.isEmpty) {
                  setState(() {
                    isSearch = false;
                  });
                  searchController.clear();
                  print(isSearch);
                } else {
                       String key = value.substring(0, 1).toUpperCase() +
                      value.substring(1).toLowerCase();
                  controller
                      .searchData(
                          collectionName: "fasilitas",
                          value: 'nama',
                          searchKey: key )
                      .then((value) {
                    snapshotData = value;
                    setState(() {
                      isSearch = true;
                    });
                    print(isSearch);
                  });
                }
              },
            ),
          ),
          actions: [
            isSearch
                ? IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      setState(() {
                        isSearch = false;
                        searchController.clear();
                      });
                    })
                : SizedBox(),
          ],
        ),
        body: isSearch
            ? snapshotData.docs.isNotEmpty
                ? searchData()
                : Center(child: Text("Data tidak ditemukan"))
            : Center(
                child: Text("Cari Fasilitas"),
              ));
  }

  Widget searchData() {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: snapshotData.docs.length,
        physics: ClampingScrollPhysics(),
        itemBuilder: (context, i) {
          return InkWell(
            onTap: () => Get.to(CustomDetailsPage(snapshotData.docs[i].data())),
            child: ListTile(
              leading: CachedNetworkImage(
                imageUrl: snapshotData.docs[i].data()['gambar'],
                placeholder: (context, url) => CircularProgressIndicator(),
                imageBuilder: (context, imageProvider) => CircleAvatar(
                  backgroundColor: Colors.white,
                  backgroundImage: imageProvider,
                ),
              ),
              title: Text(
                snapshotData.docs[i].data()['nama'],
              ),
              subtitle: Text(
                snapshotData.docs[i].data()['kategori'],
                style: TextStyle(color: primaryColor),
              ),
            ),
          );
        });
  }
}
