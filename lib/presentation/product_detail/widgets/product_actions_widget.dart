import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProductActionsWidget extends StatelessWidget {
  final bool isInStock;
  final VoidCallback onAddToCart;
  final VoidCallback onBuyNow;

  const ProductActionsWidget({
    super.key,
    required this.isInStock,
    required this.onAddToCart,
    required this.onBuyNow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        children: [
          // Add to Cart button
          SizedBox(
            width: double.infinity,
            height: 6.h,
            child: ElevatedButton(
              onPressed: isInStock ? onAddToCart : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: isInStock
                    ? AppTheme.accentLight
                    : AppTheme.textDisabledLight,
                foregroundColor: AppTheme.onAccentLight,
                elevation: isInStock ? 2 : 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: 'shopping_cart',
                    color: AppTheme.onAccentLight,
                    size: 20,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    isInStock ? 'Add to Cart' : 'Out of Stock',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      color: AppTheme.onAccentLight,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 2.h),

          // Buy Now button
          SizedBox(
            width: double.infinity,
            height: 6.h,
            child: OutlinedButton(
              onPressed: isInStock ? onBuyNow : null,
              style: OutlinedButton.styleFrom(
                foregroundColor: isInStock
                    ? AppTheme.accentLight
                    : AppTheme.textDisabledLight,
                side: BorderSide(
                  color: isInStock
                      ? AppTheme.accentLight
                      : AppTheme.textDisabledLight,
                  width: 2,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: 'flash_on',
                    color: isInStock
                        ? AppTheme.accentLight
                        : AppTheme.textDisabledLight,
                    size: 20,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Buy Now',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      color: isInStock
                          ? AppTheme.accentLight
                          : AppTheme.textDisabledLight,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 2.h),

          // Additional info row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildInfoItem(
                icon: 'security',
                text: 'Secure Payment',
                color: AppTheme.successLight,
              ),
              Container(
                width: 1,
                height: 4.h,
                color: AppTheme.borderLight,
              ),
              _buildInfoItem(
                icon: 'local_shipping',
                text: 'Free Shipping',
                color: AppTheme.accentLight,
              ),
              Container(
                width: 1,
                height: 4.h,
                color: AppTheme.borderLight,
              ),
              _buildInfoItem(
                icon: 'keyboard_return',
                text: '30-Day Return',
                color: AppTheme.warningLight,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem({
    required String icon,
    required String text,
    required Color color,
  }) {
    return Column(
      children: [
        CustomIconWidget(
          iconName: icon,
          color: color,
          size: 24,
        ),
        SizedBox(height: 1.h),
        Text(
          text,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.textMediumEmphasisLight,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
