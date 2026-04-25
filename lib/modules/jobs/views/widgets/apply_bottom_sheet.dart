import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/common/custom_button.dart';
import '../../../../data/models/job_model.dart';
import '../../../../data/services/notification_service.dart';
import '../../controllers/jobs_controller.dart';

class ApplyBottomSheet extends StatelessWidget {
  ApplyBottomSheet({super.key, required this.job});

  final JobModel job;
  final Rxn<PlatformFile> selectedFile = Rxn<PlatformFile>();
  final RxBool isUploading = false.obs;
  final RxBool isLoadingProfile = true.obs;
  final RxString existingCvName = ''.obs;
  final RxString existingCvUrl = ''.obs;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> _loadExistingCv() async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      isLoadingProfile.value = false;
      return;
    }

    final userDoc = await _firestore.collection('users').doc(currentUser.uid).get();
    final data = userDoc.data() ?? const <String, dynamic>{};

    // Support legacy single-file fields and new 'cv_files' list
    // 'cv_files' expected as List<Map<String,dynamic>> with keys 'name' and 'url'
    final cvFiles = (data['cv_files'] as List?) ?? const [];
    if (cvFiles.isNotEmpty) {
      final first = cvFiles.first as Map<String, dynamic>;
      existingCvName.value = (first['name'] as String?) ?? '';
      existingCvUrl.value = (first['url'] as String?) ?? '';
    } else {
      existingCvName.value = (data['cv_file_name'] as String?) ?? '';
      existingCvUrl.value = (data['cv_file_url'] as String?) ?? '';
    }

    isLoadingProfile.value = false;
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
      withData: true,
    );

    if (result != null && result.files.single.bytes != null) {
      selectedFile.value = result.files.single;
    } else if (result != null) {
      Get.snackbar('err_title'.tr, 'err_file_not_readable'.tr);
    }
  }

  Future<void> _submitApplication() async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      Get.snackbar('err_title'.tr, 'auth_err_no_user_logged_in'.tr);
      return;
    }

    String cvName = existingCvName.value;
    String cvUrl = existingCvUrl.value;
    final file = selectedFile.value;

    if ((file == null || file.bytes == null) && cvUrl.isEmpty) {
      Get.snackbar('err_title'.tr, 'lbl_select_cv'.tr, backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }

    isUploading.value = true;
    try {
      final existing = await _firestore
          .collection('applications')
          .where('job_id', isEqualTo: job.id)
          .where('job_seeker_id', isEqualTo: currentUser.uid)
          .limit(1)
          .get();

      if (existing.docs.isNotEmpty) {
        if (Get.isRegistered<JobsController>()) {
          Get.find<JobsController>().markJobAsApplied(job.id);
        }
        Get.back(result: true);
        Get.snackbar('err_title'.tr, 'err_application_exists'.tr);
        return;
      }

      if (file != null && file.bytes != null) {
        final safeName = file.name.replaceAll(' ', '_');
        final storagePath = 'application_files/${currentUser.uid}/${job.id}/${DateTime.now().millisecondsSinceEpoch}_$safeName';
        final fileRef = _storage.ref().child(storagePath);
        await fileRef.putData(
          file.bytes!,
          SettableMetadata(contentType: _mimeTypeFor(file.extension)),
        );
        cvUrl = await fileRef.getDownloadURL();
        cvName = file.name;
      }

      final userDoc = await _firestore.collection('users').doc(currentUser.uid).get();
      final userData = userDoc.data() ?? const <String, dynamic>{};
      final skills = ((userData['ai_extracted_skills'] as List?) ?? const []).map((e) => e.toString()).toList();
      final applicantName = (userData['fullName'] as String?) ?? currentUser.email?.split('@').first ?? '';

      await _firestore.collection('applications').add({
        'job_id': job.id,
        'job_title': job.title,
        'company_id': job.companyId,
        'company_name': job.company,
        'job_seeker_id': currentUser.uid,
        'job_seeker_name': applicantName,
        'status': 'applied',
        'decision': 'applied',
        'rejectionReason': '',
        'rejection_reason': '',
        'skills': skills,
        'match_score': job.matchScore,
        'cv_file_name': cvName,
        'cv_file_url': cvUrl,
        'created_at': FieldValue.serverTimestamp(),
        'updated_at': FieldValue.serverTimestamp(),
      }).then((docRef) async {
        // Trigger notification to company
        final notificationService = Get.find<NotificationService>();
        await notificationService.onApplicationSubmitted(
          companyId: job.companyId,
          companyName: job.company,
          jobId: job.id,
          jobTitle: job.title,
          applicationId: docRef.id,
        );
      });

      if (Get.isRegistered<JobsController>()) {
        Get.find<JobsController>().markJobAsApplied(job.id);
      }
      Get.back(result: true);
      Get.snackbar(
        'success_title'.tr,
        'msg_app_sent'.tr,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(20),
        icon: const Icon(Icons.check_circle, color: Colors.white),
      );
    } catch (e) {
      Get.snackbar('err_title'.tr, 'err_application_submit_failed'.trParams({'error': e.toString()}));
    } finally {
      isUploading.value = false;
    }
  }

  String _mimeTypeFor(String? ext) {
    switch ((ext ?? '').toLowerCase()) {
      case 'pdf':
        return 'application/pdf';
      case 'doc':
        return 'application/msword';
      case 'docx':
        return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
      default:
        return 'application/octet-stream';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoadingProfile.value &&
        existingCvName.value.isEmpty &&
        existingCvUrl.value.isEmpty) {
      _loadExistingCv();
    }

    return Container(
      padding: EdgeInsets.all(24.r),
      decoration: BoxDecoration(
        color: context.theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.r)),
      ),
      child: Obx(
        () => Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 50.w,
                height: 5.h,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            20.verticalSpace,
            Text('lbl_apply_title'.trParams({'job': job.title}), style: context.textTheme.headlineSmall?.copyWith(fontSize: 18.sp)),
            10.verticalSpace,
            Text('lbl_upload_cv_msg'.tr, style: context.textTheme.bodyMedium),
            24.verticalSpace,
            if (isLoadingProfile.value)
              Container(
                height: 96.h,
                decoration: BoxDecoration(
                  color: context.theme.cardColor,
                  borderRadius: BorderRadius.circular(18.r),
                ),
              )
            else ...[
              if (existingCvUrl.value.isNotEmpty)
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16.r),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(18.r),
                    border: Border.all(color: Colors.green.withValues(alpha: 0.16)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.description_outlined, color: Colors.green),
                      12.horizontalSpace,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('application_use_existing_cv'.tr, style: const TextStyle(fontWeight: FontWeight.bold)),
                            4.verticalSpace,
                            Text(existingCvName.value, maxLines: 1, overflow: TextOverflow.ellipsis),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              14.verticalSpace,
              GestureDetector(
                onTap: _pickFile,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(18.r),
                  decoration: BoxDecoration(
                    color: context.theme.cardColor,
                    borderRadius: BorderRadius.circular(18.r),
                    border: Border.all(color: context.theme.primaryColor.withValues(alpha: 0.4)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10.r),
                        decoration: BoxDecoration(
                          color: context.theme.primaryColor.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Icon(Icons.upload_file, color: context.theme.primaryColor),
                      ),
                      14.horizontalSpace,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(selectedFile.value?.name ?? 'application_replace_cv'.tr, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold)),
                            4.verticalSpace,
                            Text('upload_desc'.tr, style: TextStyle(fontSize: 11.sp, color: Colors.grey)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            24.verticalSpace,
            isUploading.value
                ? Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    decoration: BoxDecoration(
                      color: context.theme.primaryColor.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Center(
                      child: Text('application_submitting'.tr, style: TextStyle(color: context.theme.primaryColor, fontWeight: FontWeight.bold)),
                    ),
                  )
                : CustomButton(
                    text: 'lbl_submit_app'.tr,
                    onPressed: _submitApplication,
                  ),
            16.verticalSpace,
          ],
        ),
      ),
    );
  }
}
