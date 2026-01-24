import 'package:ai_job_matcher/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';
import 'core/localization/locale_string.dart';
import 'core/localization/localization_controller.dart';
import 'routes/app_pages.dart'; // تأكد أنك أنشأت هذا الملف من الخطوة السابقة

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Init Storage
  await GetStorage.init();

  // 3. Inject Global Controllers
  // نقوم بحقنهم هنا ليكونوا متاحين طوال حياة التطبيق
  final themeCtrl = Get.put(ThemeController());
  final langCtrl = Get.put(LocalizationController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find();
    final LocalizationController langController = Get.find();

    // 1440x900 is a standard Laptop/Web breakpoint
    return ScreenUtilInit(
      designSize: const Size(1440, 900),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Web App',

          // --- Localization ---
          translations: LocaleString(),
          locale: langController.initialLocale,
          fallbackLocale: const Locale('en', 'US'),

          // --- Theme ---
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: themeController.themeMode,

          // --- Routing ---
          initialRoute: Routes.ROOT,
          getPages: AppPages.routes,
        );
      },
    );
  }
}
