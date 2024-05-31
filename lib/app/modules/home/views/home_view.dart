// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../../routes/app_pages.dart';
// import '../controllers/home_controller.dart';

// class HomeView extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final HomeController controller = Get.find<HomeController>();

//     return DefaultTabController(
//       length: 3,
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text(
//             'SRI REZEKI',
//             style: TextStyle(color: Color(0xffffffff)),
//           ),
//           backgroundColor: Color(0xFF478755),
//           centerTitle: true,
//           actions: [
//             IconButton(
//               onPressed: () {
//                 Get.toNamed(Routes.REGISTER);
//               },
//               icon: Row(
//                 // Menggunakan Row untuk menampilkan dua ikon sekaligus
//                 children: [
//                   Icon(Icons.account_circle), // ikon profil
//                   Icon(Icons.add), // ikon tambah
//                 ],
//               ),
//             ),
//             body: TabBarView(
//           children: [
//             // Isi tab
//             // Misalnya: StockView(), PenjualanView(), RiwayatView()
//           ],
//         ),
//         bottomNavigationBar: TabBar(
//           tabs: [
//             Text('Stock'),
//             Text('Penjualan'),
//             Text('Riwayat'),
//           ],
//         ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../controllers/home_controller.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find<HomeController>();

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'SRI REZEKI',
            style: TextStyle(color: Color(0xffffffff)),
          ),
          backgroundColor: Color(0xFF478755),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                Get.toNamed(Routes.REGISTER);
              },
              icon: Row(
                children: [
                  Icon(Icons.account_circle), // ikon profil
                  Icon(Icons.add), // ikon tambah
                ],
              ),
            ),
          ],
          bottom: TabBar(
            tabs: [
              Text('Stock'),
              Text('Penjualan'),
              Text('Riwayat'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Isi tab
            // Misalnya: StockView(), PenjualanView(), RiwayatView()
          ],
        ),
      ),
    );
  }
}
