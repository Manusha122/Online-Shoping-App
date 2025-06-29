import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class OrderSummaryWidget extends StatelessWidget {
  final double subtotal;
  final double shipping;
  final double tax;
  final double total;
  final VoidCallback onCheckout;

  const OrderSummaryWidget({
    super.key,
    required this.subtotal,
    required this.shipping,
    required this.tax,
    required this.total,
    required this.onCheckout,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(
            color: AppTheme.borderLight,
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Order Summary',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 2.h),

              // Subtotal
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Subtotal',
                    style: AppTheme.lightTheme.textTheme.bodyMedium,
                  ),
                  Text(
                    '\$${subtotal.toStringAsFixed(2)}',
                    style: AppTheme.lightTheme.textTheme.bodyMedium,
                  ),
                ],
              ),
              SizedBox(height: 1.h),

              // Shipping
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        'Shipping',
                        style: AppTheme.lightTheme.textTheme.bodyMedium,
                      ),
                      if (shipping == 0.0) ...[
                        SizedBox(width: 2.w),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 2.w,
                            vertical: 0.5.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.successLight.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'FREE',
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: AppTheme.successLight,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  Text(
                    shipping == 0.0
                        ? 'Free'
                        : '\$${shipping.toStringAsFixed(2)}',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: shipping == 0.0 ? AppTheme.successLight : null,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 1.h),

              // Tax
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Tax',
                    style: AppTheme.lightTheme.textTheme.bodyMedium,
                  ),
                  Text(
                    '\$${tax.toStringAsFixed(2)}',
                    style: AppTheme.lightTheme.textTheme.bodyMedium,
                  ),
                ],
              ),
              SizedBox(height: 2.h),

              // Divider
              Divider(
                color: AppTheme.borderLight,
                thickness: 1,
              ),
              SizedBox(height: 2.h),

              // Total
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '\$${total.toStringAsFixed(2)}',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.accentLight,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 3.h),

              // Free shipping notice
              if (subtotal < 50 && subtotal > 0)
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(3.w),
                  margin: EdgeInsets.only(bottom: 3.h),
                  decoration: BoxDecoration(
                    color: AppTheme.warningLight.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppTheme.warningLight.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'local_shipping',
                        color: AppTheme.warningLight,
                        size: 20,
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Text(
                          'Add \$${(50 - subtotal).toStringAsFixed(2)} more for free shipping',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppTheme.warningLight,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              // Checkout button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onCheckout,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconWidget(
                        iconName: 'lock',
                        color: AppTheme.onAccentLight,
                        size: 20,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'Secure Checkout',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
