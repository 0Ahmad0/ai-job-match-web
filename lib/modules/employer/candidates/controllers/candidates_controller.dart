import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../data/models/candidate_model.dart';
import '../../../../data/services/notification_service.dart';

class CandidatesController extends GetxController {
  final candidates = <CandidateModel>[].obs;
  final isLoading = false.obs;
  final processingCandidateId = RxnString();
  final activeJobTitle = ''.obs;
  final selectedStatusFilter = 'all'.obs;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void onInit() {
    super.onInit();
    fetchApplicants();
  }

  Future<void> fetchApplicants() async {
    final company = _auth.currentUser;
    if (company == null) {
      candidates.clear();
      return;
    }

    isLoading.value = true;
    try {
      final approvedJobsSnap = await _firestore
          .collection('jobs')
          .where('company_id', isEqualTo: company.uid)
          .where('status', isEqualTo: 'approved')
          .get();

      final jobs = approvedJobsSnap.docs;
      if (jobs.isEmpty) {
        candidates.clear();
        activeJobTitle.value = '';
        return;
      }

      final jobMap = {for (final j in jobs) j.id: j.data()};
      activeJobTitle.value = (jobs.first.data()['title'] as String?) ?? '';

      // Fetch ALL applications (not just pending ones) for historical visibility
      final allApplications = <QueryDocumentSnapshot<Map<String, dynamic>>>[];
      final jobIds = jobs.map((j) => j.id).toList();
      for (var i = 0; i < jobIds.length; i += 10) {
        final end = (i + 10) > jobIds.length ? jobIds.length : (i + 10);
        final chunk = jobIds.sublist(i, end);
        final appSnap = await _firestore
            .collection('applications')
            .where('job_id', whereIn: chunk)
            .get();
        allApplications.addAll(appSnap.docs);
      }

      if (allApplications.isEmpty) {
        candidates.clear();
        return;
      }

      final seekerIds = allApplications
          .map((a) => a.data()['job_seeker_id'] as String?)
          .whereType<String>()
          .toSet()
          .toList();

      final seekers = <String, Map<String, dynamic>>{};
      for (var i = 0; i < seekerIds.length; i += 10) {
        final end = (i + 10) > seekerIds.length ? seekerIds.length : (i + 10);
        final chunk = seekerIds.sublist(i, end);
        final seekersSnap = await _firestore
            .collection('users')
            .where(FieldPath.documentId, whereIn: chunk)
            .get();
        for (final s in seekersSnap.docs) {
          seekers[s.id] = s.data();
        }
      }

      allApplications.sort((a, b) {
        final aDate = (a.data()['created_at'] as Timestamp?)?.toDate();
        final bDate = (b.data()['created_at'] as Timestamp?)?.toDate();
        if (aDate == null && bDate == null) return 0;
        if (aDate == null) return 1;
        if (bDate == null) return -1;
        return bDate.compareTo(aDate);
      });

      final mapped = allApplications.map((appDoc) {
        final app = appDoc.data();
        final seekerId = app['job_seeker_id'] as String? ?? '';
        final seeker = seekers[seekerId] ?? const <String, dynamic>{};
        final jobId = app['job_id'] as String? ?? '';
        final job = jobMap[jobId] ?? const <String, dynamic>{};
        final status = _normalizeStatus(app['status']);

        final seekerSkills = ((app['skills'] as List?) ?? const [])
            .map((e) => e.toString())
            .toList();
        final requiredSkills = ((job['required_skills'] as List?) ?? const [])
            .map((e) => e.toString())
            .toList();

        final matching = _computeMatchingSkills(seekerSkills, requiredSkills);
        final score = _computeScore(seekerSkills, requiredSkills, app['match_score']);

        return CandidateModel(
          id: appDoc.id, // application id
          name: (seeker['fullName'] as String?) ??
              (seeker['name'] as String?) ??
              (seeker['email'] as String?) ??
              'unknown_candidate'.tr,
          jobTitle: (job['title'] as String?) ?? 'unknown_job'.tr,
          matchScore: score,
          matchingSkills: matching,
          imageUrl: (seeker['profile_image_url'] as String?) ?? '',
          status: status,
        );
      }).toList();

      mapped.sort((a, b) => b.matchScore.compareTo(a.matchScore));
      candidates.assignAll(mapped);
    } catch (e) {
      Get.snackbar(
        'err_title'.tr,
        'err_fetch_applicants'.trParams({'error': e.toString()}),
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Performs a state-machine-compliant action on an application.
  /// Actions are mutually exclusive based on current status.
  /// Valid transitions:
  ///   applied/under_review -> rejected (terminal)
  ///   applied/under_review -> accepted (terminal)
  ///   applied/under_review -> interview_scheduled
  ///   interview_scheduled -> accepted (terminal)
  ///   interview_scheduled -> rejected (terminal)
  Future<void> performAction(String actionKey, CandidateModel candidate, {Map<String, dynamic>? interviewDetails}) async {
    final currentStatus = candidate.status.toLowerCase();

    // Validate action based on current status (state machine)
    if (!_isValidTransition(currentStatus, actionKey)) {
      Get.snackbar(
        'err_title'.tr,
        'err_invalid_action'.trParams({
          'action': _actionLabel(actionKey),
          'status': _statusLabel(currentStatus),
        }),
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    final updateData = <String, dynamic>{
      'updated_at': FieldValue.serverTimestamp(),
    };

    if (actionKey == 'action_reject') {
      updateData['status'] = 'rejected';
      updateData['decision'] = 'rejected';
    } else if (actionKey == 'action_accept') {
      updateData['status'] = 'accepted';
      updateData['decision'] = 'accepted';
    } else if (actionKey == 'action_interview_request') {
      updateData['status'] = 'interview_scheduled';
      updateData['decision'] = 'interview_scheduled';
      // Add interview details if provided
      if (interviewDetails != null) {
        if (interviewDetails['interview_date'] != null) {
          updateData['interview_date'] = interviewDetails['interview_date'];
        }
        if (interviewDetails['interview_time'] != null) {
          updateData['interview_time'] = interviewDetails['interview_time'];
        }
        if (interviewDetails['interview_notes'] != null) {
          updateData['interview_notes'] = interviewDetails['interview_notes'];
        }
        if (interviewDetails['interview_location'] != null) {
          updateData['interview_location'] = interviewDetails['interview_location'];
        }
      }
    } else {
      return;
    }

    try {
      processingCandidateId.value = candidate.id;
      
      // First, get the application details to find the job seeker ID
      final appDoc = await _firestore.collection('applications').doc(candidate.id).get();
      final appData = appDoc.data() ?? {};
      final jobSeekerId = appData['job_seeker_id'] as String? ?? '';
      final jobTitle = appData['job_title'] as String? ?? candidate.jobTitle;
      final companyName = appData['company_name'] as String? ?? '';

      await _firestore.collection('applications').doc(candidate.id).update(updateData);

      // CRITICAL: Do NOT remove candidates from the list.
      // Update their status in-place to maintain historical visibility.
      final index = candidates.indexWhere((c) => c.id == candidate.id);
      if (index != -1) {
        String newStatus;
        if (actionKey == 'action_reject') {
          newStatus = 'rejected';
        } else if (actionKey == 'action_accept') {
          newStatus = 'accepted';
        } else {
          newStatus = 'interview_scheduled';
        }
        candidates[index] = candidates[index].copyWith(status: newStatus);
        candidates.refresh();
      }

      // Trigger notification to job seeker
      if (jobSeekerId.isNotEmpty) {
        final notificationService = Get.find<NotificationService>();
        ApplicationStatus appStatus;
        String? interviewDateToSend;
        
        if (actionKey == 'action_reject') {
          appStatus = ApplicationStatus.rejected;
        } else if (actionKey == 'action_accept') {
          appStatus = ApplicationStatus.accepted;
        } else {
          appStatus = ApplicationStatus.interviewScheduled;
          interviewDateToSend = interviewDetails?['interview_date'] as String?;
        }

        await notificationService.onApplicationStatusChanged(
          jobSeekerId: jobSeekerId,
          jobTitle: jobTitle,
          companyName: companyName,
          status: appStatus,
          interviewDate: interviewDateToSend,
        );
      }

      // Show success message
      String message;
      Color bgColor;
      if (actionKey == 'action_reject') {
        message = 'msg_candidate_rejected'.trParams({'name': candidate.name});
        bgColor = Colors.red;
      } else if (actionKey == 'action_accept') {
        message = 'msg_candidate_accepted'.trParams({'name': candidate.name});
        bgColor = Colors.green;
      } else {
        message = 'msg_candidate_interview'.trParams({'name': candidate.name});
        bgColor = Colors.indigo;
      }

      Get.snackbar(
        'success_title'.tr,
        message,
        backgroundColor: bgColor,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'err_title'.tr,
        'err_update_application_state'.trParams({'error': e.toString()}),
      );
    } finally {
      processingCandidateId.value = null;
    }
  }

  /// Validates whether the given action is allowed from the candidate's current status.
  bool _isValidTransition(String currentStatus, String actionKey) {
    // Terminal states cannot transition to anything else
    if (currentStatus == 'accepted' || currentStatus == 'rejected') {
      return false;
    }

    // From applied, under_review, or interview_scheduled, any action is valid
    if (currentStatus == 'applied' ||
        currentStatus == 'pending' ||
        currentStatus == 'under_review' ||
        currentStatus == 'interview_scheduled' ||
        currentStatus == 'interview') {
      return true;
    }

    return false;
  }

  String _actionLabel(String actionKey) {
    switch (actionKey) {
      case 'action_reject':
        return 'action_reject'.tr;
      case 'action_accept':
        return 'action_accept'.tr;
      case 'action_interview_request':
        return 'action_interview_request'.tr;
      default:
        return actionKey;
    }
  }

  String _statusLabel(String status) {
    switch (status) {
      case 'applied':
      case 'pending':
        return 'status_applied'.tr;
      case 'under_review':
        return 'status_under_review'.tr;
      case 'interview_scheduled':
      case 'interview':
        return 'status_interview_scheduled'.tr;
      case 'accepted':
        return 'status_accepted'.tr;
      case 'rejected':
        return 'status_rejected'.tr;
      default:
        return status;
    }
  }

  List<String> _computeMatchingSkills(List<String> seeker, List<String> required) {
    if (required.isEmpty) {
      return seeker.take(5).toList();
    }
    final reqLower = required.map((e) => e.toLowerCase()).toSet();
    final matches = seeker.where((s) => reqLower.contains(s.toLowerCase())).toList();
    return matches.isEmpty ? required.take(3).toList() : matches.take(5).toList();
  }

  int _computeScore(List<String> seeker, List<String> required, dynamic explicitScore) {
    if (explicitScore is num) {
      return explicitScore.toInt().clamp(0, 100);
    }
    if (required.isEmpty) {
      return 50;
    }
    final reqLower = required.map((e) => e.toLowerCase()).toSet();
    final matchCount = seeker.where((s) => reqLower.contains(s.toLowerCase())).length;
    return ((matchCount / reqLower.length) * 100).round().clamp(0, 100);
  }

  List<CandidateModel> get filteredCandidates {
    final filter = selectedStatusFilter.value;
    if (filter == 'all') {
      return candidates;
    }
    return candidates.where((c) => c.status == filter).toList();
  }

  void setStatusFilter(String filter) {
    selectedStatusFilter.value = filter;
  }

  String _normalizeStatus(dynamic value) {
    final status = (value as String? ?? 'applied').toLowerCase().trim();
    switch (status) {
      case 'shortlisted':
        return 'accepted';
      case 'interview_requested':
      case 'interview':
        return 'interview_scheduled';
      case 'pending':
        return 'applied';
      default:
        return status;
    }
  }
}
