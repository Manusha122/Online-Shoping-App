import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProductCardWidget extends StatefulWidget {
  final Map<String, dynamic> product;
  final VoidCallback onTap;
  final VoidCallback onWishlistTap;
  final VoidCallback onQuickAddTap;

  const ProductCardWidget({
    super.key,
    required this.product,
    required this.onTap,
    required this.onWishlistTap,
    required this.onQuickAddTap,
  });

  @override
  State<ProductCardWidget> createState() => _ProductCardWidgetState();
}

class _ProductCardWidgetState extends State<ProductCardWidget> {
  bool _isWishlisted = false;

  @override
  void initState() {
    super.initState();
    _isWishlisted = widget.product['isWishlisted'] as bool? ?? false;
  }

  void _toggleWishlist() {
    setState(() {
      _isWishlisted = !_isWishlisted;
    });
    widget.onWishlistTap();
  }

  Widget _buildRatingStars(double rating) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        if (index < rating.floor()) {
          return CustomIconWidget(
            iconName: 'star',
            color: Colors.amber,
            size: 3.w,
          );
        } else if (index < rating) {
          return CustomIconWidget(
            iconName: 'star_half',
            color: Colors.amber,
            size: 3.w,
          );
        } else {
          return CustomIconWidget(
            iconName: 'star_border',
            color: Colors.grey,
            size: 3.w,
          );
        }
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final rating = (product['rating'] as num?)?.toDouble() ?? 0.0;
    final hasOriginalPrice = product['originalPrice'] != null &&
        product['originalPrice'] != product['price'];

    return GestureDetector(
      onTap: widget.onTap,
      onLongPress: () {
        _showQuickActions(context);
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.cardColor,
          borderRadius: BorderRadius.circular(3.w),
          boxShadow: [
            BoxShadow(
              color:
                  AppTheme.lightTheme.colorScheme.shadow.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image with wishlist button
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(3.w),
                      topRight: Radius.circular(3.w),
                    ),
                    child: CustomImageWidget(
                      imageUrl: product['image'] as String,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),

                  // Wishlist button
                  Positioned(
                    top: 2.w,
                    right: 2.w,
                    child: GestureDetector(
                      onTap: _toggleWishlist,
                      child: Container(
                        padding: EdgeInsets.all(2.w),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(2.w),
                        ),
                        child: CustomIconWidget(
                          iconName:
                              _isWishlisted ? 'favorite' : 'favorite_border',
                          color: _isWishlisted
                              ? AppTheme.lightTheme.colorScheme.error
                              : AppTheme.lightTheme.colorScheme.onSurface
                                  .withValues(alpha: 0.6),
                          size: 4.w,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Product details
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.all(3.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product name
                    Text(
                      product['name'] as String,
                      style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    SizedBox(height: 1.h),

                    // Rating
                    Row(
                      children: [
                        _buildRatingStars(rating),
                        SizedBox(width: 2.w),
                        Text(
                          rating.toStringAsFixed(1),
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.onSurface
                                .withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),

                    const Spacer(),

                    // Price and quick add button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product['price'] as String,
                                style: AppTheme.lightTheme.textTheme.titleMedium
                                    ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color:
                                      AppTheme.lightTheme.colorScheme.primary,
                                ),
                              ),
                              if (hasOriginalPrice)
                                Text(
                                  product['originalPrice'] as String,
                                  style: AppTheme.lightTheme.textTheme.bodySmall
                                      ?.copyWith(
                                    decoration: TextDecoration.lineThrough,
                                    color: AppTheme
                                        .lightTheme.colorScheme.onSurface
                                        .withValues(alpha: 0.6),
                                  ),
                                ),
                            ],
                          ),
                        ),

                        // Quick add button
                        GestureDetector(
                          onTap: widget.onQuickAddTap,
                          child: Container(
                            padding: EdgeInsets.all(2.w),
                            decoration: BoxDecoration(
                              color: AppTheme.lightTheme.colorScheme.primary,
                              borderRadius: BorderRadius.circular(2.w),
                            ),
                            child: CustomIconWidget(
                              iconName: 'add',
                              color: AppTheme.lightTheme.colorScheme.onPrimary,
                              size: 4.w,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showQuickActions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.lightTheme.cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(4.w)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 1.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(1.w),
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              'Quick Actions',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 3.h),
            _buildQuickActionItem(
              icon: 'favorite_border',
              title: 'Add to Wishlist',
              onTap: () {
                Navigator.pop(context);
                _toggleWishlist();
              },
            ),
            _buildQuickActionItem(
              icon: 'share',
              title: 'Share Product',
              onTap: () {
                Navigator.pop(context);
                // Handle share
              },
            ),
            _buildQuickActionItem(
              icon: 'compare_arrows',
              title: 'Similar Items',
              onTap: () {
                Navigator.pop(context);
                // Handle similar items
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionItem({
    required String icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: CustomIconWidget(
        iconName: icon,
        color: AppTheme.lightTheme.colorScheme.primary,
        size: 6.w,
      ),
      title: Text(
        title,
        style: AppTheme.lightTheme.textTheme.bodyLarge,
      ),
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(horizontal: 2.w),
    );
  }
}
