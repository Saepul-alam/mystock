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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              onChanged: (value) {
                controller.search(value);
              },
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot<Object?>>(
              stream: controller.streamData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error fetching data: ${snapshot.error}',
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
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF478755),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        margin: const EdgeInsets.symmetric(
                            vertical: 4.0, horizontal: 8.0),
                        child: ListTile(
                          title: Text(
                            data[index]['nama'],
                            style: const TextStyle(color: Colors.white),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Stock: ${data[index]['stock']}',
                                style: const TextStyle(
                                  color: Color.fromARGB(221, 247, 255, 183),
                                ),
                              ),
                              Text(
                                'Harga: ${data[index]['harga']}',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () => Get.toNamed(
                                  Routes.UPDATE,
                                  arguments: data[index].id,
                                ),
                                icon: const Icon(Icons.edit),
                                color: Colors.white,
                              ),
                              IconButton(
                                onPressed: () {
                                  int hargaSatuan =
                                      int.parse(data[index]['harga']);
                                  int totalHargaBarang = hargaSatuan * 1;
                                  controller.tambahPenjualan(
                                    data[index]['nama'],
                                    1,
                                    hargaSatuan,
                                    totalHargaBarang,
                                  );
                                },
                                icon: const Icon(Icons.add_shopping_cart),
                                color: Colors.white,
                              ),
                              IconButton(
                                onPressed: () =>
                                    controller.deleteData(data[index].id),
                                icon: const Icon(Icons.delete),
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: ElevatedButton(
              onPressed: () {
                Get.toNamed(Routes.CREATE);
              },
              style: ElevatedButton.styleFrom(
                primary: const Color(0xFF478755),
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
        ],
      ),
    );
  }
}
