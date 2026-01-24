import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';

class SignupHeaderWidget extends StatelessWidget {
  const SignupHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FadeInDown(
      duration: const Duration(milliseconds: 800),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'signup_title'.tr,
            style: context.textTheme.headlineLarge,
          ),
          10.verticalSpace,
          Text(
            'signup_subtitle'.tr,
            style: context.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}