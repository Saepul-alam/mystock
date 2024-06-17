import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mystock/app/modules/history/controllers/history_controller.dart';
import 'package:mystock/app/modules/history_barang/views/history_barang_view.dart';

import '../../history_penjualan/views/history_penjualan_view.dart';
// import '../../../routes/app_pages.dart';

class HistoryView extends GetView<HistoryController> {
  const HistoryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Column(
            children: [
              Container(
                height: 40,
                margin: const EdgeInsets.symmetric(horizontal: 40),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(5),
                ),
                child: TabBar(
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: BoxDecoration(
                    color: const Color(0xFF478755),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: const Color(0xFF478755),
                  tabs: const [
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
                        'Stok',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Expanded(
                child: TabBarView(
                  children: [
                    HistoryPenjualanView(),
                    HistoryBarangView(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
