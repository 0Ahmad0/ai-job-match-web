import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../auth_controller.dart';
import '../controllers/login_controller.dart';
import 'widgets/login_header_widget.dart';
import 'widgets/login_form_widget.dart';
import 'widgets/login_footer_widget.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              30.verticalSpace,
              const LoginHeaderWidget(),
              40.verticalSpace,
              const LoginFormWidget(),
              40.verticalSpace,
              const LoginFooterWidget(),
              24.verticalSpace,
              // TEMP_ADMIN_SEED_START (safe to delete after one-time use)
              Obx(
                () => SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: authController.isLoading.value
                        ? null
                        : authController.seedAdminAccount,
                    child: Text('seed_admin_btn'.tr),
                  ),
                ),
              ),
              // TEMP_ADMIN_SEED_END
            ],
          ),
        ),
      ),
    );
  }
}
