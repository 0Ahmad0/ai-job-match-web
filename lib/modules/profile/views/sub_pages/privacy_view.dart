import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class PrivacyView extends StatelessWidget {
  const PrivacyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('privacy_title'.tr), centerTitle: true),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'privacy_text'.tr, // النص الطويل الوهمي
              style: context.textTheme.bodyMedium?.copyWith(height: 1.8),
            ),

            // محتوى إضافي لملء الصفحة كشكل جمالي
            20.verticalSpace,
            _buildSection(context, 'privacy_data_collection_title'.tr),
            Text('privacy_data_collection_desc'.tr, style: TextStyle(color: Colors.grey, fontSize: 12.sp)),

            20.verticalSpace,
            _buildSection(context, 'privacy_security_title'.tr),
            Text('privacy_security_desc'.tr, style: TextStyle(color: Colors.grey, fontSize: 12.sp)),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title) {
    return Text(
      title,
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp, color: context.theme.primaryColor),
    );
  }
}
