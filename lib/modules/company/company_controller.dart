import 'package:get/get.dart';

class CompanyController extends GetxController {
  final currentSection = 0.obs;

  void setSection(int index) {
    currentSection.value = index;
  }
}
