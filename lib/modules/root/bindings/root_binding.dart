import 'package:get/get.dart';

import '../../admin_dashboard/bindings/admin_dashboard_binding.dart';
import '../../ai_analyzer/bindings/ai_analyzer_binding.dart';
import '../../applications/bindings/applications_binding.dart';
import '../../auth/auth_binding.dart';
import '../../employer/candidates/bindings/candidates_binding.dart';
import '../../employer/employer_dashboard/bindings/employer_dashboard_binding.dart';
import '../../employer/post_job/bindings/post_job_binding.dart';
import '../../jobs/bindings/jobs_binding.dart';
import '../../profile/bindings/profile_binding.dart';
import '../../seeker_home/bindings/seeker_home_binding.dart';
import '../controllers/root_controller.dart';

class RootBinding extends Bindings {
  @override
  void dependencies() {
    if (Get.isRegistered<RootController>()) {
      Get.delete<RootController>(force: true);
    }
    // Root tabs rely on authenticated/session-aware controllers.
    AuthBinding().dependencies();
    Get.put<RootController>(RootController(), permanent: true);
    SeekerHomeBinding().dependencies();
    AiAnalyzerBinding().dependencies();
    JobsBinding().dependencies();
    ApplicationsBinding().dependencies();
    EmployerDashboardBinding().dependencies();
    PostJobBinding().dependencies();
    CandidatesBinding().dependencies();
    AdminDashboardBinding().dependencies();
    ProfileBinding().dependencies();
  }
}
