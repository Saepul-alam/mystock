import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mystock/app/routes/app_pages.dart';
import '../controllers/history_controller.dart';

class HistoryView extends GetView<HistoryController> {
  const HistoryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HistoryController controller = Get.put(HistoryController());

    void _selectDate(BuildContext context) async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2101),
      );
      if (picked != null) {
        controller.selectedDate.value = picked;
      }
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200], // Updated to a cleaner background color
        ),
        child: Column(
          children: [
            Expanded(
              child: Obx(() {
                return StreamBuilder<QuerySnapshot<Object?>>(
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
                                  vertical: 8.0, horizontal: 16.0),
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                                color: Color.fromARGB(255, 70, 211,
                                    91), // Updated background color
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: ListTile(
                                onTap: () => Get.toNamed(Routes.HISTORY_INFO,
                                    arguments: document.id),
                                title: Text(
                                  document['pelanggan'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                                subtitle: Text(
                                  controller
                                      .formatCurrency(document['total_harga']),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    color: Colors.white70,
                                  ),
                                ),
                                trailing: Text(
                                  controller.formatDate(document['tanggal']),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    color: Colors.white70,
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      } else {
                        return Center(
                          child: Text(
                            'No data',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                        );
                      }
                    } else {
                      return Center(
                        child: CircularProgressIndicator(
                          color: Colors.teal,
                        ),
                      );
                    }
                  },
                );
              }),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx(() {
                      return Text(
                        controller.selectedDate.value != null
                            ? 'Selected Date: ${DateFormat('dd MMMM yyyy', 'id_ID').format(controller.selectedDate.value!)}'
                            : 'No date selected',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      );
                    }),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.date_range, color: Colors.black),
                          onPressed: () => _selectDate(context),
                        ),
                        IconButton(
                          icon: Icon(Icons.print, color: Colors.black),
                          onPressed: () async {
                            var snapshot =
                                await controller.streamDataRiwayat().first;
                            controller.printPdf(snapshot.docs);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
