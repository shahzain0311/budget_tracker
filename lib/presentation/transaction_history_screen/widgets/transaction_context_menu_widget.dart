import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TransactionContextMenuWidget extends StatelessWidget {
  final Map<String, dynamic> transaction;
  final VoidCallback onEdit;
  final VoidCallback onDuplicate;
  final VoidCallback onShare;
  final VoidCallback onDelete;

  const TransactionContextMenuWidget({
    super.key,
    required this.transaction,
    required this.onEdit,
    required this.onDuplicate,
    required this.onShare,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50.w,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color:
                AppTheme.lightTheme.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildMenuItem(
            icon: 'edit',
            title: 'Edit',
            onTap: onEdit,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
          _buildDivider(),
          _buildMenuItem(
            icon: 'content_copy',
            title: 'Duplicate',
            onTap: onDuplicate,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
          _buildDivider(),
          _buildMenuItem(
            icon: 'share',
            title: 'Share',
            onTap: onShare,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
          _buildDivider(),
          _buildMenuItem(
            icon: 'delete',
            title: 'Delete',
            onTap: onDelete,
            color: AppTheme.getErrorColor(true),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required String icon,
    required String title,
    required VoidCallback onTap,
    required Color color,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        child: Row(
          children: [
            CustomIconWidget(
              iconName: icon,
              size: 20,
              color: color,
            ),
            SizedBox(width: 3.w),
            Text(
              title,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
    );
  }
}
