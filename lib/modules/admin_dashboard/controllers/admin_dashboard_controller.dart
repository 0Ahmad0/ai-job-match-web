import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminDashboardController extends GetxController {
  final usersList = <Map<String, dynamic>>[].obs;
  final jobRequests = <Map<String, dynamic>>[].obs;
  final totalUsersCount = 0.obs;
  final pendingCompaniesCount = 0.obs;
  final pendingJobsCount = 0.obs;
  final approvedJobsCount = 0.obs;

  final isUsersLoading = false.obs;
  final isJobsLoading = false.obs;
  final isActionLoading = false.obs;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    loadPendingData();
  }

  Future<void> loadPendingData() async {
    await Future.wait([
      fetchSummaryStats(),
      fetchUsersAndCompanies(),
      fetchPendingJobs(),
    ]);
  }

  Future<void> fetchSummaryStats() async {
    try {
      final usersSnap = await _firestore.collection('users').get();
      final nonAdminUsers = usersSnap.docs.where((doc) {
        final role = ((doc.data()['role'] as String?) ?? '').toLowerCase().trim();
        return role != 'admin';
      }).toList();
      totalUsersCount.value = nonAdminUsers.length;

      pendingCompaniesCount.value = nonAdminUsers.where((doc) {
        final data = doc.data();
        final role = ((data['role'] as String?) ?? '').toLowerCase().trim();
        final status = ((data['status'] as String?) ?? '').toLowerCase().trim();
        return role == 'company' && status == 'pending';
      }).length;

      final approvedJobsSnap =
          await _firestore.collection('jobs').where('status', isEqualTo: 'approved').get();
      approvedJobsCount.value = approvedJobsSnap.docs.length;
    } catch (e) {
      Get.snackbar(
        'err_title'.tr,
        'err_fetch_pending_jobs'.trParams({'error': e.toString()}),
      );
    }
  }

  Future<void> fetchUsersAndCompanies() async {
    isUsersLoading.value = true;
    try {
      final snap = await _firestore.collection('users').get();
      final users = snap.docs
          .where((doc) => ((doc.data()['role'] as String?) ?? '').toLowerCase().trim() != 'admin')
          .map((doc) {
        final data = doc.data();
        final role = ((data['role'] as String?) ?? 'jobseeker').toLowerCase().trim();
        final status = ((data['status'] as String?) ?? 'approved').toLowerCase().trim();
        final companyName = (data['companyName'] as String?)?.trim() ?? '';
        final fullName = (data['fullName'] as String?)?.trim() ?? '';
        final email = (data['email'] as String?)?.trim() ?? '';

        final name = role == 'company'
            ? (companyName.isNotEmpty ? companyName : 'unknown_company'.tr)
            : (fullName.isNotEmpty
                ? fullName
                : (email.isNotEmpty ? email.split('@').first : 'unknown_candidate'.tr));

        return <String, dynamic>{
          'id': doc.id,
          'name': name,
          'email': email,
          'role': role,
          'status': status,
        };
      }).toList();

      users.sort((a, b) {
        final roleA = a['role'] as String? ?? '';
        final roleB = b['role'] as String? ?? '';
        if (roleA == roleB) {
          return (a['name'] as String? ?? '').compareTo(b['name'] as String? ?? '');
        }
        if (roleA == 'company') return -1;
        if (roleB == 'company') return 1;
        return roleA.compareTo(roleB);
      });
      usersList.assignAll(users);
    } catch (e) {
      Get.snackbar(
        'err_title'.tr,
        'err_fetch_pending_companies'.trParams({'error': e.toString()}),
      );
    } finally {
      isUsersLoading.value = false;
    }
  }

  Future<void> fetchPendingJobs() async {
    isJobsLoading.value = true;
    try {
      final snap = await _firestore.collection('jobs').where('status', isEqualTo: 'pending').get();

      jobRequests.assignAll(
        snap.docs.map((doc) {
          final data = doc.data();
          final salaryMin = data['salary_min'] ?? 0;
          final salaryMax = data['salary_max'] ?? 0;
          return <String, dynamic>{
            'id': doc.id,
            'title': (data['title'] as String?) ?? '',
            'company': (data['company_name'] as String?) ?? 'unknown_company'.tr,
            'desc': (data['description'] as String?) ?? '',
            'salary': '$salaryMin - $salaryMax',
            'status': 'Pending',
          };
        }).toList(),
      );
      pendingJobsCount.value = snap.docs.length;
    } catch (e) {
      Get.snackbar(
        'err_title'.tr,
        'err_fetch_pending_jobs'.trParams({'error': e.toString()}),
      );
    } finally {
      isJobsLoading.value = false;
    }
  }

  Future<void> approveCompany(String id) async {
    await _updateUserStatus(id: id, status: 'approved', successKey: 'label_company_approved');
  }

  Future<void> rejectCompany(String id) async {
    await _updateUserStatus(id: id, status: 'rejected', successKey: 'msg_company_rejected');
  }

  Future<void> blockUser(String id) async {
    await _updateUserStatus(id: id, status: 'blocked', successKey: 'label_user_blocked');
  }

  Future<void> unblockUser(String id) async {
    await _updateUserStatus(id: id, status: 'approved', successKey: 'label_user_unblocked');
  }

  Future<void> _updateUserStatus({
    required String id,
    required String status,
    required String successKey,
  }) async {
    isActionLoading.value = true;
    try {
      await _firestore.collection('users').doc(id).update({
        'status': status,
        'updated_at': FieldValue.serverTimestamp(),
      });
      await loadPendingData();
      Get.snackbar('success_title'.tr, successKey.tr);
    } catch (e) {
      Get.snackbar(
        'err_title'.tr,
        'err_company_reject_failed'.trParams({'error': e.toString()}),
      );
    } finally {
      isActionLoading.value = false;
    }
  }

  Future<void> approveJob(String id) async {
    isActionLoading.value = true;
    try {
      await _firestore.collection('jobs').doc(id).update({
        'status': 'approved',
        'updated_at': FieldValue.serverTimestamp(),
      });
      await loadPendingData();
      Get.snackbar('success_title'.tr, 'label_job_approved'.tr);
    } catch (e) {
      Get.snackbar(
        'err_title'.tr,
        'err_job_approve_failed'.trParams({'error': e.toString()}),
      );
    } finally {
      isActionLoading.value = false;
    }
  }

  Future<void> rejectJob(String id) async {
    final reasonCtrl = TextEditingController();
    Get.defaultDialog(
      title: 'btn_reject_reason'.tr,
      content: Column(
        children: [
          TextField(
            controller: reasonCtrl,
            decoration: InputDecoration(hintText: 'hint_reject_reason'.tr),
          ),
        ],
      ),
      textConfirm: 'dialog_reject_confirm'.tr,
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () async {
        if (reasonCtrl.text.isEmpty) {
          return;
        }
        isActionLoading.value = true;
        try {
          await _firestore.collection('jobs').doc(id).update({
            'status': 'rejected',
            'rejection_reason': reasonCtrl.text.trim(),
            'updated_at': FieldValue.serverTimestamp(),
          });
          await loadPendingData();
          Get.back();
          Get.snackbar(
            'success_title'.tr,
            'msg_job_rejected_reason'.trParams({'reason': reasonCtrl.text}),
          );
        } catch (e) {
          Get.back();
          Get.snackbar(
            'err_title'.tr,
            'err_job_reject_failed'.trParams({'error': e.toString()}),
          );
        } finally {
          isActionLoading.value = false;
        }
      },
    );
  }
}
