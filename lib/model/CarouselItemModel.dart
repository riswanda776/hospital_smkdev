import 'dart:convert';

import 'package:flutter/services.dart';

class CarouselModel {
  String title;
  String body;
  String image;
  int key;

  CarouselModel({this.title, this.body, this.image,this.key});

  factory CarouselModel.fromJson(Map<String, dynamic> json) {
    return CarouselModel(
      title: json['title'],
      body: json['body'],
      image: json['image'],
      key: json['key']
    );
  }
}

Future<List<CarouselModel>> loadCarousel() async {
  final response = await rootBundle.loadString('assets/json/carousel.json');
  List json = jsonDecode(response);
  return json.map((e) => CarouselModel.fromJson(e)).toList();
}
