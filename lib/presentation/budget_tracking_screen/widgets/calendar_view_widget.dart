import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CalendarViewWidget extends StatefulWidget {
  final List<Map<String, dynamic>> calendarData;
  final String selectedMonth;
  final Function(String) onMonthChanged;

  const CalendarViewWidget({
    super.key,
    required this.calendarData,
    required this.selectedMonth,
    required this.onMonthChanged,
  });

  @override
  State<CalendarViewWidget> createState() => _CalendarViewWidgetState();
}

class _CalendarViewWidgetState extends State<CalendarViewWidget> {
  late PageController _pageController;
  late DateTime _currentDate;

  @override
  void initState() {
    super.initState();
    _currentDate = DateTime.now();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      child: Column(
        children: [
          // Calendar Header
          _buildCalendarHeader(),
          SizedBox(height: 3.h),

          // Calendar Grid
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentDate =
                      DateTime(_currentDate.year, _currentDate.month + index);
                });
                widget.onMonthChanged(_getMonthString(_currentDate));
              },
              itemBuilder: (context, index) {
                final DateTime monthDate =
                    DateTime(_currentDate.year, _currentDate.month + index);
                return _buildCalendarGrid(monthDate);
              },
            ),
          ),

          // Legend
          _buildLegend(),
        ],
      ),
    );
  }

  Widget _buildCalendarHeader() {
    return Container(
      padding: EdgeInsets.all(4.w),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              _pageController.previousPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
            icon: CustomIconWidget(
              iconName: 'chevron_left',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 24,
            ),
          ),
          Text(
            _getMonthString(_currentDate),
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          IconButton(
            onPressed: () {
              _pageController.nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
            icon: CustomIconWidget(
              iconName: 'chevron_right',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid(DateTime monthDate) {
    final int daysInMonth =
        DateTime(monthDate.year, monthDate.month + 1, 0).day;
    final int firstWeekday =
        DateTime(monthDate.year, monthDate.month, 1).weekday;
    final List<String> weekdays = [
      'Mon',
      'Tue',
      'Wed',
      'Thu',
      'Fri',
      'Sat',
      'Sun'
    ];

    return Container(
      padding: EdgeInsets.all(4.w),
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
          // Weekday Headers
          Row(
            children: weekdays
                .map((weekday) => Expanded(
                      child: Center(
                        child: Text(
                          weekday,
                          style: AppTheme.lightTheme.textTheme.labelMedium
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppTheme.lightTheme.colorScheme.onSurface
                                .withValues(alpha: 0.6),
                          ),
                        ),
                      ),
                    ))
                .toList(),
          ),
          SizedBox(height: 2.h),

          // Calendar Days
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                childAspectRatio: 1,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
              ),
              itemCount: 42, // 6 weeks * 7 days
              itemBuilder: (context, index) {
                final int dayNumber = index - firstWeekday + 2;

                if (dayNumber <= 0 || dayNumber > daysInMonth) {
                  return Container(); // Empty cell
                }

                final DateTime dayDate =
                    DateTime(monthDate.year, monthDate.month, dayNumber);
                final Map<String, dynamic>? dayData = _getDayData(dayDate);

                return _buildCalendarDay(dayNumber, dayData);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarDay(int dayNumber, Map<String, dynamic>? dayData) {
    final bool hasData = dayData != null;
    final double intensity = hasData ? (dayData["intensity"] as double) : 0.0;
    final double amount = hasData ? (dayData["amount"] as double) : 0.0;

    Color dayColor = AppTheme.lightTheme.colorScheme.surface;
    if (hasData) {
      if (intensity >= 0.8) {
        dayColor = AppTheme.lightTheme.colorScheme.error;
      } else if (intensity >= 0.6) {
        dayColor = AppTheme.getWarningColor(true);
      } else if (intensity >= 0.3) {
        dayColor = AppTheme.lightTheme.colorScheme.primary;
      } else {
        dayColor = AppTheme.getSuccessColor(true);
      }
    }

    return GestureDetector(
      onTap: hasData
          ? () {
              _showDayDetails(dayNumber, amount);
            }
          : null,
      child: Container(
        decoration: BoxDecoration(
          color: hasData
              ? dayColor.withValues(alpha: 0.2)
              : AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: hasData ? Border.all(color: dayColor, width: 1) : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              dayNumber.toString(),
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: hasData
                    ? dayColor
                    : AppTheme.lightTheme.colorScheme.onSurface,
              ),
            ),
            if (hasData) ...[
              SizedBox(height: 0.5.h),
              Container(
                width: 1.5.w,
                height: 1.5.w,
                decoration: BoxDecoration(
                  color: dayColor,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildLegend() {
    return Container(
      padding: EdgeInsets.all(4.w),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Spending Intensity',
            style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildLegendItem('Low', AppTheme.getSuccessColor(true)),
              _buildLegendItem(
                  'Medium', AppTheme.lightTheme.colorScheme.primary),
              _buildLegendItem('High', AppTheme.getWarningColor(true)),
              _buildLegendItem(
                  'Very High', AppTheme.lightTheme.colorScheme.error),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Column(
      children: [
        Container(
          width: 4.w,
          height: 4.w,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: color, width: 1),
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurface
                .withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }

  Map<String, dynamic>? _getDayData(DateTime date) {
    final String dateString =
        "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
    return widget.calendarData
            .firstWhere(
              (data) => data["date"] == dateString,
              orElse: () => {},
            )
            .isEmpty
        ? null
        : widget.calendarData.firstWhere(
            (data) => data["date"] == dateString,
          );
  }

  String _getMonthString(DateTime date) {
    const List<String> months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return '${months[date.month - 1]} ${date.year}';
  }

  void _showDayDetails(int day, double amount) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Day $day Spending',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomIconWidget(
              iconName: 'account_balance_wallet',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 48,
            ),
            SizedBox(height: 2.h),
            Text(
              '\$${amount.toStringAsFixed(2)}',
              style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: AppTheme.lightTheme.colorScheme.primary,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Total spent on this day',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface
                    .withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Close',
              style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                color: AppTheme.lightTheme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
