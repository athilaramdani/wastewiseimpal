import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/supabase_client.dart';
import '../../../routes/app_pages.dart'; // ✅ penting: import ini, bukan app_routes.dart

class LoginController extends GetxController {
  final emailC = TextEditingController();
  final passwordC = TextEditingController();

  final obscure = true.obs;
  final isLoading = false.obs;

  void toggleObscure() => obscure.value = !obscure.value;

  Future<void> signIn() async {
    Get.focusScope?.unfocus();
    final email = emailC.text.trim();
    final pass = passwordC.text;

    if (email.isEmpty || pass.isEmpty) {
      Get.snackbar('Error', 'Email and password are required');
      return;
    }

    isLoading.value = true;
    try {
      await SClient.I.auth.signInWithPassword(email: email, password: pass);
      Get.offAllNamed(Routes.HOME);
    } on AuthException catch (e) {
      Get.snackbar('Login Failed', e.message);
    } catch (_) {
      Get.snackbar('Login Failed', 'An unexpected error occurred');
    } finally {
      isLoading.value = false;
    }
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
