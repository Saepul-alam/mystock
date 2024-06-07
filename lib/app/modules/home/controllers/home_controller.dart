import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';

class HomeController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late Stream<QuerySnapshot<Map<String, dynamic>>> _streamData;
  RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _streamData = streamData();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamData() {
    return _firestore
        .collection('barang')
        .orderBy('nama', descending: false)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> search(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      return streamData();
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
        textCancel: "No",
      );
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

  void tambahPenjualan(
    String nama,
    int quantity,
    int hargaSatuan,
    int totalHargaBarang,
  ) async {
    var isExist = await _firestore
        .collection('penjualan')
        .where('nama', isEqualTo: nama)
        .get();
    try {
      if (isExist.size == 1) {
        Get.defaultDialog(
          title: 'Error',
          middleText: 'Barang telah ada di penjualan',
          textCancel: 'Oke',
        );
      } else {
        await _firestore.collection('penjualan').add({
          'nama': nama,
          'quantity': quantity,
          'harga_satuan': hargaSatuan,
          'total_harga_barang': totalHargaBarang,
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamDataPenjualan() {
    return _firestore.collection('penjualan').orderBy('nama').snapshots();
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
        textCancel: "No",
      );
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

  void updateHarga(String docId, int hargaBarang) async {
    try {
      await _firestore.collection('penjualan').doc(docId).update({
        'total_harga_barang': hargaBarang,
      });
    } catch (e) {
      print(e);
    }
  }

  late TextEditingController namaPelangganController;
  void submitPenjualan() {
    Get.defaultDialog(
      title: 'Konfirmasi Nama Pelanggan',
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(padding: EdgeInsets.only(bottom: 5)),
          TextField(
            controller: namaPelangganController,
            decoration: const InputDecoration(
              enabledBorder: UnderlineInputBorder(),
              labelText: 'Masukkan nama pelanggan',
            ),
          ),
          const Padding(padding: EdgeInsets.only(bottom: 15)),
        ],
      ),
      onConfirm: () {},
      textConfirm: 'Lanjutkan',
      textCancel: 'Batal',
      radius: 20,
    );
  }

  @override
  void onReady() {
    namaPelangganController = TextEditingController();
    super.onReady();
  }

  @override
  void onClose() {
    namaPelangganController.dispose();
    super.onClose();
  }
}
