import 'package:get/get.dart';

import '../controllers/sale_controller.dart';

class SaleBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SaleController>(
      () => SaleController(),
    );
  }
}
