import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProductOptionsWidget extends StatelessWidget {
  final List<String> sizes;
  final List<String> colors;
  final String selectedSize;
  final String selectedColor;
  final int quantity;
  final Function(String) onSizeChanged;
  final Function(String) onColorChanged;
  final Function(int) onQuantityChanged;

  const ProductOptionsWidget({
    super.key,
    required this.sizes,
    required this.colors,
    required this.selectedSize,
    required this.selectedColor,
    required this.quantity,
    required this.onSizeChanged,
    required this.onColorChanged,
    required this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Size selection
          Text(
            'Size',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          SizedBox(
            height: 6.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: sizes.length,
              itemBuilder: (context, index) {
                final size = sizes[index];
                final isSelected = size == selectedSize;

                return GestureDetector(
                  onTap: () => onSizeChanged(size),
                  child: Container(
                    margin: EdgeInsets.only(right: 3.w),
                    padding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppTheme.accentLight
                          : AppTheme.lightTheme.scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected
                            ? AppTheme.accentLight
                            : AppTheme.borderLight,
                        width: 1,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        size,
                        style:
                            AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                          color: isSelected
                              ? AppTheme.onAccentLight
                              : AppTheme.textHighEmphasisLight,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          SizedBox(height: 3.h),

          // Color selection
          Text(
            'Color',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          SizedBox(
            height: 6.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: colors.length,
              itemBuilder: (context, index) {
                final color = colors[index];
                final isSelected = color == selectedColor;

                return GestureDetector(
                  onTap: () => onColorChanged(color),
                  child: Container(
                    margin: EdgeInsets.only(right: 3.w),
                    padding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppTheme.accentLight
                          : AppTheme.lightTheme.scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected
                            ? AppTheme.accentLight
                            : AppTheme.borderLight,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 4.w,
                          height: 4.w,
                          decoration: BoxDecoration(
                            color: _getColorFromName(color),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppTheme.borderLight,
                              width: 1,
                            ),
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          color,
                          style: AppTheme.lightTheme.textTheme.titleSmall
                              ?.copyWith(
                            color: isSelected
                                ? AppTheme.onAccentLight
                                : AppTheme.textHighEmphasisLight,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          SizedBox(height: 3.h),

          // Quantity selection
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Quantity',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: AppTheme.borderLight),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: quantity > 1
                          ? () => onQuantityChanged(quantity - 1)
                          : null,
                      child: Container(
                        padding: EdgeInsets.all(2.w),
                        child: CustomIconWidget(
                          iconName: 'remove',
                          color: quantity > 1
                              ? AppTheme.textHighEmphasisLight
                              : AppTheme.textDisabledLight,
                          size: 20,
                        ),
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.w),
                      child: Text(
                        quantity.toString(),
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: quantity < 10
                          ? () => onQuantityChanged(quantity + 1)
                          : null,
                      child: Container(
                        padding: EdgeInsets.all(2.w),
                        child: CustomIconWidget(
                          iconName: 'add',
                          color: quantity < 10
                              ? AppTheme.textHighEmphasisLight
                              : AppTheme.textDisabledLight,
                          size: 20,
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
    );
  }

  Color _getColorFromName(String colorName) {
    switch (colorName.toLowerCase()) {
      case 'black':
        return Colors.black;
      case 'white':
        return Colors.white;
      case 'navy':
        return Colors.indigo.shade800;
      case 'gray':
        return Colors.grey;
      case 'red':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
