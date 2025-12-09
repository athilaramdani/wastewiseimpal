import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../routes/app_pages.dart';

class ProfileController extends GetxController {
  final userProfile = RxMap<String, dynamic>({});
  final userEmail = ''.obs;
  final isLoading = false.obs;
  final currentIndex = 4.obs; // Profile tab

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    isLoading.value = true;
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user != null) {
        userEmail.value = user.email ?? '';
        final response = await Supabase.instance.client
            .from('user_profiles')
            .select()
            .eq('id', user.id)
            .single();
        userProfile.value = response;
      }
    } catch (e) {
      print("Error fetching profile: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await Supabase.instance.client.auth.signOut();
    Get.offAllNamed(Routes.LOGIN);
  }

  void onTapBottomNav(int index) {
      if (index == 0) {
        Get.offNamed(Routes.HOME);
      } else if (index == 1) {
         Get.toNamed(Routes.MAPS);
      } else if (index == 2) {
         Get.toNamed(Routes.REPORTWASTE);
      } else if (index == 3) {
         Get.toNamed(Routes.LEADERBOARD);
      } else if (index == 4) {
        // Current
      }
  }
}
