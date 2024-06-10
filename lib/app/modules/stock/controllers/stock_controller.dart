import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';

class StockController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  //TODO: Implement StockController

  late Stream<QuerySnapshot<Map<String, dynamic>>> streamData;
  RxString searchQuery = ''.obs;
  @override
  void onInit() {
    super.onInit();
    streamData = _streamData();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> _streamData() {
    CollectionReference<Map<String, dynamic>> data =
        _firestore.collection('barang');
    return data.orderBy('nama', descending: false).snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> search(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      return _streamData();
    } else {
      return _firestore
          .collection('barang')
          .where('nama', isGreaterThanOrEqualTo: query)
          .where('nama', isLessThanOrEqualTo: query + '\uf8ff')
          .snapshots();
    }
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

  void tambahPenjualan(String nama, int quantity, int hargaSatuan,
      int totalHargaBarang, String idBarang, int stock) async {
    var stokBarang = await _firestore.collection('barang').doc(idBarang).get();
    var isExist = await _firestore
        .collection('penjualan')
        .where('id_barang', isEqualTo: idBarang)
        .get();
    try {
      if (stokBarang['stock'] > 0) {
        if (isExist.size == 1) {
          Get.defaultDialog(
              title: 'Error',
              middleText: 'Barang telah ada di penjualan',
              textCancel: 'Oke');
        } else {
          await _firestore.collection('penjualan').doc(idBarang).set({
            'nama': nama,
            'quantity': quantity,
            'harga_satuan': hargaSatuan,
            'total_harga_barang': totalHargaBarang,
            'id_barang': idBarang,
            'stock_awal': stock,
          });
        }
      } else {
        Get.defaultDialog(
          title: 'Stok Habis',
          middleText:
              'Stok barang yang dipilih habis, silahkan edit barang jika stok di gundang sudah bertambah',
          textConfirm: 'Oke',
          onConfirm: () => Get.back(),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    Get.offAllNamed(Routes.LOGIN);
  }
}
