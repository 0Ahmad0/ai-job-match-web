import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../controllers/signup_controller.dart';

class RoleSelectionWidget extends GetView<SignupController> {
  const RoleSelectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      duration: const Duration(milliseconds: 800),
      delay: const Duration(milliseconds: 200),
      child: Row(
        children: [
          Expanded(
            child: _buildRoleCard(
              context,
              index: 1,
              title: 'role_seeker'.tr,
              desc: 'role_seeker_desc'.tr,
              icon: FontAwesomeIcons.userTie,
            ),
          ),
          15.horizontalSpace,
          Expanded(
            child: _buildRoleCard(
              context,
              index: 2,
              title: 'role_employer'.tr,
              desc: 'role_employer_desc'.tr,
              icon: FontAwesomeIcons.briefcase,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleCard(BuildContext context, {
    required int index,
    required String title,
    required String desc,
    required IconData icon,
  }) {
    return Obx(() {
      final isSelected = controller.selectedRole.value == index;
      final primary = context.theme.primaryColor;

      return InkWell(
        onTap: () => controller.selectRole(index),
        borderRadius: BorderRadius.circular(16.r),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: isSelected ? primary.withValues(alpha: 0.1) : context.theme.cardColor,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: isSelected ? primary : Colors.grey.withValues(alpha: 0.3),
              width: 2,
            ),
            boxShadow: isSelected
                ? [BoxShadow(color: primary.withValues(alpha: 0.2), blurRadius: 10, offset: const Offset(0, 4))]
                : [],
          ),
          child: Column(
            children: [
              FaIcon(
                icon,
                size: 30.sp,
                color: isSelected ? primary : Colors.grey,
              ),
              12.verticalSpace,
              Text(
                title,
                style: context.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isSelected ? primary : null,
                  fontSize: 14.sp,
                ),
                textAlign: TextAlign.center,
              ),
              8.verticalSpace,
              Text(
                desc,
                style: context.textTheme.bodyMedium?.copyWith(
                  fontSize: 10.sp,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
              ),
            ],
          ),
        ),
      );
    });
  }
}