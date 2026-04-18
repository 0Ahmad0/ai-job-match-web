import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../data/models/application_model.dart';

class TrackApplicationView extends StatelessWidget {
  const TrackApplicationView({super.key, required this.application});

  final ApplicationModel application;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('lbl_timeline'.tr), centerTitle: true),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            28.verticalSpace,
            Text('lbl_current_stage'.tr, style: context.textTheme.titleLarge),
            16.verticalSpace,
            _buildDynamicTimeline(context),
            if (application.status == AppStatus.rejected && application.rejectionReason != null)
              _buildRejectionCard(context),
            if (application.status == AppStatus.accepted) _buildOfferCard(context),
            if (application.status == AppStatus.interviewScheduled) _buildInterviewCard(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: context.theme.cardColor,
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(color: context.theme.dividerColor),
      ),
      child: Row(
        children: [
          Container(
            width: 60.w,
            height: 60.w,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: const Icon(Icons.business_center_outlined, color: Colors.grey),
          ),
          15.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(application.jobTitle, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp)),
                5.verticalSpace,
                Text(application.company, style: TextStyle(color: Colors.grey, fontSize: 14.sp)),
                if (application.matchScore != null) ...[
                  10.verticalSpace,
                  Text(
                    'lbl_ai_match'.trParams({'score': application.matchScore.toString()}),
                    style: TextStyle(color: context.theme.primaryColor, fontWeight: FontWeight.bold),
                  ),
                ],
                8.verticalSpace,
                _buildStatusChip(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(BuildContext context) {
    Color bgColor;
    Color textColor;
    String label;
    IconData icon;

    switch (application.status) {
      case AppStatus.applied:
        bgColor = Colors.grey.withValues(alpha: 0.1);
        textColor = Colors.grey.shade700;
        label = 'status_applied'.tr;
        icon = Icons.send_outlined;
        break;
      case AppStatus.underReview:
        bgColor = Colors.orange.withValues(alpha: 0.1);
        textColor = Colors.orange.shade800;
        label = 'status_under_review'.tr;
        icon = Icons.visibility_outlined;
        break;
      case AppStatus.interviewScheduled:
        bgColor = Colors.indigo.withValues(alpha: 0.1);
        textColor = Colors.indigo.shade800;
        label = 'status_interview_scheduled'.tr;
        icon = Icons.event_available_outlined;
        break;
      case AppStatus.accepted:
        bgColor = Colors.green.withValues(alpha: 0.1);
        textColor = Colors.green.shade800;
        label = 'status_accepted'.tr;
        icon = Icons.check_circle_outlined;
        break;
      case AppStatus.rejected:
        bgColor = Colors.red.withValues(alpha: 0.1);
        textColor = Colors.red.shade800;
        label = 'status_rejected'.tr;
        icon = Icons.cancel_outlined;
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14.sp, color: textColor),
          6.horizontalSpace,
          Text(
            label,
            style: TextStyle(fontSize: 12.sp, color: textColor, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildDynamicTimeline(BuildContext context) {
    final isInterviewScheduled = application.status == AppStatus.interviewScheduled;
    final isAccepted = application.status == AppStatus.accepted;
    final isRejected = application.status == AppStatus.rejected;
    final isUnderReview = application.status == AppStatus.underReview;

    final steps = <Widget>[
      _buildTimelineItem(
        context,
        'step_submitted'.tr,
        application.appliedDate,
        true,
        true,
        false,
      ),
      _buildTimelineItem(
        context,
        'step_under_review'.tr,
        isUnderReview || isInterviewScheduled || isAccepted || isRejected
            ? 'status_completed'.tr
            : 'status_pending'.tr,
        isUnderReview || isInterviewScheduled || isAccepted || isRejected,
        isUnderReview || isInterviewScheduled || isAccepted || isRejected,
        false,
      ),
      _buildTimelineItem(
        context,
        'step_interview'.tr,
        isInterviewScheduled || isAccepted
            ? (application.interviewDate != null ? application.interviewDate! : 'status_completed'.tr)
            : 'status_pending'.tr,
        isInterviewScheduled || isAccepted,
        isInterviewScheduled || isAccepted,
        false,
      ),
      _buildTimelineItem(
        context,
        isRejected ? 'step_rejected'.tr : (isAccepted ? 'step_accepted'.tr : 'step_final_decision'.tr),
        isAccepted
            ? 'status_accepted'.tr
            : isRejected
                ? 'status_rejected'.tr
                : 'status_awaiting_decision'.tr,
        isAccepted || isRejected,
        isAccepted || isRejected,
        isRejected,
        isLast: true,
      ),
    ];

    return Column(children: steps);
  }

  Widget _buildTimelineItem(
    BuildContext context,
    String title,
    String date,
    bool isActive,
    bool isCompleted,
    bool isFailure, {
    bool isLast = false,
  }) {
    final color = isFailure
        ? Colors.red
        : isCompleted
            ? Colors.green
            : Colors.grey.shade300;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            children: [
              Container(
                width: 24.w,
                height: 24.w,
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
                    color: isCompleted ? Colors.green.withValues(alpha: 0.35) : Colors.grey.shade200,
                  ),
                ),
            ],
          ),
          16.horizontalSpace,
          Expanded(
            child: Container(
              margin: EdgeInsets.only(bottom: isLast ? 0 : 24.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp,
                      color: isFailure ? Colors.red : (isActive ? context.textTheme.bodyLarge?.color : Colors.grey),
                    ),
                  ),
                  6.verticalSpace,
                  Text(date, style: TextStyle(color: Colors.grey, fontSize: 12.sp)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRejectionCard(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 30.h),
      padding: EdgeInsets.all(20.r),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: Colors.red.withValues(alpha: 0.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.info_outline, color: Colors.red),
              8.horizontalSpace,
              Text('lbl_rejection_reason'.tr, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red, fontSize: 14.sp)),
            ],
          ),
          10.verticalSpace,
          Text(application.rejectionReason ?? 'msg_rejection'.tr, style: TextStyle(fontSize: 13.sp, color: Colors.grey[800])),
        ],
      ),
    );
  }

  Widget _buildOfferCard(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 30.h),
      padding: EdgeInsets.all(20.r),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: Colors.green.withValues(alpha: 0.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.check_circle_outline, color: Colors.green),
              8.horizontalSpace,
              Text('msg_congrats'.tr, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green, fontSize: 14.sp)),
            ],
          ),
          14.verticalSpace,
          if (application.startDate != null)
            _buildDetailRow('lbl_start_date'.tr, application.startDate!),
          if (application.startDate != null && application.offerSalary != null)
            10.verticalSpace,
          if (application.offerSalary != null)
            _buildDetailRow('lbl_salary'.tr.replaceAll('/', ''), application.offerSalary!),
        ],
      ),
    );
  }

  Widget _buildInterviewCard(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 30.h),
      padding: EdgeInsets.all(20.r),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.indigo.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: Colors.indigo.withValues(alpha: 0.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.event_available, color: Colors.indigo),
              8.horizontalSpace,
              Text('lbl_interview_scheduled'.tr, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo, fontSize: 14.sp)),
            ],
          ),
          14.verticalSpace,
          if (application.interviewDate != null)
            _buildDetailRow('lbl_interview_date'.tr, application.interviewDate!),
          if (application.interviewDate != null && application.interviewTime != null)
            10.verticalSpace,
          if (application.interviewTime != null)
            _buildDetailRow('lbl_interview_time'.tr, application.interviewTime!),
          if ((application.interviewDate != null || application.interviewTime != null) && application.interviewLocation != null)
            10.verticalSpace,
          if (application.interviewLocation != null)
            _buildDetailRow('lbl_interview_location'.tr, application.interviewLocation!),
          if ((application.interviewDate != null || application.interviewTime != null || application.interviewLocation != null) && application.interviewNotes != null)
            10.verticalSpace,
          if (application.interviewNotes != null)
            _buildDetailRow('lbl_interview_notes'.tr, application.interviewNotes!),
          if (application.interviewDate == null && application.interviewTime == null && application.interviewLocation == null && application.interviewNotes == null)
            Text('msg_interview_scheduled'.tr, style: TextStyle(fontSize: 13.sp, color: Colors.grey[800])),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: Colors.grey.shade600, fontSize: 13.sp)),
        Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.sp)),
      ],
    );
  }
}
