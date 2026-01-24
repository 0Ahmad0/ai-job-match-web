import 'package:get/get.dart';

class EmployerDashboardController extends GetxController {
  // Stats
  final activeJobsCount = 3.obs;
  final newCandidatesCount = 18.obs;
  final shortlistedCount = 5.obs;
  final interviewsCount = 2.obs;

  // Recent Applicants List (Mock Data)
  final recentApplicants = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadData();
  }

  void _loadData() {
    recentApplicants.assignAll([
      {
        'name': 'Sarah Ahmed',
        'job': 'Flutter Developer',
        'match': 95,
        'image': '', // Empty for default icon
        'time': '2m ago'
      },
      {
        'name': 'John Doe',
        'job': 'UI/UX Designer',
        'match': 82,
        'image': '',
        'time': '1h ago'
      },
      {
        'name': 'Ali Hassan',
        'job': 'Backend Engineer',
        'match': 60,
        'image': '',
        'time': '3h ago'
      },
    ]);
  }
}