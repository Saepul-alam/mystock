import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../controllers/home_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find<HomeController>();
    TextEditingController searchController = TextEditingController();

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF478755),
          title: const Text(
            'SRI REZEKI',
            style: TextStyle(color: Color(0xffffffff)),
          ),
          actions: [
            IconButton(
              onPressed: () {
                Get.toNamed(Routes.REGISTER);
              },
              icon: const Row(
                children: [
                  Icon(
                    Icons.account_circle,
                    color: Colors.white,
                  ),
                  Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              TabBar(
                indicatorColor: Colors.green[900],
                tabs: const [
                  Tab(text: 'Stock'),
                  Tab(text: 'Penjualan'),
                  Tab(text: 'Riwayat'),
                ],
              ),
              SizedBox(
                height: 700,
                child: TabBarView(children: [
//  =============================== Tab Stok Barang ================================

                  Column(
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
                            controller.search(
                                value); // Call search function on controller
                          },
                        ),
                      ),
                      SizedBox(
                        height: 500,
                        child: StreamBuilder<QuerySnapshot>(
                          stream: controller.streamData(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
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
                                  return Container(
                                    decoration: BoxDecoration(
                                      color: const Color(
                                          0xFF478755), // Background color green
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 4.0, horizontal: 8.0),
                                    child: ListTile(
                                      title: Text(
                                        data[index]['nama'],
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Stock: ${data[index]['stock']}',
                                            style: const TextStyle(
                                                color: Color.fromARGB(
                                                    221, 247, 255, 183)),
                                          ),
                                          Text(
                                            'Harga: ${data[index]['harga']}',
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              ElevatedButton(
                                                onPressed: () => Get.toNamed(
                                                    Routes.UPDATE,
                                                    arguments: data[index].id),
                                                style: ElevatedButton.styleFrom(
                                                  foregroundColor: Colors.white,
                                                  backgroundColor: Colors
                                                      .green, // Text color white
                                                ),
                                                child: const Text(
                                                  'Edit',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              ElevatedButton(
                                                onPressed: () {
                                                  int hargaSatuan = int.parse(
                                                      data[index]['harga']);
                                                  int totalHargaBarang =
                                                      hargaSatuan * 1;
                                                  controller.tambahPenjualan(
                                                      data[index]['nama'],
                                                      1,
                                                      hargaSatuan,
                                                      totalHargaBarang);
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  foregroundColor: Colors.white,
                                                  backgroundColor: Colors
                                                      .green, // Text color white
                                                ),
                                                child: const Text(
                                                  'Penjualan',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      trailing: IconButton(
                                        onPressed: () => controller
                                            .deleteData(data[index].id),
                                        icon: const Icon(Icons.delete),
                                        color: Colors.white,
                                      ),
                                    ),
                                  );
                                },
                              );
                            }
                          },
                        ),
                      ),
                      const Padding(padding: EdgeInsets.only(top: 40)),
                      Container(
                        width: 400,
                        decoration: BoxDecoration(
                            color: const Color(0xFF478755),
                            borderRadius: BorderRadius.circular(20)),
                        child: InkWell(
                          onTap: () {
                            Get.toNamed(Routes
                                .CREATE); // Navigate to create input data page
                          },
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
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

// ========================== Tab Penjualan =============================

                  Column(
                    children: [
                      SizedBox(
                        height: 650,
                        child: StreamBuilder<QuerySnapshot>(
                            stream: controller.streamDataPenjualan(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
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
                                  child: Text('No data'),
                                );
                              } else {
                                var data = snapshot.data!.docs;

                                hitungTotalHarga() {
                                  num totalHarga = 0;
                                  for (int i = 0; i < data.length; i++) {
                                    totalHarga = totalHarga +
                                        data[i]['total_harga_barang'];
                                  }
                                  return totalHarga;
                                }

                                return Column(
                                  children: [
                                    SizedBox(
                                      height: 580,
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: data.length,
                                        itemBuilder: (context, index) {
                                          return Container(
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF478755),
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 4.0, horizontal: 8.0),
                                            child: ListTile(
                                              title: Text(
                                                data[index]['nama'],
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18),
                                              ),
                                              subtitle: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Jumlah: ${data[index]['quantity'].toString()}",
                                                    style: const TextStyle(
                                                      color: Colors.white,
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
                                                          int jumlah = data[
                                                                      index]
                                                                  ['quantity'] +
                                                              1;
                                                          int hargaBarang = data[
                                                                      index][
                                                                  'harga_satuan'] *
                                                              jumlah;
                                                          controller
                                                              .updateHarga(
                                                                  data[index]
                                                                      .id,
                                                                  hargaBarang);
                                                          controller
                                                              .updateJumlah(
                                                                  data[index]
                                                                      .id,
                                                                  jumlah);
                                                        },
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          foregroundColor:
                                                              Colors.white,
                                                          backgroundColor: Colors
                                                              .green, // Text color white
                                                        ),
                                                        child: const Text(
                                                          '+1',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 12),
                                                        ),
                                                      ),
                                                      const SizedBox(width: 8),
                                                      ElevatedButton(
                                                        onPressed: () {
                                                          int jumlah = data[
                                                                      index]
                                                                  ['quantity'] -
                                                              1;
                                                          int hargaBarang = data[
                                                                      index][
                                                                  'harga_satuan'] *
                                                              jumlah;
                                                          if (jumlah < 1) {
                                                            Get.defaultDialog(
                                                                title: 'Error',
                                                                middleText:
                                                                    'Jumlah barang tidak bisa kurang dari 0',
                                                                textCancel:
                                                                    'Oke');
                                                          } else {
                                                            controller
                                                                .updateJumlah(
                                                                    data[index]
                                                                        .id,
                                                                    jumlah);
                                                            controller
                                                                .updateHarga(
                                                                    data[index]
                                                                        .id,
                                                                    hargaBarang);
                                                          }
                                                        },
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          foregroundColor:
                                                              Colors.white,
                                                          backgroundColor: Colors
                                                              .green, // Text color white
                                                        ),
                                                        child: const Text(
                                                          '-1',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 12),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              trailing: IconButton(
                                                onPressed: () => controller
                                                    .deleteDataPenjualan(
                                                        data[index].id),
                                                icon: const Icon(Icons.delete),
                                                color: Colors.white,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    const Padding(
                                        padding: EdgeInsets.only(top: 10)),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            'Total Harga:',
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          Text(
                                            '${hitungTotalHarga()}',
                                            style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w500),
                                          )
                                        ],
                                      ),
                                    ),
                                    const Padding(
                                        padding: EdgeInsets.only(top: 10)),
                                  ],
                                );
                              }
                            }),
                      ),
                      Container(
                        width: 400,
                        decoration: BoxDecoration(
                            color: const Color(0xFF478755),
                            borderRadius: BorderRadius.circular(20)),
                        child: InkWell(
                          onTap: () {
                            controller.submitPenjualan();
                          },
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12.0),
                            child: Center(
                              child: Text(
                                'Jual Barang',
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

                  // ========================== Tab Riwayat =============================
                  Container(
                      child: StreamBuilder<QuerySnapshot<Object?>>(
                          stream: controller.streamData(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.active) {
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
                                        color: Colors.green,
                                        borderRadius:
                                            BorderRadius.circular(3.0),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 1,
                                            blurRadius: 3,
                                            offset: Offset(0,
                                                2), // changes position of shadow
                                          ),
                                        ],
                                      ),

                                      // ========================== ini di aktifkan nanti
                                      // child: ListTile(

                                      // onTap: () => Get.toNamed(
                                      //     Routes.RIWAYAT_INFO,
                                      //     arguments: document.id),
                                      // title: Text(
                                      //   document['pelanggan'],
                                      //   style: TextStyle(
                                      //       fontWeight: FontWeight.w500,
                                      //       fontSize: 18,
                                      //       color: Colors.white),
                                      // ),
                                      // subtitle: Text(
                                      //   controller.formatCurrency(
                                      //       document['total']),
                                      //   style: TextStyle(
                                      //       fontWeight: FontWeight.w500,
                                      //       fontSize: 16,
                                      //       color: Colors.white),
                                      // ),
                                      // trailing: Text(
                                      //   controller
                                      //       .formatDate(document['tgl']),
                                      //   style: TextStyle(
                                      //       fontWeight: FontWeight.w500,
                                      //       fontSize: 16,
                                      //       color: Colors.white),
                                      // ),
                                      // ),
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
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
