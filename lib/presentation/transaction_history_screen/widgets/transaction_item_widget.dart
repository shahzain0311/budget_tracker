import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TransactionItemWidget extends StatelessWidget {
  final Map<String, dynamic> transaction;
  final String searchQuery;
  final Function(Offset) onLongPress;
  final VoidCallback onEdit;
  final VoidCallback onDuplicate;
  final VoidCallback onDelete;

  const TransactionItemWidget({
    super.key,
    required this.transaction,
    required this.searchQuery,
    required this.onLongPress,
    required this.onEdit,
    required this.onDuplicate,
    required this.onDelete,
  });

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'food & dining':
        return Colors.orange;
      case 'transport':
        return Colors.blue;
      case 'shopping':
        return Colors.purple;
      case 'entertainment':
        return Colors.red;
      case 'investment':
        return AppTheme.getSuccessColor(true);
      case 'income':
        return AppTheme.getSuccessColor(true);
      default:
        return AppTheme.lightTheme.colorScheme.primary;
    }
  }

  String _formatAmount(double amount) {
    String sign = amount >= 0 ? '+' : '';
    return '$sign\$${amount.abs().toStringAsFixed(2)}';
  }

  String _formatTime(DateTime timestamp) {
    int hour = timestamp.hour;
    int minute = timestamp.minute;
    String period = hour >= 12 ? 'PM' : 'AM';
    hour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period';
  }

  Widget _buildHighlightedText(String text, String query) {
    if (query.isEmpty) {
      return Text(text);
    }

    List<TextSpan> spans = [];
    String lowerText = text.toLowerCase();
    String lowerQuery = query.toLowerCase();

    int start = 0;
    int index = lowerText.indexOf(lowerQuery);

    while (index != -1) {
      if (index > start) {
        spans.add(TextSpan(text: text.substring(start, index)));
      }

      spans.add(TextSpan(
        text: text.substring(index, index + query.length),
        style: TextStyle(
          backgroundColor:
              AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.3),
          fontWeight: FontWeight.w600,
        ),
      ));

      start = index + query.length;
      index = lowerText.indexOf(lowerQuery, start);
    }

    if (start < text.length) {
      spans.add(TextSpan(text: text.substring(start)));
    }

    return RichText(
      text: TextSpan(
        style: AppTheme.lightTheme.textTheme.titleMedium,
        children: spans,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double amount = transaction['amount'] as double;
    final bool isIncome = amount >= 0;
    final Color amountColor = isIncome
        ? AppTheme.getSuccessColor(true)
        : AppTheme.lightTheme.colorScheme.onSurface;

    return GestureDetector(
      onLongPressStart: (details) {
        onLongPress(details.globalPosition);
      },
      child: Dismissible(
        key: Key(transaction['id'] as String),
        background: Container(
          margin: EdgeInsets.symmetric(vertical: 1.h),
          decoration: BoxDecoration(
            color: AppTheme.getSuccessColor(true).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(left: 6.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomIconWidget(
                iconName: 'edit',
                size: 24,
                color: AppTheme.getSuccessColor(true),
              ),
              SizedBox(height: 0.5.h),
              Text(
                'Edit',
                style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                  color: AppTheme.getSuccessColor(true),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        secondaryBackground: Container(
          margin: EdgeInsets.symmetric(vertical: 1.h),
          decoration: BoxDecoration(
            color: AppTheme.getErrorColor(true).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.centerRight,
          padding: EdgeInsets.only(right: 6.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomIconWidget(
                iconName: 'delete',
                size: 24,
                color: AppTheme.getErrorColor(true),
              ),
              SizedBox(height: 0.5.h),
              Text(
                'Delete',
                style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                  color: AppTheme.getErrorColor(true),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        confirmDismiss: (direction) async {
          if (direction == DismissDirection.startToEnd) {
            onEdit();
            return false;
          } else if (direction == DismissDirection.endToStart) {
            onDelete();
            return false;
          }
          return false;
        },
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 1.h),
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              // Category Icon
              Container(
                width: 12.w,
                height: 12.w,
                decoration: BoxDecoration(
                  color: _getCategoryColor(transaction['category'] as String)
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: CustomIconWidget(
                    iconName: transaction['categoryIcon'] as String,
                    size: 24,
                    color: _getCategoryColor(transaction['category'] as String),
                  ),
                ),
              ),

              SizedBox(width: 4.w),

              // Transaction Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHighlightedText(
                      transaction['merchantName'] as String,
                      searchQuery,
                    ),
                    SizedBox(height: 0.5.h),
                    Row(
                      children: [
                        Text(
                          transaction['category'] as String,
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        Text(
                          ' • ',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        Text(
                          _formatTime(transaction['timestamp'] as DateTime),
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    if (transaction['description'] != null &&
                        (transaction['description'] as String).isNotEmpty)
                      Padding(
                        padding: EdgeInsets.only(top: 0.5.h),
                        child: Text(
                          transaction['description'] as String,
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant
                                .withValues(alpha: 0.7),
                            fontStyle: FontStyle.italic,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
                ),
              ),

              // Amount
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _formatAmount(amount),
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      color: amountColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (isIncome)
                    Container(
                      margin: EdgeInsets.only(top: 0.5.h),
                      padding: EdgeInsets.symmetric(
                          horizontal: 2.w, vertical: 0.5.h),
                      decoration: BoxDecoration(
                        color: AppTheme.getSuccessColor(true)
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'Income',
                        style:
                            AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                          color: AppTheme.getSuccessColor(true),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
