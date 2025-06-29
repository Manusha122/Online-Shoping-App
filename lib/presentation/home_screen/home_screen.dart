import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/category_grid_widget.dart';
import './widgets/hero_banner_widget.dart';
import './widgets/product_section_widget.dart';
import './widgets/search_header_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final RefreshIndicator _refreshIndicator = RefreshIndicator(
    onRefresh: () async {
      await Future.delayed(const Duration(seconds: 1));
    },
    child: Container(),
  );
  int _currentBottomNavIndex = 0;
  bool _isLoading = false;

  // Mock data for the home screen
  final List<Map<String, dynamic>> _bannerData = [
    {
      "id": 1,
      "title": "Summer Sale",
      "subtitle": "Up to 50% off on fashion",
      "image":
          "https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=800&h=400&fit=crop",
      "backgroundColor": "#FF6B6B"
    },
    {
      "id": 2,
      "title": "Electronics Deal",
      "subtitle": "Latest gadgets at best prices",
      "image":
          "https://images.unsplash.com/photo-1498049794561-7780e7231661?w=800&h=400&fit=crop",
      "backgroundColor": "#4ECDC4"
    },
    {
      "id": 3,
      "title": "Home & Garden",
      "subtitle": "Transform your space",
      "image":
          "https://images.unsplash.com/photo-1586023492125-27b2c045efd7?w=800&h=400&fit=crop",
      "backgroundColor": "#45B7D1"
    }
  ];

  final List<Map<String, dynamic>> _trendingProducts = [
    {
      "id": 1,
      "name": "Wireless Headphones",
      "price": "\$89.99",
      "originalPrice": "\$129.99",
      "image":
          "https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=300&h=300&fit=crop",
      "rating": 4.5,
      "isWishlisted": false
    },
    {
      "id": 2,
      "name": "Smart Watch",
      "price": "\$199.99",
      "originalPrice": "\$249.99",
      "image":
          "https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=300&h=300&fit=crop",
      "rating": 4.8,
      "isWishlisted": true
    },
    {
      "id": 3,
      "name": "Bluetooth Speaker",
      "price": "\$49.99",
      "originalPrice": "\$79.99",
      "image":
          "https://images.unsplash.com/photo-1608043152269-423dbba4e7e1?w=300&h=300&fit=crop",
      "rating": 4.3,
      "isWishlisted": false
    },
    {
      "id": 4,
      "name": "Laptop Stand",
      "price": "\$29.99",
      "originalPrice": "\$39.99",
      "image":
          "https://images.unsplash.com/photo-1527864550417-7fd91fc51a46?w=300&h=300&fit=crop",
      "rating": 4.6,
      "isWishlisted": false
    }
  ];

  final List<Map<String, dynamic>> _recommendedProducts = [
    {
      "id": 5,
      "name": "Running Shoes",
      "price": "\$79.99",
      "originalPrice": "\$99.99",
      "image":
          "https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=300&h=300&fit=crop",
      "rating": 4.7,
      "isWishlisted": false
    },
    {
      "id": 6,
      "name": "Coffee Maker",
      "price": "\$149.99",
      "originalPrice": "\$199.99",
      "image":
          "https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=300&h=300&fit=crop",
      "rating": 4.4,
      "isWishlisted": true
    },
    {
      "id": 7,
      "name": "Backpack",
      "price": "\$39.99",
      "originalPrice": "\$59.99",
      "image":
          "https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=300&h=300&fit=crop",
      "rating": 4.2,
      "isWishlisted": false
    }
  ];

  final List<Map<String, dynamic>> _recentlyViewedProducts = [
    {
      "id": 8,
      "name": "Smartphone",
      "price": "\$699.99",
      "originalPrice": "\$799.99",
      "image":
          "https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=300&h=300&fit=crop",
      "rating": 4.6,
      "isWishlisted": false
    },
    {
      "id": 9,
      "name": "Tablet",
      "price": "\$299.99",
      "originalPrice": "\$399.99",
      "image":
          "https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?w=300&h=300&fit=crop",
      "rating": 4.5,
      "isWishlisted": true
    }
  ];

  final List<Map<String, dynamic>> _categories = [
    {"id": 1, "name": "Electronics", "icon": "devices", "color": "#FF6B6B"},
    {"id": 2, "name": "Fashion", "icon": "checkroom", "color": "#4ECDC4"},
    {"id": 3, "name": "Home", "icon": "home", "color": "#45B7D1"},
    {"id": 4, "name": "Sports", "icon": "sports_soccer", "color": "#96CEB4"},
    {"id": 5, "name": "Books", "icon": "menu_book", "color": "#FFEAA7"},
    {
      "id": 6,
      "name": "Beauty",
      "icon": "face_retouching_natural",
      "color": "#DDA0DD"
    },
    {"id": 7, "name": "Toys", "icon": "toys", "color": "#98D8C8"},
    {"id": 8, "name": "More", "icon": "more_horiz", "color": "#F7DC6F"}
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMoreProducts();
    }
  }

  Future<void> _loadMoreProducts() async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _onRefresh() async {
    await Future.delayed(const Duration(seconds: 1));
  }

  void _onBottomNavTap(int index) {
    setState(() {
      _currentBottomNavIndex = index;
    });

    switch (index) {
      case 0:
        // Already on home
        break;
      case 1:
        Navigator.pushNamed(context, '/product-search');
        break;
      case 2:
        Navigator.pushNamed(context, '/shopping-cart');
        break;
      case 3:
        // Profile - not implemented
        break;
    }
  }

  void _onProductTap(Map<String, dynamic> product) {
    Navigator.pushNamed(context, '/product-detail', arguments: product);
  }

  void _onCategoryTap(Map<String, dynamic> category) {
    Navigator.pushNamed(context, '/product-search',
        arguments: {'category': category['name']});
  }

  void _onSearchTap() {
    Navigator.pushNamed(context, '/product-search');
  }

  void _onNotificationTap() {
    // Handle notification tap
  }

  void _onScanTap() {
    // Handle barcode/QR scan
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _onRefresh,
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              // Sticky header with search and notifications
              SliverAppBar(
                floating: true,
                pinned: true,
                snap: false,
                elevation: 0,
                backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
                flexibleSpace: SearchHeaderWidget(
                  onSearchTap: _onSearchTap,
                  onNotificationTap: _onNotificationTap,
                  notificationCount: 3,
                ),
              ),

              // Main content
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 2.h),

                    // Hero banner carousel
                    HeroBannerWidget(
                      banners: _bannerData,
                      onBannerTap: (banner) {
                        // Handle banner tap
                      },
                    ),

                    SizedBox(height: 3.h),

                    // Categories grid
                    CategoryGridWidget(
                      categories: _categories,
                      onCategoryTap: _onCategoryTap,
                    ),

                    SizedBox(height: 3.h),

                    // Trending products section
                    ProductSectionWidget(
                      title: "Trending Now",
                      products: _trendingProducts,
                      onProductTap: _onProductTap,
                      onSeeAllTap: () {
                        Navigator.pushNamed(context, '/product-search',
                            arguments: {'section': 'trending'});
                      },
                    ),

                    SizedBox(height: 3.h),

                    // Recommended products section
                    ProductSectionWidget(
                      title: "Recommended for You",
                      products: _recommendedProducts,
                      onProductTap: _onProductTap,
                      onSeeAllTap: () {
                        Navigator.pushNamed(context, '/product-search',
                            arguments: {'section': 'recommended'});
                      },
                    ),

                    SizedBox(height: 3.h),

                    // Recently viewed products section
                    if (_recentlyViewedProducts.isNotEmpty)
                      ProductSectionWidget(
                        title: "Recently Viewed",
                        products: _recentlyViewedProducts,
                        onProductTap: _onProductTap,
                        onSeeAllTap: () {
                          Navigator.pushNamed(context, '/product-search',
                              arguments: {'section': 'recent'});
                        },
                      ),

                    SizedBox(height: 3.h),

                    // Loading indicator for infinite scroll
                    if (_isLoading)
                      Container(
                        padding: EdgeInsets.all(4.w),
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(
                          color: AppTheme.lightTheme.colorScheme.primary,
                        ),
                      ),

                    SizedBox(height: 10.h), // Bottom padding for FAB
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      // Floating action button for scanning
      floatingActionButton: FloatingActionButton(
        onPressed: _onScanTap,
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        child: CustomIconWidget(
          iconName: 'qr_code_scanner',
          color: AppTheme.lightTheme.colorScheme.onPrimary,
          size: 6.w,
        ),
      ),

      // Bottom navigation bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentBottomNavIndex,
        onTap: _onBottomNavTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        selectedItemColor: AppTheme.lightTheme.colorScheme.primary,
        unselectedItemColor:
            AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.6),
        elevation: 8.0,
        items: [
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'home',
              color: _currentBottomNavIndex == 0
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurface
                      .withValues(alpha: 0.6),
              size: 6.w,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'search',
              color: _currentBottomNavIndex == 1
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurface
                      .withValues(alpha: 0.6),
              size: 6.w,
            ),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Stack(
              children: [
                CustomIconWidget(
                  iconName: 'shopping_cart',
                  color: _currentBottomNavIndex == 2
                      ? AppTheme.lightTheme.colorScheme.primary
                      : AppTheme.lightTheme.colorScheme.onSurface
                          .withValues(alpha: 0.6),
                  size: 6.w,
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: EdgeInsets.all(0.5.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.error,
                      borderRadius: BorderRadius.circular(2.w),
                    ),
                    constraints: BoxConstraints(
                      minWidth: 4.w,
                      minHeight: 4.w,
                    ),
                    child: Text(
                      '2',
                      style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onError,
                        fontSize: 8.sp,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'person',
              color: _currentBottomNavIndex == 3
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurface
                      .withValues(alpha: 0.6),
              size: 6.w,
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
