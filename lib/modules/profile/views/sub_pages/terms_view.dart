import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/common/app_ui.dart';

class TermsView extends StatelessWidget {
  const TermsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('terms_title'.tr)),
      body: SingleChildScrollView(
        child: AppPageContainer(
          maxWidth: 960,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppSectionHeader(
                title: 'terms_title'.tr,
                subtitle: 'terms_subtitle'.tr,
              ),
              24.verticalSpace,
              _section(context, 'terms_use_title'.tr, 'terms_use_desc'.tr),
              _section(context, 'terms_content_title'.tr, 'terms_content_desc'.tr),
              _section(context, 'terms_ai_title'.tr, 'terms_ai_desc'.tr),
              _section(context, 'terms_liability_title'.tr, 'terms_liability_desc'.tr),
            ],
          ),
        ),
      ),
    );
  }

  Widget _section(BuildContext context, String title, String body) {
    return Padding(
      padding: EdgeInsets.only(bottom: 22.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: context.textTheme.titleLarge),
          10.verticalSpace,
          Text(body, style: context.textTheme.bodyMedium),
        ],
      ),
    );
  }
}
