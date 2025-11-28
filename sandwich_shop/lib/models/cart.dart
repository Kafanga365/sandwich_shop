import 'dart:collection';

import '../models/sandwich.dart';
import '../models/priceable.dart';
import '../repositories/pricing_repository.dart';

/// Represents an item in the cart.
///
/// Equality and hashCode are based on the sandwich identity (type, size,
/// bread). This allows the cart to merge quantities for the same sandwich
/// configuration.
class CartItem implements Priceable {
  @override
  final Sandwich sandwich;
  @override
  final int quantity;

  CartItem({required this.sandwich, required this.quantity})
      : assert(quantity > 0);

  CartItem copyWith({Sandwich? sandwich, int? quantity}) {
    return CartItem(
      sandwich: sandwich ?? this.sandwich,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CartItem &&
        other.sandwich.type == sandwich.type &&
        other.sandwich.isFootlong == sandwich.isFootlong &&
        other.sandwich.breadType == sandwich.breadType;
  }

  @override
  int get hashCode =>
      Object.hash(sandwich.type, sandwich.isFootlong, sandwich.breadType);
}

/// Cart holds a collection of [CartItem]s and delegates pricing logic to
/// [PricingRepository]. The cart itself does not compute base prices.
class Cart {
  final PricingRepository pricingRepository;

  // Internal list preserves order of insertion.
  final List<CartItem> _items = [];

  String? _discountCode;
  double _discountPercent = 0.0; // in percent, e.g. 10.0 for 10%

  Cart({required this.pricingRepository});

  /// Read-only view of cart items.
  UnmodifiableListView<CartItem> get items => UnmodifiableListView(_items);

  bool get isEmpty => _items.isEmpty;

  int get totalQuantity => _items.fold(0, (p, e) => p + e.quantity);

  /// Currently applied discount code (if any).
  String? get discountCode => _discountCode;

  /// Adds an item to the cart. If an equivalent item already exists (same
  /// sandwich type/size/bread), their quantities are merged.
  void addItem(CartItem item) {
    final index = _items.indexWhere((i) => i == item);
    if (index >= 0) {
      final existing = _items[index];
      _items[index] =
          existing.copyWith(quantity: existing.quantity + item.quantity);
    } else {
      _items.add(item);
    }
  }

  /// Removes the given item from the cart (match by sandwich identity).
  /// Returns true if an item was removed.
  bool removeItem(CartItem item) {
    final index = _items.indexWhere((i) => i == item);
    if (index >= 0) {
      _items.removeAt(index);
      return true;
    }
    return false;
  }

  /// Update the quantity of a cart item. If [newQuantity] <= 0 the item is
  /// removed. Returns true if the item was found and updated/removed.
  bool updateItemQuantity(CartItem item, int newQuantity) {
    final index = _items.indexWhere((i) => i == item);
    if (index < 0) return false;

    if (newQuantity <= 0) {
      _items.removeAt(index);
    } else {
      _items[index] = _items[index].copyWith(quantity: newQuantity);
    }
    return true;
  }

  /// Clears the cart and removes any applied discount.
  void clear() {
    _items.clear();
    _discountCode = null;
    _discountPercent = 0.0;
  }

  /// Get the total for a specific item by delegating to [PricingRepository].
  double getItemTotal(CartItem item) {
    return pricingRepository.calculatePrice(item: item);
  }

  /// Get the cart total by delegating to [PricingRepository] and then applying
  /// any percentage discount (discount is applied on top of the repository
  /// total). The discount percent is in range 0..100.
  double getTotal() {
    final baseTotal = pricingRepository.calculatePrice(items: _items);
    if (_discountPercent <= 0.0) return baseTotal;
    final multiplier = (100.0 - _discountPercent) / 100.0;
    final discounted =
        double.parse((baseTotal * multiplier).toStringAsFixed(2));
    return discounted;
  }

  /// Apply a simple percentage discount code. [percent] is 0..100.
  /// Returns true if applied successfully.
  bool applyPercentageDiscount(String code, double percent) {
    if (percent <= 0.0 || percent > 100.0) return false;
    _discountCode = code;
    _discountPercent = percent;
    return true;
  }

  /// Remove any applied discount.
  void removeDiscount() {
    _discountCode = null;
    _discountPercent = 0.0;
  }

  /// Expose the active discount percent for inspection (0.0 if none).
  double get activeDiscountPercent => _discountPercent;
}
