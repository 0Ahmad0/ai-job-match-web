import 'package:get/get.dart';

class JobSeekerController extends GetxController {
  final currentSection = 0.obs;

  void setSection(int index) {
    currentSection.value = index;
  }
}
