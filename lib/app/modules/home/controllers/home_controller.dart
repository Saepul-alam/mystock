// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';

class HomeController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Widget roleValidation() {
    if (_auth.currentUser?.uid == 'PvEnxP4jEgYygl875T9KFWR3VUg2') {
      return IconButton(
        onPressed: () {
          Get.toNamed(Routes.REGISTER);
        },
        icon: const Row(
          children: [
            Icon(
              Icons.account_circle,
              color: Colors.white,
            ),
            Icon(
              Icons.add,
              color: Colors.white,
            ),
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  Widget exitButton() {
    return IconButton(
        onPressed: () {
          _auth.signOut();
          Get.toNamed(Routes.LOGIN);
        },
        icon: const Icon(
          Icons.exit_to_app,
          color: Colors.white,
        ));
  }
}
