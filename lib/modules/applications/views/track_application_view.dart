import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';

import '../../../data/models/application_model.dart';

class TrackApplicationView extends StatelessWidget {
  final ApplicationModel application;

  const TrackApplicationView({super.key, required this.application});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('lbl_timeline'.tr), centerTitle: true),
      body: SingleChildScrollView( // جعلناها قابلة للسكرول
        padding: EdgeInsets.all(30.r),
        child: Column(
          children: [
            // 1. Job Header
            _buildHeader(context),

            40.verticalSpace,
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text('lbl_current_stage'.tr, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
            ),
            20.verticalSpace,

            // 2. Dynamic Timeline
            _buildDynamicTimeline(context),

            // 3. Info Card (Reason or Offer)
            if (application.status == AppStatus.rejected)
              _buildRejectionCard(context),

            if (application.status == AppStatus.accepted)
              _buildOfferCard(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 60.w, height: 60.w,
          decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(15)),
          child: const Icon(Icons.business, color: Colors.grey),
        ),
        15.horizontalSpace,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(application.jobTitle, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp)),
            Text(application.company, style: TextStyle(color: Colors.grey, fontSize: 14.sp)),
          ],
        )
      ],
    );
  }

  // المنطق الديناميكي لبناء الخطوات
  Widget _buildDynamicTimeline(BuildContext context) {
    List<Widget> steps = [];

    // الخطوة 1: التقديم (دائماً موجودة ومكتملة)
    steps.add(_buildTimelineItem(context, 'step_submitted'.tr, application.appliedDate, true, true, false));

    // سيناريو الرفض
    if (application.status == AppStatus.rejected) {
      // الخطوة 2: المراجعة (مكتملة)
      steps.add(_buildTimelineItem(context, 'step_viewed'.tr, 'Done', true, true, false));
      // الخطوة 3: الرفض (حمراء ونهائية)
      steps.add(_buildTimelineItem(context, 'step_rejected'.tr, 'Closed', true, true, true));
    }
    // سيناريو القبول أو الانتظار
    else {
      // الخطوة 2: المراجعة
      steps.add(_buildTimelineItem(context, 'step_viewed'.tr, 'Done', true, true, false));

      // الخطوة 3: المقابلة
      bool isInterviewDone = application.status == AppStatus.accepted;
      steps.add(_buildTimelineItem(context, 'step_interview'.tr, isInterviewDone ? 'Done' : 'Pending', isInterviewDone, isInterviewDone, false));

      // الخطوة 4: العرض
      steps.add(_buildTimelineItem(context, 'step_offer'.tr, isInterviewDone ? 'Accepted' : 'Pending', isInterviewDone, isInterviewDone, false, isLast: true));
    }

    return Column(children: steps);
  }

  Widget _buildTimelineItem(
      BuildContext context,
      String title,
      String date,
      bool isActive,
      bool isCompleted,
      bool isFailure, // هل هذه خطوة فشل (رفض)؟
          {bool isLast = false}
      ) {
    Color color;
    if (isFailure) {
      color = Colors.red;
    } else if (isCompleted) {
      color = Colors.green;
    } else {
      color = Colors.grey.shade300;
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Line & Dot
          Column(
            children: [
              Container(
                width: 24.w, height: 24.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isFailure ? Colors.red : (isCompleted ? Colors.green : Colors.white),
                  border: Border.all(color: color, width: 2),
                ),
                child: isCompleted || isFailure
                    ? Icon(isFailure ? Icons.close : Icons.check, size: 14.sp, color: Colors.white)
                    : null,
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: isCompleted ? Colors.green.withOpacity(0.5) : Colors.grey.shade200,
                  ),
                ),
            ],
          ),
          20.horizontalSpace,
          // Content
          Expanded(
            child: Container(
              margin: EdgeInsets.only(bottom: isLast ? 0 : 30.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      title,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.sp,
                          color: isFailure ? Colors.red : (isActive ? context.textTheme.bodyLarge?.color : Colors.grey)
                      )
                  ),
                  5.verticalSpace,
                  Text(date, style: TextStyle(color: Colors.grey, fontSize: 12.sp)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // بطاقة الرفض
  Widget _buildRejectionCard(BuildContext context) {
    return FadeInUp(
      delay: const Duration(milliseconds: 500),
      child: Container(
        margin: EdgeInsets.only(top: 30.h),
        padding: EdgeInsets.all(20.r),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.05),
          borderRadius: BorderRadius.circular(15.r),
          border: Border.all(color: Colors.red.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info_outline, color: Colors.red, size: 20.sp),
                10.horizontalSpace,
                Text('lbl_rejection_reason'.tr, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red, fontSize: 14.sp)),
              ],
            ),
            10.verticalSpace,
            Text('msg_rejection'.tr, style: TextStyle(fontSize: 12.sp, color: Colors.black87)),
            10.verticalSpace,
            Text('"${application.rejectionReason}"', style: TextStyle(fontSize: 13.sp, fontStyle: FontStyle.italic, color: Colors.grey[700])),
          ],
        ),
      ),
    );
  }

  // بطاقة العرض الوظيفي
  Widget _buildOfferCard(BuildContext context) {
    return FadeInUp(
      delay: const Duration(milliseconds: 500),
      child: Container(
        margin: EdgeInsets.only(top: 30.h),
        padding: EdgeInsets.all(20.r),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.green.withOpacity(0.05),
          borderRadius: BorderRadius.circular(15.r),
          border: Border.all(color: Colors.green.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.celebration, color: Colors.green, size: 20.sp),
                10.horizontalSpace,
                Text('msg_congrats'.tr, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green, fontSize: 14.sp)),
              ],
            ),
            15.verticalSpace,
            _buildDetailRow('lbl_start_date'.tr, application.startDate ?? '-'),
            10.verticalSpace,
            _buildDetailRow('lbl_salary'.tr.replaceAll('/', ''), application.offerSalary ?? '-'),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: Colors.grey, fontSize: 12.sp)),
        Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.sp)),
      ],
    );
  }
}