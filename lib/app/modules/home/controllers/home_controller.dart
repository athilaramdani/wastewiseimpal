import 'package:get/get.dart';
import '../../../routes/app_pages.dart';

class HomeController extends GetxController {
  final currentIndex = 0.obs;

  void onTapBottomNav(int i) {
    // Index: 0 home, 1 maps, 2 add/report, 3 leaderboard, 4 profile
    if (i == 2) {
      Get.toNamed(Routes.REPORTWASTE);
      return;
    }
    currentIndex.value = i;

    // Dummy routing untuk selain home
    if (i != 0) {
      Get.snackbar(
        "Coming Soon",
        ["Maps", "Report", "Leaderboard", "Profile"][i > 2 ? i - 1 : i] +
            " is in progress.",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void openReportWaste() {
    Get.toNamed(Routes.REPORTWASTE);
  }

  void openNearbyBins() {
    Get.snackbar(
      "Nearby Bins",
      "Dummy map/redirection in progress.",
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void openEducation() {
    Get.snackbar(
      "Education",
      "Dummy article list in progress.",
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
