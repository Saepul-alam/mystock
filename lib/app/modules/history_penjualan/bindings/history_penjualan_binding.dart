import 'package:get/get.dart';

import '../controllers/history_penjualan_controller.dart';

class HistoryPenjualanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HistoryPenjualanController>(
      () => HistoryPenjualanController(),
    );
  }
}
