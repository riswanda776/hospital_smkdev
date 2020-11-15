import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:rumahsakit_smkdev/ui/constant/constant.dart';
import 'package:rumahsakit_smkdev/ui/widget/CustomDetailsPage.dart';

/// Widget untuk menampung event,promo
Widget customContainerBox(BuildContext context, Map<String, dynamic> data) {
    return Padding(
      padding: const EdgeInsets.only(left: 18, right: 18, top: 18, bottom: 0),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => CustomDetailsPage(data)));
        },
        child: Container(
          height: setHeight(630),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: newsBorder,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: CachedNetworkImage(
                  imageUrl: data['gambar'],
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(),
                  ),
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                        color: Colors.grey.withAlpha(400),
                        image: DecorationImage(
                            fit: BoxFit.cover, image: imageProvider),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10))),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 2,
                      child: Padding(
                        padding:
                            const EdgeInsets.only(left: 8, top: 8, bottom: 5),
                        child: Text(
                          data['kategori'],
                          style: TextStyle(color: primaryColor),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8, bottom: 5),
                        child: Text(
                          data['Judul'] ?? data['nama'],
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: titleStyle.copyWith(fontSize: setFontSize(40)),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          data['tgl'],
                          style: colorStyle,
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
