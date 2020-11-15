import 'dart:convert';

import 'package:flutter/services.dart';

class Contact {
  String nama;
  String alamat;
  String email;
  String telepon;

  Contact({this.nama, this.alamat, this.email, this.telepon});

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
        nama: json['nama'],
        alamat: json['alamat'],
        email: json['email'],
        telepon: json['telepon']);
  }
}

Future<Contact> loadContact() async {
  final response = await rootBundle.loadString('assets/json/contact.json');
  var json = jsonDecode(response);
  return Contact.fromJson(json);
}
