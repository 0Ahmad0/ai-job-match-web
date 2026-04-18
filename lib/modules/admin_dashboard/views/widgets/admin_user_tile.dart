import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AdminUserTile extends StatelessWidget {
  const AdminUserTile({
    super.key,
    required this.name,
    required this.type,
    required this.status,
    required this.onApprove,
    required this.onBlock,
  });

  final String name;
  final String type;
  final String status;
  final VoidCallback onApprove;
  final VoidCallback onBlock;

  @override
  Widget build(BuildContext context) {
    final statusColor = status == 'Pending'
        ? Colors.orange
        : (status == 'Reported' ? Colors.red : Colors.green);

    final typeLabel =
        type == 'Employer' ? 'user_type_employer'.tr : 'user_type_seeker'.tr;
    final statusLabel = status == 'Pending'
        ? 'status_pending'.tr
        : status == 'Blocked'
            ? 'status_blocked'.tr
            : status == 'Active'
                ? 'status_active'.tr
                : status;

    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: context.theme.cardColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border(left: BorderSide(color: statusColor, width: 4)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.grey.shade200,
            child: Icon(
              type == 'Employer' ? Icons.business : Icons.person,
              color: Colors.grey,
            ),
          ),
          15.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
                ),
                Text(
                  '$typeLabel - $statusLabel',
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onApprove,
            icon: const Icon(Icons.check_circle_outline, color: Colors.green),
            tooltip: 'btn_approve'.tr,
          ),
          IconButton(
            onPressed: onBlock,
            icon: const Icon(Icons.block, color: Colors.red),
            tooltip: 'btn_block'.tr,
          ),
        ],
      ),
    );
  }
}
