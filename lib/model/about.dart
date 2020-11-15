import 'dart:convert';
import 'package:flutter/services.dart';

class About {
  String imageUrl;
  String title;
  String body;
  List<Section> section;

  About({this.imageUrl, this.title, this.body, this.section});

  factory About.fromJson(Map<String, dynamic> json) {
    return About(
        imageUrl: json['imageUrl'],
        title: json['title'],
        body: json['body'],
        section: List<Section>.from(
            json['section'].map((e) => Section.fromJson(e))));
  }
}

class Section {
  String icon;
  String title;
  String columTitle1;
  String columText1;
  String columTitle2;
  String columText2;
  String columTitle3;
  String columText3;
  bool isTreeColum;

  Section({
    this.icon,
    this.title,
    this.columTitle1,
    this.columText1,
    this.columTitle2,
    this.columText2,
    this.columTitle3,
    this.columText3,
    this.isTreeColum,
  });

  factory Section.fromJson(Map<String, dynamic> json) {
    return Section(
        icon: json['icon'],
        title: json['title'],
        columTitle1: json['columTitle1'],
        columText1: json['columText1'],
        columTitle2: json['columTitle2'],
        columText2: json['columText2'],
        columTitle3: json['columTitle3'],
        columText3: json['columText3'],
        isTreeColum: json['isTreeColum']);
  }
}

Future<About> loadAbout() async {
  final response = await rootBundle.loadString('assets/json/about.json');
  var json = jsonDecode(response);
  return About.fromJson(json);
}
