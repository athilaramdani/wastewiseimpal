import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../routes/app_pages.dart'; // ✅ penting: import ini, bukan app_routes.dart

class RegisterController extends GetxController {
  final fullNameC = TextEditingController();
  final emailC = TextEditingController();
  final passwordC = TextEditingController();
  final confirmC = TextEditingController();

  final obscurePass = true.obs;
  final obscureConfirm = true.obs;

  void togglePass() => obscurePass.value = !obscurePass.value;
  void toggleConfirm() => obscureConfirm.value = !obscureConfirm.value;

  void createAccount() {
    Get.focusScope?.unfocus();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.offAllNamed(Routes.HOME);
    });
  }

  void goToLogin() {
    Get.focusScope?.unfocus();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.offNamed(Routes.LOGIN); // ⬅️ ganti offAllNamed/toNamed -> offNamed
    });
  }

  @override
  void onClose() {
    fullNameC.dispose();
    emailC.dispose();
    passwordC.dispose();
    confirmC.dispose();
    super.onClose();
  }
}
