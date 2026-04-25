import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../core/common/app_ui.dart';
import '../../../../../data/models/candidate_model.dart';
import '../../../../../core/common/shimmer_skeletons.dart';
import '../../controllers/candidates_controller.dart';

class CandidateCardWidget extends GetView<CandidatesController> {
  final CandidateModel candidate;

  const CandidateCardWidget({super.key, required this.candidate});

  @override
  Widget build(BuildContext context) {
    // Score color logic
    Color scoreColor = Colors.green;
    if (candidate.matchScore < 80) scoreColor = Colors.orange;
    if (candidate.matchScore < 60) scoreColor = Colors.red;

    return Obx(() {
      final isProcessing =
          controller.processingCandidateId.value == candidate.id;

      // Determine action button states based on candidate status
      final isTerminal = candidate.status == 'accepted' || candidate.status == 'rejected';
      final isAccepted = candidate.status == 'accepted';
      final isRejected = candidate.status == 'rejected';
      final isInterviewScheduled = candidate.status == 'interview_scheduled';

      return Container(
      margin: EdgeInsets.only(bottom: 15.h),
      padding: EdgeInsets.all(15.r),
      decoration: BoxDecoration(
        color: context.theme.cardColor,
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
      ),
      child: Column(
        children: [
          // Status badge at top
          _buildStatusBadge(context),
          12.verticalSpace,
          if (isProcessing) ...[
            const ShimmerSkeleton(height: 6, radius: 3),
            12.verticalSpace,
          ],
          Row(
            children: [
              // Avatar
              AppUserAvatar(
                name: candidate.name,
                imageUrl: candidate.imageUrl,
                radius: 30,
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
                          color: context.theme.primaryColor.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(4.r),
                          border: Border.all(color: context.theme.primaryColor.withValues(alpha: 0.2)),
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
          Divider(color: Colors.grey.withValues(alpha: 0.1)),
          5.verticalSpace,

          // Actions - mutually exclusive based on status
          if (isTerminal)
            // Terminal state: show status indicator, no actions
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isAccepted ? Icons.check_circle : Icons.cancel,
                    color: isAccepted ? Colors.green : Colors.red,
                    size: 20.sp,
                  ),
                  8.horizontalSpace,
                  Text(
                    isAccepted ? 'lbl_candidate_accepted'.tr : 'lbl_candidate_rejected'.tr,
                    style: TextStyle(
                      color: isAccepted ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 13.sp,
                    ),
                  ),
                ],
              ),
            )
          else
            // Non-terminal: show action buttons
            IgnorePointer(
              ignoring: isProcessing,
              child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildActionButton(
                  context,
                  Icons.close,
                  'btn_reject'.tr,
                  Colors.red,
                  isInterviewScheduled ? () => _showInterviewActionDialog(context, 'action_reject') : () => _showRejectReasonDialog(context),
                ),
                _buildActionButton(
                  context,
                  Icons.check_circle_outline,
                  'btn_approve'.tr,
                  Colors.green,
                  isInterviewScheduled ? () => _showInterviewActionDialog(context, 'action_accept') : () => controller.performAction('action_accept', candidate),
                ),
                if (!isInterviewScheduled)
                  _buildActionButton(
                    context,
                    Icons.calendar_month,
                    'btn_interview'.tr,
                    context.theme.primaryColor,
                    () => _showInterviewSchedulingDialog(context),
                  ),
              ],
            ),
            ),
        ],
      ),
    );
    });
  }

  Widget _buildStatusBadge(BuildContext context) {
    final status = candidate.status;
    Color bgColor;
    Color textColor;
    String label;
    IconData icon;

    switch (status) {
      case 'applied':
      case 'pending':
        bgColor = Colors.grey.withValues(alpha: 0.1);
        textColor = Colors.grey.shade700;
        label = 'status_applied'.tr;
        icon = Icons.send_outlined;
        break;
      case 'under_review':
        bgColor = Colors.orange.withValues(alpha: 0.1);
        textColor = Colors.orange.shade800;
        label = 'status_under_review'.tr;
        icon = Icons.visibility_outlined;
        break;
      case 'interview_scheduled':
      case 'interview':
        bgColor = Colors.indigo.withValues(alpha: 0.1);
        textColor = Colors.indigo.shade800;
        label = 'status_interview_scheduled'.tr;
        icon = Icons.event_available_outlined;
        break;
      case 'accepted':
        bgColor = Colors.green.withValues(alpha: 0.1);
        textColor = Colors.green.shade800;
        label = 'status_accepted'.tr;
        icon = Icons.check_circle_outlined;
        break;
      case 'rejected':
        bgColor = Colors.red.withValues(alpha: 0.1);
        textColor = Colors.red.shade800;
        label = 'status_rejected'.tr;
        icon = Icons.cancel_outlined;
        break;
      default:
        bgColor = Colors.grey.withValues(alpha: 0.1);
        textColor = Colors.grey.shade700;
        label = status;
        icon = Icons.help_outline;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
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
            style: TextStyle(fontSize: 11.sp, color: textColor, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, IconData icon, String label, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
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

  void _showInterviewSchedulingDialog(BuildContext context) {
    final dateCtrl = TextEditingController();
    final timeCtrl = TextEditingController();
    final locationCtrl = TextEditingController();
    final notesCtrl = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: Text('dialog_schedule_interview'.tr),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: dateCtrl,
                decoration: InputDecoration(
                  labelText: 'lbl_interview_date'.tr,
                  hintText: 'hint_interview_date'.tr,
                  prefixIcon: const Icon(Icons.calendar_today),
                ),
              ),
              12.verticalSpace,
              TextField(
                controller: timeCtrl,
                decoration: InputDecoration(
                  labelText: 'lbl_interview_time'.tr,
                  hintText: 'hint_interview_time'.tr,
                  prefixIcon: const Icon(Icons.access_time),
                ),
              ),
              12.verticalSpace,
              TextField(
                controller: locationCtrl,
                decoration: InputDecoration(
                  labelText: 'lbl_interview_location'.tr,
                  hintText: 'hint_interview_location'.tr,
                  prefixIcon: const Icon(Icons.location_on),
                ),
              ),
              12.verticalSpace,
              TextField(
                controller: notesCtrl,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'lbl_interview_notes'.tr,
                  hintText: 'hint_interview_notes'.tr,
                  prefixIcon: const Icon(Icons.note),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('btn_cancel'.tr),
          ),
          ElevatedButton(
            onPressed: () {
              if (dateCtrl.text.trim().isEmpty) {
                Get.snackbar('err_title'.tr, 'err_interview_date_required'.tr);
                return;
              }
              Get.back();
              controller.performAction(
                'action_interview_request',
                candidate,
                interviewDetails: {
                  'interview_date': dateCtrl.text.trim(),
                  'interview_time': timeCtrl.text.trim(),
                  'interview_location': locationCtrl.text.trim(),
                  'interview_notes': notesCtrl.text.trim(),
                },
              );
            },
            child: Text('btn_schedule'.tr),
          ),
        ],
      ),
    );
  }

  void _showInterviewActionDialog(BuildContext context, String action) {
    final message = action == 'action_accept'
        ? 'msg_confirm_accept_interviewed'.trParams({'name': candidate.name})
        : 'msg_confirm_reject_interviewed'.trParams({'name': candidate.name});

    Get.dialog(
      AlertDialog(
        title: Text(action == 'action_accept' ? 'lbl_confirm_accept'.tr : 'lbl_confirm_reject'.tr),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('btn_cancel'.tr),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: action == 'action_accept' ? Colors.green : Colors.red,
            ),
            onPressed: () {
              Get.back();
              if (action == 'action_reject') {
                _showRejectReasonDialog(context);
                return;
              }
              controller.performAction(action, candidate);
            },
            child: Text(
              action == 'action_accept' ? 'btn_approve'.tr : 'btn_reject'.tr,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _showRejectReasonDialog(BuildContext context) {
    final reasonCtrl = TextEditingController();
    Get.dialog(
      AlertDialog(
        title: Text('btn_reject_reason'.tr),
        content: TextField(
          controller: reasonCtrl,
          minLines: 2,
          maxLines: 4,
          decoration: InputDecoration(
            hintText: 'hint_reject_reason'.tr,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('btn_cancel'.tr),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              final reason = reasonCtrl.text.trim();
              if (reason.isEmpty) {
                Get.snackbar('err_title'.tr, 'hint_reject_reason'.tr);
                return;
              }
              Get.back();
              controller.performAction(
                'action_reject',
                candidate,
                rejectionReason: reason,
              );
            },
            child: Text('btn_reject'.tr, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
