import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReportwasteController extends GetxController {
  // Form controllers
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final locationController = TextEditingController();

  // Selected category
  final selectedCategory = Rx<String?>(null);

  // Categories
  final categories = [
    'Organic Waste',
    'Plastic Waste',
    'Paper Waste',
    'Glass Waste',
    'Metal Waste',
    'Electronic Waste',
    'Other',
  ];

  // Bottom navigation index
  final currentIndex = 2.obs; // Report tab

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    locationController.dispose();
    super.onClose();
  }

  void onTapBottomNav(int index) {
    switch (index) {
      case 0:
        Get.offNamed('/home');
        break;
      case 1:
        Get.snackbar(
          'Coming Soon',
          'Fitur Maps sedang dalam pengembangan',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        break;
      case 2:
        // Already on Report page
        break;
      case 3:
        Get.snackbar(
          'Coming Soon',
          'Fitur Leaderboard sedang dalam pengembangan',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        break;
      case 4:
        Get.snackbar(
          'Coming Soon',
          'Fitur Profile sedang dalam pengembangan',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        break;
    }
  }

  void submitReport() {
    // Validate all fields
    if (titleController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Report title is required');
      return;
    }

    if (selectedCategory.value == null) {
      Get.snackbar('Error', 'Waste category must be selected');
      return;
    }

    if (locationController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Location is required');
      return;
    }

    if (descriptionController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Description is required');
      return;
    }

    // All validation passed
    Get.snackbar('Success', 'Waste report submitted successfully');

    // Clear form
    titleController.clear();
    descriptionController.clear();
    locationController.clear();
    selectedCategory.value = null;

    // TODO: Send to Supabase
  }
}
