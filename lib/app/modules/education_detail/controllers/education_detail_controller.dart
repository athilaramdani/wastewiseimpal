import 'package:get/get.dart';
import '../../../data/models/education.dart';

class EducationDetailController extends GetxController {
  late Education education;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments is Education) {
      education = Get.arguments as Education;
    } else {
      // Fallback or error
      Get.back();
    }
  }
}
