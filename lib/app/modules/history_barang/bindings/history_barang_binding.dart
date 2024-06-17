import 'package:get/get.dart';

import '../controllers/history_barang_controller.dart';

class HistoryBarangBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HistoryBarangController>(
      () => HistoryBarangController(),
    );
  }
}
