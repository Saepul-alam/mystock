import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../routes/app_pages.dart';
import '../controllers/history_penjualan_controller.dart';

class HistoryPenjualanView extends GetView<HistoryPenjualanController> {
  const HistoryPenjualanView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final HistoryPenjualanController controller =
        Get.put(HistoryPenjualanController());

    return Scaffold(
      appBar: AppBar(
        title: Obx(() {
          return Text(
            controller.selectedDate.value != null
                ? ' ${DateFormat('dd MMMM yyyy', 'id_ID').format(controller.selectedDate.value!)}'
                : 'All day',
          );
        }),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt),
            onPressed: () => controller.filterdate(context),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => controller.resetFilter(),
          ),
          IconButton(
            icon: const Icon(Icons.print),
            onPressed: () async {
              try {
                var snapshot = await controller.streamDataRiwayat().first;
                await controller.printPdf(snapshot.docs);
              } catch (e) {
                print('Error printing: $e');
                // Handle error or display a message to the user
              }
            },
          ),
        ],
      ),
      body: Obx(() {
        return StreamBuilder<QuerySnapshot<Object?>>(
          stream: controller.streamDataRiwayat(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              }

              if (snapshot.data!.size != 0) {
                var data = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    var document = data[index];
                    return Dismissible(
                      key: Key(document.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20.0),
                        child: const Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                      confirmDismiss: (direction) async {
                        return await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("Confirmation"),
                              content: const Text(
                                  "Are you sure you want to delete this item?"),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                  child: const Text("Cancel"),
                                ),
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(true),
                                  child: const Text("Delete"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      onDismissed: (direction) {
                        if (direction == DismissDirection.endToStart) {
                          controller.deleteDataRiwayat(document.id);
                        }
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 12.0),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromARGB(255, 0, 0, 0)
                                  .withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 0,
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            ),
                          ],
                          color: Color.fromARGB(255, 45, 74, 98),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: ListTile(
                          onTap: () => Get.toNamed(Routes.HISTORY_INFO,
                              arguments: document.id),
                          title: Text(
                            document['pelanggan'],
                            style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                                color: Colors.white),
                          ),
                          subtitle: Text(
                            controller.formatCurrency(document['total_harga']),
                            style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Colors.white),
                          ),
                          trailing: Text(
                            controller.formatDate(document['tanggal']),
                            style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Colors.white),
                          ),
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
          },
        );
      }),

    );
  }
}
