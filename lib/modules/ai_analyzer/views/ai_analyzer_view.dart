import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/ai_analyzer_controller.dart';
import 'widgets/upload_box_widget.dart';
import 'widgets/scanning_animation_widget.dart';
import 'widgets/results_dashboard_widget.dart';

class AiAnalyzerView extends GetView<AiAnalyzerController> {
  const AiAnalyzerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ai_title'.tr),
        centerTitle: true,
        actions: [
          // زر وهمي لإظهار الهيبة
          IconButton(onPressed: (){}, icon: const Icon(Icons.history))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Obx(() {
          switch (controller.viewState.value) {
            case 0: // Upload Mode
              return const UploadBoxWidget();
            case 1: // Scanning Mode
              return const ScanningAnimationWidget();
            case 2: // Result Mode
              return const ResultsDashboardWidget();
            default:
              return const UploadBoxWidget();
          }
        }),
      ),
    );
  }
}