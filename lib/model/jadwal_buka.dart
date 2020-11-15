import 'dart:convert';

import 'package:flutter/services.dart';

class JadwalBuka {
  String namaTempat;
  String alamat;
  String jadwal1;
  String jadwal2;

  JadwalBuka({this.namaTempat, this.alamat, this.jadwal1, this.jadwal2});

  factory JadwalBuka.fromJson(Map<String, dynamic> json) {
    return JadwalBuka(
      namaTempat: json['nama_tempat'],
      alamat: json['alamat'],
      jadwal1: json['jadwal1'],
      jadwal2: json['jadwal2'],
    );
  }
}

Future<List<JadwalBuka>> getJadwal() async {
  final response = await rootBundle.loadString('assets/json/jadwal_rs.json');
  List json = jsonDecode(response);
  return json.map((e) => JadwalBuka.fromJson(e)).toList();
}
