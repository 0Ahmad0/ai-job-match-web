import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controllers/login_controller.dart';
import 'widgets/login_header_widget.dart';
import 'widgets/login_form_widget.dart';
import 'widgets/login_social_widget.dart';
import 'widgets/login_footer_widget.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
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
              const LoginSocialWidget(),
              40.verticalSpace,
              const LoginFooterWidget(),
            ],
          ),
        ),
      ),
    );
  }
}