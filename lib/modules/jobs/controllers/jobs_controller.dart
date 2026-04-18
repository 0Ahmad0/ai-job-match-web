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

      final extractedSkills = ((userData['ai_extracted_skills'] as List?) ?? const [])
          .map((e) => e.toString())
          .where((e) => e.trim().isNotEmpty)
          .toList();

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

        final score = MatcherUtil.calculateMatchPercentage(
          requiredSkills: requiredSkills,
          userSkills: userSkills,
        ).round();

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
          requirements: requiredSkills,
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
  }

  @override
  void onClose() {
    searchCtrl.dispose();
    super.onClose();
  }
}
