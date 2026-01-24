import 'package:get/get.dart';

import '../../../../routes/app_routes.dart';

class OtpController extends GetxController {

  // محاكاة فتح تطبيق الايميل
  Future<void> openEmailApp() async {
    // Android: intent to open mail app
    // iOS: message://
    // final Uri emailLaunchUri = Uri(scheme: 'mailto');
    // try {
    //   if (await canLaunchUrl(emailLaunchUri)) {
    //     await launchUrl(emailLaunchUri);
    //   } else {
    //     Get.snackbar('Error', 'Could not open email app');
    //   }
    // } catch (e) {
    //   // Fallback
    // }
  }

  void resendLink() {
    Get.snackbar('Sent', 'Link resent successfully');
  }

  void skipToLogin() {
    Get.offAllNamed(Routes.AUTH_LOGIN);
  }
}