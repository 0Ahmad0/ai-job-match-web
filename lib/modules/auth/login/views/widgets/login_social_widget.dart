import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:animate_do/animate_do.dart';

class LoginSocialWidget extends StatelessWidget {
  const LoginSocialWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      duration: const Duration(milliseconds: 800),
      delay: const Duration(milliseconds: 400),
      child: Column(
        children: [
          Row(
            children: [
              const Expanded(child: Divider()),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Text('or_continue'.tr, style: context.textTheme.bodyMedium),
              ),
              const Expanded(child: Divider()),
            ],
          ),
          20.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _SocialButton(
                icon: FontAwesomeIcons.google,
                color: Colors.red,
                onTap: () {},
              ),
              20.horizontalSpace,
              _SocialButton(
                icon: FontAwesomeIcons.linkedinIn,
                color: Colors.blue.shade800,
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _SocialButton({required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        width: 50.w,
        height: 50.h,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
          borderRadius: BorderRadius.circular(12.r),
          color: context.isDarkMode ? Colors.white.withValues(alpha: 0.05) : Colors.white,
        ),
        child: Center(
          child: FaIcon(icon, color: color, size: 22.sp),
        ),
      ),
    );
  }
}