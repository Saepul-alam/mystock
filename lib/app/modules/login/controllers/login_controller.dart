import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mystock/app/routes/app_pages.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  // bool obscureText = true;

  Stream<User?> get streamAuthStatus =>
      FirebaseAuth.instance.authStateChanges();

  void login(String email, String password) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (userCredential.user!.emailVerified) {
        Get.snackbar('Success', 'User logged in successfully',
            snackPosition: SnackPosition.TOP,
            duration: const Duration(seconds: 2),
            margin: const EdgeInsets.all(12),
            colorText: Colors.white,
            backgroundColor: Colors.green);
        emailController.clear();
        passwordController.clear();
        Get.offAllNamed(Routes.HOME);
      } else {
        Get.snackbar(
          'Error',
          'Please verify your email',
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 2),
          margin: const EdgeInsets.all(12),
          colorText: Colors.white,
          backgroundColor: Colors.red,
        );
      }
    } on FirebaseAuthException catch (e) {
      print(e.code);
      if (e.code == 'invalid-email') {
        Get.snackbar(
          'Error',
          'Email tidak valid, gunakan email yang valid.',
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 2),
          margin: const EdgeInsets.all(12),
          colorText: Colors.white,
          backgroundColor: Colors.red,
        );
      } else if (e.code == 'invalid-credential') {
        Get.snackbar(
          'Error',
          'Password atau email yang dimasukkan salah.',
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 2),
          margin: const EdgeInsets.all(12),
          colorText: Colors.white,
          backgroundColor: Colors.red,
        );
      } else if (e.code == 'channel-error') {
        Get.snackbar(
          'Error',
          'Email dan password tidak boleh kosong.',
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 2),
          margin: const EdgeInsets.all(12),
          colorText: Colors.white,
          backgroundColor: Colors.red,
        );
      }
      print(e.code);
    } catch (e) {
      print(e);
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
