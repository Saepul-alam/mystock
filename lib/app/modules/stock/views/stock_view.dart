import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/stock_controller.dart';
import '../../../routes/app_pages.dart';

class StockView extends GetView<StockController> {
  const StockView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final StockController controller = Get.put(StockController());
    TextEditingController searchController = TextEditingController();

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200], // Set the background color here
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 75,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  onChanged: (value) {
                    controller.search(value);
                  },
                ),
              ),
            ),
            Expanded(
              child: Obx(() {
                return StreamBuilder<QuerySnapshot>(
                  stream: controller.searchQuery.isEmpty
                      ? controller.streamData
                      : controller.search(controller.searchQuery.value),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return const Center(
                        child: Text(
                          'Error fetching data',
                          style: TextStyle(color: Colors.red),
                        ),
                      );
                    } else if (!snapshot.hasData ||
                        snapshot.data!.docs.isEmpty) {
                      return const Center(
                        child: Text(
                          'No data',
                          style: TextStyle(color: Colors.blue),
                        ),
                      );
                    } else {
                      var data = snapshot.data!.docs;
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          var doc = data[index];

                          return Container(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                              color: Color.fromARGB(255, 254, 254, 254),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            margin: const EdgeInsets.symmetric(
                                vertical: 4.0, horizontal: 8.0),
                            child: ListTile(
                              title: Text(
                                doc['nama'],
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 14, 1, 39),
                                  fontWeight: FontWeight.w800,
                                  fontSize: 18,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Stock: ${doc['stock']}',
                                    style: TextStyle(
                                      color: doc['stock'] == 0
                                          ? Color.fromARGB(255, 210, 33, 20)
                                          : Color.fromARGB(221, 2, 134, 70),
                                      fontWeight: FontWeight.w800,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    'Harga: ${doc['harga']}',
                                    style: const TextStyle(
                                      color: Color.fromARGB(255, 14, 1, 39),
                                      fontWeight: FontWeight.w800,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () => Get.toNamed(
                                            Routes.UPDATE,
                                            arguments: data[index].id),
                                        style: ElevatedButton.styleFrom(
                                          foregroundColor: const Color.fromARGB(
                                              255, 255, 255, 255),
                                          backgroundColor:
                                              Color.fromARGB(255, 45, 74, 98),
                                        ),
                                        child: const Text(
                                          'Edit',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      ElevatedButton(
                                        onPressed: () {
                                          int hargaSatuan =
                                              int.parse(data[index]['harga']);
                                          int totalHargaBarang =
                                              hargaSatuan * 1;
                                          String idBarang =
                                              data[index]['id_barang'];
                                          int stock = data[index]['stock'];
                                          controller.tambahPenjualan(
                                              data[index]['nama'],
                                              1,
                                              hargaSatuan,
                                              totalHargaBarang,
                                              idBarang,
                                              stock);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          foregroundColor: Colors.white,
                                          backgroundColor: const Color.fromARGB(
                                              255, 42, 113, 44),
                                        ),
                                        child: const Text(
                                          'Penjualan',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              trailing: IconButton(
                                onPressed: () {
                                  controller.deleteData(doc.id);
                                },
                                icon: const Icon(
                                  Icons.delete_forever_rounded,
                                  color: Color.fromARGB(255, 210, 33, 20),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                );
              }),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15, top: 15),
              child: ElevatedButton(
                onPressed: () {
                  Get.toNamed(Routes.CREATE);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 14, 1, 39),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                  child: Center(
                    child: Text(
                      'Input Barang',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.only(bottom: 10)),
          ],
        ),
      ),
    );
  }
}
