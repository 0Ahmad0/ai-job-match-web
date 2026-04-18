import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../theme/app_theme.dart';

class ShimmerSkeleton extends StatelessWidget {
  const ShimmerSkeleton({
    super.key,
    this.height = 16,
    this.width = double.infinity,
    this.radius = 8,
    this.margin,
  });

  final double height;
  final double width;
  final double radius;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;
    final baseColor = isDark ? AppTheme.darkSurfaceAlt : Color(0xFFF0F4F8);
    final highlightColor = isDark ? AppTheme.darkSurface : AppTheme.lightSurface;

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Container(
        margin: margin,
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: baseColor,
          borderRadius: BorderRadius.circular(radius.r),
        ),
      ),
    );
  }
}

class UserListShimmer extends StatelessWidget {
  const UserListShimmer({super.key, this.itemCount = 6});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.all(20.r),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      separatorBuilder: (_, __) => 10.verticalSpace,
      itemBuilder: (_, __) => Row(
        children: [
          const ShimmerSkeleton(height: 44, width: 44, radius: 22),
          12.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                ShimmerSkeleton(height: 12, width: 140),
                ShimmerSkeleton(
                  height: 10,
                  width: 110,
                  margin: EdgeInsets.only(top: 8),
                ),
              ],
            ),
          ),
          const ShimmerSkeleton(height: 28, width: 60),
        ],
      ),
    );
  }
}

class JobListShimmer extends StatelessWidget {
  const JobListShimmer({super.key, this.itemCount = 4});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.all(20.r),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      separatorBuilder: (_, __) => 14.verticalSpace,
      itemBuilder: (_, __) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          ShimmerSkeleton(height: 14, width: 180),
          ShimmerSkeleton(
            height: 10,
            width: 220,
            margin: EdgeInsets.only(top: 8),
          ),
          ShimmerSkeleton(
            height: 72,
            width: double.infinity,
            margin: EdgeInsets.only(top: 12),
          ),
        ],
      ),
    );
  }
}

class CandidateListShimmer extends StatelessWidget {
  const CandidateListShimmer({super.key, this.itemCount = 5});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.all(20.r),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      separatorBuilder: (_, __) => 12.verticalSpace,
      itemBuilder: (_, __) => Column(
        children: const [
          Row(
            children: [
              ShimmerSkeleton(height: 56, width: 56, radius: 28),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShimmerSkeleton(height: 12, width: 120),
                      ShimmerSkeleton(
                        height: 10,
                        width: 140,
                        margin: EdgeInsets.only(top: 8),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          ShimmerSkeleton(
            height: 34,
            width: double.infinity,
            margin: EdgeInsets.only(top: 12),
          ),
        ],
      ),
    );
  }
}

class ApplicationListShimmer extends StatelessWidget {
  const ApplicationListShimmer({super.key, this.itemCount = 4});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      separatorBuilder: (_, __) => 14.verticalSpace,
      itemBuilder: (_, __) => const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerSkeleton(height: 72, width: double.infinity, radius: 18),
          ShimmerSkeleton(
            height: 12,
            width: 180,
            margin: EdgeInsets.only(top: 10),
          ),
        ],
      ),
    );
  }
}

class ProfileHeaderShimmer extends StatelessWidget {
  const ProfileHeaderShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.r),
      decoration: BoxDecoration(
        color: context.theme.cardColor,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: context.theme.dividerColor),
      ),
      child: const Row(
        children: [
          ShimmerSkeleton(height: 76, width: 76, radius: 38),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerSkeleton(height: 14, width: 200),
                ShimmerSkeleton(height: 12, width: 160, margin: EdgeInsets.only(top: 8)),
                ShimmerSkeleton(height: 10, width: 260, margin: EdgeInsets.only(top: 8)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CardListShimmer extends StatelessWidget {
  const CardListShimmer({super.key, this.itemCount = 3});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        itemCount,
        (index) => const Padding(
          padding: EdgeInsets.only(bottom: 14),
          child: ShimmerSkeleton(height: 82, width: double.infinity, radius: 20),
        ),
      ),
    );
  }
}
