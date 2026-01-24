import 'dart:ui';
import 'package:get/get.dart';

import '../../data/services/storage_service.dart';

class LocalizationController extends GetxController {
  final StorageService _storage = StorageService();

  Locale? get initialLocale {
    final savedLang = _storage.getLanguage();
    if (savedLang != null) {
      return Locale(savedLang);
    }
    // Default system locale or fallback
    return Get.deviceLocale;
  }

  void changeLanguage(String langCode) {
    Locale locale = Locale(langCode);
    Get.updateLocale(locale);
    _storage.saveLanguage(langCode);
  }
}