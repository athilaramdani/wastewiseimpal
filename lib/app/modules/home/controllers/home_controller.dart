import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../data/models/trash_bin.dart';
import '../../../data/models/education.dart';
import '../../../routes/app_pages.dart';

class HomeController extends GetxController {
  final currentIndex = 0.obs;

  final nearbyBins = <TrashBin>[].obs;
  final educationList = <Education>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchHomeData();
  }

  Future<void> fetchHomeData() async {
    isLoading.value = true;
    try {
      await Future.wait([
        fetchNearbyBins(),
        fetchEducation(),
      ]);
    } catch (e) {
      print("Error fetching home data: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchNearbyBins() async {
    // TODO: Real distance calculation. For now valid fetch limit 3.
    try {
      final response = await Supabase.instance.client
          .from('trashbin')
          .select()
          .limit(3);
      
      final data = response as List;
      nearbyBins.value = data.map((e) => TrashBin.fromJson(e)).toList();
    } catch (e) {
      print("Error fetching bins: $e");
      // Fallback dummy data if DB empty or error
      nearbyBins.value = [
        TrashBin(id: 1, locationName: "Main Gate", latitude: 0, longitude: 0, capacity: "full", type: "organic"),
        TrashBin(id: 2, locationName: "Library", latitude: 0, longitude: 0, capacity: "half", type: "inorganic"),
        TrashBin(id: 3, locationName: "Canteen", latitude: 0, longitude: 0, capacity: "empty", type: "organic"),
      ];
    }
  }

  Future<void> fetchEducation() async {
    try {
      final response = await Supabase.instance.client
          .from('education')
          .select()
          .limit(5);

      final data = response as List;
      educationList.value = data.map((e) => Education.fromJson(e)).toList();
    } catch (e) {
      // Fallback dummy
      educationList.value = [
        Education(id: 1, title: "Cara Daur Ulang Plastik", body: "Tips and trik..."),
        Education(id: 2, title: "Jenis Sampah Organik", body: "Apa saja isi sampah organik?"),
      ];
    }
  }

  void onTapBottomNav(int i) {
    if (i == 2) {
      Get.toNamed(Routes.REPORTWASTE);
      return;
    }
    currentIndex.value = i;
    
    // Routing logic for bottom nav
    if (i == 0) {
      // already home
    } else if (i == 1) {
       Get.toNamed(Routes.MAPS); // Assuming MAPS route exists or will exist
    } else if (i == 3) {
       // Leaderboard
    } else if (i == 4) {
       // Profile
    }
  }

  void openReportWaste() {
    Get.toNamed(Routes.REPORTWASTE);
  }

  void openNearbyBins() {
    Get.toNamed(Routes.MAPS);
  }

  void openEducationDetail(Education item) {
    Get.toNamed(Routes.EDUCATION_DETAIL, arguments: item);
  }
}
