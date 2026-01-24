import 'package:get/get.dart';
import '../../../../data/models/application_model.dart';
class ApplicationsController extends GetxController {
  final myApplications = <ApplicationModel>[].obs;
  final filterStatus = Rxn<AppStatus>();


  @override
  void onInit() {
    super.onInit();
    _loadApplications();
  }

  void _loadApplications() {
    myApplications.assignAll([
      // 1. حالة القبول (كاملة)
      ApplicationModel(
        id: '1',
        jobTitle: 'Senior Flutter Developer',
        company: 'Tech Solutions',
        logoUrl: '',
        appliedDate: '2023-10-15',
        status: AppStatus.accepted,
        startDate: '2023-11-01',
        offerSalary: '\$4,500',
      ),

      // 2. حالة الانتظار (في الوسط)
      ApplicationModel(
        id: '2',
        jobTitle: 'UI/UX Designer',
        company: 'Creative Agency',
        logoUrl: '',
        appliedDate: '2023-10-20',
        status: AppStatus.pending,
      ),

      // 3. حالة الرفض (تايم لاين مقطوع + سبب)
      ApplicationModel(
        id: '3',
        jobTitle: 'Backend Engineer',
        company: 'Google',
        logoUrl: '',
        appliedDate: '2023-09-01',
        status: AppStatus.rejected,
        rejectionReason: 'Looking for more experience in Microservices architecture.',
      ),
    ]);
  }

  List<ApplicationModel> get filteredApps {
    if (filterStatus.value == null) {
      return myApplications;
    }
    return myApplications.where((app) => app.status == filterStatus.value).toList();
  }

  void setFilter(AppStatus? status) {
    filterStatus.value = status;
  }
}