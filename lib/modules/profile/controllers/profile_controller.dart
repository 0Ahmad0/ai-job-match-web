import 'dart:developer' as developer;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/localization/localization_controller.dart';
import '../../../core/theme/theme_controller.dart';
import '../../../routes/app_routes.dart';
import '../../auth/auth_controller.dart';

class ProfileController extends GetxController {
  ProfileController({
    ThemeController? themeController,
    LocalizationController? localizationController,
  })  : _themeController = themeController ?? Get.find<ThemeController>(),
        _localizationController =
            localizationController ?? Get.find<LocalizationController>();

  final ThemeController _themeController;
  final LocalizationController _localizationController;
  final AuthController _authController = Get.find<AuthController>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  late TextEditingController editNameCtrl;
  late TextEditingController editJobCtrl;
  late TextEditingController editBioCtrl;

  final isLoading = true.obs;
  final isSaving = false.obs;
  final isDeleting = false.obs;
  final isUploadingImage = false.obs;

  final userName = ''.obs;
  final userJob = ''.obs;
  final userBio = ''.obs;
  final userImage = ''.obs;
  final userEmail = ''.obs;
  final userRole = 'jobSeeker'.obs;

  final statApplied = 0.obs;
  final statReviewed = 0.obs;
  final statInterviews = 0.obs;

  Uint8List? _pendingAvatarBytes;

  bool get isDarkMode => _themeController.isDarkMode;

  @override
  void onInit() {
    super.onInit();
    editNameCtrl = TextEditingController();
    editJobCtrl = TextEditingController();
    editBioCtrl = TextEditingController();
    loadProfile();
  }

  Future<void> loadProfile() async {
    final user = _auth.currentUser;
    if (user == null) {
      isLoading.value = false;
      return;
    }

    try {
      isLoading.value = true;
      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      final data = userDoc.data() ?? const <String, dynamic>{};

      userRole.value = (data['role'] as String?) ?? 'jobSeeker';
      userEmail.value = (data['email'] as String?) ?? (user.email ?? '');
      userName.value = _resolveDisplayName(data, user);
      userJob.value = _resolveHeadline(data);
      userBio.value = (data['bio'] as String?) ?? '';
      userImage.value = (data['profile_image_url'] as String?) ?? '';

      editNameCtrl.text = userName.value;
      editJobCtrl.text = userJob.value;
      editBioCtrl.text = userBio.value;

      await _loadStats(user.uid, userRole.value);
    } catch (e, stackTrace) {
      developer.log(
        'Failed to load profile: $e',
        name: 'ProfileController',
        error: e,
        stackTrace: stackTrace,
      );
      Get.snackbar('err_title'.tr, 'err_profile_load'.trParams({'error': e.toString()}));
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loadStats(String uid, String role) async {
    if (role == 'company') {
      final jobs = await _firestore.collection('jobs').where('company_id', isEqualTo: uid).get();
      final approvedJobs = jobs.docs.where((doc) => doc.data()['status'] == 'approved').length;
      final applicants = await _firestore
          .collection('applications')
          .where('company_id', isEqualTo: uid)
          .get();
      final interviewApplicants = applicants.docs
          .where((doc) => (doc.data()['status'] ?? '') == 'interview')
          .length;
      statApplied.value = approvedJobs;
      statReviewed.value = applicants.docs.length;
      statInterviews.value = interviewApplicants;
      return;
    }

    if (role == 'admin') {
      final users = await _firestore.collection('users').get();
      final jobs = await _firestore.collection('jobs').get();
      statApplied.value = users.docs.length;
      statReviewed.value = users.docs.where((doc) => doc.data()['status'] == 'pending').length;
      statInterviews.value = jobs.docs.where((doc) => doc.data()['status'] == 'pending').length;
      return;
    }

    final applications = await _firestore
        .collection('applications')
        .where('job_seeker_id', isEqualTo: uid)
        .get();
    statApplied.value = applications.docs.length;
    statReviewed.value = applications.docs
        .where((doc) => (doc.data()['status'] ?? '') == 'interview')
        .length;
    statInterviews.value = applications.docs
        .where((doc) => (doc.data()['status'] ?? '') == 'accepted')
        .length;
  }

  void toggleTheme(bool value) {
    _themeController.toggleTheme();
    update();
  }

  void changeLanguage() {
    if (Get.locale?.languageCode == 'en') {
      _localizationController.changeLanguage('ar');
    } else {
      _localizationController.changeLanguage('en');
    }
    update();
  }

  Future<void> pickProfileImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
      withData: true,
    );

    final file = result?.files.single;
    if (file == null || file.bytes == null) {
      return;
    }

    try {
      isUploadingImage.value = true;
      _pendingAvatarBytes = await _compressImage(file.bytes!);
      userImage.value = '';
      Get.snackbar('success_title'.tr, 'msg_profile_image_ready'.tr);
    } catch (e) {
      Get.snackbar('err_title'.tr, 'err_profile_image_pick'.trParams({'error': e.toString()}));
    } finally {
      isUploadingImage.value = false;
    }
  }

  Future<void> saveProfileChanges() async {
    final user = _auth.currentUser;
    if (user == null) {
      Get.snackbar('err_title'.tr, 'auth_err_no_user_logged_in'.tr);
      return;
    }
    if (editNameCtrl.text.trim().isEmpty) {
      Get.snackbar('err_title'.tr, 'err_name_required'.tr);
      return;
    }

    try {
      isSaving.value = true;
      String? uploadedAvatarUrl = userImage.value;
      if (_pendingAvatarBytes != null) {
        final ref = _storage.ref().child('profile_images/${user.uid}/avatar.png');
        await ref.putData(
          _pendingAvatarBytes!,
          SettableMetadata(contentType: 'image/png'),
        );
        uploadedAvatarUrl = await ref.getDownloadURL();
      }

      final isCompany = userRole.value == 'company';
      final payload = <String, dynamic>{
        'updatedAt': FieldValue.serverTimestamp(),
        'profile_image_url': uploadedAvatarUrl ?? '',
        'headline': editJobCtrl.text.trim(),
        'bio': editBioCtrl.text.trim(),
      };
      if (isCompany) {
        payload['companyName'] = editNameCtrl.text.trim();
      } else {
        payload['fullName'] = editNameCtrl.text.trim();
      }

      await _firestore.collection('users').doc(user.uid).set(payload, SetOptions(merge: true));
      if (!isCompany) {
        await user.updateDisplayName(editNameCtrl.text.trim());
      }

      _pendingAvatarBytes = null;
      await loadProfile();
      Get.back();
      Get.snackbar(
        'success_title'.tr,
        'msg_profile_updated'.tr,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e, stackTrace) {
      developer.log(
        'Failed to save profile: $e',
        name: 'ProfileController',
        error: e,
        stackTrace: stackTrace,
      );
      Get.snackbar('err_title'.tr, 'err_profile_save'.trParams({'error': e.toString()}));
    } finally {
      isSaving.value = false;
    }
  }

  void logout() {
    Get.defaultDialog(
      title: 'lbl_logout'.tr,
      middleText: 'msg_logout_confirm'.tr,
      textConfirm: 'btn_yes_logout'.tr,
      textCancel: 'btn_cancel'.tr,
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () async {
        Get.back();
        await _authController.logout();
        Get.offAllNamed(Routes.AUTH_LOGIN);
      },
    );
  }

  void confirmDeleteAccount() {
    Get.defaultDialog(
      title: 'delete_account_title'.tr,
      middleText: 'delete_account_message'.tr,
      textConfirm: 'delete_account_cta'.tr,
      textCancel: 'btn_cancel'.tr,
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: deleteAccount,
    );
  }

  Future<void> deleteAccount() async {
    final user = _auth.currentUser;
    if (user == null) {
      return;
    }

    try {
      isDeleting.value = true;
      Get.back();
      await _firestore.collection('users').doc(user.uid).delete();
      await user.delete();
      await _authController.logout();
      Get.offAllNamed(Routes.AUTH_LOGIN);
      Get.snackbar('success_title'.tr, 'delete_account_success'.tr);
    } catch (e) {
      Get.snackbar('err_title'.tr, 'delete_account_error'.trParams({'error': e.toString()}));
    } finally {
      isDeleting.value = false;
    }
  }

  String _resolveDisplayName(Map<String, dynamic> data, User user) {
    final role = (data['role'] as String?) ?? 'jobSeeker';
    if (role == 'company') {
      return ((data['companyName'] as String?)?.trim().isNotEmpty == true)
          ? (data['companyName'] as String).trim()
          : (user.email?.split('@').first ?? 'Company');
    }
    return ((data['fullName'] as String?)?.trim().isNotEmpty == true)
        ? (data['fullName'] as String).trim()
        : (user.displayName?.trim().isNotEmpty == true
            ? user.displayName!.trim()
            : (user.email?.split('@').first ?? 'User'));
  }

  String _resolveHeadline(Map<String, dynamic> data) {
    final headline = (data['headline'] as String?)?.trim();
    if (headline != null && headline.isNotEmpty) {
      return headline;
    }
    if (userRole.value == 'company') {
      return 'role_employer'.tr;
    }
    if (userRole.value == 'admin') {
      return 'role_admin_title'.tr;
    }
    return (data['ai_job_title'] as String?)?.trim().isNotEmpty == true
        ? (data['ai_job_title'] as String).trim()
        : 'role_seeker'.tr;
  }

  Future<Uint8List> _compressImage(Uint8List originalBytes) async {
    final codec = await ui.instantiateImageCodec(
      originalBytes,
      targetWidth: 512,
      targetHeight: 512,
    );
    final frame = await codec.getNextFrame();
    final byteData = await frame.image.toByteData(format: ui.ImageByteFormat.png);
    if (byteData == null) {
      throw Exception('err_file_not_readable'.tr);
    }
    return byteData.buffer.asUint8List();
  }

  @override
  void onClose() {
    editNameCtrl.dispose();
    editJobCtrl.dispose();
    editBioCtrl.dispose();
    super.onClose();
  }
}
