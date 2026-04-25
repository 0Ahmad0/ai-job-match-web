import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/common/app_ui.dart';

class SupportView extends StatefulWidget {
  const SupportView({super.key});

  @override
  State<SupportView> createState() => _SupportViewState();
}

class _SupportViewState extends State<SupportView> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _messageCtrl = TextEditingController();

  bool _isSubmitting = false;
  bool _isRoleLoading = true;
  bool _isAdmin = false;
  final Set<String> _updatingTicketIds = <String>{};

  @override
  void initState() {
    super.initState();
    _loadUserRole();
  }

  @override
  void dispose() {
    _messageCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadUserRole() async {
    final user = _auth.currentUser;
    if (user == null) {
      if (mounted) {
        setState(() => _isRoleLoading = false);
      }
      return;
    }

    try {
      final doc = await _firestore.collection('users').doc(user.uid).get();
      final role = (doc.data()?['role'] as String?)?.toLowerCase().trim();
      if (!mounted) return;
      setState(() {
        _isAdmin = role == 'admin';
        _isRoleLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _isRoleLoading = false);
    }
  }

  Future<void> _submitTicket() async {
    final user = _auth.currentUser;
    final message = _messageCtrl.text.trim();
    if (user == null) {
      Get.snackbar('err_title'.tr, 'auth_err_no_user_logged_in'.tr);
      return;
    }
    if (message.isEmpty) {
      Get.snackbar('err_title'.tr, 'support_message_required'.tr);
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      final now = Timestamp.now();
      await _firestore.collection('support_tickets').add({
        'message': message,
        'userId': user.uid,
        'userEmail': user.email ?? '',
        'status': 'pending',
        'createdAt': now,
        'updatedAt': now,
      });
      _messageCtrl.clear();
      if (!mounted) return;
      Get.rawSnackbar(
        message: 'support_sent_success'.tr,
        duration: const Duration(seconds: 2),
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(12),
        borderRadius: 10,
      );
    } catch (e) {
      Get.snackbar('err_title'.tr, e.toString());
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  Future<void> _updateTicketStatus(String ticketId, String newStatus) async {
    setState(() => _updatingTicketIds.add(ticketId));
    try {
      await _firestore.collection('support_tickets').doc(ticketId).update({
        'status': newStatus,
        'updatedAt': Timestamp.now(),
      });
      Get.snackbar('success_title'.tr, 'support_status_updated'.tr);
    } catch (e) {
      Get.snackbar('err_title'.tr, e.toString());
    } finally {
      if (mounted) {
        setState(() => _updatingTicketIds.remove(ticketId));
      }
    }
  }

  Future<void> _replyToTicket({
    required String ticketId,
    String initialReply = '',
  }) async {
    final replyCtrl = TextEditingController(text: initialReply);
    await Get.defaultDialog(
      title: 'support_admin_reply'.tr,
      content: Column(
        children: [
          TextField(
            controller: replyCtrl,
            minLines: 3,
            maxLines: 6,
            decoration: InputDecoration(
              hintText: 'support_reply_hint'.tr,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
            ),
          ),
        ],
      ),
      textConfirm: 'lbl_save_changes'.tr,
      textCancel: 'btn_cancel'.tr,
      confirmTextColor: Colors.white,
      onConfirm: () async {
        final reply = replyCtrl.text.trim();
        if (reply.isEmpty) {
          Get.snackbar('err_title'.tr, 'support_reply_required'.tr);
          return;
        }

        Get.back();
        setState(() => _updatingTicketIds.add(ticketId));
        try {
          final admin = _auth.currentUser;
          await _firestore.collection('support_tickets').doc(ticketId).update({
            'adminReply': reply,
            'repliedBy': admin?.uid ?? '',
            'repliedAt': Timestamp.now(),
            'status': 'in_progress',
            'updatedAt': Timestamp.now(),
          });
          Get.snackbar('success_title'.tr, 'support_reply_saved'.tr);
        } catch (e) {
          Get.snackbar('err_title'.tr, e.toString());
        } finally {
          if (mounted) {
            setState(() => _updatingTicketIds.remove(ticketId));
          }
        }
      },
    );
  }

  Stream<QuerySnapshot<Map<String, dynamic>>>? _ticketsStream(User? user) {
    if (_isAdmin) {
      return _firestore.collection('support_tickets').orderBy('updatedAt', descending: true).snapshots();
    }
    if (user == null) {
      return null;
    }
    return _firestore
        .collection('support_tickets')
        .where('userId', isEqualTo: user.uid)
        .orderBy('updatedAt', descending: true)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;
    final ticketsStream = _ticketsStream(user);

    return Scaffold(
      appBar: AppBar(title: Text('support_title'.tr)),
      body: _isRoleLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: AppPageContainer(
                maxWidth: 900,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppSectionHeader(
                      title: 'support_title'.tr,
                      subtitle: _isAdmin ? 'support_admin_subtitle'.tr : 'support_subtitle'.tr,
                    ),
                    20.verticalSpace,
                    if (!_isAdmin) _buildUserComposerCard(context),
                    if (!_isAdmin) 20.verticalSpace,
                    Text(
                      _isAdmin ? 'support_all_tickets'.tr : 'support_previous_tickets'.tr,
                      style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    10.verticalSpace,
                    if (ticketsStream == null)
                      AppStateCard(
                        icon: Icons.lock_outline,
                        title: 'err_title'.tr,
                        message: 'auth_err_no_user_logged_in'.tr,
                      )
                    else
                      StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        stream: ticketsStream,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          }

                          final docs = snapshot.data?.docs ?? const [];
                          if (docs.isEmpty) {
                            return AppStateCard(
                              icon: Icons.mark_email_unread_outlined,
                              title: 'support_no_tickets_title'.tr,
                              message: 'support_no_tickets_desc'.tr,
                            );
                          }

                          return Column(
                            children: docs.map((doc) {
                              final data = doc.data();
                              final status = (data['status'] as String? ?? 'pending').toLowerCase();
                              final createdAt = (data['createdAt'] as Timestamp?)?.toDate();
                              final adminReply = (data['adminReply'] as String?)?.trim() ?? '';
                              final statusMeta = _ticketStatusMeta(status);
                              final isUpdating = _updatingTicketIds.contains(doc.id);

                              return Container(
                                width: double.infinity,
                                margin: EdgeInsets.only(bottom: 12.h),
                                padding: EdgeInsets.all(14.r),
                                decoration: BoxDecoration(
                                  color: context.theme.cardColor,
                                  borderRadius: BorderRadius.circular(12.r),
                                  border: Border.all(color: context.theme.dividerColor),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(statusMeta.icon, color: statusMeta.color, size: 16.sp),
                                        6.horizontalSpace,
                                        Text(
                                          statusMeta.label,
                                          style: TextStyle(
                                            color: statusMeta.color,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12.sp,
                                          ),
                                        ),
                                        const Spacer(),
                                        Text(
                                          createdAt == null
                                              ? '-'
                                              : '${createdAt.year}-${createdAt.month.toString().padLeft(2, '0')}-${createdAt.day.toString().padLeft(2, '0')}',
                                          style: TextStyle(color: Colors.grey, fontSize: 11.sp),
                                        ),
                                      ],
                                    ),
                                    if (_isAdmin) ...[
                                      6.verticalSpace,
                                      Text(
                                        '${'email_label'.tr}: ${(data['userEmail'] as String?) ?? '-'}',
                                        style: TextStyle(color: Colors.grey, fontSize: 12.sp),
                                      ),
                                    ],
                                    10.verticalSpace,
                                    Text(data['message']?.toString() ?? ''),
                                    if (adminReply.isNotEmpty) ...[
                                      10.verticalSpace,
                                      Container(
                                        width: double.infinity,
                                        padding: EdgeInsets.all(10.r),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10.r),
                                          color: context.theme.primaryColor.withValues(alpha: 0.08),
                                        ),
                                        child: Text(
                                          '${'support_admin_reply'.tr}: $adminReply',
                                          style: context.textTheme.bodyMedium,
                                        ),
                                      ),
                                    ],
                                    if (_isAdmin) ...[
                                      10.verticalSpace,
                                      Wrap(
                                        spacing: 8.w,
                                        runSpacing: 8.h,
                                        children: [
                                          OutlinedButton(
                                            onPressed: isUpdating
                                                ? null
                                                : () => _replyToTicket(
                                                      ticketId: doc.id,
                                                      initialReply: adminReply,
                                                    ),
                                            child: Text('support_admin_reply'.tr),
                                          ),
                                          PopupMenuButton<String>(
                                            enabled: !isUpdating,
                                            onSelected: (value) => _updateTicketStatus(doc.id, value),
                                            itemBuilder: (_) => [
                                              PopupMenuItem(
                                                value: 'pending',
                                                child: Text('support_status_pending'.tr),
                                              ),
                                              PopupMenuItem(
                                                value: 'in_progress',
                                                child: Text('support_status_in_progress'.tr),
                                              ),
                                              PopupMenuItem(
                                                value: 'resolved',
                                                child: Text('support_status_resolved'.tr),
                                              ),
                                            ],
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 14.w,
                                                vertical: 10.h,
                                              ),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(8.r),
                                                border: Border.all(
                                                  color: context.theme.dividerColor,
                                                ),
                                              ),
                                              child: Text(
                                                isUpdating
                                                    ? 'loading'.tr
                                                    : 'support_change_status'.tr,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ],
                                ),
                              );
                            }).toList(),
                          );
                        },
                      ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildUserComposerCard(BuildContext context) {
    return AppThemedCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'support_send_to_admin'.tr,
            style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          12.verticalSpace,
          TextField(
            controller: _messageCtrl,
            minLines: 3,
            maxLines: 6,
            decoration: InputDecoration(
              hintText: 'support_message_hint'.tr,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
            ),
          ),
          12.verticalSpace,
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isSubmitting ? null : _submitTicket,
              child: Text(_isSubmitting ? 'loading'.tr : 'support_send_ticket'.tr),
            ),
          ),
        ],
      ),
    );
  }

  _TicketStatusMeta _ticketStatusMeta(String status) {
    switch (status) {
      case 'resolved':
        return _TicketStatusMeta(
          'support_status_resolved'.tr,
          Colors.green,
          Icons.check_circle_outline,
        );
      case 'in_progress':
        return _TicketStatusMeta(
          'support_status_in_progress'.tr,
          Colors.indigo,
          Icons.pending_actions_outlined,
        );
      default:
        return _TicketStatusMeta(
          'support_status_pending'.tr,
          Colors.orange,
          Icons.hourglass_top_outlined,
        );
    }
  }
}

class _TicketStatusMeta {
  final String label;
  final Color color;
  final IconData icon;

  _TicketStatusMeta(this.label, this.color, this.icon);
}
