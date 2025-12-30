import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../theme/app_colors.dart';
import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Icon app
                  CircleAvatar(
                    radius: 36,
                    backgroundColor: AppColors.secondary.withOpacity(.2),
                    child: const Icon(
                      Icons.eco,
                      size: 40,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 18),

                  const Text(
                    "Create Account",
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 24),

                  // Full Name
                  TextField(
                    key: ValueKey('reg_name_${controller.hashCode}'),
                    controller: controller.fullNameC,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      labelText: "Full Name",
                      hintText: "Your full name",
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Email
                  TextField(
                    key: ValueKey('reg_email_${controller.hashCode}'),
                    controller: controller.emailC,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: "Email",
                      hintText: "Enter your email",
                      prefixIcon: Icon(Icons.alternate_email),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Password
                  Obx(
                    () => TextField(
                      key: ValueKey('reg_pass_${controller.hashCode}'),
                      controller: controller.passwordC,
                      obscureText: controller.obscurePass.value,
                      decoration: InputDecoration(
                        labelText: "Password",
                        hintText: "Enter your password",
                        helperText: "Minimum 6 characters",
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          onPressed: controller.togglePass,
                          icon: Icon(
                            controller.obscurePass.value
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Confirm Password
                  Obx(
                    () => TextField(
                      key: ValueKey('reg_confirm_${controller.hashCode}'),
                      controller: controller.confirmC,
                      obscureText: controller.obscureConfirm.value,
                      decoration: InputDecoration(
                        labelText: "Confirm Password",
                        hintText: "Re-type your password",
                        prefixIcon: const Icon(Icons.lock_reset),
                        suffixIcon: IconButton(
                          onPressed: controller.toggleConfirm,
                          icon: Icon(
                            controller.obscureConfirm.value
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Create Account
                  Obx(
                    () => ElevatedButton(
                      onPressed:
                          controller.isLoading.value
                              ? null
                              : controller.createAccount,
                      child:
                          controller.isLoading.value
                              ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                              : const Text("Create Account"),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Footer
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account? "),
                      GestureDetector(
                        onTap: controller.goToLogin,
                        child: const Text(
                          "Sign In",
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
