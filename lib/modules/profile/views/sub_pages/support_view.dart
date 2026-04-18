import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/common/app_ui.dart';
import '../../../../routes/app_routes.dart';

class SupportView extends StatelessWidget {
  const SupportView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('support_title'.tr)),
      body: SingleChildScrollView(
        child: AppPageContainer(
          maxWidth: 900,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppSectionHeader(
                title: 'support_title'.tr,
                subtitle: 'support_subtitle'.tr,
              ),
              24.verticalSpace,
              AppStateCard(
                icon: Icons.support_agent_outlined,
                title: 'support_card_title'.tr,
                message: 'support_card_desc'.tr,
                action: SizedBox(
                  width: 220.w,
                  child: ElevatedButton(
                    onPressed: () => Get.toNamed(Routes.PROFILE_CONTACT),
                    child: Text('contact_us_title'.tr),
                  ),
                ),
              ),
              20.verticalSpace,
              _item(context, 'support_item_1_title'.tr, 'support_item_1_desc'.tr),
              _item(context, 'support_item_2_title'.tr, 'support_item_2_desc'.tr),
              _item(context, 'support_item_3_title'.tr, 'support_item_3_desc'.tr),
            ],
          ),
        ),
      ),
    );
  }

  Widget _item(BuildContext context, String title, String desc) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: ListTile(
        tileColor: context.theme.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.r)),
        leading: Icon(Icons.check_circle_outline, color: context.theme.primaryColor),
        title: Text(title),
        subtitle: Text(desc),
      ),
    );
  }
}
