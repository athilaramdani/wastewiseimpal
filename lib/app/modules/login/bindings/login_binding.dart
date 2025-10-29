import 'package:get/get.dart';
import '../controllers/login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    // biar kalo disposed, Get.find() bisa nge-spawn ulang
    Get.lazyPut<LoginController>(() => LoginController(), fenix: true);
  }
}
