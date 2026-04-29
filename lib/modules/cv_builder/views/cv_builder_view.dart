import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/common/shimmer_skeletons.dart';
import '../controllers/cv_builder_controller.dart';
import 'widgets/cv_bottom_controls_widget.dart';
import 'widgets/cv_progress_bar_widget.dart';
import 'widgets/step_education_widget.dart';
import 'widgets/step_experience_widget.dart';
import 'widgets/step_personal_info_widget.dart';
import 'widgets/step_projects_widget.dart';
import 'widgets/step_skills_widget.dart';
import 'widgets/step_summary_widget.dart';
import 'widgets/step_template_selector_widget.dart';

class CvBuilderView extends GetView<CvBuilderController> {
  const CvBuilderView({super.key});

  Widget _buildStepContent() {
    switch (controller.currentStep.value) {
      case 0: return const StepPersonalInfoWidget();
      case 1: return const StepSummaryWidget();
      case 2: return const StepExperienceWidget();
      case 3: return const StepEducationWidget();
      case 4: return const StepSkillsWidget();
      case 5: return const StepProjectsWidget();
      case 6: return const StepTemplateSelectorWidget();
      default: return const StepPersonalInfoWidget();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('cv_builder_title'.tr),
        actions: [
          Obx(() => controller.isAnalyzing.value
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
                  ),
                )
              : TextButton.icon(
                  onPressed: controller.optimizeWithAi,
                  icon: const Icon(Icons.auto_awesome),
                  label: Text('btn_optimize_ai_short'.tr),
                )),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          const CvProgressBarWidget(),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CardListShimmer(itemCount: 4));
              }
              
              return Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: Column(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          child: FadeInUp(
                            key: ValueKey(controller.currentStep.value),
                            duration: const Duration(milliseconds: 300),
                            child: _buildStepContent(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
          const CvBottomControlsWidget(),
        ],
      ),
    );
  }
}
