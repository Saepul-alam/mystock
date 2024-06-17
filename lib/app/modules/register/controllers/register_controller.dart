import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;

  void register(String email, String password, String name,
      String confirmPassword) async {
    if (email.isEmpty ||
        password.isEmpty ||
        name.isEmpty ||
        confirmPassword.isEmpty) {
      Get.snackbar(
        'Error',
        'Mohon isi semua kolom.',
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(12),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (password != confirmPassword) {
      Get.snackbar(
        'Error',
        'Password dan Konfirmasi Password tidak cocok.',
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(12),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await saveUserInfo(userCredential.user!.uid, email, name);

      Get.snackbar(
        'Success',
        'Pendaftaran berhasil. Silakan verifikasi email Anda untuk melanjutkan.',
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 5),
        margin: const EdgeInsets.all(12),
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      userCredential.user!.sendEmailVerification();
      Get.defaultDialog(
        title: 'Verifikasi Email Anda',
        middleText:
            'Mohon verifikasi email Anda untuk melanjutkan. Kami telah mengirimkan tautan verifikasi email ke alamat email Anda.',
        textConfirm: 'OK',
        confirmTextColor: Colors.white,
        onConfirm: () => Get.back(),
        barrierDismissible: false,
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Terjadi kesalahan. Silakan coba lagi.';
      if (e.code == 'weak-password') {
        errorMessage =
            'Password yang Anda masukkan terlalu lemah. Mohon gunakan password yang lebih kuat.';
      } else if (e.code == 'email-already-in-use') {
        errorMessage = 'Akun sudah ada untuk email tersebut.';
      }

      Get.snackbar(
        'Error',
        errorMessage,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 5),
        margin: const EdgeInsets.all(12),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );

      print('FirebaseAuthException: ${e.code}');
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> saveUserInfo(
    String userId,
    String email,
    String name,
  ) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        'email': email,
        'name': name,
      });
    } catch (e) {
      print('Error saving user info: $e');
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
