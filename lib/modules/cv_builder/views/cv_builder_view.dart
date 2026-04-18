import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/common/app_ui.dart';
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
              : IconButton(
                  onPressed: controller.optimizeWithAi,
                  icon: const Icon(Icons.auto_awesome),
                  tooltip: 'btn_optimize_ai'.tr,
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
                      if (controller.isRefactorMode || controller.isAnalyzing.value)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                          child: FadeInDown(
                            duration: const Duration(milliseconds: 400),
                            child: _CvFlowGuideCard(controller: controller),
                          ),
                        ),
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

class _CvFlowGuideCard extends StatelessWidget {
  const _CvFlowGuideCard({required this.controller});
  final CvBuilderController controller;

  static const Map<String, String> _sectionLabels = {
    'personal': 'Personal',
    'summary': 'Summary',
    'experience': 'Experience',
    'education': 'Education',
    'skills': 'Skills',
    'projects': 'Projects',
    'template': 'Template',
  };

  @override
  Widget build(BuildContext context) {
    return AppThemedCard(
      backgroundColor: controller.isRefactorMode ? context.theme.primaryColor.withValues(alpha: 0.05) : null,
      border: Border.all(color: context.theme.primaryColor.withValues(alpha: 0.2), width: 1),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: context.theme.primaryColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  controller.isRefactorMode ? Icons.auto_awesome_outlined : Icons.info_outline,
                  color: context.theme.primaryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(controller.flowModeTitle, style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                    Text(controller.flowModeSubtitle, style: context.textTheme.bodySmall?.copyWith(color: Colors.grey.shade600)),
                  ],
                ),
              ),
              if (controller.atsScore.value > 0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getScoreColor(controller.atsScore.value).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text('ATS: ${controller.atsScore.value}%',
                    style: TextStyle(color: _getScoreColor(controller.atsScore.value), fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
            ],
          ),
          if (controller.aiSuggestions.isNotEmpty) ...[
            const SizedBox(height: 12),
            Divider(color: context.theme.dividerColor.withValues(alpha: 0.5)),
            const SizedBox(height: 8),
            Text('lbl_ai_suggestions'.tr, style: context.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            ...controller.aiSuggestions.take(2).map((s) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.check_circle_outline, size: 14, color: Colors.green),
                  const SizedBox(width: 6),
                  Expanded(child: Text(s, style: context.textTheme.bodySmall?.copyWith(height: 1.4))),
                ],
              ),
            )),
          ],
          if (controller.highlightedSections.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: controller.orderedHighlightedSections.map((key) => FilterChip(
                label: Text(_sectionLabels[key] ?? key),
                selected: controller.currentStep.value == CvBuilderController.sectionStepMap[key],
                onSelected: (_) => controller.jumpToSection(key),
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                visualDensity: VisualDensity.compact,
              )).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Color _getScoreColor(int score) {
    if (score >= 80) return Colors.green;
    if (score >= 60) return Colors.orange;
    return Colors.red;
  }
}
