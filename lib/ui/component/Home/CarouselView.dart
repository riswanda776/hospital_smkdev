import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rumahsakit_smkdev/services/database_services/database_services.dart';
import 'package:rumahsakit_smkdev/ui/constant/constant.dart';
import 'package:rumahsakit_smkdev/ui/widget/CustomDetailsPage.dart';

class CarouselView extends StatefulWidget {
  @override
  _CarouselViewState createState() => _CarouselViewState();
}

class _CarouselViewState extends State<CarouselView> {
  /// Index of pageview
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DatabaseServices>(
      init: DatabaseServices(),
      builder: (controller) => FutureBuilder(
        future: controller.getEventPromoLimit(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Stack(
              children: [
                Container(
                    height: setHeight(750),
                    child: PageView.builder(
                        onPageChanged: (value) =>
                            setState(() => currentIndex = value),
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, i) =>
                            _carouselContent(i, snapshot.data[i].data()))),
                Positioned(
                  top: setHeight(670),
                  left: setHeight(50),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        children: List.generate(snapshot.data.length,
                            (index) => carouselDot(index)),
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
        },
      ),
    );
  }


/// Carousel content 
  Widget _carouselContent(int i, Map<String, dynamic> data) {
    return CachedNetworkImage(
      imageUrl: data['gambar'],
      placeholder: (context, url) => Center(
        child: CircularProgressIndicator(),
      ),
      imageBuilder: (context, imageProvider) => GestureDetector(
        onTap: () {
          Get.to(CustomDetailsPage(data));
        },
        child: Container(
          decoration: BoxDecoration(
              color: grayColor.withOpacity(0.5),
              image: DecorationImage(
                colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.35), BlendMode.darken),
                fit: BoxFit.cover,
                image: imageProvider,
              )),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data['Judul'],
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: setFontSize(70)),
                ),
                SizedBox(
                  height: setHeight(30),
                ),
                Text(
                  data['isi'],
                  overflow: TextOverflow.clip,
                  maxLines: 3,
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

/// Dot Indicator
  AnimatedContainer carouselDot(int index) {
    return AnimatedContainer(
      margin: EdgeInsets.only(right: 5),
      duration: Duration(milliseconds: 300),
      height: 6,
      width: currentIndex == index ? 15 : 6,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: currentIndex == index ? primaryColor : Colors.white,
      ),
    );
  }
}
