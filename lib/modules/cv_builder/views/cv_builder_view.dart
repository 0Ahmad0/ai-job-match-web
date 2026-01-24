import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/cv_builder_controller.dart';
import 'widgets/cv_progress_bar_widget.dart';
import 'widgets/cv_bottom_controls_widget.dart';

// استيراد الـ Widgets الخاصة بالخطوات
import 'widgets/step_personal_info_widget.dart';
import 'widgets/step_projects_widget.dart';
import 'widgets/step_summary_widget.dart'; // جديد
import 'widgets/step_experience_widget.dart';
import 'widgets/step_education_widget.dart'; // جديد
import 'widgets/step_skills_widget.dart'; // جديد
import 'widgets/step_template_selector_widget.dart';

class CvBuilderView extends GetView<CvBuilderController> {
  const CvBuilderView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('cv_builder_title'.tr),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          const CvProgressBarWidget(),

          Expanded(
            child: Obx(() {
              // الترتيب حسب الـ currentStep
              switch (controller.currentStep.value) {
                case 0:
                  return const StepPersonalInfoWidget();
                case 1:
                  return const StepSummaryWidget();
                case 2:
                  return const StepExperienceWidget();
                case 3:
                  return const StepEducationWidget();
                case 4:
                  return const StepSkillsWidget();
                case 5:
                  return const StepProjectsWidget();
                case 6:
                  return const StepTemplateSelectorWidget();
                default:
                  return const StepPersonalInfoWidget();
              }
            }),
          ),

          const CvBottomControlsWidget(),
        ],
      ),
    );
  }
}
