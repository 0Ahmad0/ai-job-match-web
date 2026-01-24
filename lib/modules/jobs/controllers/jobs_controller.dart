import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/job_model.dart';

class JobsController extends GetxController {
  // القائمة الكاملة
  final allJobs = <JobModel>[].obs;

  // القائمة المعروضة (لأغراض البحث)
  final displayedJobs = <JobModel>[].obs;

  final searchCtrl = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _loadDummyJobs();
  }

  void search(String query) {
    if (query.isEmpty) {
      displayedJobs.assignAll(allJobs);
    } else {
      displayedJobs.assignAll(allJobs.where((job) =>
      job.title.toLowerCase().contains(query.toLowerCase()) ||
          job.company.toLowerCase().contains(query.toLowerCase())
      ).toList());
    }
  }

  void _loadDummyJobs() {
    // بيانات تجريبية (لاحقاً تأتي من API)
    final data = [
      JobModel(
        id: '1',
        title: 'Senior Flutter Developer',
        company: 'Tech Solutions',
        location: 'Riyadh, KSA',
        type: 'Full Time',
        salary: '\$3k - \$5k',
        matchScore: 95, // تطابق عالي
        postedTime: '2h ago',
        description: 'We are looking for an expert Flutter developer...',
      ),
      JobModel(
        id: '2',
        title: 'UI/UX Designer',
        company: 'Creative Agency',
        location: 'Dubai, UAE',
        type: 'Remote',
        salary: '\$2k - \$4k',
        matchScore: 78,
        postedTime: '5h ago',
        description: 'Design beautiful interfaces for mobile apps...',
      ),
      JobModel(
        id: '3',
        title: 'Backend Engineer (Node.js)',
        company: 'Cloud Systems',
        location: 'Cairo, Egypt',
        type: 'Part Time',
        salary: '\$1.5k',
        matchScore: 45, // تطابق منخفض
        postedTime: '1d ago',
        description: 'Build scalable APIs using Node.js...',
      ),
      JobModel(
        id: '4',
        title: 'Product Manager',
        company: 'Startup Inc',
        location: 'Remote',
        type: 'Contract',
        salary: '\$4k',
        matchScore: 60,
        postedTime: '2d ago',
        description: 'Lead the product team...',
      ),
    ];

    allJobs.assignAll(data);
    displayedJobs.assignAll(data);
  }
}