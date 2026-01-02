import 'package:get/get.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../data/models/trash_bin.dart';
import 'package:flutter/material.dart';
import '../../../routes/app_pages.dart';

class MapsController extends GetxController {
  final mapController = MapController();
  final trashBins = <TrashBin>[].obs;
  final userPosition = Rxn<LatLng>();
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _checkPermissionAndLocate();
    fetchTrashBins();
  }

  Future<void> _checkPermissionAndLocate() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        Get.snackbar(
          "Location",
          "Location services are disabled.",
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();

      // Request permission jika belum ada
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();

        if (permission == LocationPermission.denied) {
          Get.snackbar(
            "Location",
            "Location permission is required to show your position",
            snackPosition: SnackPosition.BOTTOM,
          );
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        Get.snackbar(
          "Location",
          "Please enable location permission in app settings",
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 4),
        );
        return;
      }

      // Get current position
      final pos = await Geolocator.getCurrentPosition();
      userPosition.value = LatLng(pos.latitude, pos.longitude);

      // Auto move map?
      // mapController.move(userPosition.value!, 15);
    } catch (e) {
      print("Error getting location: $e");
      Get.snackbar(
        "Error",
        "Failed to get location: $e",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> fetchTrashBins() async {
    try {
      final response = await Supabase.instance.client.from('trashbin').select();
      final data = response as List;
      trashBins.value = data.map((e) => TrashBin.fromJson(e)).toList();
    } catch (e) {
      print("Error fetching bins: $e");
      // Dummy
      trashBins.value = [
        TrashBin(
          id: 1,
          locationName: "Bin A",
          latitude: -6.973,
          longitude: 107.63,
          capacity: "full",
          type: "organic",
        ),
        TrashBin(
          id: 2,
          locationName: "Bin B",
          latitude: -6.975,
          longitude: 107.632,
          capacity: "half",
          type: "inorganic",
        ),
      ];
    }
  }

  final currentIndex = 1.obs;

  void onTapBottomNav(int index) {
    if (index == 0) {
      Get.offAllNamed(Routes.HOME);
    } else if (index == 1) {
      // Current
    } else if (index == 2) {
      Get.toNamed(Routes.REPORTWASTE);
    } else if (index == 3) {
      Get.toNamed(Routes.LEADERBOARD);
    } else if (index == 4) {
      Get.toNamed(Routes.PROFILE);
    }
  }

  // Helper for color
  Color getBinColor(String capacity) {
    switch (capacity.toLowerCase()) {
      case 'full':
        return Colors.red;
      case 'half':
      case 'almost full':
        return Colors.yellow; // or Orange
      default:
        return Colors.green;
    }
  }
}
