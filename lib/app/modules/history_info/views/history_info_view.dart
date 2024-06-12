// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// import 'package:get/get.dart';
// import '../controllers/history_info_controller.dart';

// class HistoryInfoView extends GetView<HistoryInfoController> {
//   const HistoryInfoView({Key? key}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF478755),
//         title: const Text(
//           'Detail Riwayat',
//           style: TextStyle(color: Color(0xffffffff)),
//         ),
//         centerTitle: true,
//       ),
//       body: FutureBuilder<DocumentSnapshot>(
//         future: controller.getRiwayatById(Get.arguments),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (!snapshot.data!.exists) {
//             return Center(child: Text('Riwayat not found'));
//           } else {
//             final riwayatData = snapshot.data!.data() as Map<String, dynamic>;
//             return Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Container(
//                     width: double.maxFinite,
//                     margin: const EdgeInsets.symmetric(
//                         vertical: 8.0, horizontal: 12.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const Text(
//                           "Pelanggan",
//                           style: TextStyle(
//                             fontWeight: FontWeight.w400,
//                             color: Colors.black54,
//                             fontSize: 16,
//                           ),
//                           textAlign: TextAlign.left,
//                         ),
//                         Text(
//                           riwayatData['pelanggan'],
//                           style: const TextStyle(
//                             color: Colors.black87,
//                             fontWeight: FontWeight.w500,
//                             fontSize: 16,
//                           ),
//                         ),
//                         const SizedBox(height: 15),
//                         const Text(
//                           "Tanggal",
//                           style: TextStyle(
//                             fontWeight: FontWeight.w400,
//                             color: Colors.black54,
//                             fontSize: 16,
//                           ),
//                           textAlign: TextAlign.left,
//                         ),
//                         Text(
//                           controller.formatDate(riwayatData['tanggal']),
//                           style: const TextStyle(
//                             color: Colors.black87,
//                             fontWeight: FontWeight.w500,
//                             fontSize: 16,
//                           ),
//                         ),
//                       ],
//                     )),
//                 const Divider(
//                   height: 20,
//                   thickness: 8,
//                   indent: 0,
//                   endIndent: 0,
//                   color: Color.fromRGBO(241, 245, 249, 1),
//                 ),
//                 // SizedBox(height: 20),
//                 Container(
//                   margin: const EdgeInsets.symmetric(
//                       vertical: 8.0, horizontal: 12.0),
//                   child: const Text('Daftar Barang',
//                       style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black87)),
//                 ),
//                 Expanded(
//                   child: StreamBuilder<QuerySnapshot>(
//                     stream: controller.getBarangRiwayat(snapshot.data!.id),
//                     builder: (context, snapshot) {
//                       if (snapshot.connectionState == ConnectionState.waiting) {
//                         return Center(child: CircularProgressIndicator());
//                       } else if (snapshot.hasError) {
//                         return Center(child: Text('Error: ${snapshot.error}'));
//                       } else if (snapshot.data!.docs.isEmpty) {
//                         return Center(child: Text('Belum ada barang riwayat'));
//                       } else {
//                         return ListView.builder(
//                           itemCount: snapshot.data!.docs.length,
//                           itemBuilder: (context, index) {
//                             final barangRiwayatData = snapshot.data!.docs[index]
//                                 .data() as Map<String, dynamic>;
//                             return Container(
//                                 margin: const EdgeInsets.symmetric(
//                                     vertical: 8.0, horizontal: 8.0),
//                                 decoration: const BoxDecoration(
//                                   border: Border(
//                                     bottom: BorderSide(
//                                       color: Color.fromRGBO(226, 232, 240, 1),
//                                       width: 2.0,
//                                     ),
//                                   ),
//                                 ),
//                                 child: ListTile(
//                                   title: Text(
//                                     barangRiwayatData['nama'],
//                                     style: const TextStyle(
//                                       color: Colors.black87,
//                                       fontWeight: FontWeight.w600,
//                                       fontSize: 18,
//                                     ),
//                                   ),
//                                   subtitle: Text(
//                                       '${controller.formatCurrency(barangRiwayatData['harga_satuan'])} x ${barangRiwayatData['quantity']}'),
//                                   trailing: Text(
//                                     controller.formatCurrency(barangRiwayatData[
//                                         'total_harga_barang']),
//                                     style: const TextStyle(
//                                       fontWeight: FontWeight.w600,
//                                       fontSize: 18,
//                                     ),
//                                   ),
//                                 ));
//                           },
//                         );
//                       }
//                     },
//                   ),
//                 ),
//                 Container(
//                   padding: EdgeInsets.only(top: 16),
//                   decoration: const BoxDecoration(
//                     border: Border(
//                       top: BorderSide(
//                         color: Color.fromRGBO(226, 232, 240, 1),
//                         width: 3.0,
//                       ),
//                     ),
//                   ),
//                   margin: const EdgeInsets.symmetric(
//                       vertical: 12.0, horizontal: 12.0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       const Text(
//                         "Total",
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 20,
//                         ),
//                       ),
//                       Text(
//                         controller.formatCurrency(riwayatData['total_harga']),
//                         style: const TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 20,
//                         ),
//                       )
//                       const SizedBox(height: 30);
//                       ElevatedButton(
//                         onPressed: () {
//                           // Menyiapkan argumen yang diperlukan
//                           List<Map<String, dynamic>> barangRiwayatData =
//                               []; // Ganti dengan data barang riwayat yang sesuai
//                           String jenis =
//                               ''; // Ganti dengan jenis riwayat yang sesuai
//                           int tanggal =
//                               0; // Ganti dengan tanggal riwayat yang sesuai

//                           // Memanggil metode printPdf dengan argumen yang disiapkan
//                           controller.printPdf(
//                               barangRiwayatData, jenis, tanggal);
//                         },
//                         child: Text('Cetak Riwayat'),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             );
//           }
//         },
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/history_info_controller.dart';

class HistoryInfoView extends GetView<HistoryInfoController> {
  const HistoryInfoView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF478755),
        title: const Text(
          'Detail Riwayat',
          style: TextStyle(color: Color(0xffffffff)),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: controller.getRiwayatById(Get.arguments),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.data!.exists) {
            return Center(child: Text('Riwayat not found'));
          } else {
            final riwayatData = snapshot.data!.data() as Map<String, dynamic>;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.maxFinite,
                  margin: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 12.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Pelanggan",
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Colors.black54,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      Text(
                        riwayatData['pelanggan'],
                        style: const TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        "Tanggal",
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Colors.black54,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      Text(
                        controller.formatDate(riwayatData['tanggal']),
                        style: const TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(
                  height: 20,
                  thickness: 8,
                  indent: 0,
                  endIndent: 0,
                  color: Color.fromRGBO(241, 245, 249, 1),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 12.0,
                  ),
                  child: const Text(
                    'Daftar Barang',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: controller.getBarangRiwayat(snapshot.data!.id),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (snapshot.data!.docs.isEmpty) {
                        return Center(child: Text('Belum ada barang riwayat'));
                      } else {
                        return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            final barangRiwayatData = snapshot.data!.docs[index]
                                .data() as Map<String, dynamic>;
                            return Container(
                              margin: const EdgeInsets.symmetric(
                                vertical: 8.0,
                                horizontal: 8.0,
                              ),
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Color.fromRGBO(226, 232, 240, 1),
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              child: ListTile(
                                title: Text(
                                  barangRiwayatData['nama'],
                                  style: const TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18,
                                  ),
                                ),
                                subtitle: Text(
                                  '${controller.formatCurrency(barangRiwayatData['harga_satuan'])} x ${barangRiwayatData['quantity']}',
                                ),
                                trailing: Text(
                                  controller.formatCurrency(
                                    barangRiwayatData['total_harga_barang'],
                                  ),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 16),
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: Color.fromRGBO(226, 232, 240, 1),
                        width: 3.0,
                      ),
                    ),
                  ),
                  margin: const EdgeInsets.symmetric(
                    vertical: 12.0,
                    horizontal: 12.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Total",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        controller.formatCurrency(riwayatData['total_harga']),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: () {
                          // Menyiapkan argumen yang diperlukan
                          List<Map<String, dynamic>> barangRiwayatData =
                              []; // Ganti dengan data barang riwayat yang sesuai
                          String jenis =
                              ''; // Ganti dengan jenis riwayat yang sesuai
                          int tanggal =
                              0; // Ganti dengan tanggal riwayat yang sesuai

                          // Memanggil metode printPdf dengan argumen yang disiapkan
                          controller.printPdf(
                              barangRiwayatData, jenis, tanggal);
                        },
                        child: Text('Cetak Riwayat'),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
