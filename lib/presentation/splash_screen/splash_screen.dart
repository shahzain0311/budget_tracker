import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _fadeController;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoFadeAnimation;
  late Animation<double> _backgroundFadeAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startSplashSequence();
  }

  void _initializeAnimations() {
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _logoScaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.elasticOut,
    ));

    _logoFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
    ));

    _backgroundFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));
  }

  void _startSplashSequence() async {
    // Start background fade
    _fadeController.forward();

    // Delay then start logo animation
    await Future.delayed(const Duration(milliseconds: 300));
    _logoController.forward();

    // Perform background initialization tasks
    await _performInitializationTasks();

    // Navigate to appropriate screen after splash duration
    await Future.delayed(const Duration(milliseconds: 2500));
    _navigateToNextScreen();
  }

  Future<void> _performInitializationTasks() async {
    // Simulate checking biometric availability
    await Future.delayed(const Duration(milliseconds: 500));

    // Simulate loading encrypted user preferences
    await Future.delayed(const Duration(milliseconds: 300));

    // Simulate validating secure storage
    await Future.delayed(const Duration(milliseconds: 400));

    // Simulate preparing cached financial data
    await Future.delayed(const Duration(milliseconds: 600));
  }

  void _navigateToNextScreen() {
    // Mock authentication status check
    final bool isAuthenticated = _checkAuthenticationStatus();
    final bool hasBiometricSetup = _checkBiometricSetup();
    final bool isNewInstallation = _checkNewInstallation();

    if (isAuthenticated) {
      // Navigate to dashboard (using transaction history as placeholder)
      Navigator.pushReplacementNamed(context, '/transaction-history-screen');
    } else if (hasBiometricSetup) {
      // Navigate to biometric prompt (using budget tracking as placeholder)
      Navigator.pushReplacementNamed(context, '/budget-tracking-screen');
    } else if (isNewInstallation) {
      // Navigate to registration flow (using user profile as placeholder)
      Navigator.pushReplacementNamed(context, '/user-profile-screen');
    } else {
      // Navigate to login screen (using transaction history as placeholder)
      Navigator.pushReplacementNamed(context, '/transaction-history-screen');
    }
  }

  bool _checkAuthenticationStatus() {
    // Mock authentication check - returns false for demo
    return false;
  }

  bool _checkBiometricSetup() {
    // Mock biometric setup check - returns true for demo
    return true;
  }

  bool _checkNewInstallation() {
    // Mock new installation check - returns false for demo
    return false;
  }

  @override
  void dispose() {
    _logoController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _backgroundFadeAnimation,
        builder: (context, child) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppTheme.lightTheme.scaffoldBackgroundColor,
                  AppTheme.lightTheme.primaryColor.withValues(
                    alpha: 0.1 * _backgroundFadeAnimation.value,
                  ),
                ],
              ),
            ),
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(flex: 2),
                  _buildLogoSection(),
                  SizedBox(height: 4.h),
                  _buildTaglineSection(),
                  const Spacer(flex: 2),
                  _buildLoadingSection(),
                  SizedBox(height: 8.h),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLogoSection() {
    return AnimatedBuilder(
      animation: _logoController,
      builder: (context, child) {
        return Transform.scale(
          scale: _logoScaleAnimation.value,
          child: Opacity(
            opacity: _logoFadeAnimation.value,
            child: Container(
              width: 25.w,
              height: 25.w,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.primaryColor,
                borderRadius: BorderRadius.circular(6.w),
                boxShadow: [
                  BoxShadow(
                    color:
                        AppTheme.lightTheme.primaryColor.withValues(alpha: 0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: 'account_balance_wallet',
                  color: AppTheme.lightTheme.colorScheme.onPrimary,
                  size: 12.w,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTaglineSection() {
    return AnimatedBuilder(
      animation: _logoController,
      builder: (context, child) {
        return Opacity(
          opacity: _logoFadeAnimation.value,
          child: Column(
            children: [
              Text(
                'Budget Tracker',
                style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 1.h),
              Text(
                'Smart Financial Management',
                style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLoadingSection() {
    return AnimatedBuilder(
      animation: _logoController,
      builder: (context, child) {
        return Opacity(
          opacity: _logoFadeAnimation.value,
          child: Column(
            children: [
              SizedBox(
                width: 8.w,
                height: 8.w,
                child: CircularProgressIndicator(
                  strokeWidth: 2.0,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppTheme.lightTheme.primaryColor,
                  ),
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                'Initializing your financial data...',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }
}
