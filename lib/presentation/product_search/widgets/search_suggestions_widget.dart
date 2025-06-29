import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SearchSuggestionsWidget extends StatelessWidget {
  final String searchQuery;
  final List<String> recentSearches;
  final List<String> trendingSearches;
  final List<String> autocompleteSuggestions;
  final Function(String) onSuggestionTap;

  const SearchSuggestionsWidget({
    super.key,
    required this.searchQuery,
    required this.recentSearches,
    required this.trendingSearches,
    required this.autocompleteSuggestions,
    required this.onSuggestionTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasQuery = searchQuery.trim().isNotEmpty;
    final List<String> filteredSuggestions = hasQuery
        ? autocompleteSuggestions
            .where((suggestion) =>
                suggestion.toLowerCase().contains(searchQuery.toLowerCase()))
            .toList()
        : [];

    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (hasQuery && filteredSuggestions.isNotEmpty) ...[
            _buildSectionHeader('Suggestions'),
            SizedBox(height: 2.w),
            ...filteredSuggestions.map((suggestion) => _buildSuggestionItem(
                  suggestion,
                  Icons.search,
                  isHighlighted: true,
                )),
            SizedBox(height: 4.w),
          ],
          if (recentSearches.isNotEmpty) ...[
            _buildSectionHeader('Recent Searches'),
            SizedBox(height: 2.w),
            ...recentSearches.map((search) => _buildSuggestionItem(
                  search,
                  Icons.history,
                )),
            SizedBox(height: 4.w),
          ],
          _buildSectionHeader('Trending Searches'),
          SizedBox(height: 2.w),
          ...trendingSearches.map((search) => _buildSuggestionItem(
                search,
                Icons.trending_up,
              )),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
        fontWeight: FontWeight.w600,
        color: AppTheme.lightTheme.colorScheme.onSurface,
      ),
    );
  }

  Widget _buildSuggestionItem(
    String text,
    IconData icon, {
    bool isHighlighted = false,
  }) {
    return InkWell(
      onTap: () => onSuggestionTap(text),
      borderRadius: BorderRadius.circular(8.0),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 3.w,
          vertical: 3.w,
        ),
        child: Row(
          children: [
            CustomIconWidget(
              iconName: _getIconName(icon),
              color: isHighlighted
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 20,
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Text(
                text,
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: isHighlighted
                      ? AppTheme.lightTheme.colorScheme.primary
                      : AppTheme.lightTheme.colorScheme.onSurface,
                  fontWeight: isHighlighted ? FontWeight.w500 : FontWeight.w400,
                ),
              ),
            ),
            CustomIconWidget(
              iconName: 'north_west',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  String _getIconName(IconData icon) {
    if (icon == Icons.search) return 'search';
    if (icon == Icons.history) return 'history';
    if (icon == Icons.trending_up) return 'trending_up';
    return 'search';
  }
}
