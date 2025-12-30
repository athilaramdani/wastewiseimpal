import 'package:get/get.dart';
import '../../leaderboard/controllers/leaderboard_controller.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
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
    try {
      // 1. Get User Location
      bool serviceEnabled;
      LocationPermission permission;

      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Location services are disabled.
        Get.snackbar("Location Disabled", "Please enable location services to find nearby bins.");
        return;
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print("Location permissions are denied");
          return;
        }
      }
      
      if (permission == LocationPermission.deniedForever) {
        Get.snackbar("Permission Denied", "Location permission is permanently denied. Please enable it in settings.");
        return;
      }

      final position = await Geolocator.getCurrentPosition();
      final userLat = position.latitude;
      final userLong = position.longitude;
      
      // 2. Fetch all bins (or a larger limit)
      final response = await Supabase.instance.client
          .from('trashbin')
          .select();
      
      final data = response as List;
      final allBins = data.map((e) => TrashBin.fromJson(e)).toList();

      // 3. Calculate distances
      final Distance distance = Distance();
      for (var bin in allBins) {
        final meter = distance.as(
          LengthUnit.Meter,
          LatLng(userLat, userLong),
          LatLng(bin.latitude, bin.longitude)
        );
        bin.distanceInKm = meter / 1000.0;
      }

      // 4. Sort by distance
      allBins.sort((a, b) => (a.distanceInKm ?? double.infinity).compareTo(b.distanceInKm ?? double.infinity));

      // 5. Take top 3
      nearbyBins.value = allBins.take(3).toList();

    } catch (e) {
      Get.snackbar("Error", "Failed to load nearby bins");
      print("Error fetching bins: $e");
      // Keep/Use fallback if necessary, but for now just log
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
       Get.toNamed(Routes.MAPS);
    } else if (i == 3) {
       if (Get.isRegistered<LeaderboardController>()) {
          Get.find<LeaderboardController>().fetchLeaderboard();
       }
       Get.toNamed(Routes.LEADERBOARD);
    } else if (i == 4) {
       Get.toNamed(Routes.PROFILE);
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
