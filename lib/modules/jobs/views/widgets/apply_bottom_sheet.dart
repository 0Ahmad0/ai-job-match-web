import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/common/custom_button.dart';
import '../../../../data/models/job_model.dart';

class ApplyBottomSheet extends StatefulWidget {
  final JobModel job;

  const ApplyBottomSheet({super.key, required this.job});

  @override
  State<ApplyBottomSheet> createState() => _ApplyBottomSheetState();
}

class _ApplyBottomSheetState extends State<ApplyBottomSheet> {
  String? selectedFileName;
  bool isUploading = false;

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );

    if (result != null) {
      setState(() {
        selectedFileName = result.files.single.name;
      });
    }
  }

  void _submitApplication() async {
    if (selectedFileName == null) {
      Get.snackbar('Error', 'Please select a CV first', backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }

    setState(() => isUploading = true);

    // محاكاة الإرسال
    await Future.delayed(const Duration(seconds: 2));

    Get.back(); // إغلاق الـ Sheet

    // إظهار رسالة نجاح جميلة
    Get.snackbar(
      'Success',
      'msg_app_sent'.tr,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(20),
      icon: const Icon(Icons.check_circle, color: Colors.white),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.r),
      decoration: BoxDecoration(
        color: context.theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 50.w,
              height: 5.h,
              decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10)),
            ),
          ),
          20.verticalSpace,

          Text(
            'lbl_apply_title'.trParams({'job': widget.job.title}),
            style: context.textTheme.headlineSmall?.copyWith(fontSize: 18.sp),
          ),
          10.verticalSpace,
          Text(
            'lbl_upload_cv_msg'.tr,
            style: context.textTheme.bodyMedium?.copyWith(color: Colors.grey),
          ),

          30.verticalSpace,

          // Upload Box
          GestureDetector(
            onTap: _pickFile,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(20.r),
              decoration: BoxDecoration(
                color: context.theme.cardColor,
                borderRadius: BorderRadius.circular(15.r),
                border: Border.all(color: context.theme.primaryColor.withValues(alpha: 0.5), style: BorderStyle.solid),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(10.r),
                    decoration: BoxDecoration(color: context.theme.primaryColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
                    child: Icon(Icons.upload_file, color: context.theme.primaryColor),
                  ),
                  15.horizontalSpace,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          selectedFileName ?? 'lbl_select_cv'.tr,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (selectedFileName == null)
                          Text("PDF, DOCX (Max 5MB)", style: TextStyle(fontSize: 10.sp, color: Colors.grey)),
                      ],
                    ),
                  ),
                  if (selectedFileName != null)
                    Icon(Icons.check_circle, color: Colors.green, size: 20.sp),
                ],
              ),
            ),
          ),

          30.verticalSpace,

          // Submit Button
          SizedBox(
            width: double.infinity,
            child: isUploading
                ? const Center(child: CircularProgressIndicator())
                : CustomButton(
              text: 'lbl_submit_app'.tr,
              onPressed: _submitApplication,
            ),
          ),

          20.verticalSpace,
        ],
      ),
    );
  }
}