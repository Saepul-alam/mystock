import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../controllers/history_controller.dart';

class HistoryView extends GetView<HistoryController> {
  const HistoryView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final HistoryController controller = Get.put(HistoryController());
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('HistoryView'),
      //   centerTitle: true,
      // ),

      body: Container(
          decoration: BoxDecoration(
            color: Colors.grey[200], // Set the background color here
          ),
          child: StreamBuilder<QuerySnapshot<Object?>>(
              stream: controller.streamDataRiwayat(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.data!.size != 0) {
                    var data = snapshot.data!.docs;
                    return ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        var document = data[index];

                        return Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 12.0),
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: const Color.fromARGB(255, 0, 0, 0)
                                    .withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ],
                            color: Color.fromARGB(255, 70, 211, 91),
                            borderRadius: BorderRadius.circular(20),
                          ),

                          // ========================== ini di aktifkan nanti
                          child: ListTile(
                            onTap: () => Get.toNamed(Routes.HISTORY_INFO,
                                arguments: document.id),
                            title: Text(
                              document['pelanggan'],
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
                                  color: Colors.white),
                            ),
                            subtitle: Text(
                              controller
                                  .formatCurrency(document['total_harga']),
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: Colors.white),
                            ),
                            trailing: Text(
                              controller.formatDate(document['tanggal']),
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: Colors.white),
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return const Center(
                      child: Text('No data'),
                    );
                  }
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              })),
    );
  }
}
