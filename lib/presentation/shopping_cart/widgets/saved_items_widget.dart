import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SavedItemsWidget extends StatelessWidget {
  final List<Map<String, dynamic>> savedItems;
  final Function(int) onMoveToCart;
  final Function(int) onRemove;

  const SavedItemsWidget({
    super.key,
    required this.savedItems,
    required this.onMoveToCart,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    if (savedItems.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'bookmark_border',
              color: AppTheme.textDisabledLight,
              size: 64,
            ),
            SizedBox(height: 3.h),
            Text(
              'No Saved Items',
              style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                color: AppTheme.textMediumEmphasisLight,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Items you save for later will appear here',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.textDisabledLight,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.all(4.w),
      itemCount: savedItems.length,
      separatorBuilder: (context, index) => SizedBox(height: 2.h),
      itemBuilder: (context, index) {
        final item = savedItems[index];
        return Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.cardColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
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
                      style: AppTheme.lightTheme.textTheme.titleMedium,
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
                                color: AppTheme.lightTheme.colorScheme.surface,
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
                                color: AppTheme.lightTheme.colorScheme.surface,
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

                    // Price
                    Row(
                      children: [
                        Text(
                          '\$${(item["price"] ?? 0.0).toStringAsFixed(2)}',
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(
                            color: AppTheme.accentLight,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (item["originalPrice"] != null &&
                            item["originalPrice"] != item["price"]) ...[
                          SizedBox(width: 2.w),
                          Text(
                            '\$${(item["originalPrice"] ?? 0.0).toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: AppTheme.textDisabledLight,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ],
                      ],
                    ),
                    SizedBox(height: 2.h),

                    // Action buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => onMoveToCart(item["id"]),
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 1.5.h),
                            ),
                            child: const Text('Move to Cart'),
                          ),
                        ),
                        SizedBox(width: 3.w),
                        InkWell(
                          onTap: () => onRemove(item["id"]),
                          child: Container(
                            padding: EdgeInsets.all(2.w),
                            decoration: BoxDecoration(
                              color: AppTheme.errorLight.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: CustomIconWidget(
                              iconName: 'delete_outline',
                              color: AppTheme.errorLight,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
