import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class EmployerDashboardController extends GetxController {
  final activeJobsCount = 0.obs;
  final newCandidatesCount = 0.obs;
  final shortlistedCount = 0.obs;
  final interviewsCount = 0.obs;

  final recentApplicants = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void onInit() {
    super.onInit();
    loadDashboardData();
  }

  Future<void> loadDashboardData() async {
    final company = _auth.currentUser;
    if (company == null) {
      _clearState();
      return;
    }

    isLoading.value = true;
    try {
      final jobsSnap = await _firestore
          .collection('jobs')
          .where('company_id', isEqualTo: company.uid)
          .get();

      final jobs = jobsSnap.docs;
      final approvedJobs = jobs.where((j) => j.data()['status'] == 'approved').toList();
      activeJobsCount.value = approvedJobs.length;

      final approvedJobIds = approvedJobs.map((j) => j.id).toList();
      if (approvedJobIds.isEmpty) {
        newCandidatesCount.value = 0;
        shortlistedCount.value = 0;
        interviewsCount.value = 0;
        recentApplicants.clear();
        return;
      }

      final apps = <QueryDocumentSnapshot<Map<String, dynamic>>>[];
      for (var i = 0; i < approvedJobIds.length; i += 10) {
        final end = (i + 10) > approvedJobIds.length ? approvedJobIds.length : (i + 10);
        final chunk = approvedJobIds.sublist(i, end);
        final snap = await _firestore
            .collection('applications')
            .where('job_id', whereIn: chunk)
            .get();
        apps.addAll(snap.docs);
      }

      newCandidatesCount.value =
          apps.where((a) {
            final s = _normalizeStatus(a.data()['status']);
            return s == 'pending' || s == 'applied';
          }).length;
      shortlistedCount.value = apps.where((a) {
        final s = _normalizeStatus(a.data()['status']);
        return s == 'accepted' || s == 'shortlisted';
      }).length;
      interviewsCount.value =
          apps.where((a) {
            final s = _normalizeStatus(a.data()['status']);
            return s == 'interview' || s == 'interview_scheduled' || s == 'interview_requested';
          }).length;

      apps.sort((a, b) {
        final aTime = (a.data()['created_at'] as Timestamp?)?.toDate();
        final bTime = (b.data()['created_at'] as Timestamp?)?.toDate();
        if (aTime == null && bTime == null) return 0;
        if (aTime == null) return 1;
        if (bTime == null) return -1;
        return bTime.compareTo(aTime);
      });

      final seekerIds = apps
          .map((a) => a.data()['job_seeker_id'] as String?)
          .whereType<String>()
          .toSet()
          .toList();
      final seekers = <String, Map<String, dynamic>>{};
      for (var i = 0; i < seekerIds.length; i += 10) {
        final end = (i + 10) > seekerIds.length ? seekerIds.length : (i + 10);
        final chunk = seekerIds.sublist(i, end);
        final snap = await _firestore
            .collection('users')
            .where(FieldPath.documentId, whereIn: chunk)
            .get();
        for (final doc in snap.docs) {
          seekers[doc.id] = doc.data();
        }
      }

      final jobsMap = {for (final j in approvedJobs) j.id: j.data()};
      recentApplicants.assignAll(
        apps.take(5).map((appDoc) {
          final app = appDoc.data();
          final seekerId = (app['job_seeker_id'] as String?) ?? '';
          final seeker = seekers[seekerId] ?? const <String, dynamic>{};
          final jobId = (app['job_id'] as String?) ?? '';
          final job = jobsMap[jobId] ?? const <String, dynamic>{};
          return <String, dynamic>{
            'name': (seeker['fullName'] as String?) ??
                (seeker['name'] as String?) ??
                (seeker['email'] as String?) ??
                'unknown_candidate'.tr,
            'job': (job['title'] as String?) ?? 'unknown_job'.tr,
            'match': (app['match_score'] as num?)?.toInt() ?? 0,
            'time': _timeAgo((app['created_at'] as Timestamp?)?.toDate()),
          };
        }).toList(),
      );
    } catch (e) {
      Get.snackbar(
        'err_title'.tr,
        'err_fetch_applicants'.trParams({'error': e.toString()}),
      );
    } finally {
      isLoading.value = false;
    }
  }

  void _clearState() {
    activeJobsCount.value = 0;
    newCandidatesCount.value = 0;
    shortlistedCount.value = 0;
    interviewsCount.value = 0;
    recentApplicants.clear();
    isLoading.value = false;
  }

  String _normalizeStatus(dynamic value) {
    return (value as String? ?? 'pending').toLowerCase().trim();
  }

  String _timeAgo(DateTime? date) {
    if (date == null) return '-';
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 1) return 'now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    if (diff.inDays < 30) return '${diff.inDays}d';
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
