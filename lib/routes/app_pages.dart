import 'package:get/get.dart';

import '../data/models/application_model.dart';
import '../data/models/job_model.dart';
import '../modules/admin/admin_binding.dart';
import '../modules/admin_dashboard/bindings/admin_dashboard_binding.dart';
import '../modules/admin_dashboard/views/admin_dashboard_view.dart';
import '../modules/admin_dashboard/views/admin_jobs_view.dart';
import '../modules/admin_dashboard/views/admin_users_view.dart';
import '../modules/ai_analyzer/bindings/ai_analyzer_binding.dart';
import '../modules/ai_analyzer/views/ai_analyzer_view.dart';
import '../modules/applications/bindings/applications_binding.dart';
import '../modules/applications/views/applications_view.dart';
import '../modules/applications/views/track_application_view.dart';
import '../modules/auth/auth_binding.dart';
import '../modules/auth/forget_password/bindings/forget_password_binding.dart';
import '../modules/auth/forget_password/views/forget_password_view.dart';
import '../modules/auth/login/bindings/login_binding.dart';
import '../modules/auth/login/views/login_view.dart';
import '../modules/auth/otp/bindings/otp_binding.dart';
import '../modules/auth/otp/views/otp_view.dart';
import '../modules/auth/status/views/auth_status_view.dart';
import '../modules/auth/signup/bindings/signup_binding.dart';
import '../modules/auth/signup/views/signup_view.dart';
import '../modules/company/company_binding.dart';
import '../modules/cv_builder/bindings/cv_builder_binding.dart';
import '../modules/cv_builder/views/cv_builder_view.dart';
import '../modules/cv_builder/views/cv_entry_view.dart';
import '../modules/employer/candidates/bindings/candidates_binding.dart';
import '../modules/employer/candidates/views/candidates_view.dart';
import '../modules/employer/employer_dashboard/bindings/employer_dashboard_binding.dart';
import '../modules/employer/employer_dashboard/views/employer_dashboard_view.dart';
import '../modules/employer/post_job/bindings/post_job_binding.dart';
import '../modules/employer/post_job/views/post_job_view.dart';
import '../modules/job_seeker/job_seeker_binding.dart';
import '../modules/jobs/bindings/jobs_binding.dart';
import '../modules/jobs/views/job_details_view.dart';
import '../modules/jobs/views/jobs_view.dart';
import '../modules/onboarding/bindings/onboarding_binding.dart';
import '../modules/onboarding/views/onboarding_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/profile/views/sub_pages/about_view.dart';
import '../modules/profile/views/sub_pages/contact_view.dart';
import '../modules/profile/views/sub_pages/edit_profile_view.dart';
import '../modules/profile/views/sub_pages/faq_view.dart';
import '../modules/profile/views/sub_pages/notifications_view.dart';
import '../modules/profile/views/sub_pages/privacy_view.dart';
import '../modules/profile/views/sub_pages/support_view.dart';
import '../modules/profile/views/sub_pages/terms_view.dart';
import '../modules/root/bindings/root_binding.dart';
import '../modules/root/views/root_view.dart';
import '../modules/seeker_home/bindings/seeker_home_binding.dart';
import '../modules/seeker_home/views/seeker_home_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';
import 'app_routes.dart';
import 'middlewares.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.INITIAL;

  static final routes = <GetPage>[
    GetPage(
      name: Routes.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: Routes.ONBOARDING,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
      middlewares: [GuestMiddleware()],
    ),
    GetPage(
      name: Routes.AUTH_LOGIN,
      page: () => const LoginView(),
      bindings: [AuthBinding(), LoginBinding()],
      middlewares: [GuestMiddleware()],
    ),
    GetPage(
      name: Routes.AUTH_SIGNUP,
      page: () => const SignupView(),
      bindings: [AuthBinding(), SignupBinding()],
      middlewares: [GuestMiddleware()],
    ),
    GetPage(
      name: Routes.AUTH_FORGET_PASSWORD,
      page: () => const ForgetPasswordView(),
      bindings: [AuthBinding(), ForgetPasswordBinding()],
      middlewares: [GuestMiddleware()],
    ),
    GetPage(
      name: Routes.AUTH_OTP,
      page: () => const OtpView(),
      bindings: [AuthBinding(), OtpBinding()],
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.AUTH_STATUS,
      page: () => const AuthStatusView(),
      binding: AuthBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.ROOT,
      page: () => const RootView(),
      binding: RootBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.HOME,
      page: () => const RootView(),
      binding: RootBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.SEEKER_HOME,
      page: () => const SeekerHomeView(),
      bindings: [JobSeekerBinding(), SeekerHomeBinding(), JobsBinding()],
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.JOB_SEEKER_HOME,
      page: () => const RootView(),
      binding: RootBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.CV_ENTRY,
      page: () => const CvEntryView(),
      bindings: [JobSeekerBinding()],
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.CV_BUILDER,
      page: () => const CvBuilderView(),
      bindings: [JobSeekerBinding(), CvBuilderBinding()],
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.AI_ANALYZER,
      page: () => const AiAnalyzerView(),
      bindings: [JobSeekerBinding(), AiAnalyzerBinding(), JobsBinding()],
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.JOBS,
      page: () => const JobsView(),
      bindings: [JobSeekerBinding(), JobsBinding()],
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.JOB_DETAILS,
      page: () => JobDetailsView(job: Get.arguments as JobModel),
      bindings: [JobSeekerBinding(), JobsBinding()],
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.APPLICATIONS,
      page: () => const ApplicationsView(),
      bindings: [JobSeekerBinding(), ApplicationsBinding()],
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.TRACK_APPLICATION,
      page: () => TrackApplicationView(
        application: Get.arguments as ApplicationModel,
      ),
      bindings: [JobSeekerBinding(), ApplicationsBinding()],
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.PROFILE_EDIT,
      page: () => const EditProfileView(),
      binding: ProfileBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.PROFILE_NOTIFICATIONS,
      page: () => const NotificationsView(),
      binding: ProfileBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.PROFILE_FAQ,
      page: () => const FaqView(),
      binding: ProfileBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.PROFILE_ABOUT,
      page: () => const AboutView(),
      binding: ProfileBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.PROFILE_PRIVACY,
      page: () => const PrivacyView(),
      binding: ProfileBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.PROFILE_TERMS,
      page: () => const TermsView(),
      binding: ProfileBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.PROFILE_CONTACT,
      page: () => const ContactView(),
      binding: ProfileBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.PROFILE_SUPPORT,
      page: () => const SupportView(),
      binding: ProfileBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.COMPANY_DASHBOARD,
      page: () => const EmployerDashboardView(),
      bindings: [CompanyBinding(), EmployerDashboardBinding()],
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.COMPANY_PANEL,
      page: () => const RootView(),
      binding: RootBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.COMPANY_POST_JOB,
      page: () => const PostJobView(),
      bindings: [CompanyBinding(), PostJobBinding()],
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.COMPANY_CANDIDATES,
      page: () => const CandidatesView(),
      bindings: [CompanyBinding(), CandidatesBinding()],
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.ADMIN_DASHBOARD,
      page: () => const AdminDashboardView(),
      bindings: [AdminBinding(), AdminDashboardBinding()],
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.ADMIN_DASHBOARD_ALIAS,
      page: () => const RootView(),
      binding: RootBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.ADMIN_USERS,
      page: () => const AdminUsersView(),
      bindings: [AdminBinding(), AdminDashboardBinding()],
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.ADMIN_JOBS,
      page: () => const AdminJobsView(),
      bindings: [AdminBinding(), AdminDashboardBinding()],
      middlewares: [AuthMiddleware()],
    ),
  ];
}
