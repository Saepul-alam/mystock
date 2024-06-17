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
          backgroundColor: const Color(0xFF478755),
          title: const Text(
            'SRI REZEKI',
            style: TextStyle(color: Color(0xffffffff)),
          ),
          actions: [
            controller.roleValidation(),
            controller.exitButton(),
          ],
        ),
        body: const Column(
          children: [
            TabBar(
              indicatorColor: Color(0xFF478755),
              labelColor: Color(0xFF478755),
              indicatorWeight: 5,
              indicatorSize: TabBarIndicatorSize.tab,
              tabs: [
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
