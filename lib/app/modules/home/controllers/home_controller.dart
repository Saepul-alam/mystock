import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../routes/app_pages.dart';

class HomeController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Controller untuk Tab Stock Barang

  late Stream<QuerySnapshot<Map<String, dynamic>>> _streamData;
  @override
  void onInit() {
    super.onInit();
    _streamData = streamData();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamData() {
    CollectionReference<Map<String, dynamic>> data =
        _firestore.collection('barang');
    return data.orderBy('nama', descending: false).snapshots();
  }

  void search(String keyword) {
    _streamData = FirebaseFirestore.instance
        .collection('barang')
        .where('nama', isGreaterThanOrEqualTo: keyword)
        .snapshots();
    update();
  }

  void deleteData(String docID) {
    try {
      Get.defaultDialog(
          title: "Delete Barang",
          middleText: "Are you sure you want to delete this Barang?",
          onConfirm: () {
            _firestore.collection('barang').doc(docID).delete();
            Get.back();
            Get.snackbar(
              'Success',
              'Data deleted successfully',
              snackPosition: SnackPosition.BOTTOM,
              duration: const Duration(seconds: 2),
              margin: const EdgeInsets.all(12),
            );
          },
          textConfirm: "Yes, I'm sure",
          textCancel: "No");
    } catch (e) {
      print(e);
      Get.snackbar(
        'Error',
        'Cannot delete this Barang',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(12),
      );
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    Get.offAllNamed(Routes.LOGIN);
  }

  // Controller untuk Tab Penjualan

  void tambahPenjualan(String nama, int quantity, int totalHarga) async {
    var isExist = await _firestore
        .collection('penjualan')
        .where('nama', isEqualTo: nama)
        .get();

    try {
      if (isExist.size == 1) {
        Get.defaultDialog(
            title: 'Error',
            middleText: 'Barang telah ada di penjualan',
            textCancel: 'Oke');
      } else {
        await _firestore.collection('penjualan').add({
          'nama': nama,
          'quantity': quantity,
          'total_harga': totalHarga,
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamDataPenjualan() {
    CollectionReference<Map<String, dynamic>> data =
        _firestore.collection('penjualan');
    return data.orderBy('nama').snapshots();
  }

  void deleteDataPenjualan(String docID) {
    try {
      Get.defaultDialog(
          title: "Delete Barang",
          middleText: "Yakin menghapus barang ini?",
          onConfirm: () {
            _firestore.collection('penjualan').doc(docID).delete();
            Get.back();
            Get.snackbar(
              'Success',
              'Data deleted successfully',
              snackPosition: SnackPosition.BOTTOM,
              duration: const Duration(seconds: 2),
              margin: const EdgeInsets.all(12),
            );
          },
          textConfirm: "Yes, I'm sure",
          textCancel: "No");
    } catch (e) {
      print(e);
      Get.snackbar(
        'Error',
        'Cannot delete this Barang',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(12),
      );
    }
  }

  void updateJumlah(String docID, int quantity) async {
    try {
      await _firestore.collection('penjualan').doc(docID).update({
        'quantity': quantity,
      });
    } catch (e) {
      print(e);
    }
  }
}
