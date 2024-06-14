import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdateController extends GetxController {
  late TextEditingController namaController;
  late TextEditingController stockController;
  late TextEditingController hargaController;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<DocumentSnapshot<Object?>> getData(String docID) async {
    DocumentReference docRef = firestore.collection('barang').doc(docID);
    return docRef.get();
  }

  void updateData(String docID, String nama, int stock, String harga) async {
    try {
      await firestore.collection('barang').doc(docID).update({
        'nama': nama,
        'stock': stock,
        'harga': harga, // Include harga in Firestore data
      });

      Get.back();
      Get.snackbar('Success', 'Data updated successfully',
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 2),
          margin: EdgeInsets.all(12),
          colorText: Colors.white,
          backgroundColor: Colors.green);
    } catch (e) {
      print(e);
      Get.snackbar('Error', 'Failed updating data',
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 2),
          margin: EdgeInsets.all(12),
          colorText: Colors.white,
          backgroundColor: Colors.red);
    }
  }

  @override
  void onInit() {
    namaController = TextEditingController();
    stockController = TextEditingController();
    hargaController = TextEditingController();
    super.onInit();
  }

  @override
  void onClose() {
    namaController.dispose();
    stockController.dispose();
    hargaController.dispose();
    super.onClose();
  }
}
