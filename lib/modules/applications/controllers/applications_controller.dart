import 'dart:async';
import 'dart:developer' as developer;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../../data/models/application_model.dart';

class ApplicationsController extends GetxController {
  final myApplications = <ApplicationModel>[].obs;
  final filterStatus = Rxn<AppStatus>();
  final isLoading = true.obs;
  final errorMessage = ''.obs;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  StreamSubscription<QuerySnapshot>? _appsSub;

  @override
  void onInit() {
    super.onInit();
    _startListener();
  }

  /// Backwards-compatible public API.
  /// Some widgets call `controller.loadApplications` on button press — expose it.
  Future<void> loadApplications() async {
    // Start or refresh the listener; keep it synchronous internally.
    _startListener();
  }

  void _startListener() {
    final user = _auth.currentUser;
    if (user == null) {
      myApplications.clear();
      isLoading.value = false;
      return;
    }

    _appsSub?.cancel();
    _appsSub = _firestore
        .collection('applications')
        .where('job_seeker_id', isEqualTo: user.uid)
        .snapshots()
        .listen((snap) async {
      try {
        isLoading.value = true;
        errorMessage.value = '';
        final jobsCache = <String, String>{};
        final items = <ApplicationModel>[];
        for (final doc in snap.docs) {
          final data = doc.data();
          final jobId = (data['job_id'] as String?) ?? '';
          if (jobId.isNotEmpty && !jobsCache.containsKey(jobId)) {
            final jobDoc = await _firestore.collection('jobs').doc(jobId).get();
            jobsCache[jobId] = (jobDoc.data()?['company_name'] as String?) ?? '';
          }
          data['company_name'] = data['company_name'] ?? jobsCache[jobId] ?? '';
          items.add(ApplicationModel.fromFirestore(doc.id, data));
        }

        items.sort((a, b) => b.appliedDate.compareTo(a.appliedDate));
        myApplications.assignAll(items);
      } catch (e, stackTrace) {
        developer.log(
          'Failed to load applications (listener): $e',
          name: 'ApplicationsController',
          error: e,
          stackTrace: stackTrace,
        );
        errorMessage.value = 'err_load_applications'.trParams({'error': e.toString()});
        myApplications.clear();
      } finally {
        isLoading.value = false;
      }
    });
  }

  @override
  void onClose() {
    _appsSub?.cancel();
    super.onClose();
  }

  List<ApplicationModel> get filteredApps {
    final status = filterStatus.value;
    if (status == null) {
      return myApplications;
    }
    return myApplications.where((app) => app.status == status).toList();
  }

  void setFilter(AppStatus? status) {
    filterStatus.value = status;
  }
}
