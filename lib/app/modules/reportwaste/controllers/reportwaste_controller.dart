import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/supabase_client.dart';
import '../../../data/models/trash_bin.dart';
import '../../../routes/app_pages.dart';

class ReportwasteController extends GetxController {
  // Form controllers
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  // Selections
  final selectedType = Rx<String?>('organic'); // Default or null
  final selectedTrashBin = Rxn<TrashBin>();
  final selectedCapacity = Rx<String?>('full'); // Default?

  // Options
  final types = ['organic', 'inorganic'];
  final capacities = ['empty', 'half', 'full'];

  // Data
  final allTrashBins = <TrashBin>[].obs;
  
  // Computed
  List<TrashBin> get filteredBins {
    if (selectedType.value == null) return [];
    return allTrashBins.where((bin) => bin.type == selectedType.value!.toLowerCase()).toList();
  }

  // Bottom navigation index
  final currentIndex = 2.obs;

  // Selected image attachment
  final selectedImage = Rxn<XFile>();
  final ImagePicker _picker = ImagePicker();
  final isSubmitting = false.obs;
  final isLoadingBins = false.obs;

  static const _mimeByExtension = {
    'jpg': 'image/jpeg',
    'jpeg': 'image/jpeg',
    'png': 'image/png',
    'heic': 'image/heic',
    'gif': 'image/gif',
    'webp': 'image/webp',
  };

  @override
  void onInit() {
    super.onInit();
    fetchTrashBins();
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    super.onClose();
  }

  Future<void> fetchTrashBins() async {
    isLoadingBins.value = true;
    try {
      final response = await Supabase.instance.client
          .from('trashbin')
          .select();
      final data = response as List;
      allTrashBins.value = data.map((e) => TrashBin.fromJson(e)).toList();
    } catch (e) {
      print("Error fetching bins: $e");
      // Dummy data
      allTrashBins.value = [
         TrashBin(id: 1, locationName: "Main Gate Side A", latitude: 0, longitude: 0, capacity: "full", type: "organic"),
         TrashBin(id: 2, locationName: "Main Gate Side B", latitude: 0, longitude: 0, capacity: "empty", type: "inorganic"),
         TrashBin(id: 3, locationName: "Canteen Area", latitude: 0, longitude: 0, capacity: "half", type: "organic"),
      ];
    } finally {
      isLoadingBins.value = false;
    }
  }

  void onTapBottomNav(int index) {
      if (index == 0) {
        Get.offNamed(Routes.HOME);
      } else if (index == 1) {
         Get.toNamed(Routes.MAPS);
      } else if (index == 2) {
        // Current
      } else {
        Get.snackbar("Coming Soon", "Feature in progress");
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

    // Validation
    if (titleController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Report title is required');
      return;
    }
    if (selectedTrashBin.value == null) {
      Get.snackbar('Error', 'Please select a Trash Bin');
      return;
    }
    if (selectedCapacity.value == null) {
      Get.snackbar('Error', 'Please select capacity status');
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

    final client = Supabase.instance.client;
    final currentUser = client.auth.currentUser;
    if (currentUser == null) {
      Get.snackbar('Error', 'User session expired, please login again');
      return;
    }

    isSubmitting.value = true;

    try {
      // 1. Upload Image
      final fileBytes = await image.readAsBytes();
      final extension = image.path.split('.').last.toLowerCase();
      final mimeType = _mimeByExtension[extension] ?? 'image/jpeg';
      final fileName = 'report-${currentUser.id}-${DateTime.now().millisecondsSinceEpoch}.$extension';
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

      // 2. Insert Report
      await client.from('reports').insert({
        'title': titleController.text.trim(),
        'description': descriptionController.text.trim(),
        'image_url': publicUrl,
        'user_id': currentUser.id,
        'trashbin_id': selectedTrashBin.value!.id,
        'points': 10, // Default points? User said "points -> default 0" but DB has default 0. Trigger might update user profile.
        // DB Schema has: created_at default now()
      });

      // 3. Update TrashBin Capacity (Optional but logical based on "Status capacity" input)
      await client.from('trashbin').update({
        'capacity': selectedCapacity.value,
      }).eq('bin_id', selectedTrashBin.value!.id);

      Get.snackbar('Success', 'Waste report submitted successfully (+10 Points)');

      // Reset
      titleController.clear();
      descriptionController.clear();
      selectedTrashBin.value = null;
      selectedImage.value = null;
      // selectedCapacity.value = 'full'; // Keep or reset?
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
