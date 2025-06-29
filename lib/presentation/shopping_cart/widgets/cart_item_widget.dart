import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CartItemWidget extends StatelessWidget {
  final Map<String, dynamic> item;
  final Function(int) onQuantityChanged;
  final VoidCallback onRemove;
  final VoidCallback onMoveToWishlist;
  final VoidCallback onSaveForLater;

  const CartItemWidget({
    super.key,
    required this.item,
    required this.onQuantityChanged,
    required this.onRemove,
    required this.onMoveToWishlist,
    required this.onSaveForLater,
  });

  void _showContextMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.borderLight,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 3.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'favorite_border',
                color: AppTheme.accentLight,
                size: 24,
              ),
              title: const Text('Move to Wishlist'),
              onTap: () {
                Navigator.pop(context);
                onMoveToWishlist();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'bookmark_border',
                color: AppTheme.secondaryLight,
                size: 24,
              ),
              title: const Text('Save for Later'),
              onTap: () {
                Navigator.pop(context);
                onSaveForLater();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'delete_outline',
                color: AppTheme.errorLight,
                size: 24,
              ),
              title: const Text('Remove'),
              onTap: () {
                Navigator.pop(context);
                onRemove();
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool inStock = item["inStock"] ?? true;
    final int quantity = item["quantity"] ?? 1;
    final int maxQuantity = item["maxQuantity"] ?? 10;

    return Dismissible(
      key: Key('cart_item_${item["id"]}'),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) => onRemove(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 4.w),
        decoration: BoxDecoration(
          color: AppTheme.errorLight,
          borderRadius: BorderRadius.circular(12),
        ),
        child: CustomIconWidget(
          iconName: 'delete',
          color: AppTheme.onErrorLight,
          size: 24,
        ),
      ),
      child: GestureDetector(
        onLongPress: () => _showContextMenu(context),
        child: Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.cardColor,
            borderRadius: BorderRadius.circular(12),
            border: !inStock
                ? Border.all(color: AppTheme.errorLight, width: 1)
                : null,
          ),
          child: Column(
            children: [
              if (!inStock)
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 1.h),
                  margin: EdgeInsets.only(bottom: 2.h),
                  decoration: BoxDecoration(
                    color: AppTheme.errorLight.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconWidget(
                        iconName: 'warning',
                        color: AppTheme.errorLight,
                        size: 16,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'Out of Stock',
                        style: TextStyle(
                          color: AppTheme.errorLight,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CustomImageWidget(
                      imageUrl: item["image"] ?? "",
                      width: 20.w,
                      height: 20.w,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: 4.w),

                  // Product details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item["name"] ?? "",
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(
                            color: inStock
                                ? AppTheme.textHighEmphasisLight
                                : AppTheme.textDisabledLight,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 1.h),

                        // Product options
                        if (item["size"] != null || item["color"] != null)
                          Wrap(
                            spacing: 2.w,
                            children: [
                              if (item["size"] != null)
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 2.w,
                                    vertical: 0.5.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        AppTheme.lightTheme.colorScheme.surface,
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(
                                      color: AppTheme.borderLight,
                                      width: 1,
                                    ),
                                  ),
                                  child: Text(
                                    'Size: ${item["size"]}',
                                    style: TextStyle(
                                      fontSize: 10.sp,
                                      color: AppTheme.textMediumEmphasisLight,
                                    ),
                                  ),
                                ),
                              if (item["color"] != null)
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 2.w,
                                    vertical: 0.5.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        AppTheme.lightTheme.colorScheme.surface,
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(
                                      color: AppTheme.borderLight,
                                      width: 1,
                                    ),
                                  ),
                                  child: Text(
                                    'Color: ${item["color"]}',
                                    style: TextStyle(
                                      fontSize: 10.sp,
                                      color: AppTheme.textMediumEmphasisLight,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        SizedBox(height: 2.h),

                        // Price and quantity row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Price
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '\$${(item["price"] ?? 0.0).toStringAsFixed(2)}',
                                  style: AppTheme
                                      .lightTheme.textTheme.titleMedium
                                      ?.copyWith(
                                    color: inStock
                                        ? AppTheme.accentLight
                                        : AppTheme.textDisabledLight,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                if (item["originalPrice"] != null &&
                                    item["originalPrice"] != item["price"])
                                  Text(
                                    '\$${(item["originalPrice"] ?? 0.0).toStringAsFixed(2)}',
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: AppTheme.textDisabledLight,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                              ],
                            ),

                            // Quantity controls
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppTheme.borderLight,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  InkWell(
                                    onTap: inStock && quantity > 1
                                        ? () => onQuantityChanged(quantity - 1)
                                        : null,
                                    child: Container(
                                      padding: EdgeInsets.all(2.w),
                                      child: CustomIconWidget(
                                        iconName: 'remove',
                                        color: inStock && quantity > 1
                                            ? AppTheme.textHighEmphasisLight
                                            : AppTheme.textDisabledLight,
                                        size: 16,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 3.w),
                                    child: Text(
                                      quantity.toString(),
                                      style: AppTheme
                                          .lightTheme.textTheme.bodyMedium
                                          ?.copyWith(
                                        fontWeight: FontWeight.w500,
                                        color: inStock
                                            ? AppTheme.textHighEmphasisLight
                                            : AppTheme.textDisabledLight,
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: inStock && quantity < maxQuantity
                                        ? () => onQuantityChanged(quantity + 1)
                                        : null,
                                    child: Container(
                                      padding: EdgeInsets.all(2.w),
                                      child: CustomIconWidget(
                                        iconName: 'add',
                                        color: inStock && quantity < maxQuantity
                                            ? AppTheme.textHighEmphasisLight
                                            : AppTheme.textDisabledLight,
                                        size: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
