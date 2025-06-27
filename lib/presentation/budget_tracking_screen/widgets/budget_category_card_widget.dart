import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BudgetCategoryCardWidget extends StatefulWidget {
  final Map<String, dynamic> category;
  final VoidCallback onTap;

  const BudgetCategoryCardWidget({
    super.key,
    required this.category,
    required this.onTap,
  });

  @override
  State<BudgetCategoryCardWidget> createState() =>
      _BudgetCategoryCardWidgetState();
}

class _BudgetCategoryCardWidgetState extends State<BudgetCategoryCardWidget>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final String name = widget.category["name"] as String;
    final String icon = widget.category["icon"] as String;
    final double allocated = widget.category["allocated"] as double;
    final double spent = widget.category["spent"] as double;
    final int colorValue = widget.category["color"] as int;
    final List<dynamic> transactions = widget.category["transactions"] as List;

    final double progressPercentage = allocated > 0 ? (spent / allocated) : 0;
    final Color categoryColor = Color(colorValue);
    final Color progressColor = progressPercentage > 1.0
        ? AppTheme.lightTheme.colorScheme.error
        : progressPercentage > 0.8
            ? AppTheme.getWarningColor(true)
            : categoryColor;

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Main Card Content
          InkWell(
            onTap: _toggleExpansion,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: EdgeInsets.all(5.w),
              child: Column(
                children: [
                  // Header Row
                  Row(
                    children: [
                      // Category Icon
                      Container(
                        width: 12.w,
                        height: 12.w,
                        decoration: BoxDecoration(
                          color: categoryColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: CustomIconWidget(
                            iconName: icon,
                            color: categoryColor,
                            size: 24,
                          ),
                        ),
                      ),
                      SizedBox(width: 4.w),

                      // Category Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: AppTheme.lightTheme.textTheme.titleMedium
                                  ?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 0.5.h),
                            Text(
                              '\$${spent.toStringAsFixed(0)} of \$${allocated.toStringAsFixed(0)}',
                              style: AppTheme.lightTheme.textTheme.bodyMedium
                                  ?.copyWith(
                                color: AppTheme.lightTheme.colorScheme.onSurface
                                    .withValues(alpha: 0.6),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Percentage and Arrow
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 2.w, vertical: 0.5.h),
                            decoration: BoxDecoration(
                              color: progressColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${(progressPercentage * 100).toInt()}%',
                              style: AppTheme.lightTheme.textTheme.labelSmall
                                  ?.copyWith(
                                color: progressColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          SizedBox(height: 1.h),
                          AnimatedRotation(
                            turns: _isExpanded ? 0.5 : 0,
                            duration: const Duration(milliseconds: 300),
                            child: CustomIconWidget(
                              iconName: 'keyboard_arrow_down',
                              color: AppTheme.lightTheme.colorScheme.onSurface
                                  .withValues(alpha: 0.6),
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 3.h),

                  // Progress Bar
                  Container(
                    width: double.infinity,
                    height: 6,
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.outline
                          .withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: progressPercentage.clamp(0.0, 1.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: progressColor,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Expandable Transactions Section
          SizeTransition(
            sizeFactor: _expandAnimation,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(5.w, 0, 5.w, 5.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(
                    color: AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.2),
                    height: 1,
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    'Recent Transactions',
                    style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  transactions.isNotEmpty
                      ? ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount:
                              transactions.length > 3 ? 3 : transactions.length,
                          separatorBuilder: (context, index) =>
                              SizedBox(height: 2.h),
                          itemBuilder: (context, index) {
                            final transaction =
                                transactions[index] as Map<String, dynamic>;
                            return _buildTransactionItem(transaction);
                          },
                        )
                      : Container(
                          padding: EdgeInsets.all(4.w),
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.colorScheme.surface,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              CustomIconWidget(
                                iconName: 'info_outline',
                                color: AppTheme.lightTheme.colorScheme.onSurface
                                    .withValues(alpha: 0.6),
                                size: 20,
                              ),
                              SizedBox(width: 3.w),
                              Text(
                                'No transactions yet',
                                style: AppTheme.lightTheme.textTheme.bodyMedium
                                    ?.copyWith(
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurface
                                      .withValues(alpha: 0.6),
                                ),
                              ),
                            ],
                          ),
                        ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionItem(Map<String, dynamic> transaction) {
    final String title = transaction["title"] as String;
    final double amount = transaction["amount"] as double;
    final String date = transaction["date"] as String;

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 10.w,
            height: 10.w,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primary
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: 'receipt',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 16,
              ),
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 0.5.h),
                Text(
                  date,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurface
                        .withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
          Text(
            '-\$${amount.toStringAsFixed(0)}',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.lightTheme.colorScheme.error,
            ),
          ),
        ],
      ),
    );
  }
}
