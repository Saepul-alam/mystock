import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../routes/app_pages.dart';

class HomeController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

// ================================= Controller untuk Tab Stock Barang ==================================

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

// ====================== Controller untuk Tab Penjualan ============================

  void tambahPenjualan(
      String nama, int quantity, int hargaSatuan, int totalHargaBarang) async {
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
          'harga_satuan': hargaSatuan,
          'total_harga_barang': totalHargaBarang,
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
  void konfirmasiPenjualan(String pelanggan) async {
    try {
      var penjualanQuery = await _firestore.collection('penjualan').get();
      var penjualan = penjualanQuery.docs;
      num totalHarga = 0;

      for (int i = 0; i < penjualan.length; i++) {
        totalHarga = totalHarga + penjualan[i]['total_harga_barang'];
      }

      DateTime now = DateTime.now();

      // Mendapatkan Unix time dalam milidetik
      int unixTimeMillis = now.millisecondsSinceEpoch;
      await _firestore.collection('riwayat').add({
        'pelanggan': pelanggan,
      }).then((DocumentReference doc) {
        _firestore.collection('riwayat').doc(doc.id).update({
          'total_harga': totalHarga,
          'tanggal': unixTimeMillis,
          'id': doc.id,
        });
        for (int i = 0; i < penjualan.length; i++) {
          _firestore
              .collection('riwayat')
              .doc(doc.id)
              .collection('barang_riwayat')
              .add({
            'nama': penjualan[i]['nama'],
            'quantity': penjualan[i]['quantity'],
            'harga_satuan': penjualan[i]['harga_satuan'],
            'total_harga_barang': penjualan[i]['total_harga_barang'],
          });
        }
      });
    } catch (e) {
      print(e);
    }
  }

  // ====================== Controller untuk Tab Riwayat ============================
  final CollectionReference riwayatCollection =
      FirebaseFirestore.instance.collection('riwayat');
  final CollectionReference barangRiwayatCollection =
      FirebaseFirestore.instance.collection('penjualan');

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot<Object?>> streamDataRiwayat() {
    CollectionReference data = firestore.collection('riwayat');
    return data.snapshots();
  }

  String formatCurrency(int amount) {
    final formatter =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);
    return formatter.format(amount);
  }

  String formatDate(int tgl) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(tgl);
    String formattedDate = DateFormat('dd MMMM yyyy', 'id_ID').format(dateTime);
    // DateFormat('dd MMMM yyyy -', 'id_ID').add_jm().format(dateTime);
    return formattedDate;
  }

  // String formatDateJM(int tgl) {
  //   DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(tgl);
  //   String formattedDate =
  //       DateFormat('dd MMMM yyyy -', 'id_ID').add_jm().format(dateTime);
  //   return formattedDate;
  // }

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
