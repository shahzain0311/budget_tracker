import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FilterBottomSheetWidget extends StatefulWidget {
  final Map<String, dynamic> activeFilters;
  final Function(Map<String, dynamic>) onFiltersApplied;

  const FilterBottomSheetWidget({
    super.key,
    required this.activeFilters,
    required this.onFiltersApplied,
  });

  @override
  State<FilterBottomSheetWidget> createState() =>
      _FilterBottomSheetWidgetState();
}

class _FilterBottomSheetWidgetState extends State<FilterBottomSheetWidget> {
  late Map<String, dynamic> _tempFilters;

  final List<String> _categories = [
    'All Categories',
    'Food & Dining',
    'Transport',
    'Shopping',
    'Entertainment',
    'Investment',
    'Income',
  ];

  String _selectedCategory = 'All Categories';
  RangeValues _amountRange = RangeValues(0, 1000);
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _tempFilters = Map.from(widget.activeFilters);

    // Initialize UI state from active filters
    if (_tempFilters.containsKey('category')) {
      _selectedCategory = _tempFilters['category'] as String;
    }

    if (_tempFilters.containsKey('minAmount') &&
        _tempFilters.containsKey('maxAmount')) {
      _amountRange = RangeValues(
        (_tempFilters['minAmount'] as double).toDouble(),
        (_tempFilters['maxAmount'] as double).toDouble(),
      );
    }

    if (_tempFilters.containsKey('startDate')) {
      _startDate = _tempFilters['startDate'] as DateTime;
    }

    if (_tempFilters.containsKey('endDate')) {
      _endDate = _tempFilters['endDate'] as DateTime;
    }
  }

  void _selectDateRange() async {
    DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now().subtract(Duration(days: 365)),
      lastDate: DateTime.now(),
      initialDateRange: _startDate != null && _endDate != null
          ? DateTimeRange(start: _startDate!, end: _endDate!)
          : null,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: AppTheme.lightTheme.colorScheme.primary,
                ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
    }
  }

  void _applyFilters() {
    Map<String, dynamic> newFilters = {};

    if (_selectedCategory != 'All Categories') {
      newFilters['category'] = _selectedCategory;
    }

    if (_amountRange.start > 0 || _amountRange.end < 1000) {
      newFilters['minAmount'] = _amountRange.start;
      newFilters['maxAmount'] = _amountRange.end;
    }

    if (_startDate != null) {
      newFilters['startDate'] = _startDate;
    }

    if (_endDate != null) {
      newFilters['endDate'] = _endDate;
    }

    widget.onFiltersApplied(newFilters);
    Navigator.pop(context);
  }

  void _clearFilters() {
    setState(() {
      _selectedCategory = 'All Categories';
      _amountRange = RangeValues(0, 1000);
      _startDate = null;
      _endDate = null;
    });
  }

  String _formatDateRange() {
    if (_startDate == null || _endDate == null) {
      return 'Select date range';
    }

    String startStr =
        '${_startDate!.day}/${_startDate!.month}/${_startDate!.year}';
    String endStr = '${_endDate!.day}/${_endDate!.month}/${_endDate!.year}';

    return '$startStr - $endStr';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.only(top: 2.h),
            width: 12.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                  .withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filter Transactions',
                  style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: CustomIconWidget(
                    iconName: 'close',
                    size: 24,
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 6.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category Filter
                  Text(
                    'Category',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Wrap(
                    spacing: 2.w,
                    runSpacing: 1.h,
                    children: _categories.map((category) {
                      bool isSelected = _selectedCategory == category;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedCategory = category;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 4.w, vertical: 1.5.h),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppTheme.lightTheme.colorScheme.primary
                                : AppTheme.lightTheme.colorScheme.surface,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected
                                  ? AppTheme.lightTheme.colorScheme.primary
                                  : AppTheme.lightTheme.colorScheme.outline,
                              width: 1,
                            ),
                          ),
                          child: Text(
                            category,
                            style: AppTheme.lightTheme.textTheme.labelMedium
                                ?.copyWith(
                              color: isSelected
                                  ? AppTheme.lightTheme.colorScheme.onPrimary
                                  : AppTheme.lightTheme.colorScheme.onSurface,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  SizedBox(height: 4.h),

                  // Amount Range Filter
                  Text(
                    'Amount Range',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${_amountRange.start.toInt()}',
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '\$${_amountRange.end.toInt()}',
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  RangeSlider(
                    values: _amountRange,
                    min: 0,
                    max: 1000,
                    divisions: 20,
                    activeColor: AppTheme.lightTheme.colorScheme.primary,
                    inactiveColor: AppTheme.lightTheme.colorScheme.outline,
                    onChanged: (RangeValues values) {
                      setState(() {
                        _amountRange = values;
                      });
                    },
                  ),

                  SizedBox(height: 4.h),

                  // Date Range Filter
                  Text(
                    'Date Range',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  GestureDetector(
                    onTap: _selectDateRange,
                    child: Container(
                      width: double.infinity,
                      padding:
                          EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppTheme.lightTheme.colorScheme.outline,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _formatDateRange(),
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              color: _startDate == null
                                  ? AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant
                                  : AppTheme.lightTheme.colorScheme.onSurface,
                            ),
                          ),
                          CustomIconWidget(
                            iconName: 'calendar_today',
                            size: 20,
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 6.h),
                ],
              ),
            ),
          ),

          // Action Buttons
          Container(
            padding: EdgeInsets.all(6.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              border: Border(
                top: BorderSide(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _clearFilters,
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                    ),
                    child: Text('Clear All'),
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _applyFilters,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                    ),
                    child: Text('Apply Filters'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
