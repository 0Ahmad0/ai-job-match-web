abstract class Routes {
  Routes._();

  static const INITIAL = SPLASH;

  static const SPLASH = '/';
  static const ONBOARDING = '/onboarding';

  static const AUTH_LOGIN = '/auth/login';
  static const AUTH_SIGNUP = '/auth/signup';
  static const AUTH_FORGET_PASSWORD = '/auth/forget-password';
  static const AUTH_OTP = '/auth/otp';
  static const AUTH_STATUS = '/auth/status';

  static const ROOT = '/root';

  static const SEEKER_HOME = '/seeker/home';
  static const CV_ENTRY = '/seeker/cv-entry';
  static const CV_BUILDER = '/seeker/cv-builder';
  static const AI_ANALYZER = '/seeker/ai-analyzer';
  static const JOBS = '/seeker/jobs';
  static const JOB_DETAILS = '/seeker/jobs/details';
  static const APPLICATIONS = '/seeker/applications';
  static const TRACK_APPLICATION = '/seeker/applications/track';

  static const PROFILE = '/profile';
  static const PROFILE_EDIT = '/profile/edit';
  static const PROFILE_NOTIFICATIONS = '/profile/notifications';
  static const PROFILE_FAQ = '/profile/faq';
  static const PROFILE_ABOUT = '/profile/about';
  static const PROFILE_PRIVACY = '/profile/privacy';
  static const PROFILE_TERMS = '/profile/terms';
  static const PROFILE_CONTACT = '/profile/contact';
  static const PROFILE_SUPPORT = '/profile/support';

  static const COMPANY_DASHBOARD = '/company/dashboard';
  static const COMPANY_PANEL = '/company-panel';
  static const COMPANY_POST_JOB = '/company/post-job';
  static const COMPANY_CANDIDATES = '/company/candidates';

  static const ADMIN_DASHBOARD = '/admin/dashboard';
  static const ADMIN_DASHBOARD_ALIAS = '/admin-dashboard';
  static const ADMIN_USERS = '/admin/users';
  static const ADMIN_JOBS = '/admin/jobs';

  static const JOB_SEEKER_HOME = '/job-seeker-home';
}
