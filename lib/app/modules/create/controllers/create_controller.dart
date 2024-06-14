import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateController extends GetxController {
  late TextEditingController namaController;
  late TextEditingController stockController;
  late TextEditingController hargaController;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void addData(String nama, int stock, String harga) async {
    try {
      String dateNow = DateTime.now().toString();
      await firestore.collection('barang').add({
        'nama': nama,
        'stock': stock,
        'harga': harga,
        'time': dateNow
      }).then((DocumentReference doc) {
        firestore.collection('barang').doc(doc.id).update({
          'id_barang': doc.id,
        });
      });

      Get.back();
      Get.snackbar('Success', 'Data added successfully',
          colorText: Colors.white, backgroundColor: Colors.green);
      namaController.clear();
      stockController.clear();
      hargaController.clear(); // Clear harga controller
    } catch (e) {
      print(e);
    }
  }

  @override
  void onInit() {
    namaController = TextEditingController();
    stockController = TextEditingController();
    hargaController = TextEditingController(); // Initialize harga controller
    super.onInit();
  }

  @override
  void onClose() {
    namaController.dispose();
    stockController.dispose();
    hargaController.dispose(); // Dispose harga controller
    super.onClose();
  }
}
