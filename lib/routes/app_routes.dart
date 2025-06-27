import 'package:flutter/material.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/user_profile_screen/user_profile_screen.dart';
import '../presentation/transaction_history_screen/transaction_history_screen.dart';
import '../presentation/budget_tracking_screen/budget_tracking_screen.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String splashScreen = '/splash-screen';
  static const String userProfileScreen = '/user-profile-screen';
  static const String transactionHistoryScreen = '/transaction-history-screen';
  static const String budgetTrackingScreen = '/budget-tracking-screen';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    splashScreen: (context) => const SplashScreen(),
    userProfileScreen: (context) => const UserProfileScreen(),
    transactionHistoryScreen: (context) => const TransactionHistoryScreen(),
    budgetTrackingScreen: (context) => const BudgetTrackingScreen(),
    // TODO: Add your other routes here
  };
}
