import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:rumahsakit_smkdev/ui/constant/constant.dart';

/// Widget untuk menampung detail event,promo dan berita
class CustomDetailsPage extends StatelessWidget {
  final Map<String, dynamic> data;
 CustomDetailsPage(this.data);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () => Navigator.pop(context)),
        title: Text(
          data['Judul'] ?? data['nama'],
          style: titleStyle.copyWith(
              color: Colors.black, fontSize: setFontSize(50)),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CachedNetworkImage(
              imageUrl: data['gambar'],
              placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
              imageBuilder: (context, imageProvider) => Container(
                height: setHeight(500),
                decoration: BoxDecoration(
                    
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: imageProvider)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 0),
              child: Text(
                data['kategori'] != null ? data['kategori'] :  "Berita",
                style: titleStyle.copyWith(
                    color: primaryColor, fontSize: setFontSize(42)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 5, 18, 4),
              child: Text(
                data['Judul'] ?? data['nama'],
                style: titleStyle.copyWith(fontSize: setFontSize(55)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 0, 18, 8),
              child: Text(
                data['tgl'],
                style: colorStyle,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Text(data['isi'] ?? data['keterangan']),
            )
          ],
        ),
      ),
    );
  }
}