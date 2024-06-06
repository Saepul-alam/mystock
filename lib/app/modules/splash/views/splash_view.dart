import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({Key? key}) : super(key: key);
  @override
   Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF478755), Color(0xFFC3DBC8), Color(0xFF58665B)],
          ),
        ),
        child: Center(
          child: Image.asset(
            'assets/images/Group 8.png',
            width: 200,
            height: 200,
          ),
        ),
      ),
    );
  }
}
