import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SaleController extends GetxController {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
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

  void submitPenjualan() async {
    int i = 0;
    var penjualanQuery = await _firestore.collection('penjualan').get();
    var penjualan = penjualanQuery.docs;
    num totalHarga = 0;

    for (int i = 0; i < penjualan.length; i++) {
      totalHarga = totalHarga + penjualan[i]['total_harga_barang'];
    }

    DateTime now = DateTime.now();

    int unixTimeMillis = now.millisecondsSinceEpoch;

    await _firestore.collection('riwayat').add({
      'pelanggan': namaPelangganController.text,
    }).then((DocumentReference doc) {
      _firestore.collection('riwayat').doc(doc.id).update({
        'total_harga': totalHarga,
        'tanggal': unixTimeMillis,
        'id': doc.id,
      });
      for (i = 0; i < penjualan.length; i++) {
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

        _firestore.collection('barang').doc(penjualan[i]['id_barang']).update({
          'stock': penjualan[i]['stock_awal'] - penjualan[i]['quantity'],
        }).then((value) {
          for (var ds in penjualan) {
            ds.reference.delete();
          }
        });
      }
    });
  }

  late TextEditingController namaPelangganController;
  void konfirmasiPenjualan() async {
    try {
      int i = 0;
      var penjualanQuery = await _firestore.collection('penjualan').get();
      var penjualan = penjualanQuery.docs;
      int isValidTotal = 0;

      for (i = 0; i < penjualan.length; i++) {
        var stokQuery = await _firestore
            .collection('barang')
            .where('id_barang', isEqualTo: penjualan[i]['id_barang'])
            .get();
        var stok = stokQuery.docs;
        if (stok[0]['stock'] >= penjualan[i]['quantity']) {
          isValidTotal += 1;
        }
      }

      if (isValidTotal == penjualan.length) {
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
              const Padding(padding: EdgeInsets.only(bottom: 15))
            ],
          ),
          onConfirm: () {
            submitPenjualan();
            Get.back();
            Get.defaultDialog(
                title: 'Success',
                middleText: 'Barang berhasil dijual',
                textCancel: 'Oke');
          },
          textConfirm: 'Lanjutkan',
          textCancel: 'Batal',
          radius: 20,
        );
      } else {
        Get.defaultDialog(
          title: 'Gagal melakukan penjualan',
          middleText:
              'Stok barang pada gudang kurang dari permintaan pelanggan',
          textConfirm: 'Oke',
          onConfirm: () => Get.back(),
        );
      }
    } catch (e) {
      print(e);
    }
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
