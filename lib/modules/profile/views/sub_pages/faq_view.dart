import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class FaqView extends StatelessWidget {
  const FaqView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('faq_title'.tr), centerTitle: true),
      body: ListView(
        padding: EdgeInsets.all(20.r),
        children: [
          _buildFaqTile(context, 'faq_q1'.tr, 'faq_a1'.tr),
          _buildFaqTile(context, 'faq_q2'.tr, 'faq_a2'.tr),
          _buildFaqTile(context, 'faq_q3'.tr, 'faq_a3'.tr),
          // يمكنك إضافة المزيد هنا
        ],
      ),
    );
  }

  Widget _buildFaqTile(BuildContext context, String question, String answer) {
    return Card(
      margin: EdgeInsets.only(bottom: 15.h),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: ExpansionTile(
        title: Text(
          question,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp, color: context.textTheme.bodyLarge?.color),
        ),
        childrenPadding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 20.h),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            answer,
            style: TextStyle(fontSize: 13.sp, color: Colors.grey, height: 1.5),
          ),
        ],
      ),
    );
  }
}