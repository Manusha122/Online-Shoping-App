import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SortOptionsWidget extends StatelessWidget {
  final String selectedSort;
  final Function(String) onSortChanged;

  const SortOptionsWidget({
    super.key,
    required this.selectedSort,
    required this.onSortChanged,
  });

  static const List<Map<String, dynamic>> _sortOptions = [
    {
      'title': 'Relevance',
      'subtitle': 'Best match for your search',
      'icon': 'star',
    },
    {
      'title': 'Price: Low to High',
      'subtitle': 'Lowest price first',
      'icon': 'arrow_upward',
    },
    {
      'title': 'Price: High to Low',
      'subtitle': 'Highest price first',
      'icon': 'arrow_downward',
    },
    {
      'title': 'Customer Rating',
      'subtitle': 'Highest rated first',
      'icon': 'star_rate',
    },
    {
      'title': 'Newest Arrivals',
      'subtitle': 'Latest products first',
      'icon': 'new_releases',
    },
    {
      'title': 'Best Sellers',
      'subtitle': 'Most popular products',
      'icon': 'trending_up',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20.0),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _sortOptions.length,
            separatorBuilder: (context, index) => Divider(
              height: 1,
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.2),
            ),
            itemBuilder: (context, index) {
              final option = _sortOptions[index];
              final isSelected = selectedSort == option['title'];

              return ListTile(
                leading: Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppTheme.lightTheme.colorScheme.primary
                            .withValues(alpha: 0.1)
                        : AppTheme.lightTheme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: CustomIconWidget(
                    iconName: option['icon'],
                    color: isSelected
                        ? AppTheme.lightTheme.colorScheme.primary
                        : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                ),
                title: Text(
                  option['title'],
                  style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected
                        ? AppTheme.lightTheme.colorScheme.primary
                        : AppTheme.lightTheme.colorScheme.onSurface,
                  ),
                ),
                subtitle: Text(
                  option['subtitle'],
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
                trailing: isSelected
                    ? CustomIconWidget(
                        iconName: 'check_circle',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 24,
                      )
                    : null,
                onTap: () {
                  onSortChanged(option['title']);
                  Navigator.pop(context);
                },
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 4.w,
                  vertical: 1.w,
                ),
              );
            },
          ),
          SizedBox(height: 4.w),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
            width: 1.0,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Sort By',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          Container(
            width: 8.w,
            height: 1.w,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2.0),
            ),
          ),
        ],
      ),
    );
  }
}
