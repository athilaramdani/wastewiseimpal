import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../theme/app_colors.dart';
import '../controllers/education_detail_controller.dart';
import 'package:intl/intl.dart';

class EducationDetailView extends GetView<EducationDetailController> {
  const EducationDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<EducationDetailController>()) {
      Get.put(EducationDetailController());
    }
    
    // Safety check if accessed without valid args
    // Although Controller handles it, View needs object to build.
    // Ideally use Obx if checking status, but here we assume init calls valid.
    final item = controller.education;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Education Detail"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (item.image != null)
              SizedBox(
                width: double.infinity,
                height: 250,
                child: Image.network(
                  item.image!,
                  fit: BoxFit.cover,
                  errorBuilder: (ctx, err, stack) => Container(
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.broken_image, size: 50, color: Colors.grey),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (item.createdAt != null)
                    Text(
                      DateFormat('dd MMM yyyy').format(item.createdAt!),
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  const SizedBox(height: 16),
                  Divider(color: Colors.grey.shade200),
                  const SizedBox(height: 16),
                  Text(
                    item.body,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.6,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
