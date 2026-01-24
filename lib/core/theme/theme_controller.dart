import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/services/storage_service.dart';

class ThemeController extends GetxController {
  final StorageService _storage = StorageService();

  // Observable variable
  final _isDarkMode = false.obs;

  bool get isDarkMode => _isDarkMode.value;
  ThemeMode get themeMode => _isDarkMode.value ? ThemeMode.dark : ThemeMode.light;

  @override
  void onInit() {
    super.onInit();
    // Load saved theme
    _isDarkMode.value = _storage.getThemeMode();
  }

  void toggleTheme() {
    _isDarkMode.value = !_isDarkMode.value;

    Get.changeThemeMode(_isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
    _storage.saveTheme(_isDarkMode.value);
  }
}