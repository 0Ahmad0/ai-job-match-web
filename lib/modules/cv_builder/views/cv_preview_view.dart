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
        actions: [
          IconButton(
            tooltip: 'cv_share_cta'.tr,
            onPressed: controller.shareGeneratedPdf,
            icon: const Icon(Icons.ios_share_outlined),
          ),
        ],
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
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isCompact = constraints.maxWidth < 420;

              final openButton = OutlinedButton.icon(
                onPressed: controller.openGeneratedPdf,
                icon: const Icon(Icons.open_in_new),
                label: Text('cv_open_cta'.tr, overflow: TextOverflow.ellipsis),
              );
              final downloadButton = ElevatedButton.icon(
                onPressed: controller.downloadGeneratedPdf,
                icon: const Icon(Icons.download),
                label: Text('btn_download_pdf'.tr, overflow: TextOverflow.ellipsis),
              );

              if (isCompact) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(width: double.infinity, child: openButton),
                    const SizedBox(height: 10),
                    SizedBox(width: double.infinity, child: downloadButton),
                  ],
                );
              }

              return Row(
                children: [
                  Expanded(child: openButton),
                  const SizedBox(width: 12),
                  Expanded(child: downloadButton),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
