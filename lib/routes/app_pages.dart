import 'package:get/get.dart';
import 'app_routes.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';
import '../modules/onboarding/bindings/onboarding_binding.dart';
import '../modules/onboarding/views/onboarding_view.dart';
import '../modules/auth/login/bindings/login_binding.dart';
import '../modules/auth/login/views/login_view.dart';
import '../modules/auth/signup/bindings/signup_binding.dart';
import '../modules/auth/signup/views/signup_view.dart';
import '../modules/auth/forget_password/bindings/forget_password_binding.dart';
import '../modules/auth/forget_password/views/forget_password_view.dart';
import '../modules/auth/otp/bindings/otp_binding.dart';
import '../modules/auth/otp/views/otp_view.dart';
import '../modules/root/bindings/root_binding.dart';
import '../modules/root/views/root_view.dart';
import '../modules/seeker_home/bindings/seeker_home_binding.dart';
import '../modules/seeker_home/views/seeker_home_view.dart';
import '../modules/cv_builder/bindings/cv_builder_binding.dart';
import '../modules/cv_builder/views/cv_builder_view.dart';
import '../modules/ai_analyzer/bindings/ai_analyzer_binding.dart';
import '../modules/ai_analyzer/views/ai_analyzer_view.dart';
import '../modules/jobs/bindings/jobs_binding.dart';
import '../modules/jobs/views/jobs_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/applications/bindings/applications_binding.dart';
import '../modules/applications/views/applications_view.dart';
import '../modules/employer/employer_dashboard/bindings/employer_dashboard_binding.dart';
import '../modules/employer/employer_dashboard/views/employer_dashboard_view.dart';
import '../modules/employer/post_job/bindings/post_job_binding.dart';
import '../modules/employer/post_job/views/post_job_view.dart';
import '../modules/employer/candidates/bindings/candidates_binding.dart';
import '../modules/employer/candidates/views/candidates_view.dart';
import '../modules/admin_dashboard/bindings/admin_dashboard_binding.dart';
import '../modules/admin_dashboard/views/admin_dashboard_view.dart';







class AppPages {
  AppPages._();

  static const INITIAL = Routes.INITIAL;

  static final routes = [
    GetPage(
      name: Routes.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: Routes.ONBOARDING,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: Routes.AUTH_LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: Routes.AUTH_SIGNUP,
      page: () => const SignupView(),
      binding: SignupBinding(),
    ),
    GetPage(
      name: Routes.AUTH_FORGET_PASSWORD,
      page: () => const ForgetPasswordView(),
      binding: ForgetPasswordBinding(),
    ),
    GetPage(
      name: Routes.AUTH_OTP,
      page: () => const OtpView(),
      binding: OtpBinding(),
    ),

    GetPage(
      name: Routes.ROOT,
      page: () => const RootView(),
      binding: RootBinding(),
    ),
    GetPage(
      name: Routes.SEEKER_HOME,
      page: () => const SeekerHomeView(),
      binding: SeekerHomeBinding(),
    ),
    GetPage(
      name: Routes.CV_BUILDER,
      page: () => const CvBuilderView(),
      binding: CvBuilderBinding(),
    ),
    GetPage(
      name: Routes.AI_ANALYZER,
      page: () => const AiAnalyzerView(),
      binding: AiAnalyzerBinding(),
    ),
    GetPage(
      name: Routes.JOBS,
      page: () => const JobsView(),
      binding: JobsBinding(),
    ),
    GetPage(
      name: Routes.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: Routes.APPLICATIONS,
      page: () => const ApplicationsView(),
      binding: ApplicationsBinding(),
    ),
      GetPage(
      name: Routes.EMPLOYER_EMPLOYER_DASHBOARD,
      page: () => const EmployerDashboardView(),
      binding: EmployerDashboardBinding(),
    ),

    GetPage(
      name: Routes.EMPLOYER_POST_JOB,
      page: () => const PostJobView(),
      binding: PostJobBinding(),
    ),
    GetPage(
      name: Routes.EMPLOYER_CANDIDATES,
      page: () => const CandidatesView(),
      binding: CandidatesBinding(),
    ),
    GetPage(
      name: Routes.ADMIN_DASHBOARD,
      page: () => const AdminDashboardView(),
      binding: AdminDashboardBinding(),
    ),

];
}
