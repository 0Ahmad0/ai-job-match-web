import 'package:get/get.dart';
import '../core/localization/locale_string.dart';
import 'ar_sa.dart';
import 'en_us.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys {
    final base = LocaleString().keys;
    return {
      'en_US': {
        ...?base['en_US'],
        ...enUsTranslations,
      },
      'ar_SA': {
        ...?base['ar_SA'],
        ...arSaTranslations,
        'job_applied_badge': 'تم التقديم',
        'job_applied_cta_disabled': 'تم التقديم مسبقًا',
      },
    };
  }
}
