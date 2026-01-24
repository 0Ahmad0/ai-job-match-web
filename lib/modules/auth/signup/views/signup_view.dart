import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controllers/signup_controller.dart';
import 'widgets/signup_header_widget.dart';
import 'widgets/role_selection_widget.dart';
import 'widgets/signup_form_widget.dart';
import 'widgets/signup_footer_widget.dart';

class SignupView extends GetView<SignupController> {
  const SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SignupHeaderWidget(),
              30.verticalSpace,
              const RoleSelectionWidget(),
              30.verticalSpace,
              const SignupFormWidget(),
              30.verticalSpace,
              const SignupFooterWidget(),
              20.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }
}