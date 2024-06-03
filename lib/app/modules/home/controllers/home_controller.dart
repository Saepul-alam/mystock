import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../routes/app_pages.dart';

class HomeController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final image = Rx<XFile?>(null);
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final phoneController = TextEditingController();
  late Stream<QuerySnapshot<Map<String, dynamic>>> _streamData;
  @override
  void onInit() {
    // Load user data when the controller is initialized
    super.onInit();
    getUserData();
    _streamData = streamData();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamData() {
    CollectionReference<Map<String, dynamic>> data =
        _firestore.collection('barang');
    return data.orderBy('nama', descending: true).snapshots();
  }

  void search(String keyword) {
    _streamData = FirebaseFirestore.instance
        .collection('barang')
        .where('nama', isGreaterThanOrEqualTo: keyword)
        .snapshots();
    update(); // Update the stream to reflect changes
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
              duration: Duration(seconds: 2),
              margin: EdgeInsets.all(12),
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
        duration: Duration(seconds: 2),
        margin: EdgeInsets.all(12),
      );
    }
  }

  Future<void> getImage(bool gallery) async {
    final picker = ImagePicker();
    XFile? pickedFile;

    if (gallery) {
      pickedFile = await picker.pickImage(source: ImageSource.gallery);
    } else {
      pickedFile = await picker.pickImage(source: ImageSource.camera);
    }

    if (pickedFile != null) {
      image.value = pickedFile;
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    Get.offAllNamed(Routes.LOGIN);
  }

  void getUserData() async {
    final user = _auth.currentUser;
    if (user != null) {
      final userData = await _firestore.collection('users').doc(user.uid).get();
      if (userData.exists) {
        nameController.text = userData['name'] ?? '';
        addressController.text = userData['address'] ?? '';
        phoneController.text = userData['phone'] ?? '';
      }
    }
  }

  Future<void> updateUserData() async {
    final user = _auth.currentUser;
    if (user != null) {
      try {
        await _firestore.collection('users').doc(user.uid).set({
          'name': nameController.text.trim(),
          'address': addressController.text.trim(),
          'phone': phoneController.text.trim(),
        }, SetOptions(merge: true));
        Get.snackbar(
          'Success',
          'User data updated successfully',
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 2),
          margin: EdgeInsets.all(12),
        );
      } catch (e) {
        print('Error updating user data: $e');
        Get.snackbar(
          'Error',
          'Failed to update user data',
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 2),
          margin: EdgeInsets.all(12),
        );
      }
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    addressController.dispose();
    phoneController.dispose();
    super.onClose();
  }
}
