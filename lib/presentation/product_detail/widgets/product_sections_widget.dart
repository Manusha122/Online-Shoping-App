import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProductSectionsWidget extends StatefulWidget {
  final Map<String, dynamic> productData;
  final List<Map<String, dynamic>> reviews;

  const ProductSectionsWidget({
    super.key,
    required this.productData,
    required this.reviews,
  });

  @override
  State<ProductSectionsWidget> createState() => _ProductSectionsWidgetState();
}

class _ProductSectionsWidgetState extends State<ProductSectionsWidget> {
  bool _isDescriptionExpanded = false;
  bool _isSpecsExpanded = false;
  bool _isReviewsExpanded = true;
  bool _isShippingExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildSection(
          title: 'Description',
          isExpanded: _isDescriptionExpanded,
          onToggle: () =>
              setState(() => _isDescriptionExpanded = !_isDescriptionExpanded),
          content: _buildDescriptionContent(),
        ),
        _buildSection(
          title: 'Specifications',
          isExpanded: _isSpecsExpanded,
          onToggle: () => setState(() => _isSpecsExpanded = !_isSpecsExpanded),
          content: _buildSpecificationsContent(),
        ),
        _buildSection(
          title: 'Reviews (${widget.reviews.length})',
          isExpanded: _isReviewsExpanded,
          onToggle: () =>
              setState(() => _isReviewsExpanded = !_isReviewsExpanded),
          content: _buildReviewsContent(),
        ),
        _buildSection(
          title: 'Shipping & Returns',
          isExpanded: _isShippingExpanded,
          onToggle: () =>
              setState(() => _isShippingExpanded = !_isShippingExpanded),
          content: _buildShippingContent(),
        ),
      ],
    );
  }

  Widget _buildSection({
    required String title,
    required bool isExpanded,
    required VoidCallback onToggle,
    required Widget content,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderLight),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: onToggle,
            child: Container(
              padding: EdgeInsets.all(4.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  CustomIconWidget(
                    iconName: isExpanded
                        ? 'keyboard_arrow_up'
                        : 'keyboard_arrow_down',
                    color: AppTheme.textMediumEmphasisLight,
                    size: 24,
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded) ...[
            Container(
              width: double.infinity,
              height: 1,
              color: AppTheme.borderLight,
            ),
            Container(
              padding: EdgeInsets.all(4.w),
              child: content,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDescriptionContent() {
    return Text(
      widget.productData["description"] as String,
      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
        height: 1.5,
      ),
    );
  }

  Widget _buildSpecificationsContent() {
    final specs = widget.productData["specifications"] as Map<String, dynamic>;

    return Column(
      children: specs.entries.map((entry) {
        return Padding(
          padding: EdgeInsets.only(bottom: 2.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 30.w,
                child: Text(
                  entry.key,
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textMediumEmphasisLight,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  entry.value.toString(),
                  style: AppTheme.lightTheme.textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildReviewsContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Rating breakdown
        _buildRatingBreakdown(),

        SizedBox(height: 3.h),

        // Reviews list
        ...widget.reviews.take(3).map((review) => _buildReviewItem(review)),

        SizedBox(height: 2.h),

        // Write review and view all buttons
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  // Write review functionality
                },
                child: Text('Write Review'),
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  // View all reviews functionality
                },
                child: Text('View All'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRatingBreakdown() {
    final rating = widget.productData["rating"] as double;
    final reviewCount = widget.productData["reviewCount"] as int;

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Column(
            children: [
              Text(
                rating.toString(),
                style: AppTheme.lightTheme.textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppTheme.accentLight,
                ),
              ),
              Row(
                children: List.generate(5, (index) {
                  return CustomIconWidget(
                    iconName: index < rating.floor() ? 'star' : 'star_border',
                    color: AppTheme.warningLight,
                    size: 16,
                  );
                }),
              ),
              Text(
                '$reviewCount reviews',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.textMediumEmphasisLight,
                ),
              ),
            ],
          ),
          SizedBox(width: 6.w),
          Expanded(
            child: Column(
              children: List.generate(5, (index) {
                final starCount = 5 - index;
                final percentage = (starCount / 5) * 100;

                return Padding(
                  padding: EdgeInsets.only(bottom: 1.h),
                  child: Row(
                    children: [
                      Text(
                        '$starCount',
                        style: AppTheme.lightTheme.textTheme.bodySmall,
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: LinearProgressIndicator(
                          value: percentage / 100,
                          backgroundColor: AppTheme.borderLight,
                          valueColor: AlwaysStoppedAnimation<Color>(
                              AppTheme.warningLight),
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        '${percentage.toInt()}%',
                        style: AppTheme.lightTheme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewItem(Map<String, dynamic> review) {
    return Container(
      margin: EdgeInsets.only(bottom: 3.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 5.w,
                backgroundImage: NetworkImage(review["userImage"] as String),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review["userName"] as String,
                      style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Row(
                      children: [
                        Row(
                          children: List.generate(5, (index) {
                            return CustomIconWidget(
                              iconName: index < (review["rating"] as int)
                                  ? 'star'
                                  : 'star_border',
                              color: AppTheme.warningLight,
                              size: 14,
                            );
                          }),
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          review["date"] as String,
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.textMediumEmphasisLight,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            review["comment"] as String,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              height: 1.4,
            ),
          ),
          SizedBox(height: 1.h),
          Row(
            children: [
              TextButton.icon(
                onPressed: () {},
                icon: CustomIconWidget(
                  iconName: 'thumb_up',
                  color: AppTheme.textMediumEmphasisLight,
                  size: 16,
                ),
                label: Text(
                  'Helpful (${review["helpful"]})',
                  style: AppTheme.lightTheme.textTheme.bodySmall,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildShippingContent() {
    final shipping = widget.productData["shipping"] as Map<String, dynamic>;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildShippingItem(
          icon: 'local_shipping',
          title: 'Free Shipping',
          subtitle: shipping["estimatedDays"] as String,
          color: AppTheme.successLight,
        ),
        SizedBox(height: 2.h),
        _buildShippingItem(
          icon: 'keyboard_return',
          title: 'Easy Returns',
          subtitle: shipping["returnPolicy"] as String,
          color: AppTheme.accentLight,
        ),
        SizedBox(height: 2.h),
        _buildShippingItem(
          icon: 'security',
          title: 'Secure Payment',
          subtitle: 'Your payment information is safe',
          color: AppTheme.warningLight,
        ),
      ],
    );
  }

  Widget _buildShippingItem({
    required String icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(2.w),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: CustomIconWidget(
            iconName: icon,
            color: color,
            size: 24,
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                subtitle,
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.textMediumEmphasisLight,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
