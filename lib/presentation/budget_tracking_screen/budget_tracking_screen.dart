import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/add_budget_modal_widget.dart';
import './widgets/budget_category_card_widget.dart';
import './widgets/budget_donut_chart_widget.dart';
import './widgets/calendar_view_widget.dart';
import './widgets/monthly_overview_card_widget.dart';

class BudgetTrackingScreen extends StatefulWidget {
  const BudgetTrackingScreen({super.key});

  @override
  State<BudgetTrackingScreen> createState() => _BudgetTrackingScreenState();
}

class _BudgetTrackingScreenState extends State<BudgetTrackingScreen>
    with TickerProviderStateMixin {
  int _currentBottomNavIndex = 2; // Budget tab active
  bool _isCalendarView = false;
  String _selectedMonth = 'January 2024';
  late TabController _tabController;

  // Mock data for budget tracking
  final Map<String, dynamic> _budgetData = {
    "totalBudget": 5000.0,
    "totalSpent": 3250.0,
    "remainingBalance": 1750.0,
    "categories": [
      {
        "id": 1,
        "name": "Shopping",
        "icon": "shopping_bag",
        "allocated": 1500.0,
        "spent": 1200.0,
        "color": 0xFF00D4AA,
        "transactions": [
          {
            "id": 1,
            "title": "Amazon Purchase",
            "amount": 250.0,
            "date": "2024-01-15",
            "type": "expense"
          },
          {
            "id": 2,
            "title": "Grocery Store",
            "amount": 180.0,
            "date": "2024-01-14",
            "type": "expense"
          }
        ]
      },
      {
        "id": 2,
        "name": "Investment",
        "icon": "trending_up",
        "allocated": 2000.0,
        "spent": 1800.0,
        "color": 0xFF10B981,
        "transactions": [
          {
            "id": 3,
            "title": "Stock Purchase",
            "amount": 1000.0,
            "date": "2024-01-12",
            "type": "expense"
          },
          {
            "id": 4,
            "title": "Mutual Fund",
            "amount": 800.0,
            "date": "2024-01-10",
            "type": "expense"
          }
        ]
      },
      {
        "id": 3,
        "name": "Transport",
        "icon": "directions_car",
        "allocated": 800.0,
        "spent": 250.0,
        "color": 0xFFF59E0B,
        "transactions": [
          {
            "id": 5,
            "title": "Gas Station",
            "amount": 120.0,
            "date": "2024-01-13",
            "type": "expense"
          },
          {
            "id": 6,
            "title": "Uber Ride",
            "amount": 45.0,
            "date": "2024-01-11",
            "type": "expense"
          }
        ]
      },
      {
        "id": 4,
        "name": "Food & Dining",
        "icon": "restaurant",
        "allocated": 700.0,
        "spent": 0.0,
        "color": 0xFFEF4444,
        "transactions": []
      }
    ]
  };

  final List<Map<String, dynamic>> _calendarData = [
    {"date": "2024-01-01", "amount": 45.0, "intensity": 0.3},
    {"date": "2024-01-02", "amount": 120.0, "intensity": 0.6},
    {"date": "2024-01-03", "amount": 200.0, "intensity": 0.9},
    {"date": "2024-01-04", "amount": 80.0, "intensity": 0.4},
    {"date": "2024-01-05", "amount": 150.0, "intensity": 0.7},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.index = 2; // Budget tab active
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showAddBudgetModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddBudgetModalWidget(
        onBudgetAdded: (String category, double amount) {
          setState(() {
            // Add new budget logic here
          });
        },
      ),
    );
  }

  void _onBottomNavTap(int index) {
    setState(() {
      _currentBottomNavIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/splash-screen');
        break;
      case 1:
        Navigator.pushNamed(context, '/transaction-history-screen');
        break;
      case 2:
        // Current screen - Budget Tracking
        break;
      case 3:
        Navigator.pushNamed(context, '/user-profile-screen');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: _buildAppBar(),
      body: RefreshIndicator(
        onRefresh: () async {
          // Simulate refresh
          await Future.delayed(const Duration(seconds: 1));
          setState(() {
            // Update spending calculations
          });
        },
        child: _isCalendarView ? _buildCalendarView() : _buildBudgetView(),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      elevation: 0,
      centerTitle: true,
      title: GestureDetector(
        onTap: () {
          // Show month selector
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _selectedMonth,
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(width: 1.w),
            CustomIconWidget(
              iconName: 'keyboard_arrow_down',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 20,
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            setState(() {
              _isCalendarView = !_isCalendarView;
            });
          },
          icon: CustomIconWidget(
            iconName: _isCalendarView ? 'view_list' : 'calendar_today',
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 24,
          ),
        ),
        IconButton(
          onPressed: () {
            // Settings action
          },
          icon: CustomIconWidget(
            iconName: 'settings',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 24,
          ),
        ),
        SizedBox(width: 2.w),
      ],
    );
  }

  Widget _buildBudgetView() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Monthly Overview Card
          MonthlyOverviewCardWidget(
            totalBudget: _budgetData["totalBudget"] as double,
            totalSpent: _budgetData["totalSpent"] as double,
            remainingBalance: _budgetData["remainingBalance"] as double,
          ),
          SizedBox(height: 3.h),

          // Budget Distribution Chart
          BudgetDonutChartWidget(
            categories: (_budgetData["categories"] as List)
                .cast<Map<String, dynamic>>(),
          ),
          SizedBox(height: 3.h),

          // Category Breakdown Header
          Text(
            'Budget Categories',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),

          // Category Cards List
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: (_budgetData["categories"] as List).length,
            separatorBuilder: (context, index) => SizedBox(height: 2.h),
            itemBuilder: (context, index) {
              final category = (_budgetData["categories"] as List)[index]
                  as Map<String, dynamic>;
              return BudgetCategoryCardWidget(
                category: category,
                onTap: () {
                  // Handle category tap
                },
              );
            },
          ),
          SizedBox(height: 10.h), // Space for FAB
        ],
      ),
    );
  }

  Widget _buildCalendarView() {
    return CalendarViewWidget(
      calendarData: _calendarData,
      selectedMonth: _selectedMonth,
      onMonthChanged: (String month) {
        setState(() {
          _selectedMonth = month;
        });
      },
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          height: 8.h,
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildBottomNavItem(
                icon: 'home',
                label: 'Home',
                index: 0,
                isActive: _currentBottomNavIndex == 0,
              ),
              _buildBottomNavItem(
                icon: 'history',
                label: 'History',
                index: 1,
                isActive: _currentBottomNavIndex == 1,
              ),
              _buildBottomNavItem(
                icon: 'pie_chart',
                label: 'Budget',
                index: 2,
                isActive: _currentBottomNavIndex == 2,
              ),
              _buildBottomNavItem(
                icon: 'person',
                label: 'Profile',
                index: 3,
                isActive: _currentBottomNavIndex == 3,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavItem({
    required String icon,
    required String label,
    required int index,
    required bool isActive,
  }) {
    return GestureDetector(
      onTap: () => _onBottomNavTap(index),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 1.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomIconWidget(
              iconName: icon,
              color: isActive
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurface
                      .withValues(alpha: 0.6),
              size: 24,
            ),
            SizedBox(height: 0.5.h),
            Text(
              label,
              style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                color: isActive
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.colorScheme.onSurface
                        .withValues(alpha: 0.6),
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton.extended(
      onPressed: _showAddBudgetModal,
      backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
      elevation: 4,
      label: Text(
        'Add Budget',
        style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
          color: AppTheme.lightTheme.colorScheme.onPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
      icon: CustomIconWidget(
        iconName: 'add',
        color: AppTheme.lightTheme.colorScheme.onPrimary,
        size: 20,
      ),
    );
  }
}
