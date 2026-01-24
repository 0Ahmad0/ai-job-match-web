import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';

class VerifyIllustrationWidget extends StatelessWidget {
  const VerifyIllustrationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ZoomIn(
      duration: const Duration(milliseconds: 1000),
      child: Center(
        child: Container(
          height: 180.h,
          width: 180.h,
          decoration: BoxDecoration(
            color: context.theme.primaryColor.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // دوائر متحركة وهمية (Static Pulse)
              Container(
                height: 140.h,
                width: 140.h,
                decoration: BoxDecoration(
                  color: context.theme.primaryColor.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
              ),
              Icon(
                  Icons.mark_email_read_outlined,
                  size: 80.sp,
                  color: context.theme.primaryColor
              ),
            ],
          ),
        ),
      ),
    );
  }
}