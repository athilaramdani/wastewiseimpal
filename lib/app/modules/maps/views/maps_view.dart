import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../controllers/maps_controller.dart';
import '../../../theme/app_colors.dart';

class MapsView extends GetView<MapsController> {
  const MapsView({super.key});

  BottomNavigationBarItem _navItem(IconData icon, String label) =>
      BottomNavigationBarItem(icon: Icon(icon), label: label);

  @override
  Widget build(BuildContext context) {
    if(!Get.isRegistered<MapsController>()) {
      Get.put(MapsController());
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Waste Maps"),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Obx(() {
        final bins = controller.trashBins;
        final userPos = controller.userPosition.value;

        return FlutterMap(
          mapController: controller.mapController,
          options: MapOptions(
            initialCenter: userPos ?? const LatLng(-6.9744, 107.6303), // TelU default
            initialZoom: 15.0,
            interactionOptions: const InteractionOptions(
              flags: InteractiveFlag.all,
            ),
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.wastewise.app',
            ),
            MarkerLayer(
              markers: [
                // User Marker
                if (userPos != null)
                  Marker(
                    point: userPos,
                    width: 40,
                    height: 40,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                        boxShadow: [BoxShadow(blurRadius: 10, color: Colors.blueAccent)],
                      ),
                      child: const Icon(Icons.person, color: Colors.white, size: 24),
                    ),
                  ),
                
                // Bin Markers
                ...bins.map((bin) {
                  final color = controller.getBinColor(bin.capacity);
                  return Marker(
                    point: LatLng(bin.latitude, bin.longitude),
                    width: 50,
                    height: 50,
                    child: GestureDetector(
                      onTap: () {
                         Get.bottomSheet(
                           Container(
                             padding: const EdgeInsets.all(20),
                             decoration: const BoxDecoration(
                               color: Colors.white,
                               borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                             ),
                             child: Column(
                               mainAxisSize: MainAxisSize.min,
                               children: [
                                 Text(bin.locationName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                 const SizedBox(height: 10),
                                 Row(
                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                   children: [
                                     const Text("Type:"),
                                     Text(bin.type, style: const TextStyle(fontWeight: FontWeight.w600)),
                                   ],
                                 ),
                                 const SizedBox(height: 8),
                                 Row(
                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                   children: [
                                     const Text("Status:"),
                                     Container(
                                       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                       decoration: BoxDecoration(
                                         color: color.withOpacity(0.2),
                                         borderRadius: BorderRadius.circular(8),
                                       ),
                                       child: Text(bin.capacity.toUpperCase(), style: TextStyle(color: color, fontWeight: FontWeight.bold)),
                                     ),
                                   ],
                                 ),
                                 const SizedBox(height: 20),
                               ],
                             ),
                           )
                         );
                      },
                      child: Icon(Icons.location_on, color: color, size: 40),
                    ),
                  );
                }),
              ],
            ),
          ],
        );
      }),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: controller.currentIndex.value,
          onTap: controller.onTapBottomNav,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textSecondary,
          items: [
            _navItem(Icons.home_outlined, "Home"),
            _navItem(Icons.map_outlined, "Maps"),
            _navItem(Icons.add_circle_outline, "Report"),
            _navItem(Icons.star_border, "Leaderboard"),
            _navItem(Icons.person_outline, "Profile"),
          ],
        ),
      ),
    );
  }
}
