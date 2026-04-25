import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:printing/printing.dart';

import '../controllers/cv_builder_controller.dart';

class CvPreviewView extends GetView<CvBuilderController> {
  const CvPreviewView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('cv_preview_title'.tr),
      ),
      body: Obx(() {
        final bytes = controller.generatedPdfBytes.value;
        if (bytes == null) {
          return Center(child: Text('cv_no_pdf_generated'.tr));
        }
        return PdfPreview(
          canChangePageFormat: false,
          canChangeOrientation: false,
          canDebug: false,
          allowSharing: true,
          allowPrinting: true,
          build: (_) async => bytes,
        );
      }),
    );
  }
}
