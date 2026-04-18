import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminDashboardController extends GetxController {
  final usersList = <Map<String, dynamic>>[].obs;
  final jobRequests = <Map<String, dynamic>>[].obs;

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
      fetchPendingCompanies(),
      fetchPendingJobs(),
    ]);
  }

  Future<void> fetchPendingCompanies() async {
    isUsersLoading.value = true;
    try {
      final snap = await _firestore
          .collection('users')
          .where('role', isEqualTo: 'company')
          .where('status', isEqualTo: 'pending')
          .get();

      usersList.assignAll(
        snap.docs.map((doc) {
          final data = doc.data();
          return <String, dynamic>{
            'id': doc.id,
            'name': (data['companyName'] as String?) ?? 'unknown_company'.tr,
            'type': 'Employer',
            'status': 'Pending',
          };
        }).toList(),
      );
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
      final snap = await _firestore
          .collection('jobs')
          .where('status', isEqualTo: 'pending')
          .get();

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
    isActionLoading.value = true;
    try {
      await _firestore.collection('users').doc(id).update({
        'status': 'approved',
        'updated_at': FieldValue.serverTimestamp(),
      });
      usersList.removeWhere((u) => u['id'] == id);
      Get.snackbar('success_title'.tr, 'label_company_approved'.tr);
    } catch (e) {
      Get.snackbar(
        'err_title'.tr,
        'err_company_approve_failed'.trParams({'error': e.toString()}),
      );
    } finally {
      isActionLoading.value = false;
    }
  }

  Future<void> rejectCompany(String id) async {
    isActionLoading.value = true;
    try {
      await _firestore.collection('users').doc(id).update({
        'status': 'rejected',
        'updated_at': FieldValue.serverTimestamp(),
      });
      usersList.removeWhere((u) => u['id'] == id);
      Get.snackbar('success_title'.tr, 'msg_company_rejected'.tr);
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
      jobRequests.removeWhere((j) => j['id'] == id);
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
          jobRequests.removeWhere((j) => j['id'] == id);
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
