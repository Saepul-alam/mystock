import 'package:mystock/app/modules/login/controllers/login_controller.dart';
import 'package:mystock/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginView extends GetView<LoginController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF5DA56C), Color(0xFFC3DBC8), Color(0xFF58665B)],
          ),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: ListView(
              children: [
                SizedBox(height: 20),
                Image.asset(
                  'assets/images/iconlogin.png',
                  height: 200,
                  width: 200,
                ),
                // Container(
                //   alignment: Alignment.center,
                //   padding: EdgeInsets.all(10),
                //   child: const Text(
                //     'Flutter Login Page',
                //     style: TextStyle(
                //         color: Colors.indigo,
                //         fontWeight: FontWeight.w500,
                //         fontSize: 30),
                //   ),
                // ),
                SizedBox(height: 10),
                Container(
                  width: 300,
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Username',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 5),
                      TextField(
                        controller: controller.emailController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          hintText: 'Enter your email',
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  width: 300,
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Password',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 5),
                      TextField(
                        obscureText: true,
                        controller: controller.passwordController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          hintText: 'Enter your password',
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Container(
                    height: 50,
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Color(0xFF478755),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32.0),
                        ),
                      ),
                      child: const Text('Login'),
                      onPressed: () => controller.login(
                          controller.emailController.text,
                          controller.passwordController.text),
                    )),
                TextButton(
                  onPressed: () {
                    Get.toNamed(Routes.RESET_PASSWORD);
                  },
                  child: Text('Forgot Password'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
