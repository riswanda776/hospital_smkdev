import 'package:flutter/material.dart';
import 'package:rumahsakit_smkdev/ui/component/Home/AboutView.dart';
import 'package:rumahsakit_smkdev/ui/component/Home/CarouselView.dart';
import 'package:rumahsakit_smkdev/ui/component/Home/NewsContantAndFeeback.dart';
import 'package:rumahsakit_smkdev/ui/component/Home/LocationView.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        CarouselView(),
        LocationView(),
        AboutView(),
        ContactAndFeedback(),
      ],
    );
  }
}
