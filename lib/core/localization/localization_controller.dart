import 'dart:ui';
import 'package:get/get.dart';

import '../../data/services/storage_service.dart';

class LocalizationController extends GetxController {
  final StorageService _storage = StorageService();

  static const Locale english = Locale('en', 'US');
  static const Locale arabic = Locale('ar', 'SA');

  Locale get initialLocale {
    final savedLang = _storage.getLanguage();
    if (savedLang != null) {
      return _resolveLocale(savedLang);
    }
    return _resolveLocale(Get.deviceLocale?.languageCode ?? 'en');
  }

  bool get isRtl => Get.locale?.languageCode == 'ar';

  void changeLanguage(String langCode) {
    final locale = _resolveLocale(langCode);
    Get.updateLocale(locale);
    _storage.saveLanguage(locale.languageCode);
  }

  Locale _resolveLocale(String langCode) {
    switch (langCode.toLowerCase()) {
      case 'ar':
      case 'ar_sa':
        return arabic;
      case 'en':
      case 'en_us':
      default:
        return english;
    }
  }
}
