import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AddBudgetModalWidget extends StatefulWidget {
  final Function(String category, double amount) onBudgetAdded;

  const AddBudgetModalWidget({
    super.key,
    required this.onBudgetAdded,
  });

  @override
  State<AddBudgetModalWidget> createState() => _AddBudgetModalWidgetState();
}

class _AddBudgetModalWidgetState extends State<AddBudgetModalWidget> {
  String _selectedCategory = '';
  String _amountText = '';
  double _amount = 0.0;

  final List<Map<String, dynamic>> _categories = [
    {"name": "Shopping", "icon": "shopping_bag", "color": 0xFF00D4AA},
    {"name": "Investment", "icon": "trending_up", "color": 0xFF10B981},
    {"name": "Transport", "icon": "directions_car", "color": 0xFFF59E0B},
    {"name": "Food & Dining", "icon": "restaurant", "color": 0xFFEF4444},
    {"name": "Entertainment", "icon": "movie", "color": 0xFF8B5CF6},
    {"name": "Healthcare", "icon": "local_hospital", "color": 0xFF06B6D4},
    {"name": "Education", "icon": "school", "color": 0xFFF97316},
    {"name": "Utilities", "icon": "flash_on", "color": 0xFF84CC16},
  ];

  void _onNumberTap(String number) {
    setState(() {
      if (number == '.' && _amountText.contains('.')) return;
      if (_amountText.length >= 10) return;

      _amountText += number;
      _amount = double.tryParse(_amountText) ?? 0.0;
    });
  }

  void _onBackspace() {
    setState(() {
      if (_amountText.isNotEmpty) {
        _amountText = _amountText.substring(0, _amountText.length - 1);
        _amount = double.tryParse(_amountText) ?? 0.0;
      }
    });
  }

  void _onClear() {
    setState(() {
      _amountText = '';
      _amount = 0.0;
    });
  }

  void _onSave() {
    if (_selectedCategory.isNotEmpty && _amount > 0) {
      widget.onBudgetAdded(_selectedCategory, _amount);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Handle Bar
          Container(
            margin: EdgeInsets.only(top: 2.h),
            width: 12.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.all(6.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Add Budget',
                  style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: CustomIconWidget(
                    iconName: 'close',
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                    size: 24,
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
                  // Amount Display
                  Container(
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
                      children: [
                        Text(
                          'Budget Amount',
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.onSurface
                                .withValues(alpha: 0.6),
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          _amountText.isEmpty ? '\$0' : '\$$_amountText',
                          style: AppTheme.lightTheme.textTheme.displayMedium
                              ?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppTheme.lightTheme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 4.h),

                  // Category Selection
                  Text(
                    'Select Category',
                    style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 2.h),

                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 3,
                      crossAxisSpacing: 3.w,
                      mainAxisSpacing: 2.h,
                    ),
                    itemCount: _categories.length,
                    itemBuilder: (context, index) {
                      final category = _categories[index];
                      final bool isSelected =
                          _selectedCategory == category["name"];

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedCategory = category["name"] as String;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.all(4.w),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Color(category["color"] as int)
                                    .withValues(alpha: 0.1)
                                : AppTheme.lightTheme.cardColor,
                            borderRadius: BorderRadius.circular(12),
                            border: isSelected
                                ? Border.all(
                                    color: Color(category["color"] as int),
                                    width: 2)
                                : null,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.06),
                                blurRadius: 4,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              CustomIconWidget(
                                iconName: category["icon"] as String,
                                color: Color(category["color"] as int),
                                size: 20,
                              ),
                              SizedBox(width: 3.w),
                              Expanded(
                                child: Text(
                                  category["name"] as String,
                                  style: AppTheme
                                      .lightTheme.textTheme.bodyMedium
                                      ?.copyWith(
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                    color: isSelected
                                        ? Color(category["color"] as int)
                                        : AppTheme
                                            .lightTheme.colorScheme.onSurface,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 4.h),

                  // Custom Numeric Keypad
                  _buildNumericKeypad(),
                  SizedBox(height: 4.h),

                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: (_selectedCategory.isNotEmpty && _amount > 0)
                          ? _onSave
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            AppTheme.lightTheme.colorScheme.primary,
                        foregroundColor:
                            AppTheme.lightTheme.colorScheme.onPrimary,
                        padding: EdgeInsets.symmetric(vertical: 2.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Save Budget',
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppTheme.lightTheme.colorScheme.onPrimary,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNumericKeypad() {
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
          // Row 1: 1, 2, 3
          Row(
            children: [
              _buildKeypadButton('1'),
              _buildKeypadButton('2'),
              _buildKeypadButton('3'),
            ],
          ),
          SizedBox(height: 2.h),

          // Row 2: 4, 5, 6
          Row(
            children: [
              _buildKeypadButton('4'),
              _buildKeypadButton('5'),
              _buildKeypadButton('6'),
            ],
          ),
          SizedBox(height: 2.h),

          // Row 3: 7, 8, 9
          Row(
            children: [
              _buildKeypadButton('7'),
              _buildKeypadButton('8'),
              _buildKeypadButton('9'),
            ],
          ),
          SizedBox(height: 2.h),

          // Row 4: ., 0, backspace
          Row(
            children: [
              _buildKeypadButton('.'),
              _buildKeypadButton('0'),
              _buildKeypadButton('⌫', isBackspace: true),
            ],
          ),
          SizedBox(height: 2.h),

          // Clear Button
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: _onClear,
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 2.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Clear',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKeypadButton(String text, {bool isBackspace = false}) {
    return Expanded(
      child: GestureDetector(
        onTap: isBackspace ? _onBackspace : () => _onNumberTap(text),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 1.w),
          height: 8.h,
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Center(
            child: isBackspace
                ? CustomIconWidget(
                    iconName: 'backspace',
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                    size: 24,
                  )
                : Text(
                    text,
                    style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
