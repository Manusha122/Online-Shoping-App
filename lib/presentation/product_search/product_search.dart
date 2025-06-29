import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/filter_bottom_sheet_widget.dart';
import './widgets/product_search_card_widget.dart';
import './widgets/search_filter_chip_widget.dart';
import './widgets/search_suggestions_widget.dart';
import './widgets/sort_options_widget.dart';

class ProductSearch extends StatefulWidget {
  const ProductSearch({super.key});

  @override
  State<ProductSearch> createState() => _ProductSearchState();
}

class _ProductSearchState extends State<ProductSearch>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  bool _isSearching = false;
  bool _isVoiceSearching = false;
  bool _isLoading = false;
  bool _hasSearched = false;
  List<String> _activeFilters = [];
  String _selectedSort = 'Relevance';

  // Mock data for search results
  final List<Map<String, dynamic>> _searchResults = [
    {
      "id": 1,
      "name": "Wireless Bluetooth Headphones",
      "price": "\$89.99",
      "originalPrice": "\$129.99",
      "rating": 4.5,
      "reviewCount": 234,
      "image":
          "https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=400&h=400&fit=crop",
      "isWishlisted": false,
      "discount": "31% OFF",
      "availability": "In Stock"
    },
    {
      "id": 2,
      "name": "Smart Fitness Watch",
      "price": "\$199.99",
      "originalPrice": "\$249.99",
      "rating": 4.8,
      "reviewCount": 567,
      "image":
          "https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=400&h=400&fit=crop",
      "isWishlisted": true,
      "discount": "20% OFF",
      "availability": "In Stock"
    },
    {
      "id": 3,
      "name": "Portable Phone Charger",
      "price": "\$24.99",
      "originalPrice": "\$34.99",
      "rating": 4.2,
      "reviewCount": 123,
      "image":
          "https://images.unsplash.com/photo-1609592806787-3d9c1b8e3b4e?w=400&h=400&fit=crop",
      "isWishlisted": false,
      "discount": "29% OFF",
      "availability": "Limited Stock"
    },
    {
      "id": 4,
      "name": "Wireless Gaming Mouse",
      "price": "\$59.99",
      "originalPrice": "\$79.99",
      "rating": 4.6,
      "reviewCount": 345,
      "image":
          "https://images.unsplash.com/photo-1527864550417-7fd91fc51a46?w=400&h=400&fit=crop",
      "isWishlisted": false,
      "discount": "25% OFF",
      "availability": "In Stock"
    },
    {
      "id": 5,
      "name": "USB-C Hub Adapter",
      "price": "\$39.99",
      "originalPrice": "\$59.99",
      "rating": 4.3,
      "reviewCount": 189,
      "image":
          "https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=400&h=400&fit=crop",
      "isWishlisted": true,
      "discount": "33% OFF",
      "availability": "In Stock"
    },
    {
      "id": 6,
      "name": "Bluetooth Speaker",
      "price": "\$79.99",
      "originalPrice": "\$99.99",
      "rating": 4.4,
      "reviewCount": 278,
      "image":
          "https://images.unsplash.com/photo-1608043152269-423dbba4e7e1?w=400&h=400&fit=crop",
      "isWishlisted": false,
      "discount": "20% OFF",
      "availability": "In Stock"
    }
  ];

  // Mock data for search suggestions
  final List<String> _recentSearches = [
    "wireless headphones",
    "smartphone cases",
    "laptop accessories",
    "fitness tracker"
  ];

  final List<String> _trendingSearches = [
    "gaming accessories",
    "wireless chargers",
    "bluetooth speakers",
    "smart watches",
    "phone cases"
  ];

  final List<String> _autocompleteSuggestions = [
    "wireless headphones",
    "wireless chargers",
    "wireless mouse",
    "wireless keyboard"
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _searchFocusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadMoreProducts();
    }
  }

  void _onFocusChange() {
    setState(() {
      _isSearching = _searchFocusNode.hasFocus;
    });
  }

  void _performSearch(String query) {
    if (query.trim().isEmpty) return;

    setState(() {
      _hasSearched = true;
      _isLoading = true;
      _isSearching = false;
    });

    _searchFocusNode.unfocus();

    // Simulate API call delay
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  void _loadMoreProducts() {
    // Simulate loading more products
    setState(() {
      _isLoading = true;
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  void _startVoiceSearch() {
    setState(() {
      _isVoiceSearching = true;
    });

    // Simulate voice search
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isVoiceSearching = false;
          _searchController.text = "wireless headphones";
        });
        _performSearch("wireless headphones");
      }
    });
  }

  void _openCamera() {
    // Simulate camera opening for visual search
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Camera opened for visual search',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onPrimary,
          ),
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterBottomSheetWidget(
        activeFilters: _activeFilters,
        onFiltersChanged: (filters) {
          setState(() {
            _activeFilters = filters;
          });
        },
      ),
    );
  }

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => SortOptionsWidget(
        selectedSort: _selectedSort,
        onSortChanged: (sort) {
          setState(() {
            _selectedSort = sort;
          });
        },
      ),
    );
  }

  void _removeFilter(String filter) {
    setState(() {
      _activeFilters.remove(filter);
    });
  }

  void _clearAllFilters() {
    setState(() {
      _activeFilters.clear();
    });
  }

  void _toggleWishlist(int productId) {
    setState(() {
      final productIndex =
          _searchResults.indexWhere((product) => product['id'] == productId);
      if (productIndex != -1) {
        _searchResults[productIndex]['isWishlisted'] =
            !_searchResults[productIndex]['isWishlisted'];
      }
    });
  }

  void _onSuggestionTap(String suggestion) {
    _searchController.text = suggestion;
    _performSearch(suggestion);
  }

  Future<void> _onRefresh() async {
    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(milliseconds: 1000));

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildSearchHeader(),
          if (_activeFilters.isNotEmpty) _buildActiveFilters(),
          Expanded(
            child: _isSearching
                ? _buildSearchSuggestions()
                : _buildSearchResults(),
          ),
        ],
      ),
      floatingActionButton:
          _hasSearched && !_isSearching ? _buildSortFAB() : null,
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      elevation: 0,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: CustomIconWidget(
          iconName: 'arrow_back',
          color: AppTheme.lightTheme.colorScheme.onSurface,
          size: 24,
        ),
      ),
      title: Text(
        'Search Products',
        style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: [
        if (_hasSearched && !_isSearching)
          IconButton(
            onPressed: _showFilterBottomSheet,
            icon: Stack(
              children: [
                CustomIconWidget(
                  iconName: 'tune',
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  size: 24,
                ),
                if (_activeFilters.isNotEmpty)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: EdgeInsets.all(0.5.w),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                      constraints: BoxConstraints(
                        minWidth: 4.w,
                        minHeight: 4.w,
                      ),
                      child: Text(
                        _activeFilters.length.toString(),
                        style:
                            AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.onPrimary,
                          fontSize: 8.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        SizedBox(width: 2.w),
      ],
    );
  }

  Widget _buildSearchHeader() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color:
                AppTheme.lightTheme.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(
                  color: _searchFocusNode.hasFocus
                      ? AppTheme.lightTheme.colorScheme.primary
                      : AppTheme.lightTheme.colorScheme.outline,
                  width: _searchFocusNode.hasFocus ? 2.0 : 1.0,
                ),
              ),
              child: TextField(
                controller: _searchController,
                focusNode: _searchFocusNode,
                onSubmitted: _performSearch,
                decoration: InputDecoration(
                  hintText: 'Search for products...',
                  hintStyle: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(3.w),
                    child: CustomIconWidget(
                      iconName: 'search',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                  ),
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_searchController.text.isNotEmpty)
                        IconButton(
                          onPressed: () {
                            _searchController.clear();
                            setState(() {
                              _hasSearched = false;
                            });
                          },
                          icon: CustomIconWidget(
                            iconName: 'clear',
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                            size: 20,
                          ),
                        ),
                      IconButton(
                        onPressed: _isVoiceSearching ? null : _startVoiceSearch,
                        icon: _isVoiceSearching
                            ? SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    AppTheme.lightTheme.colorScheme.primary,
                                  ),
                                ),
                              )
                            : CustomIconWidget(
                                iconName: 'mic',
                                color: AppTheme.lightTheme.colorScheme.primary,
                                size: 20,
                              ),
                      ),
                      IconButton(
                        onPressed: _openCamera,
                        icon: CustomIconWidget(
                          iconName: 'camera_alt',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 4.w,
                    vertical: 3.w,
                  ),
                ),
                style: AppTheme.lightTheme.textTheme.bodyMedium,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveFilters() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Active Filters (${_activeFilters.length})',
                style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextButton(
                onPressed: _clearAllFilters,
                child: Text(
                  'Clear All',
                  style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.w),
          Wrap(
            spacing: 2.w,
            runSpacing: 1.w,
            children: _activeFilters.map((filter) {
              return SearchFilterChipWidget(
                label: filter,
                onRemove: () => _removeFilter(filter),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchSuggestions() {
    return SearchSuggestionsWidget(
      searchQuery: _searchController.text,
      recentSearches: _recentSearches,
      trendingSearches: _trendingSearches,
      autocompleteSuggestions: _autocompleteSuggestions,
      onSuggestionTap: _onSuggestionTap,
    );
  }

  Widget _buildSearchResults() {
    if (!_hasSearched) {
      return _buildEmptyState();
    }

    if (_isLoading && _searchResults.isEmpty) {
      return _buildLoadingState();
    }

    if (_searchResults.isEmpty) {
      return _buildNoResultsState();
    }

    return RefreshIndicator(
      onRefresh: _onRefresh,
      color: AppTheme.lightTheme.colorScheme.primary,
      child: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverPadding(
            padding: EdgeInsets.all(4.w),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 3.w,
                mainAxisSpacing: 3.w,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final product = _searchResults[index];
                  return ProductSearchCardWidget(
                    product: product,
                    onWishlistTap: () => _toggleWishlist(product['id']),
                    onTap: () {
                      Navigator.pushNamed(context, '/product-detail');
                    },
                  );
                },
                childCount: _searchResults.length,
              ),
            ),
          ),
          if (_isLoading)
            SliverToBoxAdapter(
              child: Container(
                padding: EdgeInsets.all(4.w),
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppTheme.lightTheme.colorScheme.primary,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'search',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 64,
            ),
            SizedBox(height: 4.w),
            Text(
              'Start Your Search',
              style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.w),
            Text(
              'Search for products using text, voice, or camera',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 6.w),
            Wrap(
              spacing: 2.w,
              runSpacing: 2.w,
              children: _trendingSearches.take(4).map((search) {
                return ActionChip(
                  label: Text(search),
                  onPressed: () => _onSuggestionTap(search),
                  backgroundColor: AppTheme.lightTheme.colorScheme.surface,
                  labelStyle: AppTheme.lightTheme.textTheme.labelMedium,
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return GridView.builder(
      padding: EdgeInsets.all(4.w),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 3.w,
        mainAxisSpacing: 3.w,
      ),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.2),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12.0),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: EdgeInsets.all(3.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 4.w,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.outline
                              .withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(2.w),
                        ),
                      ),
                      SizedBox(height: 2.w),
                      Container(
                        height: 3.w,
                        width: 20.w,
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.outline
                              .withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(2.w),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNoResultsState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'search_off',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 64,
            ),
            SizedBox(height: 4.w),
            Text(
              'No Results Found',
              style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.w),
            Text(
              'Try adjusting your search or filters to find what you\'re looking for',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 6.w),
            ElevatedButton(
              onPressed: () {
                _searchController.clear();
                setState(() {
                  _hasSearched = false;
                  _activeFilters.clear();
                });
              },
              child: const Text('Start New Search'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSortFAB() {
    return FloatingActionButton.extended(
      onPressed: _showSortOptions,
      backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
      icon: CustomIconWidget(
        iconName: 'sort',
        color: AppTheme.lightTheme.colorScheme.onPrimary,
        size: 20,
      ),
      label: Text(
        _selectedSort,
        style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
          color: AppTheme.lightTheme.colorScheme.onPrimary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
