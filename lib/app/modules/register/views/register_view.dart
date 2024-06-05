import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mystock/app/modules/register/controllers/register_controller.dart';
import 'package:mystock/app/routes/app_pages.dart';

class RegisterView extends GetView<RegisterController> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xFF478755),
            title: Text(
              'SRI REZEKI',
              style: TextStyle(color: Color(0xffffffff)),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  Get.toNamed(Routes.REGISTER);
                },
                icon: Row(
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
              ),
            ],
          ),
          body: Container(
            child: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.all(20),
                  child: ListView(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(10),
                        child: const Text(
                          'Register Page',
                          style: TextStyle(
                              color: Color(0xFF478755),
                              fontWeight: FontWeight.w500,
                              fontSize: 30),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Username',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 5),
                            TextField(
                              controller: controller.emailController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Name',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 5),
                            TextField(
                              controller: controller.nameController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Password',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 5),
                            TextField(
                              obscureText: true,
                              controller: controller.passwordController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Confirm Password',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 5),
                            TextField(
                              obscureText: true,
                              controller: controller.confirmPasswordController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 30),
                      Container(
                        height: 50,
                        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Color(0xFF478755),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text('Register'),
                          onPressed: () => controller.register(
                            controller.emailController.text,
                            controller.passwordController.text,
                            controller.nameController.text,
                          ),
                        ),
                      ),
                      // SizedBox(height: 48),
                      // TabBar(
                      //   indicatorColor: Colors.green[900],
                      //   tabs: [
                      //     Tab(text: 'Stock'),
                      //     Tab(text: 'Penjualan'),
                      //     Tab(text: 'Riwayat'),
                      //   ],
                      // ),

                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: [
                      //     Text('Already have an account?'),
                      //     TextButton(
                      //       child: Text('Login'),
                      //       onPressed: () => Get.back(),
                      //     )
                      //   ],
                      // )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
