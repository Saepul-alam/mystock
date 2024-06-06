import 'package:get/get.dart';

import '../controllers/riwayat_info_controller.dart';

class RiwayatInfoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RiwayatInfoController>(
      () => RiwayatInfoController(),
    );
  }
}
