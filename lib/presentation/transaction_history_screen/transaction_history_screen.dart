import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/filter_bottom_sheet_widget.dart';
import './widgets/transaction_item_widget.dart';

class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({super.key});

  @override
  State<TransactionHistoryScreen> createState() =>
      _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  bool _isLoading = false;
  bool _isSearching = false;
  String _searchQuery = '';
  Map<String, dynamic> _activeFilters = {};

  // Mock transaction data
  final List<Map<String, dynamic>> _allTransactions = [
    {
      "id": "1",
      "merchantName": "Starbucks Coffee",
      "category": "Food & Dining",
      "categoryIcon": "local_cafe",
      "amount": -4.50,
      "timestamp": DateTime.now().subtract(Duration(hours: 2)),
      "date": "Today",
      "description": "Coffee and pastry",
      "type": "expense"
    },
    {
      "id": "2",
      "merchantName": "Uber Ride",
      "category": "Transport",
      "categoryIcon": "directions_car",
      "amount": -12.30,
      "timestamp": DateTime.now().subtract(Duration(hours: 4)),
      "date": "Today",
      "description": "Trip to downtown",
      "type": "expense"
    },
    {
      "id": "3",
      "merchantName": "Salary Deposit",
      "category": "Income",
      "categoryIcon": "account_balance_wallet",
      "amount": 2500.00,
      "timestamp": DateTime.now().subtract(Duration(days: 1)),
      "date": "Yesterday",
      "description": "Monthly salary",
      "type": "income"
    },
    {
      "id": "4",
      "merchantName": "Amazon Purchase",
      "category": "Shopping",
      "categoryIcon": "shopping_bag",
      "amount": -89.99,
      "timestamp": DateTime.now().subtract(Duration(days: 1)),
      "date": "Yesterday",
      "description": "Electronics accessories",
      "type": "expense"
    },
    {
      "id": "5",
      "merchantName": "Grocery Store",
      "category": "Food & Dining",
      "categoryIcon": "local_grocery_store",
      "amount": -45.67,
      "timestamp": DateTime.now().subtract(Duration(days: 2)),
      "date": "2 days ago",
      "description": "Weekly groceries",
      "type": "expense"
    },
    {
      "id": "6",
      "merchantName": "Investment Return",
      "category": "Investment",
      "categoryIcon": "trending_up",
      "amount": 150.00,
      "timestamp": DateTime.now().subtract(Duration(days: 3)),
      "date": "3 days ago",
      "description": "Stock dividend",
      "type": "income"
    },
    {
      "id": "7",
      "merchantName": "Gas Station",
      "category": "Transport",
      "categoryIcon": "local_gas_station",
      "amount": -35.20,
      "timestamp": DateTime.now().subtract(Duration(days: 3)),
      "date": "3 days ago",
      "description": "Fuel refill",
      "type": "expense"
    },
    {
      "id": "8",
      "merchantName": "Netflix Subscription",
      "category": "Entertainment",
      "categoryIcon": "movie",
      "amount": -15.99,
      "timestamp": DateTime.now().subtract(Duration(days: 5)),
      "date": "5 days ago",
      "description": "Monthly subscription",
      "type": "expense"
    }
  ];

  List<Map<String, dynamic>> _filteredTransactions = [];
  final Map<String, List<Map<String, dynamic>>> _groupedTransactions = {};

  @override
  void initState() {
    super.initState();
    _filteredTransactions = List.from(_allTransactions);
    _groupTransactionsByDate();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMoreTransactions();
    }
  }

  void _loadMoreTransactions() {
    if (!_isLoading) {
      setState(() {
        _isLoading = true;
      });

      // Simulate loading more transactions
      Future.delayed(Duration(seconds: 1), () {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }

  void _groupTransactionsByDate() {
    _groupedTransactions.clear();
    for (var transaction in _filteredTransactions) {
      String date = transaction['date'] as String;
      if (!_groupedTransactions.containsKey(date)) {
        _groupedTransactions[date] = [];
      }
      _groupedTransactions[date]!.add(transaction);
    }
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
      _isSearching = query.isNotEmpty;
      _filterTransactions();
    });
  }

  void _filterTransactions() {
    _filteredTransactions = _allTransactions.where((transaction) {
      bool matchesSearch = _searchQuery.isEmpty ||
          (transaction['merchantName'] as String)
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          (transaction['category'] as String)
              .toLowerCase()
              .contains(_searchQuery.toLowerCase());

      bool matchesFilters = true;
      if (_activeFilters.isNotEmpty) {
        if (_activeFilters.containsKey('category') &&
            _activeFilters['category'] != null) {
          matchesFilters = matchesFilters &&
              transaction['category'] == _activeFilters['category'];
        }
        if (_activeFilters.containsKey('minAmount') &&
            _activeFilters['minAmount'] != null) {
          matchesFilters = matchesFilters &&
              (transaction['amount'] as double).abs() >=
                  _activeFilters['minAmount'];
        }
        if (_activeFilters.containsKey('maxAmount') &&
            _activeFilters['maxAmount'] != null) {
          matchesFilters = matchesFilters &&
              (transaction['amount'] as double).abs() <=
                  _activeFilters['maxAmount'];
        }
      }

      return matchesSearch && matchesFilters;
    }).toList();

    _groupTransactionsByDate();
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterBottomSheetWidget(
        activeFilters: _activeFilters,
        onFiltersApplied: (filters) {
          setState(() {
            _activeFilters = filters;
            _filterTransactions();
          });
        },
      ),
    );
  }

  void _showTransactionContextMenu(
      Map<String, dynamic> transaction, Offset position) {
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy,
        position.dx + 1,
        position.dy + 1,
      ),
      items: [
        PopupMenuItem(
          value: 'edit',
          child: Row(
            children: [
              CustomIconWidget(
                iconName: 'edit',
                size: 20,
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
              SizedBox(width: 12),
              Text('Edit'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'duplicate',
          child: Row(
            children: [
              CustomIconWidget(
                iconName: 'content_copy',
                size: 20,
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
              SizedBox(width: 12),
              Text('Duplicate'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'share',
          child: Row(
            children: [
              CustomIconWidget(
                iconName: 'share',
                size: 20,
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
              SizedBox(width: 12),
              Text('Share'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              CustomIconWidget(
                iconName: 'delete',
                size: 20,
                color: AppTheme.getErrorColor(true),
              ),
              SizedBox(width: 12),
              Text(
                'Delete',
                style: TextStyle(color: AppTheme.getErrorColor(true)),
              ),
            ],
          ),
        ),
      ],
    ).then((value) {
      if (value != null) {
        _handleContextMenuAction(value, transaction);
      }
    });
  }

  void _handleContextMenuAction(
      String action, Map<String, dynamic> transaction) {
    switch (action) {
      case 'edit':
        // Navigate to edit transaction screen
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Edit transaction: ${transaction['merchantName']}')),
        );
        break;
      case 'duplicate':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Duplicated transaction: ${transaction['merchantName']}')),
        );
        break;
      case 'share':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Shared transaction: ${transaction['merchantName']}')),
        );
        break;
      case 'delete':
        _showDeleteConfirmation(transaction);
        break;
    }
  }

  void _showDeleteConfirmation(Map<String, dynamic> transaction) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Transaction'),
        content: Text('Are you sure you want to delete this transaction?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _allTransactions
                    .removeWhere((t) => t['id'] == transaction['id']);
                _filterTransactions();
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Transaction deleted')),
              );
            },
            child: Text(
              'Delete',
              style: TextStyle(color: AppTheme.getErrorColor(true)),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _onRefresh() async {
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      _filteredTransactions = List.from(_allTransactions);
      _groupTransactionsByDate();
    });
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _searchQuery = '';
      _isSearching = false;
      _filterTransactions();
    });
  }

  void _clearFilters() {
    setState(() {
      _activeFilters.clear();
      _filterTransactions();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            size: 24,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
        title: Text(
          'Transaction History',
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        actions: [
          IconButton(
            onPressed: () {
              // Export functionality
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Export feature coming soon')),
              );
            },
            icon: CustomIconWidget(
              iconName: 'file_download',
              size: 24,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search and Filter Section
          Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.lightTheme.colorScheme.shadow
                      .withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 6.h,
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.outline,
                        width: 1,
                      ),
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: _onSearchChanged,
                      decoration: InputDecoration(
                        hintText: 'Search transactions...',
                        hintStyle:
                            AppTheme.lightTheme.inputDecorationTheme.hintStyle,
                        prefixIcon: Padding(
                          padding: EdgeInsets.all(12),
                          child: CustomIconWidget(
                            iconName: 'search',
                            size: 20,
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        suffixIcon: _isSearching
                            ? IconButton(
                                onPressed: _clearSearch,
                                icon: CustomIconWidget(
                                  iconName: 'clear',
                                  size: 20,
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                                ),
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 3.w),
                Container(
                  height: 6.h,
                  width: 6.h,
                  decoration: BoxDecoration(
                    color: _activeFilters.isNotEmpty
                        ? AppTheme.lightTheme.colorScheme.primary
                        : AppTheme.lightTheme.scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _activeFilters.isNotEmpty
                          ? AppTheme.lightTheme.colorScheme.primary
                          : AppTheme.lightTheme.colorScheme.outline,
                      width: 1,
                    ),
                  ),
                  child: IconButton(
                    onPressed: _showFilterBottomSheet,
                    icon: CustomIconWidget(
                      iconName: 'tune',
                      size: 20,
                      color: _activeFilters.isNotEmpty
                          ? AppTheme.lightTheme.colorScheme.onPrimary
                          : AppTheme.lightTheme.colorScheme.onSurface,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Active Filters Display
          if (_activeFilters.isNotEmpty)
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  if (_activeFilters.containsKey('category'))
                    Chip(
                      label: Text(_activeFilters['category']),
                      onDeleted: () {
                        setState(() {
                          _activeFilters.remove('category');
                          _filterTransactions();
                        });
                      },
                      deleteIcon: CustomIconWidget(
                        iconName: 'close',
                        size: 16,
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  if (_activeFilters.containsKey('minAmount') ||
                      _activeFilters.containsKey('maxAmount'))
                    Chip(
                      label: Text(
                          'Amount: \$${_activeFilters['minAmount']?.toStringAsFixed(0) ?? '0'} - \$${_activeFilters['maxAmount']?.toStringAsFixed(0) ?? '1000'}'),
                      onDeleted: () {
                        setState(() {
                          _activeFilters.remove('minAmount');
                          _activeFilters.remove('maxAmount');
                          _filterTransactions();
                        });
                      },
                      deleteIcon: CustomIconWidget(
                        iconName: 'close',
                        size: 16,
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  TextButton(
                    onPressed: _clearFilters,
                    child: Text('Clear All'),
                  ),
                ],
              ),
            ),

          // Transaction List
          Expanded(
            child: _filteredTransactions.isEmpty
                ? _buildEmptyState()
                : RefreshIndicator(
                    onRefresh: _onRefresh,
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      itemCount: _groupedTransactions.keys.length +
                          (_isLoading ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == _groupedTransactions.keys.length) {
                          return _buildLoadingIndicator();
                        }

                        String date =
                            _groupedTransactions.keys.elementAt(index);
                        List<Map<String, dynamic>> transactions =
                            _groupedTransactions[date]!;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Date Header
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(vertical: 2.h),
                              child: Text(
                                date,
                                style: AppTheme.lightTheme.textTheme.titleMedium
                                    ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ),

                            // Transactions for this date
                            ...transactions
                                .map((transaction) => TransactionItemWidget(
                                      transaction: transaction,
                                      searchQuery: _searchQuery,
                                      onLongPress: (position) =>
                                          _showTransactionContextMenu(
                                              transaction, position),
                                      onEdit: () => _handleContextMenuAction(
                                          'edit', transaction),
                                      onDuplicate: () =>
                                          _handleContextMenuAction(
                                              'duplicate', transaction),
                                      onDelete: () =>
                                          _showDeleteConfirmation(transaction),
                                    ))
                                ,
                          ],
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to add transaction screen
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Add new transaction')),
          );
        },
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        child: CustomIconWidget(
          iconName: 'add',
          size: 24,
          color: AppTheme.lightTheme.colorScheme.onPrimary,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: _isSearching || _activeFilters.isNotEmpty
                  ? 'search_off'
                  : 'receipt_long',
              size: 64,
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            SizedBox(height: 3.h),
            Text(
              _isSearching || _activeFilters.isNotEmpty
                  ? 'No transactions found'
                  : 'Start tracking expenses',
              style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              _isSearching || _activeFilters.isNotEmpty
                  ? 'Try adjusting your search or filters'
                  : 'Add your first transaction to get started',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4.h),
            if (_isSearching || _activeFilters.isNotEmpty)
              ElevatedButton(
                onPressed: () {
                  _clearSearch();
                  _clearFilters();
                },
                child: Text('Clear Search & Filters'),
              )
            else
              ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Add new transaction')),
                  );
                },
                child: Text('Add Transaction'),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Container(
      padding: EdgeInsets.all(4.w),
      child: Center(
        child: CircularProgressIndicator(
          color: AppTheme.lightTheme.colorScheme.primary,
        ),
      ),
    );
  }
}
