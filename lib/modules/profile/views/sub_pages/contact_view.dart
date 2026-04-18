import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/common/app_ui.dart';

class ContactView extends StatelessWidget {
  const ContactView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('contact_us_title'.tr)),
      body: SingleChildScrollView(
        child: AppPageContainer(
          maxWidth: 900,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppSectionHeader(
                title: 'contact_us_title'.tr,
                subtitle: 'contact_us_subtitle'.tr,
              ),
              24.verticalSpace,
              _card(context, Icons.email_outlined, 'contact_email_title'.tr, 'contact_email_desc'.tr),
              16.verticalSpace,
              _card(context, Icons.public_outlined, 'contact_website_title'.tr, 'contact_website_desc'.tr),
              16.verticalSpace,
              _card(context, Icons.schedule_outlined, 'contact_hours_title'.tr, 'contact_hours_desc'.tr),
            ],
          ),
        ),
      ),
    );
  }

  Widget _card(BuildContext context, IconData icon, String title, String body) {
    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: context.theme.cardColor,
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(color: context.theme.dividerColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48.w,
            height: 48.w,
            decoration: BoxDecoration(
              color: context.theme.primaryColor.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: context.theme.primaryColor),
          ),
          16.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: context.textTheme.titleMedium),
                8.verticalSpace,
                Text(body, style: context.textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
