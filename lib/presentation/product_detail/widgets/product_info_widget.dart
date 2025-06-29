import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProductInfoWidget extends StatelessWidget {
  final Map<String, dynamic> productData;
  final bool isWishlisted;
  final VoidCallback onWishlistToggle;

  const ProductInfoWidget({
    super.key,
    required this.productData,
    required this.isWishlisted,
    required this.onWishlistToggle,
  });

  @override
  Widget build(BuildContext context) {
    final price = productData["price"] as double;
    final originalPrice = productData["originalPrice"] as double;
    final discount = productData["discount"] as int;
    final rating = productData["rating"] as double;
    final reviewCount = productData["reviewCount"] as int;
    final inStock = productData["inStock"] as bool;
    final stockCount = productData["stockCount"] as int;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product name and wishlist
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  productData["name"] as String,
                  style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 3.w),
              GestureDetector(
                onTap: onWishlistToggle,
                child: Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: isWishlisted
                        ? AppTheme.errorLight.withValues(alpha: 0.1)
                        : AppTheme.borderLight.withValues(alpha: 0.3),
                    shape: BoxShape.circle,
                  ),
                  child: CustomIconWidget(
                    iconName: isWishlisted ? 'favorite' : 'favorite_border',
                    color: isWishlisted
                        ? AppTheme.errorLight
                        : AppTheme.secondaryLight,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Price section
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '\$${price.toStringAsFixed(2)}',
                style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
                  color: AppTheme.accentLight,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(width: 3.w),
              if (originalPrice > price) ...[
                Text(
                  '\$${originalPrice.toStringAsFixed(2)}',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    color: AppTheme.textMediumEmphasisLight,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
                SizedBox(width: 2.w),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.w),
                  decoration: BoxDecoration(
                    color: AppTheme.successLight,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '$discount% OFF',
                    style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                      color: AppTheme.onSuccessLight,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ],
          ),

          SizedBox(height: 2.h),

          // Rating and reviews
          Row(
            children: [
              Row(
                children: List.generate(5, (index) {
                  return CustomIconWidget(
                    iconName: index < rating.floor() ? 'star' : 'star_border',
                    color: AppTheme.warningLight,
                    size: 16,
                  );
                }),
              ),
              SizedBox(width: 2.w),
              Text(
                rating.toString(),
                style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(width: 2.w),
              Text(
                '($reviewCount reviews)',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textMediumEmphasisLight,
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Stock status
          Row(
            children: [
              Container(
                width: 2.w,
                height: 2.w,
                decoration: BoxDecoration(
                  color: inStock ? AppTheme.successLight : AppTheme.errorLight,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 2.w),
              Text(
                inStock ? 'In Stock' : 'Out of Stock',
                style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                  color: inStock ? AppTheme.successLight : AppTheme.errorLight,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (inStock && stockCount <= 10) ...[
                SizedBox(width: 2.w),
                Text(
                  '(Only $stockCount left)',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.warningLight,
                  ),
                ),
              ],
            ],
          ),

          SizedBox(height: 2.h),

          // Shipping info
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.successLight.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppTheme.successLight.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'local_shipping',
                  color: AppTheme.successLight,
                  size: 20,
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Free Shipping',
                        style:
                            AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                          color: AppTheme.successLight,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        (productData["shipping"]
                            as Map<String, dynamic>)["estimatedDays"] as String,
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.textMediumEmphasisLight,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
