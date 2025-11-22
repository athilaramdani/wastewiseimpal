import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../theme/app_colors.dart';
import '../controllers/reportwaste_controller.dart';

class ReportwasteView extends GetView<ReportwasteController> {
  const ReportwasteView({super.key});

  BottomNavigationBarItem _navItem(IconData icon, String label) =>
      BottomNavigationBarItem(icon: Icon(icon), label: label);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leadingWidth: kToolbarHeight,
          leading: const SizedBox(width: kToolbarHeight),
          centerTitle: true,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.report_gmailerrorred, color: AppColors.primary),
              SizedBox(width: 8),
              Text(
                'Report Waste',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
            ],
          ),
          actions: [
            IconButton(
              tooltip: 'History',
              icon: const Icon(Icons.history_outlined),
              onPressed: controller.openHistory,
            ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 90),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withOpacity(.15),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: const [
                      Icon(
                        Icons.info_outline,
                        color: AppColors.primary,
                        size: 24,
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Help keep the environment clean by reporting waste around you',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                const Text(
                  'Photo Attachment',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Obx(() {
                  final image = controller.selectedImage.value;
                  return GestureDetector(
                    onTap: controller.pickImage,
                    child: AspectRatio(
                      aspectRatio: 4 / 3,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.inputFill,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.inputBorder),
                        ),
                        child:
                            image == null
                                ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(
                                      Icons.photo_camera_back_outlined,
                                      size: 36,
                                      color: AppColors.textSecondary,
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      'Tap to upload waste photo',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                )
                                : Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(14),
                                      child: Image.file(
                                        File(image.path),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Positioned(
                                      top: 8,
                                      right: 8,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.black54,
                                          borderRadius: BorderRadius.circular(
                                            24,
                                          ),
                                        ),
                                        child: IconButton(
                                          icon: const Icon(
                                            Icons.close,
                                            color: Colors.white,
                                          ),
                                          onPressed: controller.removeImage,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 24),

                const Text(
                  'Report Title',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: controller.titleController,
                  decoration: const InputDecoration(
                    hintText: 'e.g., Waste pile on the roadside',
                    hintStyle: TextStyle(fontSize: 14),
                  ),
                ),
                const SizedBox(height: 20),

                const Text(
                  'Waste Category',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Obx(
                  () => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: AppColors.inputFill,
                      border: Border.all(color: AppColors.inputBorder),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        hint: const Text(
                          'Select waste category',
                          style: TextStyle(fontSize: 14),
                        ),
                        value: controller.selectedCategory.value,
                        items:
                            controller.categories
                                .map(
                                  (category) => DropdownMenuItem(
                                    value: category,
                                    child: Text(category),
                                  ),
                                )
                                .toList(),
                        onChanged: (value) {
                          controller.selectedCategory.value = value;
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                const Text(
                  'Location',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: controller.locationController,
                  decoration: const InputDecoration(
                    hintText: 'e.g., Jl. Sudirman No. 123',
                    hintStyle: TextStyle(fontSize: 14),
                    prefixIcon: Icon(Icons.location_on_outlined),
                  ),
                ),
                const SizedBox(height: 20),

                const Text(
                  'Description',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: controller.descriptionController,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    hintText: 'Describe the waste condition you found...',
                    hintStyle: TextStyle(fontSize: 14),
                    alignLabelWithHint: true,
                  ),
                ),
                const SizedBox(height: 28),

                Obx(
                  () => SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed:
                          controller.isSubmitting.value
                              ? null
                              : controller.submitReport,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        disabledBackgroundColor: AppColors.primary.withOpacity(
                          .6,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child:
                          controller.isSubmitting.value
                              ? const SizedBox(
                                height: 22,
                                width: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.6,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                              : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.send, size: 20),
                                  SizedBox(width: 8),
                                  Text(
                                    'Submit Report',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Obx(
          () => BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: controller.currentIndex.value,
            onTap: controller.onTapBottomNav,
            selectedItemColor: AppColors.primary,
            unselectedItemColor: AppColors.textSecondary,
            items: [
              _navItem(Icons.home_outlined, 'Home'),
              _navItem(Icons.map_outlined, 'Maps'),
              _navItem(Icons.add_circle_outline, 'Report'),
              _navItem(Icons.star_border, 'Leaderboard'),
              _navItem(Icons.person_outline, 'Profile'),
            ],
          ),
        ),
      ),
    );
  }
}
