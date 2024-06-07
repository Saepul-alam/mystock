import 'package:get/get.dart';

import '../controllers/history_info_controller.dart';

class HistoryInfoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HistoryInfoController>(
      () => HistoryInfoController(),
    );
  }
}
