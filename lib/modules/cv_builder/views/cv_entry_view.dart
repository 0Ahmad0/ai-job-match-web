import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';

import '../../../routes/app_routes.dart';

class CvEntryView extends StatefulWidget {
  const CvEntryView({super.key});

  @override
  State<CvEntryView> createState() => _CvEntryViewState();
}

class _CvEntryViewState extends State<CvEntryView> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Map<String, dynamic>> _draftCvs = [];
  bool _isLoading = true;
  bool _isNavigating = false;

  @override
  void initState() {
    super.initState();
    _loadDraftCvs();
  }

  Future<void> _loadDraftCvs() async {
    final user = _auth.currentUser;
    if (user == null) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
      return;
    }

    try {
      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      final data = userDoc.data() ?? const <String, dynamic>{};
      final manualCv = (data['manual_cv'] as Map<String, dynamic>?) ?? const <String, dynamic>{};

      if (!mounted) return;
      setState(() {
        if (manualCv.isNotEmpty && manualCv['fullName']?.toString().isNotEmpty == true) {
          _draftCvs = [
            {
              'id': 'current_draft',
              'name': manualCv['fullName'] ?? 'Untitled Draft',
              'updatedAt': data['updatedAt'] as Timestamp?,
              'jobTitle': manualCv['jobTitle'] ?? '',
              'isDraft': true,
            },
          ];
        }
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _createNewCv() {
    _navigateToBuilder(isNew: true);
  }

  void _continueDraft() {
    _navigateToBuilder(isNew: false);
  }

  void _navigateToBuilder({required bool isNew}) {
    if (_isNavigating) return;
    setState(() => _isNavigating = true);
    FocusManager.instance.primaryFocus?.unfocus();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      Future<void>.delayed(const Duration(milliseconds: 16), () {
        if (!mounted) return;
        Get.toNamed(Routes.CV_BUILDER, arguments: {'isNew': isNew})?.whenComplete(() {
          if (mounted) {
            setState(() => _isNavigating = false);
          }
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('lbl_start_cv'.tr),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(24.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FadeInDown(
                    child: Text(
                      'lbl_choose_cv_option'.tr,
                      style: context.textTheme.headlineMedium?.copyWith(fontSize: 20.sp),
                    ),
                  ),
                  24.verticalSpace,

                  // Draft CVs section
                  if (_draftCvs.isNotEmpty) ...[
                    FadeInUp(
                      delay: const Duration(milliseconds: 100),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(20.r),
                        decoration: BoxDecoration(
                          color: context.theme.primaryColor.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(18.r),
                          border: Border.all(color: context.theme.primaryColor.withValues(alpha: 0.2)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.edit_note, color: context.theme.primaryColor, size: 24.sp),
                                12.horizontalSpace,
                                Expanded(
                                  child: Text(
                                    'lbl_saved_draft'.tr,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.sp,
                                      color: context.theme.primaryColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            16.verticalSpace,
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(16.r),
                              decoration: BoxDecoration(
                                color: context.theme.cardColor,
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _draftCvs.first['name'] as String,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp),
                                  ),
                                  if ((_draftCvs.first['jobTitle'] as String?)?.isNotEmpty == true) ...[
                                    6.verticalSpace,
                                    Text(
                                      _draftCvs.first['jobTitle'] as String,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(color: Colors.grey, fontSize: 13.sp),
                                    ),
                                  ],
                                  if (_draftCvs.first['updatedAt'] != null) ...[
                                    8.verticalSpace,
                                    Text(
                                      'lbl_last_updated'.trParams({
                                        'date': _formatTimestamp(_draftCvs.first['updatedAt'] as Timestamp?),
                                      }),
                                      style: TextStyle(color: Colors.grey.shade600, fontSize: 11.sp),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            16.verticalSpace,
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: _isNavigating ? null : _continueDraft,
                                icon: const Icon(Icons.arrow_forward),
                                label: Text('btn_continue_draft'.tr),
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(vertical: 14.h),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    20.verticalSpace,
                  ],

                  // Create New CV section
                  FadeInUp(
                    delay: const Duration(milliseconds: 200),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(20.r),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(18.r),
                        border: Border.all(color: Colors.green.withValues(alpha: 0.2)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.add_circle_outline, color: Colors.green, size: 24),
                              12.horizontalSpace,
                              Expanded(
                                child: Text(
                                  'lbl_create_new_cv'.tr,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.green,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          12.verticalSpace,
                          Text(
                            'msg_new_cv_desc'.tr,
                            style: TextStyle(color: Colors.grey.shade700, fontSize: 13.sp),
                          ),
                          16.verticalSpace,
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                               onPressed: _isNavigating ? null : _createNewCv,
                              icon: const Icon(Icons.add),
                              label: Text('btn_create_new'.tr),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(vertical: 14.h),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  String _formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) return '';
    try {
      final date = timestamp.toDate();
      final now = DateTime.now();
      final diff = now.difference(date);
      if (diff.inMinutes < 1) return 'lbl_just_now'.tr;
      if (diff.inMinutes < 60) return 'lbl_minutes_ago'.trParams({'minutes': diff.inMinutes.toString()});
      if (diff.inHours < 24) return 'lbl_hours_ago'.trParams({'hours': diff.inHours.toString()});
      if (diff.inDays < 7) return 'lbl_days_ago'.trParams({'days': diff.inDays.toString()});
      return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    } catch (_) {
      return '';
    }
  }
}
