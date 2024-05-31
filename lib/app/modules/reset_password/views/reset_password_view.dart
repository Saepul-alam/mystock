
import 'package:mystock/app/modules/reset_password/controllers/reset_password_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class ResetPasswordView extends GetView<ResetPasswordController> {
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
            colors: [Color(0xFF5DA56C), Color(0xFFBDF4C9), Color(0xFFC3DBC8)],
          ),
        ),
        child: OrientationBuilder(
          builder: (context, orientation) {
            return Stack(
              children: [
                Padding(
                  padding: EdgeInsets.all(100),
                  child: ListView(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.only(left: 10),
                        child: const Text(
                          'Reset Your Password',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Color(0xFFFFFFFF),
                            fontWeight: FontWeight.w500,
                            fontSize: 30,
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                      Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.only(left: 10),
                        child: const Text(
                          'masukan email anda untuk bisa mengubah password',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Color(0xFFFFFFFF),
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        child: Text(
                          'Email',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        width: 300,
                        padding: EdgeInsets.only(left: 10),
                        child: TextField(
                          controller: controller.emailController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              
                              borderRadius: BorderRadius.circular(10),
                              
                            ),
                            hintText: 'Enter your email',
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        height: 50,
                        width: 300,
                        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Color(0xFF478755),
                            onPrimary: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text('Reset Password'),
                          onPressed: () => controller
                              .resetPassword(controller.emailController.text),
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        height: 50,
                        width: 300,
                        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Color(0xFF478755),
                              onPrimary: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text('back'),
                            onPressed: () {
                              Navigator.pop(context);
                            }),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
