import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:rumahsakit_smkdev/model/about.dart';
import 'package:rumahsakit_smkdev/ui/constant/constant.dart';

class TentangKamiPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String imageUrl =
        "https://asset.kompas.com/crops/mOKFrYHlSTM6SEt4aD9PIXZnJE0=/0x5:593x400/750x500/data/photo/2020/03/16/5e6ee88f78835.jpg";

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () => Get.back(),
        ),
        title: Text(
          "Tentang Kami",
          style: titleStyle.copyWith(
              color: Colors.black, fontSize: setFontSize(50)),
        ),
      ),
      body: FutureBuilder(
          future: loadAbout(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              About about = snapshot.data;

              return ListView(
                children: [
                  CachedNetworkImage(
                    imageUrl: imageUrl,
                    placeholder: (context, url) => Center(
                      child: CircularProgressIndicator(),
                    ),
                    imageBuilder: (context, imageProvider) => Container(
                      height: setHeight(600),
                      decoration: BoxDecoration(
                        color: grayColor,
                        image: DecorationImage(
                            fit: BoxFit.cover, image: imageProvider),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 10, 18, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: setHeight(50),
                        ),
                        Text(
                          about.title,
                          textAlign: TextAlign.start,
                          style: titleStyle.copyWith(
                              color: primaryColor, fontSize: setFontSize(50)),
                        ),
                        SizedBox(
                          height: setHeight(30),
                        ),
                        Text(about.body),
                        SizedBox(
                          height: setHeight(100),
                        ),
                        Column(
                          children: about.section
                              .map((e) => buildService(e))
                              .toList(),
                        ),
                        SizedBox(
                          height: setHeight(80),
                        )
                      ],
                    ),
                  )
                ],
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }

  Column buildService(Section section) {
    return Column(
      children: [
        SizedBox(
          height: setHeight(100),
        ),
        Center(
          child: Container(
            height: setHeight(300),
            width: setHeight(400),
            child: SvgPicture.asset("assets/icons8-google-maps.svg"),
          ),
        ),
        SizedBox(
          height: setHeight(40),
        ),
        Text(
          section.title ?? "",
          style: titleStyle,
        ),
        SizedBox(
          height: setHeight(80),
        ),
        Column(
          children: [
            Text(
              section.columTitle1 ?? "anu",
              style: titleStyle.copyWith(fontSize: setFontSize(40)),
            ),
            Text(section.columText1 ?? "a")
          ],
        ),
        SizedBox(
          height: setHeight(40),
        ),
        Column(
          children: [
            Text(
              section.columTitle2 ?? "a",
              style: titleStyle.copyWith(fontSize: setFontSize(40)),
            ),
            Text(section.columText2 ?? "aa")
          ],
        ),
        SizedBox(
          height: setHeight(40),
        ),
        section.isTreeColum
            ? Column(
                children: [
                  Text(
                    section.columTitle3 ?? "aaa",
                    style: titleStyle.copyWith(fontSize: setFontSize(40)),
                  ),
                  Text(section.columText3 ?? "aaa")
                ],
              )
            : SizedBox(),
      ],
    );
  }
}
