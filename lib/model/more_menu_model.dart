import 'dart:convert';

import 'package:flutter/services.dart';

class MoreMenuModel {
  String title;
  String image;

  MoreMenuModel({this.title, this.image});

  factory MoreMenuModel.fromJson(Map<String, dynamic> json) {
    return MoreMenuModel(
      title: json['title'],
      image: json['image'],
    );
  }
}

Future<List<MoreMenuModel>> loadMoreMenuModel() async {
  final response = await rootBundle.loadString('assets/json/more_menu.json');
  List json = jsonDecode(response);
  return json.map((e) => MoreMenuModel.fromJson(e)).toList();
}
