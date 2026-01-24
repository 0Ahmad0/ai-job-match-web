abstract class Routes {
  Routes._();
  static const INITIAL = SPLASH;
  static const SPLASH = '/';
  static const ONBOARDING = '/onboarding';
  static const AUTH_LOGIN = '/auth/login';
  static const AUTH_SIGNUP = '/auth/signup';
  static const AUTH_FORGET_PASSWORD = '/auth/forget_password';
  static const AUTH_OTP = '/auth/otp';
  static const HOME = '/home';
  static const ROOT = '/root';
  static const SEEKER_HOME = '/seeker_home';
  static const CV_BUILDER = '/cv_builder';
  static const AI_ANALYZER = '/ai_analyzer';
  static const JOBS = '/jobs';
  static const PROFILE = '/profile';
  static const APPLICATIONS = '/applications';
  static const EMPLOYER_EMPLOYER_DASHBOARD = '/employer/employer_dashboard';
  static const EMPLOYER_POST_JOB = '/employer/post_job';
  static const EMPLOYER_CANDIDATES = '/employer/candidates';
}