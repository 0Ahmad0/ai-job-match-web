import 'package:ai_job_matcher/modules/employer/candidates/bindings/candidates_binding.dart';
import 'package:ai_job_matcher/modules/employer/employer_dashboard/bindings/employer_dashboard_binding.dart';
import 'package:ai_job_matcher/modules/employer/post_job/bindings/post_job_binding.dart';
import 'package:ai_job_matcher/modules/profile/bindings/profile_binding.dart';
import 'package:ai_job_matcher/modules/seeker_home/bindings/seeker_home_binding.dart';
import 'package:get/get.dart';
import '../controllers/root_controller.dart';

class RootBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RootController>(
      () => RootController(),
    );
    SeekerHomeBinding().dependencies();
    EmployerDashboardBinding().dependencies();
    PostJobBinding().dependencies();
    CandidatesBinding().dependencies();
    ProfileBinding().dependencies();

  }
}
