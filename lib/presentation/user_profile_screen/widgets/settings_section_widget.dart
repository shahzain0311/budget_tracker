import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SettingsSectionWidget extends StatelessWidget {
  final String title;
  final List<Map<String, dynamic>> items;

  const SettingsSectionWidget({
    super.key,
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 2.w),
          child: Text(
            title,
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
        ),
        SizedBox(height: 1.5.h),
        Container(
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppTheme.lightTheme.colorScheme.shadow
                    .withValues(alpha: 0.05),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isLast = index == items.length - 1;

              return _buildSettingItem(
                context: context,
                item: item,
                isLast: isLast,
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingItem({
    required BuildContext context,
    required Map<String, dynamic> item,
    required bool isLast,
  }) {
    final hasSwitch = item['hasSwitch'] == true;
    final switchValue = item['switchValue'] ?? false;
    final onSwitchChanged = item['onSwitchChanged'];
    final onTap = item['onTap'];

    return Container(
      decoration: BoxDecoration(
        border: !isLast
            ? Border(
                bottom: BorderSide(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.2),
                  width: 1,
                ),
              )
            : null,
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        leading: Container(
          width: 10.w,
          height: 10.w,
          decoration: BoxDecoration(
            color:
                AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: CustomIconWidget(
            iconName: item['icon'] ?? 'settings',
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 20,
          ),
        ),
        title: Text(
          item['title'] ?? '',
          style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w500,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: item['subtitle'] != null
            ? Text(
                item['subtitle'],
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
                overflow: TextOverflow.ellipsis,
              )
            : null,
        trailing: hasSwitch
            ? Switch(
                value: switchValue,
                onChanged: onSwitchChanged,
                activeColor: AppTheme.lightTheme.colorScheme.primary,
                activeTrackColor: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.3),
                inactiveThumbColor:
                    AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                inactiveTrackColor: AppTheme
                    .lightTheme.colorScheme.onSurfaceVariant
                    .withValues(alpha: 0.2),
              )
            : CustomIconWidget(
                iconName: 'chevron_right',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 20,
              ),
        onTap: hasSwitch ? null : onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
