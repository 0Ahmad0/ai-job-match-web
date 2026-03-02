import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminDashboardController extends GetxController {

  // 1. Users List
  final usersList = <Map<String, dynamic>>[].obs;

  // 2. Jobs Requests List (Pending Jobs)
  final jobRequests = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadData();
  }

  void _loadData() {
    // Users Data
    usersList.assignAll([
      {'id': '1', 'name': 'Tech Corp', 'type': 'Employer', 'status': 'Pending'},
      {'id': '2', 'name': 'Ahmed Ali', 'type': 'Seeker', 'status': 'Active'},
      {'id': '3', 'name': 'Scam Ltd', 'type': 'Employer', 'status': 'Blocked'},
    ]);

    // Jobs Data
    jobRequests.assignAll([
      {
        'id': '101',
        'title': 'Senior Flutter Dev',
        'company': 'Tech Corp',
        'desc': 'We need 5 years exp...',
        'salary': '5000\$',
        'status': 'Pending'
      },
      {
        'id': '102',
        'title': 'Data Entry (Easy Money)',
        'company': 'Unknown',
        'desc': 'Work from home earn 1000\$ daily...',
        'salary': '10000\$',
        'status': 'Pending'
      },
    ]);
  }

  // --- User Actions ---
  void toggleUserStatus(String id, String currentStatus) {
    final index = usersList.indexWhere((u) => u['id'] == id);
    if (index == -1) return;

    if (currentStatus == 'Blocked') {
      usersList[index]['status'] = 'Active'; // Unblock
      Get.snackbar('Success', 'User Unblocked');
    } else {
      usersList[index]['status'] = 'Blocked'; // Block
      Get.snackbar('Blocked', 'User Blocked');
    }
    usersList.refresh();
  }

  void approveCompany(String id) {
    final index = usersList.indexWhere((u) => u['id'] == id);
    if (index != -1) {
      usersList[index]['status'] = 'Active';
      usersList.refresh();
      Get.snackbar('Success', 'Company Approved');
    }
  }

  // --- Job Actions ---
  void approveJob(String id) {
    jobRequests.removeWhere((j) => j['id'] == id);
    Get.snackbar('Approved', 'Job is now live!');
  }

  void rejectJob(String id) {
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
      textConfirm: 'Reject',
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () {
        if (reasonCtrl.text.isNotEmpty) {
          jobRequests.removeWhere((j) => j['id'] == id);
          Get.back();
          Get.snackbar('Rejected', 'Job rejected: ${reasonCtrl.text}');
        }
      },
    );
  }
}