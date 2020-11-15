import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SelectPasienProvider extends ChangeNotifier {
  String _nama;
  String _jenisKelamin;
  String _status;

  

  selectPasien(String nama, String jenisKelamin, String status) {
    _nama = nama;
    _jenisKelamin = jenisKelamin;
    _status = status;
    notifyListeners();
  }

  String get nama => _nama;
  String get jenisKelamin => _jenisKelamin;
  String get status => _status;
}
