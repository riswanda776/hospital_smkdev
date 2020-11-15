import 'package:flutter/material.dart';
import 'package:rumahsakit_smkdev/ui/component/Layanan/FasilitasView.dart';
import 'package:rumahsakit_smkdev/ui/component/Layanan/LayananText.dart';
import 'package:rumahsakit_smkdev/ui/component/Layanan/ListEventPromo.dart';
import 'package:rumahsakit_smkdev/ui/component/Layanan/SearchBar.dart';

class LayananPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        TextLayanan(),
        SearchBar(),
        FasilitasView(),
        ListEventPromo(),
      ],
    );
  }
}
