import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../routes/app_pages.dart';
import '../theme/app_colors.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
  });

  void _onTap(int index) {
    if (index == currentIndex) return;

    switch (index) {
      case 0:
        Get.offNamed(Routes.HOME);
        break;
      case 1:
        Get.toNamed(Routes.MAPS);
        break;
      case 2:
        Get.toNamed(Routes.REPORTWASTE);
        break;
      case 3:
        Get.toNamed(Routes.LEADERBOARD);
        break;
      case 4:
        Get.toNamed(Routes.PROFILE);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        onTap: _onTap,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
        items: [
          _buildItem(Icons.home_rounded, Icons.home_outlined, "Home", 0),
          _buildItem(Icons.map_rounded, Icons.map_outlined, "Maps", 1),
          _buildMiddleItem(),
          _buildItem(Icons.emoji_events_rounded, Icons.emoji_events_outlined, "Ranking", 3),
          _buildItem(Icons.person_rounded, Icons.person_outline, "Profile", 4),
        ],
      ),
    );
  }

  BottomNavigationBarItem _buildItem(IconData activeIcon, IconData inactiveIcon, String label, int index) {
    final isSelected = index == currentIndex;
    return BottomNavigationBarItem(
      icon: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.only(bottom: 4),
        child: Icon(isSelected ? activeIcon : inactiveIcon, size: 24),
      ),
      label: label,
    );
  }

  BottomNavigationBarItem _buildMiddleItem() {
    return BottomNavigationBarItem(
      icon: Container(
        width: 48,
        height: 48,
        margin: const EdgeInsets.only(bottom: 4),
        decoration: BoxDecoration(
          color: AppColors.primary,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.4),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 30),
      ),
      label: 'Report',
    );
  }
}
