import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/common/app_ui.dart';
import '../../controllers/ai_analyzer_controller.dart';

class ResultsDashboardWidget extends GetView<AiAnalyzerController> {
  const ResultsDashboardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final result = controller.result;

    return SingleChildScrollView(
      padding: EdgeInsets.all(20.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSectionHeader(
            title: 'cv_fix_ready_title'.tr,
            subtitle: 'cv_fix_ready_desc'.tr,
          ),
          20.verticalSpace,
          FadeInDown(
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 180.w,
                    height: 180.w,
                    child: CircularProgressIndicator(
                      value: 1.0,
                      strokeWidth: 15,
                      color: Colors.grey.shade200,
                    ),
                  ),
                  SizedBox(
                    width: 180.w,
                    height: 180.w,
                    child: TweenAnimationBuilder<double>(
                      tween: Tween<double>(begin: 0, end: result.score / 100),
                      duration: const Duration(seconds: 2),
                      builder: (context, value, _) => CircularProgressIndicator(
                        value: value,
                        strokeWidth: 15,
                        color: _getScoreColor(result.score),
                        strokeCap: StrokeCap.round,
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${result.score}%',
                        style: TextStyle(fontSize: 40.sp, fontWeight: FontWeight.bold, color: context.textTheme.bodyLarge?.color),
                      ),
                      Text('result_score'.tr, style: TextStyle(fontSize: 12.sp, color: Colors.grey)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          30.verticalSpace,
          FadeInUp(
            delay: const Duration(milliseconds: 250),
            child: Container(
              padding: EdgeInsets.all(20.r),
              decoration: BoxDecoration(
                color: context.theme.cardColor,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: context.theme.dividerColor),
              ),
              child: Column(
                children: [
                  _buildSkillRow(context, 'matched_skills'.tr, result.matchedSkills, Colors.green),
                  Divider(height: 30.h),
                  _buildSkillRow(context, 'missing_skills'.tr, result.missingSkills, Colors.red),
                ],
              ),
            ),
          ),
          26.verticalSpace,
          Text('tab_tips'.tr, style: context.textTheme.headlineSmall),
          14.verticalSpace,
          ...result.tips.map(
            (tip) => FadeInUp(
              child: Container(
                margin: EdgeInsets.only(bottom: 10.h),
                padding: EdgeInsets.all(15.r),
                decoration: BoxDecoration(
                  color: tip.isCritical ? Colors.red.withValues(alpha: 0.05) : Colors.blue.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: tip.isCritical ? Colors.red.withValues(alpha: 0.2) : Colors.blue.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(tip.isCritical ? Icons.warning_amber_rounded : Icons.lightbulb_outline, color: tip.isCritical ? Colors.red : Colors.blue),
                    15.horizontalSpace,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(tip.title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp)),
                          4.verticalSpace,
                          Text(tip.description, style: TextStyle(fontSize: 12.sp, color: context.textTheme.bodyMedium?.color?.withValues(alpha: 0.8))),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          24.verticalSpace,
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: controller.openCvFixFlow,
              icon: const Icon(Icons.edit_document),
              label: Text('btn_fix_cv_issues'.tr),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillRow(BuildContext context, String title, List<String> skills, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.circle, size: 10.sp, color: color),
            8.horizontalSpace,
            Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp)),
          ],
        ),
        10.verticalSpace,
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: skills
              .map(
                (s) => Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(s, style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 12.sp)),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  Color _getScoreColor(int score) {
    if (score >= 80) return Colors.green;
    if (score >= 50) return Colors.orange;
    return Colors.red;
  }
}
