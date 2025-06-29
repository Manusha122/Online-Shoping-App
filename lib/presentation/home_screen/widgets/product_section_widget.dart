import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';
import './product_card_widget.dart';

class ProductSectionWidget extends StatelessWidget {
  final String title;
  final List<Map<String, dynamic>> products;
  final Function(Map<String, dynamic>) onProductTap;
  final VoidCallback onSeeAllTap;

  const ProductSectionWidget({
    super.key,
    required this.title,
    required this.products,
    required this.onProductTap,
    required this.onSeeAllTap,
  });

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: onSeeAllTap,
                child: Text(
                  'See All',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 1.h),

        // Horizontal product list
        SizedBox(
          height: 35.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return Container(
                width: 45.w,
                margin: EdgeInsets.only(right: 3.w),
                child: ProductCardWidget(
                  product: product,
                  onTap: () => onProductTap(product),
                  onWishlistTap: () {
                    // Handle wishlist toggle
                  },
                  onQuickAddTap: () {
                    // Handle quick add to cart
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
