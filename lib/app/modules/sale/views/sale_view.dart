import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/sale_controller.dart';

class SaleView extends GetView<SaleController> {
  const SaleView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final SaleController controller = Get.put(SaleController());
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
                stream: controller.streamDataPenjualan(),
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
                  } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text('No data'),
                    );
                  } else {
                    var data = snapshot.data!.docs;

                    hitungTotalHarga() {
                      num totalHarga = 0;
                      for (int i = 0; i < data.length; i++) {
                        totalHarga = totalHarga + data[i]['total_harga_barang'];
                      }
                      return totalHarga;
                    }

                    return Column(
                      children: [
                        const Padding(padding: EdgeInsets.only(top: 10)),
                        Expanded(
                          child: ListView.builder(
                            shrinkWrap: true,
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
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Jumlah: ${data[index]['quantity'].toString()}",
                                        style: TextStyle(
                                          color: data[index]['quantity'] >
                                                  data[index]['stock_awal']
                                              ? Colors.red[600]
                                              : Colors.white,
                                          fontSize: 14,
                                        ),
                                      ),
                                      Text(
                                        "Harga Barang: ${data[index]['harga_satuan']}"
                                            .toString(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          ElevatedButton(
                                            onPressed: () {
                                              int jumlah =
                                                  data[index]['quantity'] + 1;
                                              int hargaBarang = data[index]
                                                      ['harga_satuan'] *
                                                  jumlah;
                                              controller.updateHarga(
                                                  data[index].id, hargaBarang);
                                              controller.updateJumlah(
                                                  data[index].id, jumlah);
                                            },
                                            style: ElevatedButton.styleFrom(
                                              foregroundColor: Colors.white,
                                              backgroundColor: Colors
                                                  .green, // Text color white
                                            ),
                                            child: const Text(
                                              '+',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 24),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          ElevatedButton(
                                            onPressed: () {
                                              int jumlah =
                                                  data[index]['quantity'] - 1;
                                              int hargaBarang = data[index]
                                                      ['harga_satuan'] *
                                                  jumlah;
                                              if (jumlah < 1) {
                                                controller.deleteDataPenjualan(
                                                    data[index].id);
                                              } else {
                                                controller.updateJumlah(
                                                    data[index].id, jumlah);
                                                controller.updateHarga(
                                                    data[index].id,
                                                    hargaBarang);
                                              }
                                            },
                                            style: ElevatedButton.styleFrom(
                                              foregroundColor: Colors.white,
                                              backgroundColor: Colors
                                                  .green, // Text color white
                                            ),
                                            child: const Text(
                                              '-',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 24),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  trailing: IconButton(
                                    onPressed: () => controller
                                        .deleteDataPenjualan(data[index].id),
                                    icon: const Icon(Icons.delete),
                                    color: Colors.white,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const Padding(padding: EdgeInsets.only(top: 10)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Total Harga:',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w500),
                              ),
                              Text(
                                '${hitungTotalHarga()}',
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w500),
                              )
                            ],
                          ),
                        ),
                        const Padding(padding: EdgeInsets.only(top: 10)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: ElevatedButton(
                            onPressed: () {
                              controller.konfirmasiPenjualan();
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
                                  'Jual',
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
                    );
                  }
                }),
          ),
          const Padding(padding: EdgeInsets.only(bottom: 10)),
        ],
      ),
    );
  }
}
