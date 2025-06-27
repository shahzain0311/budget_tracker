import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MonthlyOverviewCardWidget extends StatelessWidget {
  final double totalBudget;
  final double totalSpent;
  final double remainingBalance;

  const MonthlyOverviewCardWidget({
    super.key,
    required this.totalBudget,
    required this.totalSpent,
    required this.remainingBalance,
  });

  @override
  Widget build(BuildContext context) {
    final double progressPercentage =
        totalBudget > 0 ? (totalSpent / totalBudget) : 0;
    final bool isOverBudget = totalSpent > totalBudget;
    final Color progressColor = isOverBudget
        ? AppTheme.lightTheme.colorScheme.error
        : progressPercentage > 0.8
            ? AppTheme.getWarningColor(true)
            : AppTheme.lightTheme.colorScheme.primary;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Monthly Budget',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: AppTheme.lightTheme.colorScheme.onSurface
                      .withValues(alpha: 0.7),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: progressColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${(progressPercentage * 100).toInt()}%',
                  style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                    color: progressColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),

          // Budget Amount
          Text(
            '\$${totalBudget.toStringAsFixed(0)}',
            style: AppTheme.lightTheme.textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 1.h),

          // Progress Bar
          Container(
            width: double.infinity,
            height: 8,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: progressPercentage.clamp(0.0, 1.0),
              child: Container(
                decoration: BoxDecoration(
                  color: progressColor,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
          SizedBox(height: 3.h),

          // Spent and Remaining
          Row(
            children: [
              Expanded(
                child: _buildAmountInfo(
                  label: 'Spent',
                  amount: totalSpent,
                  color: AppTheme.lightTheme.colorScheme.error,
                  icon: 'trending_down',
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: _buildAmountInfo(
                  label: 'Remaining',
                  amount: remainingBalance,
                  color: AppTheme.getSuccessColor(true),
                  icon: 'account_balance_wallet',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAmountInfo({
    required String label,
    required double amount,
    required Color color,
    required String icon,
  }) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: icon,
                color: color,
                size: 16,
              ),
              SizedBox(width: 2.w),
              Text(
                label,
                style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            '\$${amount.toStringAsFixed(0)}',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
