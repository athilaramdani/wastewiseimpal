import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../routes/app_pages.dart';

class LeaderboardController extends GetxController {
  final leaderboard = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;
  final currentIndex = 3.obs; // Leaderboard tab

  @override
  void onInit() {
    super.onInit();
    fetchLeaderboard();
  }

  Future<void> fetchLeaderboard() async {
    isLoading.value = true;
    try {
      final response = await Supabase.instance.client
          .from('user_profiles')
          .select('id, name, total_points, total_reports')
          .order('total_points', ascending: false)
          .limit(50);
      
      final data = response as List;
      leaderboard.value = data.cast<Map<String, dynamic>>();
    } catch (e) {
      print("Error fetching leaderboard: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void onTapBottomNav(int index) {
      if (index == 0) {
        Get.offNamed(Routes.HOME);
      } else if (index == 1) {
         Get.toNamed(Routes.MAPS);
      } else if (index == 2) {
         Get.toNamed(Routes.REPORTWASTE);
      } else if (index == 3) {
        // Current
      } else {
        Get.snackbar("Coming Soon", "Feature in progress");
      }
  }
}
