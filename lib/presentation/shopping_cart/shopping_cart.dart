import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/cart_item_widget.dart';
import './widgets/empty_cart_widget.dart';
import './widgets/order_summary_widget.dart';
import './widgets/saved_items_widget.dart';

class ShoppingCart extends StatefulWidget {
  const ShoppingCart({super.key});

  @override
  State<ShoppingCart> createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _promoController = TextEditingController();
  bool _isLoading = false;
  final bool _savedItemsExpanded = false;

  // Mock cart data
  final List<Map<String, dynamic>> cartItems = [
    {
      "id": 1,
      "name": "Premium Cotton T-Shirt",
      "image":
          "https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=400",
      "price": 29.99,
      "originalPrice": 39.99,
      "quantity": 2,
      "size": "M",
      "color": "Navy Blue",
      "inStock": true,
      "maxQuantity": 10,
    },
    {
      "id": 2,
      "name": "Wireless Bluetooth Headphones",
      "image":
          "https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=400",
      "price": 89.99,
      "originalPrice": 129.99,
      "quantity": 1,
      "size": null,
      "color": "Black",
      "inStock": true,
      "maxQuantity": 5,
    },
    {
      "id": 3,
      "name": "Leather Wallet",
      "image":
          "https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=400",
      "price": 45.00,
      "originalPrice": 45.00,
      "quantity": 1,
      "size": null,
      "color": "Brown",
      "inStock": false,
      "maxQuantity": 3,
    },
  ];

  final List<Map<String, dynamic>> savedItems = [
    {
      "id": 4,
      "name": "Running Shoes",
      "image":
          "https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=400",
      "price": 79.99,
      "originalPrice": 99.99,
      "size": "9",
      "color": "White",
    },
    {
      "id": 5,
      "name": "Smartphone Case",
      "image":
          "https://images.unsplash.com/photo-1556656793-08538906a9f8?w=400",
      "price": 19.99,
      "originalPrice": 24.99,
      "size": null,
      "color": "Clear",
    },
  ];

  final List<Map<String, dynamic>> recentlyViewed = [
    {
      "id": 6,
      "name": "Denim Jacket",
      "image":
          "https://images.unsplash.com/photo-1544966503-7cc5ac882d5f?w=400",
      "price": 69.99,
    },
    {
      "id": 7,
      "name": "Coffee Mug",
      "image":
          "https://images.unsplash.com/photo-1514228742587-6b1558fcf93a?w=400",
      "price": 12.99,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _promoController.dispose();
    super.dispose();
  }

  double get subtotal {
    return (cartItems as List)
        .where((item) => item["inStock"] == true)
        .fold(0.0, (sum, item) => sum + (item["price"] * item["quantity"]));
  }

  double get shipping => subtotal > 50 ? 0.0 : 5.99;
  double get tax => subtotal * 0.08;
  double get total => subtotal + shipping + tax;

  int get cartItemCount {
    return (cartItems as List)
        .fold(0, (sum, item) => sum + (item["quantity"] as int));
  }

  void _updateQuantity(int itemId, int newQuantity) {
    setState(() {
      final itemIndex =
          (cartItems as List).indexWhere((item) => item["id"] == itemId);
      if (itemIndex != -1) {
        if (newQuantity <= 0) {
          cartItems.removeAt(itemIndex);
        } else {
          cartItems[itemIndex]["quantity"] = newQuantity;
        }
      }
    });
  }

  void _removeItem(int itemId) {
    final removedItem =
        (cartItems as List).firstWhere((item) => item["id"] == itemId);
    setState(() {
      cartItems.removeWhere((item) => item["id"] == itemId);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${removedItem["name"]} removed from cart'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              cartItems.add(removedItem);
            });
          },
        ),
      ),
    );
  }

  void _moveToWishlist(int itemId) {
    final item = (cartItems as List).firstWhere((item) => item["id"] == itemId);
    setState(() {
      cartItems.removeWhere((item) => item["id"] == itemId);
      savedItems.add(item);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${item["name"]} moved to wishlist'),
      ),
    );
  }

  void _saveForLater(int itemId) {
    final item = (cartItems as List).firstWhere((item) => item["id"] == itemId);
    setState(() {
      cartItems.removeWhere((item) => item["id"] == itemId);
      savedItems.add(item);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${item["name"]} saved for later'),
      ),
    );
  }

  void _moveToCart(int itemId) {
    final item =
        (savedItems as List).firstWhere((item) => item["id"] == itemId);
    setState(() {
      savedItems.removeWhere((item) => item["id"] == itemId);
      item["quantity"] = 1;
      item["inStock"] = true;
      item["maxQuantity"] = 10;
      cartItems.add(item);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${item["name"]} moved to cart'),
      ),
    );
  }

  void _clearCart() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Cart'),
        content: const Text(
            'Are you sure you want to remove all items from your cart?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                cartItems.clear();
              });
              Navigator.pop(context);
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _applyPromoCode() {
    if (_promoController.text.trim().isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isLoading = false;
      });

      if (_promoController.text.toLowerCase() == 'save10') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Promo code applied! 10% discount added.'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid promo code. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    });
  }

  Future<void> _refreshCart() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      // Simulate price updates
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Shopping Cart',
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        elevation: 0,
        leading: CustomIconWidget(
          iconName: 'arrow_back',
          color: AppTheme.lightTheme.primaryColor,
          size: 24,
        ),
        actions: [
          if (cartItems.isNotEmpty)
            TextButton(
              onPressed: _clearCart,
              child: Text(
                'Clear All',
                style: TextStyle(
                  color: AppTheme.errorLight,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          SizedBox(width: 2.w),
        ],
      ),
      body: cartItems.isEmpty
          ? EmptyCartWidget(
              recentlyViewed: recentlyViewed,
              onContinueShopping: () =>
                  Navigator.pushNamed(context, '/home-screen'),
              onProductTap: (productId) =>
                  Navigator.pushNamed(context, '/product-detail'),
            )
          : RefreshIndicator(
              onRefresh: _refreshCart,
              child: Column(
                children: [
                  // Cart item count header
                  Container(
                    width: double.infinity,
                    padding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.surface,
                      border: Border(
                        bottom: BorderSide(
                          color: AppTheme.borderLight,
                          width: 1,
                        ),
                      ),
                    ),
                    child: Text(
                      '$cartItemCount ${cartItemCount == 1 ? 'item' : 'items'} in cart',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textMediumEmphasisLight,
                      ),
                    ),
                  ),

                  // Tab bar for cart and saved items
                  Container(
                    color: AppTheme.lightTheme.scaffoldBackgroundColor,
                    child: TabBar(
                      controller: _tabController,
                      tabs: [
                        Tab(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Cart'),
                              if (cartItems.isNotEmpty) ...[
                                SizedBox(width: 1.w),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 2.w,
                                    vertical: 0.5.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppTheme.accentLight,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    '${cartItems.length}',
                                    style: TextStyle(
                                      color: AppTheme.onAccentLight,
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        Tab(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Saved'),
                              if (savedItems.isNotEmpty) ...[
                                SizedBox(width: 1.w),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 2.w,
                                    vertical: 0.5.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppTheme.secondaryLight,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    '${savedItems.length}',
                                    style: TextStyle(
                                      color: AppTheme.onSecondaryLight,
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Tab bar view
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        // Cart items tab
                        Column(
                          children: [
                            Expanded(
                              child: ListView.separated(
                                padding: EdgeInsets.all(4.w),
                                itemCount: cartItems.length,
                                separatorBuilder: (context, index) =>
                                    SizedBox(height: 2.h),
                                itemBuilder: (context, index) {
                                  final item =
                                      cartItems[index];
                                  return CartItemWidget(
                                    item: item,
                                    onQuantityChanged: (quantity) =>
                                        _updateQuantity(item["id"], quantity),
                                    onRemove: () => _removeItem(item["id"]),
                                    onMoveToWishlist: () =>
                                        _moveToWishlist(item["id"]),
                                    onSaveForLater: () =>
                                        _saveForLater(item["id"]),
                                  );
                                },
                              ),
                            ),

                            // Promo code section
                            Container(
                              padding: EdgeInsets.all(4.w),
                              decoration: BoxDecoration(
                                color: AppTheme.lightTheme.colorScheme.surface,
                                border: Border(
                                  top: BorderSide(
                                    color: AppTheme.borderLight,
                                    width: 1,
                                  ),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: _promoController,
                                      decoration: const InputDecoration(
                                        hintText: 'Enter promo code',
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 3.w),
                                  ElevatedButton(
                                    onPressed:
                                        _isLoading ? null : _applyPromoCode,
                                    child: _isLoading
                                        ? SizedBox(
                                            width: 4.w,
                                            height: 4.w,
                                            child:
                                                const CircularProgressIndicator(
                                              strokeWidth: 2,
                                            ),
                                          )
                                        : const Text('Apply'),
                                  ),
                                ],
                              ),
                            ),

                            // Order summary
                            OrderSummaryWidget(
                              subtotal: subtotal,
                              shipping: shipping,
                              tax: tax,
                              total: total,
                              onCheckout: () {
                                // Navigate to checkout
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Proceeding to checkout...'),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),

                        // Saved items tab
                        SavedItemsWidget(
                          savedItems: savedItems,
                          onMoveToCart: _moveToCart,
                          onRemove: (itemId) {
                            setState(() {
                              savedItems
                                  .removeWhere((item) => item["id"] == itemId);
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
