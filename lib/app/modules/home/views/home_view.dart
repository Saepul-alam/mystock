import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mystock/app/modules/history/views/history_view.dart';
import 'package:mystock/app/modules/sale/views/sale_view.dart';
import 'package:mystock/app/modules/stock/views/stock_view.dart';
import '../../../routes/app_pages.dart';

class HomeView extends StatelessWidget {
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
        body: Column(
          children: [
            TabBar(
              indicatorColor: Colors.green[900],
              tabs: const [
                Tab(text: 'Stock'),
                Tab(text: 'Penjualan'),
                Tab(text: 'Riwayat'),
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
