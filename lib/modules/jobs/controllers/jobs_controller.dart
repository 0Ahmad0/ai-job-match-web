import 'dart:developer' as developer;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/utils/matcher_util.dart';
import '../../../data/models/job_model.dart';

class JobsController extends GetxController {
  final allJobs = <JobModel>[].obs;
  final displayedJobs = <JobModel>[].obs;
  final userSkills = <String>[].obs;
  final appliedJobIds = <String>{}.obs;

  final isLoading = false.obs;
  final isCvUploaded = false.obs;
  final errorMessage = ''.obs;

  final searchCtrl = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String _userTargetTitle = '';
  List<String> _userProfileKeywords = const <String>[];

  @override
  void onInit() {
    super.onInit();
    loadMatchedJobs();
  }

  bool hasApplied(String jobId) => appliedJobIds.contains(jobId);

  void markJobAsApplied(String jobId) {
    if (jobId.trim().isEmpty) {
      return;
    }
    appliedJobIds.add(jobId);
  }

  Future<void> loadMatchedJobs() async {
    final user = _auth.currentUser;
    if (user == null) {
      _clearState();
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';
    try {
      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      final userData = userDoc.data() ?? const <String, dynamic>{};
      final role = (userData['role'] as String?) ?? 'jobSeeker';
      developer.log('Loading matched jobs for uid=${user.uid} role=$role', name: 'JobsController');

      if (role != 'jobSeeker') {
        _clearState();
        return;
      }

      final appsSnap = await _firestore
          .collection('applications')
          .where('job_seeker_id', isEqualTo: user.uid)
          .get();
      appliedJobIds.value = appsSnap.docs
          .map((doc) => (doc.data()['job_id'] as String?) ?? '')
          .where((id) => id.isNotEmpty)
          .toSet();

      final extractedSkills = _collectUserSkills(userData);
      _userTargetTitle = _resolveUserTargetTitle(userData);
      _userProfileKeywords = _collectUserKeywords(userData);

      userSkills.assignAll(extractedSkills);

      final hasUploaded = (userData['cv_uploaded'] == true) && userSkills.isNotEmpty;
      isCvUploaded.value = hasUploaded;

      if (!hasUploaded) {
        allJobs.clear();
        displayedJobs.clear();
        return;
      }

      final jobsSnap = await _firestore.collection('jobs').where('status', isEqualTo: 'approved').get();

      final mapped = jobsSnap.docs.map((doc) {
        final data = doc.data();
        final requiredSkills = ((data['required_skills'] as List?) ?? const [])
            .map((e) => e.toString())
            .where((e) => e.trim().isNotEmpty)
            .toList();
        final requirements = ((data['requirements'] as List?) ?? const [])
            .map((e) => e.toString())
            .where((e) => e.trim().isNotEmpty)
            .toList();

        final score = MatcherUtil.calculateEnhancedMatchPercentage(
          requiredSkills: requiredSkills,
          userSkills: userSkills,
          jobRequirements: requirements,
          userProfileKeywords: _userProfileKeywords,
          jobTitle: (data['title'] as String?) ?? '',
          userTargetTitle: _userTargetTitle,
        );

        final salaryMin = data['salary_min'] ?? 0;
        final salaryMax = data['salary_max'] ?? 0;

        return JobModel(
          id: doc.id,
          title: (data['title'] as String?) ?? '',
          company: (data['company_name'] as String?) ?? 'unknown_company'.tr,
          companyId: (data['company_id'] as String?) ?? '',
          location: (data['location'] as String?) ?? '',
          type: (data['job_type'] as String?) ?? 'lbl_full_time'.tr,
          salary: '$salaryMin - $salaryMax',
          matchScore: score,
          postedTime: '',
          description: (data['description'] as String?) ?? '',
          requiredSkills: requiredSkills,
          requirements: requirements.isNotEmpty ? requirements : requiredSkills,
        );
      }).toList();

      mapped.sort((a, b) => b.matchScore.compareTo(a.matchScore));
      allJobs.assignAll(mapped);
      displayedJobs.assignAll(mapped);
    } catch (e, stackTrace) {
      developer.log(
        'Failed to fetch matched jobs: $e',
        name: 'JobsController',
        error: e,
        stackTrace: stackTrace,
      );
      errorMessage.value = 'err_fetch_matched_jobs'.trParams({'error': e.toString()});
      allJobs.clear();
      displayedJobs.clear();
    } finally {
      isLoading.value = false;
    }
  }

  void search(String query) {
    if (query.isEmpty) {
      displayedJobs.assignAll(allJobs);
      return;
    }

    final q = query.toLowerCase();
    displayedJobs.assignAll(
      allJobs.where((job) => job.title.toLowerCase().contains(q) || job.company.toLowerCase().contains(q)).toList(),
    );
  }

  void _clearState() {
    allJobs.clear();
    displayedJobs.clear();
    userSkills.clear();
    appliedJobIds.clear();
    isCvUploaded.value = false;
    errorMessage.value = '';
    _userTargetTitle = '';
    _userProfileKeywords = const <String>[];
  }

  List<String> _collectUserSkills(Map<String, dynamic> userData) {
    final aiSkills = ((userData['ai_extracted_skills'] as List?) ?? const [])
        .map((e) => e.toString())
        .where((e) => e.trim().isNotEmpty);
    final manualCv = (userData['manual_cv'] as Map<String, dynamic>?) ?? const <String, dynamic>{};
    final manualSkills = ((manualCv['skills'] as List?) ?? const [])
        .map((e) => e is Map ? (e['name']?.toString() ?? '') : e.toString())
        .where((e) => e.trim().isNotEmpty);

    return <String>{...aiSkills, ...manualSkills}.toList();
  }

  String _resolveUserTargetTitle(Map<String, dynamic> userData) {
    final manualCv = (userData['manual_cv'] as Map<String, dynamic>?) ?? const <String, dynamic>{};
    final candidates = <String>[
      (manualCv['jobTitle'] as String?) ?? '',
      (userData['ai_job_title'] as String?) ?? '',
      (userData['headline'] as String?) ?? '',
      (userData['jobTitle'] as String?) ?? '',
    ];
    for (final value in candidates) {
      if (value.trim().isNotEmpty) {
        return value.trim();
      }
    }
    return '';
  }

  List<String> _collectUserKeywords(Map<String, dynamic> userData) {
    final manualCv = (userData['manual_cv'] as Map<String, dynamic>?) ?? const <String, dynamic>{};
    final summary = (manualCv['summary'] as String?) ?? (userData['bio'] as String?) ?? '';
    final experiences = ((manualCv['experience'] as List?) ?? const [])
        .map((e) => e is Map ? (e['description']?.toString() ?? '') : '')
        .where((e) => e.trim().isNotEmpty)
        .toList();
    return <String>[
      summary,
      _userTargetTitle,
      ...experiences,
    ].where((e) => e.trim().isNotEmpty).toList();
  }

  @override
  void onClose() {
    searchCtrl.dispose();
    super.onClose();
  }
}
