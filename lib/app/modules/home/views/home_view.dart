import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mystock/app/modules/history/views/history_view.dart';
import 'package:mystock/app/modules/home/controllers/home_controller.dart';
import 'package:mystock/app/modules/sale/views/sale_view.dart';
import 'package:mystock/app/modules/stock/views/stock_view.dart';
// import '../../../routes/app_pages.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 14, 1, 39),
          title: const Text(
            'SRI REZEKI',
            style: TextStyle(
              color: Color(0xffffffff),
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  offset: Offset(2.0, 2.0),
                  blurRadius: 3.0,
                  color: Color.fromARGB(128, 105, 104, 104),
                ),
              ],
            ),
          ),
          actions: [
            controller.roleValidation(),
            controller.exitButton(),
          ],
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 14, 1, 39),
                  // Ending color with opacity to blend
                ],
                begin: Alignment.topCenter,
                end: Alignment.center, // Change the end point to center
              ),
            ),
          ),
        ),
        body: const Column(
          children: [
            TabBar(
              indicatorColor: Color.fromARGB(221, 180, 166, 40),
              tabs: const [
                Tab(
                  child: Text(
                    'Stok',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                Tab(
                  child: Text(
                    'Penjualan',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                Tab(
                  child: Text(
                    'Riwayat',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  StockView(),
                  SaleView(),
                  HistoryView(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
