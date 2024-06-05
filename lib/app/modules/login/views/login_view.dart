import 'package:mystock/app/modules/login/controllers/login_controller.dart';
import 'package:mystock/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final LoginController controller = Get.put(LoginController());
  bool _obscureText = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

// class LoginView extends GetView<LoginController> {
//   const LoginView({super.key});
  
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
                        obscureText: _obscureText,
                        controller: controller.passwordController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          hintText: 'Enter your password',
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureText
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: _togglePasswordVisibility,
                          ),
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
