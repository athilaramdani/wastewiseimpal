import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../routes/app_pages.dart'; // ✅ penting: import ini, bukan app_routes.dart

class LoginController extends GetxController {
  final emailC = TextEditingController();
  final passwordC = TextEditingController();

  final obscure = true.obs;

  void toggleObscure() => obscure.value = !obscure.value;

  void signIn() {
    Get.focusScope?.unfocus();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.offAllNamed(Routes.HOME);
    });
  }

  void goToRegister() {
    Get.focusScope?.unfocus();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.offNamed(Routes.REGISTER); // ⬅️ ganti toNamed -> offNamed
    });
  }

  @override
  void onClose() {
    emailC.dispose();
    passwordC.dispose();
    super.onClose();
  }
}
