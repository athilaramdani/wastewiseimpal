import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/supabase_client.dart';
import '../../../routes/app_pages.dart'; // ✅ penting: import ini, bukan app_routes.dart

class RegisterController extends GetxController {
  final fullNameC = TextEditingController();
  final emailC = TextEditingController();
  final passwordC = TextEditingController();
  final confirmC = TextEditingController();

  final obscurePass = true.obs;
  final obscureConfirm = true.obs;
  final isLoading = false.obs;

  void togglePass() => obscurePass.value = !obscurePass.value;
  void toggleConfirm() => obscureConfirm.value = !obscureConfirm.value;

  Future<void> createAccount() async {
    Get.focusScope?.unfocus();
    final name = fullNameC.text.trim();
    final email = emailC.text.trim();
    final pass = passwordC.text;
    final confirm = confirmC.text;

    if (email.isEmpty || pass.isEmpty) {
      Get.snackbar('Error', 'Email and password are required');
      return;
    }
    if (pass != confirm) {
      Get.snackbar('Error', 'Password confirmation does not match');
      return;
    }

    isLoading.value = true;
    try {
      final res = await SClient.I.auth.signUp(
        email: email,
        password: pass,
        data: {'full_name': name},
      );

      if (res.session != null) {
        Get.offAllNamed(Routes.HOME);
      } else {
        Get.snackbar(
          'Registration Successful',
          'Please check your email for verification.',
        );
        Get.offAllNamed(Routes.LOGIN);
      }
    } on AuthException catch (e) {
      Get.snackbar('Registration Failed', e.message);
    } catch (_) {
      Get.snackbar('Registration Failed', 'An unexpected error occurred');
    } finally {
      isLoading.value = false;
    }
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
