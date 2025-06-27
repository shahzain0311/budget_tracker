import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class BudgetDonutChartWidget extends StatefulWidget {
  final List<Map<String, dynamic>> categories;

  const BudgetDonutChartWidget({
    super.key,
    required this.categories,
  });

  @override
  State<BudgetDonutChartWidget> createState() => _BudgetDonutChartWidgetState();
}

class _BudgetDonutChartWidgetState extends State<BudgetDonutChartWidget> {
  int _touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(6.w),
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
            'Budget Distribution',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 4.h),

          // Chart and Legend Row
          Row(
            children: [
              // Donut Chart
              Expanded(
                flex: 3,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: PieChart(
                    PieChartData(
                      pieTouchData: PieTouchData(
                        touchCallback: (FlTouchEvent event, pieTouchResponse) {
                          setState(() {
                            if (!event.isInterestedForInteractions ||
                                pieTouchResponse == null ||
                                pieTouchResponse.touchedSection == null) {
                              _touchedIndex = -1;
                              return;
                            }
                            _touchedIndex = pieTouchResponse
                                .touchedSection!.touchedSectionIndex;
                          });
                        },
                      ),
                      borderData: FlBorderData(show: false),
                      sectionsSpace: 2,
                      centerSpaceRadius: 25.w,
                      sections: _buildPieChartSections(),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 6.w),

              // Legend
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: widget.categories.asMap().entries.map((entry) {
                    final int index = entry.key;
                    final Map<String, dynamic> category = entry.value;
                    return _buildLegendItem(category, index);
                  }).toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> _buildPieChartSections() {
    final double totalSpent = widget.categories
        .fold(0.0, (sum, category) => sum + (category["spent"] as double));

    return widget.categories.asMap().entries.map((entry) {
      final int index = entry.key;
      final Map<String, dynamic> category = entry.value;
      final double spent = category["spent"] as double;
      final int colorValue = category["color"] as int;
      final Color categoryColor = Color(colorValue);

      final bool isTouched = index == _touchedIndex;
      final double fontSize = isTouched ? 14.sp : 12.sp;
      final double radius = isTouched ? 25.w : 22.w;
      final double percentage = totalSpent > 0 ? (spent / totalSpent) * 100 : 0;

      return PieChartSectionData(
        color: categoryColor,
        value: spent,
        title: spent > 0 ? '${percentage.toInt()}%' : '',
        radius: radius,
        titleStyle: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        titlePositionPercentageOffset: 0.6,
      );
    }).toList();
  }

  Widget _buildLegendItem(Map<String, dynamic> category, int index) {
    final String name = category["name"] as String;
    final double spent = category["spent"] as double;
    final int colorValue = category["color"] as int;
    final Color categoryColor = Color(colorValue);
    final bool isHighlighted = index == _touchedIndex;

    return GestureDetector(
      onTap: () {
        setState(() {
          _touchedIndex = _touchedIndex == index ? -1 : index;
        });
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 2.h),
        padding: EdgeInsets.all(2.w),
        decoration: BoxDecoration(
          color: isHighlighted
              ? categoryColor.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              width: 4.w,
              height: 4.w,
              decoration: BoxDecoration(
                color: categoryColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: isHighlighted
                          ? categoryColor
                          : AppTheme.lightTheme.colorScheme.onSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    '\$${spent.toStringAsFixed(0)}',
                    style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurface
                          .withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
