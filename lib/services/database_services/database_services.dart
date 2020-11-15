import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';

class DatabaseServices extends GetxController {


  Future getHistoryBooking(String collection, String userID) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection(collection)
        .where("userID", isEqualTo: userID)
        .orderBy("tanggalBookingDokter", descending: true)
        .get();
    return snapshot.docs;
  }
  
  /// Method untuk search fasilitas dan partner
    Future searchData(
      {String searchKey, String collectionName, String value}) async {
    return FirebaseFirestore.instance
        .collection(collectionName)
        .where(value,
            isGreaterThanOrEqualTo: searchKey, isLessThan: searchKey + 'z')
        .get();
  }


/// Method untuk menampilkan event promo untuk carousel dan notifikasi 
  Future getEventPromoLimit() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('eventAndPromo')
        .limit(5)
        .get();
    return snapshot.docs;
  }


/// Method untuk menampilkan pasien berdasarkan user id
  Future getPasien(String userID) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("patient")
        .where("uid", isEqualTo: userID)
        .get();
    return snapshot.docs;
  }

  static Stream<QuerySnapshot> getDokter() {
    return FirebaseFirestore.instance.collection("dokter").snapshots();
  }

  static Stream<QuerySnapshot> getBerita() {
    return FirebaseFirestore.instance.collection("berita").snapshots();
  }

  static Stream<QuerySnapshot> getEventPromo() {
    return FirebaseFirestore.instance.collection("eventAndPromo").snapshots();
  }

  static Stream<QuerySnapshot> getFasilitas() {
    return FirebaseFirestore.instance.collection("fasilitas").snapshots();
  }


/// method untuk menambahkan user ke firestore
  static Future<void> addUser(String uid, String nama, String jenisKelamin,
      String nomor, String email, String photo) async {
    await FirebaseFirestore.instance.collection("user").doc(uid).set(
        {
          'nama': nama,
          'jeniskelamin': jenisKelamin,
          'nomor': nomor,
          'email': email,
          'photo': photo,
        },
        SetOptions(
          merge: true,
        ));
  }


/// method untuk menambahkan photo profile
  static Future<void> addPhoto(String uid, String photoUrl) async {
    await FirebaseFirestore.instance.collection("user").doc(uid).set(
      {
        'photo': photoUrl,
      },
      SetOptions(merge: true),
    );
  }


/// method untuk mendapatkan data user berdasarkan user id
  static Future<DocumentSnapshot> getUser(String uid) async {
    return await FirebaseFirestore.instance.collection('user').doc(uid).get();
  }


/// method untuk upload photo profile
  static Future<String> uploadImage(File imageFile) async {
    String fileName = basename(imageFile.path);
    StorageReference ref = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask task = ref.putFile(imageFile);
    StorageTaskSnapshot snapshot = await task.onComplete;

    return await snapshot.ref.getDownloadURL();
  }


/// method untuk menambahkan pasien
  static Future<void> addPasien(
      String uid, String nama, String jeniskelamin, String status) async {
    await FirebaseFirestore.instance.collection("patient").add({
      'uid': uid,
      'nama': nama,
      'jeniskelamin': jeniskelamin,
      'status': status,
    });
  }


/// method untuk booking dokter
  static Future<void> addBookingDokter(
      {String kodeBooking,
      String uid,
      String namaDokter,
      String spesialisDokter,
      String fotoDokter,
      String namaPasien,
      String jenisKelamin,
      String status,
      DateTime tanggalBookingDokter,
      DateTime tanggalBooking,
      String pesan}) async {
    await FirebaseFirestore.instance.collection("booking").add({
      'kodeBooking': kodeBooking,
      'userID': uid,
      'namaDokter': namaDokter,
      'spesialis': spesialisDokter,
      'fotoDokter': fotoDokter,
      'namaPasien': namaPasien,
      'jenisKelamin': jenisKelamin,
      'status': status,
      'tanggalBookingDokter': tanggalBookingDokter,
      'tanggalBooking': tanggalBooking,
      'pesan': pesan,
    });
  }
}
