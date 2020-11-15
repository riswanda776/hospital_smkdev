import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rumahsakit_smkdev/model/more_menu_model.dart';
import 'package:rumahsakit_smkdev/ui/component/More/Feedback_WebView.dart';
import 'package:rumahsakit_smkdev/ui/component/More/PartnerAndCareerPage.dart';
import 'package:rumahsakit_smkdev/ui/component/More/TentangKamiPage.dart';
import 'package:rumahsakit_smkdev/ui/constant/constant.dart';

class MorePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "More",
          style: titleStyle.copyWith(
              color: Colors.black, fontSize: setFontSize(70)),
        ),
      ),
      body: loadMenu(),
    );
  }

  FutureBuilder<List<MoreMenuModel>> loadMenu() {
    return FutureBuilder<List<MoreMenuModel>>(
        future: loadMoreMenuModel(),
        builder: (context, snapshot) {
         
          if (snapshot.hasData) {
            return Column(
              children: snapshot.data.map((e) => _boxItem(e)).toList(),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  Widget _boxItem(MoreMenuModel data) {
    return Flexible(
      flex: 1,
      child: Stack(
        children: [
          GestureDetector(
            onTap: () {
              switch (data.title) {
                case "Tentang Kami":
                  Get.to(TentangKamiPage());
                  break;
                case "Partner & Career":
                  Get.to(PartnerCareerPage());
                  break;
                case  "Feedback":
                 Get.to(FeedbackWebview());
                 break;
                default:
              }
            },
            child: CachedNetworkImage(
              imageUrl: data.image,
              placeholder: (context, url) => Center(
                child: CircularProgressIndicator(),
              ),
              imageBuilder: (context, imageProvider) => Container(
                margin: EdgeInsets.all(12),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.amberAccent,
                    image: DecorationImage(
                        colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(0.15), BlendMode.darken),
                        fit: BoxFit.cover,
                        image: imageProvider)),
              ),
            ),
          ),
          Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  data.title,
                  style: titleStyle.copyWith(
                    color: Colors.white,
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
