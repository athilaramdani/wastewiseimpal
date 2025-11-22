import 'package:get/get.dart';

import '../../../data/models/report_record.dart';

class ReportDetailController extends GetxController {
  final report = Rxn<ReportRecord>();

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is ReportRecord) {
      report.value = args;
    } else if (args is Map<String, dynamic>) {
      report.value = ReportRecord.fromMap(args);
    }
  }
}
