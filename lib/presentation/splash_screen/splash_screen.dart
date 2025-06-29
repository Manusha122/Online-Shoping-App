import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoAnimationController;
  late AnimationController _fadeAnimationController;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoOpacityAnimation;
  late Animation<double> _fadeAnimation;

  bool _isLoading = true;
  bool _hasError = false;
  String _loadingText = 'Initializing...';

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startSplashSequence();
  }

  void _initializeAnimations() {
    // Logo animation controller
    _logoAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Fade animation controller for screen transition
    _fadeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Logo scale animation
    _logoScaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: Curves.elasticOut,
    ));

    // Logo opacity animation
    _logoOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
    ));

    // Screen fade animation
    _fadeAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _fadeAnimationController,
      curve: Curves.easeInOut,
    ));

    // Start logo animation
    _logoAnimationController.forward();
  }

  Future<void> _startSplashSequence() async {
    try {
      // Simulate initialization tasks
      await _performInitializationTasks();

      if (mounted) {
        // Start fade out animation
        await _fadeAnimationController.forward();

        // Navigate to appropriate screen
        _navigateToNextScreen();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasError = true;
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _performInitializationTasks() async {
    // Task 1: Check authentication status
    setState(() => _loadingText = 'Checking authentication...');
    await Future.delayed(const Duration(milliseconds: 600));

    // Task 2: Load user preferences
    setState(() => _loadingText = 'Loading preferences...');
    await Future.delayed(const Duration(milliseconds: 500));

    // Task 3: Fetch product categories
    setState(() => _loadingText = 'Fetching categories...');
    await Future.delayed(const Duration(milliseconds: 700));

    // Task 4: Prepare cached data
    setState(() => _loadingText = 'Preparing catalog...');
    await Future.delayed(const Duration(milliseconds: 500));

    // Task 5: Final setup
    setState(() => _loadingText = 'Almost ready...');
    await Future.delayed(const Duration(milliseconds: 400));
  }

  void _navigateToNextScreen() {
    // Mock authentication check
    final bool isAuthenticated = _checkAuthenticationStatus();
    final bool isFirstTime = _checkFirstTimeUser();

    if (isFirstTime) {
      // Navigate to onboarding (using login as placeholder)
      Navigator.pushReplacementNamed(context, '/login-screen');
    } else if (isAuthenticated) {
      // Navigate to home screen
      Navigator.pushReplacementNamed(context, '/home-screen');
    } else {
      // Navigate to login screen
      Navigator.pushReplacementNamed(context, '/login-screen');
    }
  }

  bool _checkAuthenticationStatus() {
    // Mock authentication check
    // In real app, check stored tokens/credentials
    return false; // Default to not authenticated for demo
  }

  bool _checkFirstTimeUser() {
    // Mock first time user check
    // In real app, check shared preferences
    return true; // Default to first time for demo
  }

  void _retryInitialization() {
    setState(() {
      _hasError = false;
      _isLoading = true;
      _loadingText = 'Retrying...';
    });

    // Reset animations
    _logoAnimationController.reset();
    _fadeAnimationController.reset();

    // Restart sequence
    _logoAnimationController.forward();
    _startSplashSequence();
  }

  @override
  void dispose() {
    _logoAnimationController.dispose();
    _fadeAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Set system UI overlay style
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      body: AnimatedBuilder(
        animation: _fadeAnimation,
        builder: (context, child) {
          return Opacity(
            opacity: _fadeAnimation.value,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppTheme.lightTheme.colorScheme.primary,
                    AppTheme.lightTheme.colorScheme.primary
                        .withValues(alpha: 0.8),
                    AppTheme.lightTheme.colorScheme.secondary
                        .withValues(alpha: 0.6),
                  ],
                ),
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    Expanded(
                      flex: 3,
                      child: _buildLogoSection(),
                    ),
                    Expanded(
                      flex: 1,
                      child: _buildLoadingSection(),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLogoSection() {
    return Center(
      child: AnimatedBuilder(
        animation: _logoAnimationController,
        builder: (context, child) {
          return Opacity(
            opacity: _logoOpacityAnimation.value,
            child: Transform.scale(
              scale: _logoScaleAnimation.value,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // App Logo
                  Container(
                    width: 25.w,
                    height: 25.w,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4.w),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Center(
                      child: CustomIconWidget(
                        iconName: 'shopping_bag',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 12.w,
                      ),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  // App Name
                  Text(
                    'ShopEase',
                    style:
                        AppTheme.lightTheme.textTheme.headlineLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  // App Tagline
                  Text(
                    'Your Shopping Companion',
                    style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoadingSection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _hasError ? _buildErrorSection() : _buildLoadingIndicator(),
        SizedBox(height: 4.h),
        // Version info
        Text(
          'Version 1.0.0',
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: Colors.white.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingIndicator() {
    return Column(
      children: [
        // Loading spinner
        SizedBox(
          width: 8.w,
          height: 8.w,
          child: CircularProgressIndicator(
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            strokeWidth: 0.5.w,
          ),
        ),
        SizedBox(height: 2.h),
        // Loading text
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Text(
            _loadingText,
            key: ValueKey(_loadingText),
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorSection() {
    return Column(
      children: [
        // Error icon
        CustomIconWidget(
          iconName: 'error_outline',
          color: Colors.white,
          size: 8.w,
        ),
        SizedBox(height: 2.h),
        // Error message
        Text(
          'Something went wrong',
          style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          'Please check your connection and try again',
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: Colors.white.withValues(alpha: 0.8),
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 3.h),
        // Retry button
        ElevatedButton(
          onPressed: _retryInitialization,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: AppTheme.lightTheme.colorScheme.primary,
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 1.5.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(2.w),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomIconWidget(
                iconName: 'refresh',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 5.w,
              ),
              SizedBox(width: 2.w),
              Text(
                'Retry',
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
