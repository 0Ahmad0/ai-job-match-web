import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../data/models/candidate_model.dart';

class CandidatesController extends GetxController {
  final candidates = <CandidateModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadCandidates();
  }

  void _loadCandidates() {
    // محاكاة بيانات تأتي من السيرفر
    final data = [
      CandidateModel(
        id: '1',
        name: 'Sara Ahmed',
        jobTitle: 'Senior Flutter Dev',
        matchScore: 95,
        matchingSkills: ['Flutter', 'Dart', 'GetX', 'Clean Arch'],
      ),
      CandidateModel(
        id: '2',
        name: 'Omar Ali',
        jobTitle: 'Mobile Developer',
        matchScore: 88,
        matchingSkills: ['Flutter', 'Firebase', 'Git'],
      ),
      CandidateModel(
        id: '3',
        name: 'John Smith',
        jobTitle: 'Junior Developer',
        matchScore: 65,
        matchingSkills: ['Dart', 'UI Design'],
      ),
      CandidateModel(
        id: '4',
        name: 'Lina Karam',
        jobTitle: 'Fresh Grad',
        matchScore: 40,
        matchingSkills: ['Basic Coding'],
      ),
    ];

    // ترتيبهم: الأعلى نسبة أولاً (AI Sorting)
    data.sort((a, b) => b.matchScore.compareTo(a.matchScore));
    candidates.assignAll(data);
  }

  void performAction(String action, String name) {
    if (action == 'reject') {
      Get.snackbar('Rejected', '$name has been rejected', backgroundColor: Colors.red, colorText: Colors.white);
      // candidates.removeWhere((c) => c.name == name); // يمكن حذفهم من القائمة
    } else {
      Get.snackbar('Success', '$action for $name', backgroundColor: Colors.green, colorText: Colors.white);
    }
  }
}