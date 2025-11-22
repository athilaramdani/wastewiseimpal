import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/supabase_client.dart';

import '../../../routes/app_pages.dart';

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

  // Selected image attachment
  final selectedImage = Rxn<XFile>();
  final ImagePicker _picker = ImagePicker();
  final isSubmitting = false.obs;

  static const _mimeByExtension = {
    'jpg': 'image/jpeg',
    'jpeg': 'image/jpeg',
    'png': 'image/png',
    'heic': 'image/heic',
    'gif': 'image/gif',
    'webp': 'image/webp',
  };

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
        Get.offNamed(Routes.HOME);
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

  Future<void> pickImage() async {
    try {
      final image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        selectedImage.value = image;
      }
    } catch (_) {
      Get.snackbar('Error', 'Failed to pick image');
    }
  }

  void removeImage() {
    selectedImage.value = null;
  }

  void openHistory() {
    Get.toNamed(Routes.HISTORY);
  }

  Future<void> submitReport() async {
    if (isSubmitting.value) return;

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

    final image = selectedImage.value;
    if (image == null) {
      Get.snackbar('Error', 'Photo attachment is required');
      return;
    }

    final client = SClient.I;
    final currentUser = client.auth.currentUser;
    if (currentUser == null) {
      Get.snackbar('Error', 'User session expired, please login again');
      return;
    }

    isSubmitting.value = true;

    try {
      final fileBytes = await File(image.path).readAsBytes();
      final extension = image.path.split('.').last.toLowerCase();
      final mimeType = _mimeByExtension[extension] ?? 'image/jpeg';
      final fileName =
          'report-${currentUser.id}-${DateTime.now().millisecondsSinceEpoch}.$extension';
      final storagePath = 'reports/$fileName';

      await client.storage
          .from('waste-photos')
          .uploadBinary(
            storagePath,
            fileBytes,
            fileOptions: FileOptions(
              cacheControl: '3600',
              upsert: true,
              contentType: mimeType,
            ),
          );

      final publicUrl = client.storage
          .from('waste-photos')
          .getPublicUrl(storagePath);

      await client.from('reports').insert({
        'title': titleController.text.trim(),
        'category': selectedCategory.value,
        'location': locationController.text.trim(),
        'description': descriptionController.text.trim(),
        'image_url': publicUrl,
        'user_id': currentUser.id,
        'created_at': DateTime.now().toIso8601String(),
      });

      Get.snackbar('Success', 'Waste report submitted successfully');

      titleController.clear();
      descriptionController.clear();
      locationController.clear();
      selectedCategory.value = null;
      selectedImage.value = null;
    } on StorageException catch (error) {
      Get.snackbar('Upload Failed', error.message);
    } on PostgrestException catch (error) {
      Get.snackbar('Database Error', error.message);
    } catch (error) {
      Get.snackbar('Error', 'Unexpected error: $error');
    } finally {
      isSubmitting.value = false;
    }
  }
}
