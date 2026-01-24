
import 'package:get_storage/get_storage.dart';

class StorageService {
  final _box = GetStorage();

  static const _keyLang = 'lang_code';
  static const _keyTheme = 'is_dark_mode';

  // --- Language Methods ---
  Future<void> saveLanguage(String langCode) async {
    await _box.write(_keyLang, langCode);
  }

  String? getLanguage() {
    return _box.read(_keyLang);
  }

  // --- Theme Methods ---
  Future<void> saveTheme(bool isDarkMode) async {
    await _box.write(_keyTheme, isDarkMode);
  }

  bool getThemeMode() {
    return _box.read(_keyTheme) ?? false; // Default is Light (false)
  }
}