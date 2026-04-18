import 'dart:typed_data';
import 'dart:developer' as developer;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/analysis_result_model.dart';
import '../../../data/services/gemini_service.dart';
import '../../../routes/app_routes.dart';
import '../../jobs/controllers/jobs_controller.dart';

class AiAnalyzerController extends GetxController {
  final viewState = 0.obs; // 0=upload, 1=scanning, 2=results
  final scanningStatus = ''.obs;
  final fileName = ''.obs;

  late AnalysisResultModel result;
  Map<String, dynamic>? _latestAnalysis;

  Uint8List? _pickedBytes;
  String _pickedMimeType = 'application/octet-stream';

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  late final GeminiService _geminiService;

  @override
  void onInit() {
    super.onInit();
    _geminiService = Get.isRegistered<GeminiService>()
        ? Get.find<GeminiService>()
        : Get.put(GeminiService(), permanent: true);
    _geminiService.init();
  }

  @override
  void onReady() {
    super.onReady();
    _guardPageAccess();
  }

  Future<void> pickFile() async {
    final role = await _getCurrentUserRole();
    if (role != 'jobSeeker') {
      _handleNonJobSeekerAccess(role);
      return;
    }

    final picked = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
      withData: true,
    );

    if (picked == null) {
      return;
    }

    final file = picked.files.single;
    if (file.bytes == null) {
      Get.snackbar('err_title'.tr, 'err_file_not_readable'.tr);
      return;
    }

    _pickedBytes = file.bytes;
    fileName.value = file.name;
    _pickedMimeType = _mimeTypeFor(file.extension);
    developer.log('Picked CV file: ${file.name}', name: 'AiAnalyzerController');
  }

  Future<void> startAnalysis() async {
    if (_pickedBytes == null || fileName.value.isEmpty) {
      Get.snackbar(
        'err_title'.tr,
        'err_upload_file_first'.tr,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    final user = _auth.currentUser;
    if (user == null) {
      Get.snackbar('err_title'.tr, 'auth_err_no_user_logged_in'.tr);
      return;
    }

    final role = await _getCurrentUserRole();
    if (role != 'jobSeeker') {
      _handleNonJobSeekerAccess(role);
      return;
    }

    viewState.value = 1;
    try {
      developer.log('Starting CV analysis for uid=${user.uid}', name: 'AiAnalyzerController');
      for (final step in [
        'scanning_1'.tr,
        'scanning_2'.tr,
        'scanning_3'.tr,
        'scanning_4'.tr,
        'scanning_5'.tr,
      ]) {
        scanningStatus.value = step;
        await Future.delayed(const Duration(milliseconds: 220));
      }

      final safeName = fileName.value.replaceAll(' ', '_');
      final storagePath =
          'cv_uploads/${user.uid}/${DateTime.now().millisecondsSinceEpoch}_$safeName';
      final cvRef = _storage.ref().child(storagePath);
      await cvRef.putData(
        _pickedBytes!,
        SettableMetadata(contentType: _pickedMimeType),
      );
      final cvUrl = await cvRef.getDownloadURL();

      final analysis = await _geminiService.analyzeCvDocument(
        fileBytes: _pickedBytes!,
        mimeType: _pickedMimeType,
        fileName: fileName.value,
      );
      _latestAnalysis = analysis;
      developer.log('Gemini analysis response: $analysis', name: 'AiAnalyzerController');

      if (analysis == null) {
        throw Exception('err_cv_analysis_empty'.tr);
      }

      final jobTitle = (analysis['job_title'] as String?) ?? '';
      final extractedSkills = ((analysis['skills'] as List?) ?? const [])
          .map((e) => e.toString())
          .where((e) => e.trim().isNotEmpty)
          .toList();
      final atsScore =
          (analysis['ats_score'] is num) ? (analysis['ats_score'] as num).toInt() : 0;
      final cvLanguage = (analysis['cv_language'] as String?) ?? Get.locale?.languageCode ?? 'en';
      final suggestions =
          ((analysis['suggestions_for_improvement'] as List?) ?? const [])
              .map((e) => e.toString())
              .toList();

      await _firestore.collection('users').doc(user.uid).set({
        'cv_uploaded': true,
        'cv_file_name': fileName.value,
        'cv_file_url': cvUrl,
        'cv_uploaded_at': FieldValue.serverTimestamp(),
        'ai_job_title': jobTitle,
        'ai_extracted_skills': extractedSkills,
        'ai_ats_score': atsScore,
        'ai_cv_language': cvLanguage,
        'ai_suggestions': suggestions,
        'ai_cv_analysis': analysis,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      result = AnalysisResultModel(
        score: atsScore.clamp(0, 100).toInt(),
        matchedSkills: extractedSkills,
        missingSkills: const [],
        tips: suggestions
            .map(
              (s) => AnalysisTip(
                title: 'tip_ai_suggestion_title'.tr,
                description: s,
              ),
            )
            .toList(),
      );

      if (Get.isRegistered<JobsController>()) {
        await Get.find<JobsController>().loadMatchedJobs();
      }

      Get.snackbar(
        'success_title'.tr,
        'msg_cv_analysis_saved'.tr,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      viewState.value = 2;
    } catch (e, stackTrace) {
      developer.log(
        'CV analysis failed: $e',
        name: 'AiAnalyzerController',
        error: e,
        stackTrace: stackTrace,
      );
      viewState.value = 0;
      Get.snackbar(
        'err_title'.tr,
        'err_cv_analysis_failed'.trParams({'error': e.toString()}),
      );
    }
  }

  void reset() {
    _pickedBytes = null;
    fileName.value = '';
    viewState.value = 0;
  }

  void openCvFixFlow() {
    final analysis = _latestAnalysis ?? const <String, dynamic>{};
    Get.toNamed(
      Routes.CV_BUILDER,
      arguments: {
        'mode': 'fix',
        'fixPayload': {
          'jobTitle': (analysis['job_title'] as String?) ?? '',
          'skills': ((analysis['skills'] as List?) ?? result.matchedSkills).map((e) => e.toString()).toList(),
          'suggestions': ((analysis['suggestions_for_improvement'] as List?) ?? result.tips.map((tip) => tip.description).toList())
              .map((e) => e.toString())
              .toList(),
          'language': (analysis['cv_language'] as String?) ?? Get.locale?.languageCode ?? 'en',
        },
      },
    );
  }

  Future<void> _guardPageAccess() async {
    final role = await _getCurrentUserRole();
    if (role == null || role == 'jobSeeker') {
      return;
    }

    developer.log(
      'Blocking AI analyzer access for role=$role',
      name: 'AiAnalyzerController',
    );
    _handleNonJobSeekerAccess(role);
  }

  Future<String?> _getCurrentUserRole() async {
    final user = _auth.currentUser;
    if (user == null) {
      developer.log(
        'AI analyzer access check failed: no authenticated user.',
        name: 'AiAnalyzerController',
      );
      return null;
    }

    final userDoc = await _firestore.collection('users').doc(user.uid).get();
    final role = userDoc.data()?['role'] as String?;
    developer.log(
      'AI analyzer role check uid=${user.uid} role=$role',
      name: 'AiAnalyzerController',
    );
    return role;
  }

  void _handleNonJobSeekerAccess(String? role) {
    final routeRole = role == 'admin' || role == 'company' ? role : 'jobSeeker';
    Get.snackbar(
      'err_title'.tr,
      'err_cv_only_job_seekers'.tr,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
    Get.offAllNamed(
      Routes.ROOT,
      arguments: {
        'role': routeRole,
        'index': 0,
      },
    );
  }

  String _mimeTypeFor(String? extension) {
    switch ((extension ?? '').toLowerCase()) {
      case 'pdf':
        return 'application/pdf';
      case 'doc':
        return 'application/msword';
      case 'docx':
        return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
      default:
        return 'application/octet-stream';
    }
  }
}
