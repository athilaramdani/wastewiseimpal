import 'package:get/get.dart';

import '../controllers/reportwaste_controller.dart';

class ReportwasteBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReportwasteController>(
      () => ReportwasteController(),
    );
  }
}
