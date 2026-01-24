import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';

import '../controllers/candidates_controller.dart';
import 'widgets/candidate_card_widget.dart';

class CandidatesView extends GetView<CandidatesController> {
  const CandidatesView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(CandidatesController());

    return Scaffold(
      appBar: AppBar(
        title: Text('lbl_candidates_title'.tr),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.filter_list)),
        ],
      ),
      body: Column(
        children: [
          // Header Info
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            child: Row(
              children: [
                Text(
                  "Job: Flutter Developer", // يمكن جعله ديناميكياً لاحقاً
                  style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Obx(() => Text(
                  "${controller.candidates.length} Applicants",
                  style: TextStyle(color: Colors.grey, fontSize: 12.sp),
                )),
              ],
            ),
          ),

          // List
          Expanded(
            child: Obx(() => ListView.builder(
              padding: EdgeInsets.all(20.r),
              itemCount: controller.candidates.length,
              itemBuilder: (context, index) {
                // انميشن تتابعي جميل
                return FadeInUp(
                  delay: Duration(milliseconds: index * 100),
                  child: CandidateCardWidget(
                    candidate: controller.candidates[index],
                  ),
                );
              },
            )),
          ),
        ],
      ),
    );
  }
}