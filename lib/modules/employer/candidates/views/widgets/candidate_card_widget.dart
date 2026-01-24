import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../data/models/candidate_model.dart';
import '../../controllers/candidates_controller.dart';

class CandidateCardWidget extends GetView<CandidatesController> {
  final CandidateModel candidate;

  const CandidateCardWidget({super.key, required this.candidate});

  @override
  Widget build(BuildContext context) {
    // لون النسبة
    Color scoreColor = Colors.green;
    if (candidate.matchScore < 80) scoreColor = Colors.orange;
    if (candidate.matchScore < 60) scoreColor = Colors.red;

    return Container(
      margin: EdgeInsets.only(bottom: 15.h),
      padding: EdgeInsets.all(15.r),
      decoration: BoxDecoration(
        color: context.theme.cardColor,
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Avatar
              CircleAvatar(
                radius: 30.r,
                backgroundColor: Colors.grey.shade200,
                child: Icon(Icons.person, size: 35.sp, color: Colors.grey),
              ),
              15.horizontalSpace,

              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      candidate.name,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
                    ),
                    4.verticalSpace,
                    Text(
                      candidate.jobTitle,
                      style: TextStyle(color: Colors.grey, fontSize: 12.sp),
                    ),
                    8.verticalSpace,
                    // Matching Skills Chips
                    Wrap(
                      spacing: 5,
                      runSpacing: 5,
                      children: candidate.matchingSkills.take(3).map((skill) => Container(
                        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                        decoration: BoxDecoration(
                          color: context.theme.primaryColor.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(4.r),
                          border: Border.all(color: context.theme.primaryColor.withOpacity(0.2)),
                        ),
                        child: Text(skill, style: TextStyle(fontSize: 10.sp, color: context.theme.primaryColor)),
                      )).toList(),
                    ),
                  ],
                ),
              ),

              // AI Score Badge (Big Circle)
              Column(
                children: [
                  Container(
                    width: 50.w,
                    height: 50.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: scoreColor, width: 3),
                    ),
                    child: Center(
                      child: Text(
                        "${candidate.matchScore}%",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.sp, color: scoreColor),
                      ),
                    ),
                  ),
                  5.verticalSpace,
                  Text('lbl_match'.tr, style: TextStyle(fontSize: 10.sp, color: Colors.grey)),
                ],
              ),
            ],
          ),

          15.verticalSpace,
          Divider(color: Colors.grey.withOpacity(0.1)),
          5.verticalSpace,

          // Actions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildActionButton(context, Icons.close, 'btn_reject'.tr, Colors.red, () => controller.performAction('reject', candidate.name)),
              _buildActionButton(context, Icons.favorite_border, 'btn_shortlist'.tr, Colors.orange, () => controller.performAction('Shortlisted', candidate.name)),
              _buildActionButton(context, Icons.chat_bubble_outline, 'btn_interview'.tr, Colors.green, () => controller.performAction('Interview Request', candidate.name)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, IconData icon, String label, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20.sp),
            4.verticalSpace,
            Text(label, style: TextStyle(fontSize: 10.sp, color: color, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}