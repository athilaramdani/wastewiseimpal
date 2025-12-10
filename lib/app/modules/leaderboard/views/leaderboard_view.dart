import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../theme/app_colors.dart';
import '../controllers/leaderboard_controller.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../widgets/custom_bottom_nav.dart';

class LeaderboardView extends GetView<LeaderboardController> {
  const LeaderboardView({super.key});

  BottomNavigationBarItem _navItem(IconData icon, String label) =>
      BottomNavigationBarItem(icon: Icon(icon), label: label);

  @override
  Widget build(BuildContext context) {
    if(!Get.isRegistered<LeaderboardController>()) {
      Get.put(LeaderboardController());
    }

    final currentUserId = Supabase.instance.client.auth.currentUser?.id;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Leaderboard"),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.leaderboard.isEmpty) {
          return const Center(child: Text("No data yet."));
        }
        
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.leaderboard.length,
          itemBuilder: (context, index) {
            final user = controller.leaderboard[index];
            final name = user['name'] ?? "User ${index + 1}";
            final points = user['total_points'] ?? 0;
            final isMe = user['id'] == currentUserId;
            final rank = index + 1;

            Color? rankColor;
            if (rank == 1) rankColor = Colors.amber;
            else if (rank == 2) rankColor = Colors.grey;
            else if (rank == 3) rankColor = Colors.brown;

            return Card(
              color: isMe ? AppColors.primary.withOpacity(0.1) : Colors.white,
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: rankColor ?? Colors.blueGrey.shade100,
                  child: Text(
                    "#$rank",
                    style: TextStyle(
                      color: rankColor != null ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                title: Text(name, style: TextStyle(fontWeight: isMe ? FontWeight.bold : FontWeight.normal)),
                trailing: Chip(
                  label: Text("$points pts"),
                  backgroundColor: AppColors.primary.withOpacity(0.2),
                  labelStyle: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                ),
              ),
            );
          },
        );
      }),
      bottomNavigationBar: const CustomBottomNav(currentIndex: 3),
    );
  }
}
