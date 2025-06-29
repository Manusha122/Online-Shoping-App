import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/product_actions_widget.dart';
import './widgets/product_image_carousel_widget.dart';
import './widgets/product_info_widget.dart';
import './widgets/product_options_widget.dart';
import './widgets/product_sections_widget.dart';
import './widgets/related_products_widget.dart';

class ProductDetail extends StatefulWidget {
  const ProductDetail({super.key});

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  late AnimationController _cartAnimationController;
  late AnimationController _fabAnimationController;

  bool _showTitle = false;
  int _cartItemCount = 0;
  int _selectedImageIndex = 0;
  String _selectedSize = 'M';
  String _selectedColor = 'Black';
  int _quantity = 1;
  bool _isWishlisted = false;
  final bool _isInStock = true;

  // Mock product data
  final Map<String, dynamic> productData = {
    "id": 1,
    "name": "Premium Cotton T-Shirt",
    "price": 29.99,
    "originalPrice": 39.99,
    "discount": 25,
    "rating": 4.5,
    "reviewCount": 128,
    "description":
        """Experience ultimate comfort with our premium cotton t-shirt. Made from 100% organic cotton, this versatile piece features a classic fit that's perfect for any occasion. The breathable fabric ensures all-day comfort while maintaining its shape wash after wash.""",
    "specifications": {
      "Material": "100% Organic Cotton",
      "Fit": "Regular Fit",
      "Care": "Machine wash cold",
      "Origin": "Made in USA",
      "Weight": "180 GSM"
    },
    "images": [
      "https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=500&h=600&fit=crop",
      "https://images.unsplash.com/photo-1503341504253-dff4815485f1?w=500&h=600&fit=crop",
      "https://images.unsplash.com/photo-1562157873-818bc0726f68?w=500&h=600&fit=crop",
      "https://images.unsplash.com/photo-1576566588028-4147f3842f27?w=500&h=600&fit=crop"
    ],
    "sizes": ["XS", "S", "M", "L", "XL", "XXL"],
    "colors": ["Black", "White", "Navy", "Gray", "Red"],
    "inStock": true,
    "stockCount": 15,
    "shipping": {
      "freeShipping": true,
      "estimatedDays": "3-5 business days",
      "returnPolicy": "30-day return policy"
    }
  };

  final List<Map<String, dynamic>> relatedProducts = [
    {
      "id": 2,
      "name": "Classic Polo Shirt",
      "price": 34.99,
      "rating": 4.3,
      "image":
          "https://images.unsplash.com/photo-1586790170083-2f9ceadc732d?w=300&h=400&fit=crop"
    },
    {
      "id": 3,
      "name": "Casual Hoodie",
      "price": 49.99,
      "rating": 4.7,
      "image":
          "https://images.unsplash.com/photo-1556821840-3a63f95609a7?w=300&h=400&fit=crop"
    },
    {
      "id": 4,
      "name": "Denim Jacket",
      "price": 79.99,
      "rating": 4.4,
      "image":
          "https://images.unsplash.com/photo-1551028719-00167b16eac5?w=300&h=400&fit=crop"
    }
  ];

  final List<Map<String, dynamic>> reviews = [
    {
      "id": 1,
      "userName": "Sarah Johnson",
      "rating": 5,
      "comment":
          "Amazing quality! The fabric is so soft and comfortable. Perfect fit and great value for money.",
      "date": "2024-01-15",
      "userImage":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "helpful": 12
    },
    {
      "id": 2,
      "userName": "Mike Chen",
      "rating": 4,
      "comment":
          "Good quality shirt, runs slightly large. Color is exactly as shown in pictures.",
      "date": "2024-01-10",
      "userImage":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "helpful": 8
    },
    {
      "id": 3,
      "userName": "Emma Wilson",
      "rating": 5,
      "comment":
          "Love this t-shirt! Washes well and maintains its shape. Will definitely buy more colors.",
      "date": "2024-01-05",
      "userImage":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "helpful": 15
    }
  ];

  @override
  void initState() {
    super.initState();
    _cartAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _cartAnimationController.dispose();
    _fabAnimationController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final showTitle = _scrollController.offset > 200;
    if (showTitle != _showTitle) {
      setState(() {
        _showTitle = showTitle;
      });
    }
  }

  void _addToCart() {
    if (!_isInStock) return;

    HapticFeedback.lightImpact();
    setState(() {
      _cartItemCount += _quantity;
    });

    _cartAnimationController.forward().then((_) {
      _cartAnimationController.reverse();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added $_quantity item(s) to cart'),
        action: SnackBarAction(
          label: 'View Cart',
          onPressed: () => Navigator.pushNamed(context, '/shopping-cart'),
        ),
      ),
    );
  }

  void _buyNow() {
    if (!_isInStock) return;

    HapticFeedback.mediumImpact();
    Navigator.pushNamed(context, '/shopping-cart');
  }

  void _toggleWishlist() {
    HapticFeedback.selectionClick();
    setState(() {
      _isWishlisted = !_isWishlisted;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text(_isWishlisted ? 'Added to wishlist' : 'Removed from wishlist'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _shareProduct() {
    HapticFeedback.selectionClick();
    // Platform-native sharing would be implemented here
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Share functionality would open here'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              _buildSliverAppBar(),
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ProductImageCarouselWidget(
                      images: (productData["images"] as List).cast<String>(),
                      selectedIndex: _selectedImageIndex,
                      onImageChanged: (index) {
                        setState(() {
                          _selectedImageIndex = index;
                        });
                      },
                    ),
                    SizedBox(height: 2.h),
                    ProductInfoWidget(
                      productData: productData,
                      isWishlisted: _isWishlisted,
                      onWishlistToggle: _toggleWishlist,
                    ),
                    SizedBox(height: 2.h),
                    ProductOptionsWidget(
                      sizes: (productData["sizes"] as List).cast<String>(),
                      colors: (productData["colors"] as List).cast<String>(),
                      selectedSize: _selectedSize,
                      selectedColor: _selectedColor,
                      quantity: _quantity,
                      onSizeChanged: (size) {
                        setState(() {
                          _selectedSize = size;
                        });
                      },
                      onColorChanged: (color) {
                        setState(() {
                          _selectedColor = color;
                        });
                      },
                      onQuantityChanged: (quantity) {
                        setState(() {
                          _quantity = quantity;
                        });
                      },
                    ),
                    SizedBox(height: 2.h),
                    ProductActionsWidget(
                      isInStock: _isInStock,
                      onAddToCart: _addToCart,
                      onBuyNow: _buyNow,
                    ),
                    SizedBox(height: 3.h),
                    ProductSectionsWidget(
                      productData: productData,
                      reviews: reviews,
                    ),
                    SizedBox(height: 3.h),
                    RelatedProductsWidget(
                      products: relatedProducts,
                    ),
                    SizedBox(height: 10.h),
                  ],
                ),
              ),
            ],
          ),
          _buildFloatingCartButton(),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 0,
      floating: true,
      pinned: true,
      backgroundColor:
          AppTheme.lightTheme.scaffoldBackgroundColor.withValues(alpha: 0.95),
      elevation: _showTitle ? 1 : 0,
      leading: Container(
        margin: EdgeInsets.all(2.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.scaffoldBackgroundColor,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.primaryColor,
            size: 20,
          ),
        ),
      ),
      title: AnimatedOpacity(
        opacity: _showTitle ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 200),
        child: Text(
          productData["name"] as String,
          style: AppTheme.lightTheme.textTheme.titleMedium,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      actions: [
        Container(
          margin: EdgeInsets.all(2.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.scaffoldBackgroundColor,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: IconButton(
            onPressed: _shareProduct,
            icon: CustomIconWidget(
              iconName: 'share',
              color: AppTheme.lightTheme.primaryColor,
              size: 20,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(right: 4.w, top: 2.w, bottom: 2.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.scaffoldBackgroundColor,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: IconButton(
            onPressed: _toggleWishlist,
            icon: CustomIconWidget(
              iconName: _isWishlisted ? 'favorite' : 'favorite_border',
              color: _isWishlisted
                  ? AppTheme.errorLight
                  : AppTheme.lightTheme.primaryColor,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFloatingCartButton() {
    return Positioned(
      bottom: 12.h,
      right: 4.w,
      child: AnimatedBuilder(
        animation: _cartAnimationController,
        builder: (context, child) {
          return Transform.scale(
            scale: 1.0 + (_cartAnimationController.value * 0.2),
            child: Container(
              width: 14.w,
              height: 14.w,
              decoration: BoxDecoration(
                color: AppTheme.accentLight,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.accentLight.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Center(
                    child: CustomIconWidget(
                      iconName: 'shopping_cart',
                      color: AppTheme.onAccentLight,
                      size: 24,
                    ),
                  ),
                  if (_cartItemCount > 0)
                    Positioned(
                      top: 1.w,
                      right: 1.w,
                      child: Container(
                        padding: EdgeInsets.all(1.w),
                        decoration: BoxDecoration(
                          color: AppTheme.errorLight,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppTheme.lightTheme.scaffoldBackgroundColor,
                            width: 1,
                          ),
                        ),
                        constraints: BoxConstraints(
                          minWidth: 5.w,
                          minHeight: 5.w,
                        ),
                        child: Text(
                          _cartItemCount > 99
                              ? '99+'
                              : _cartItemCount.toString(),
                          style: AppTheme.lightTheme.textTheme.labelSmall
                              ?.copyWith(
                            color: AppTheme.onErrorLight,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
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
}
