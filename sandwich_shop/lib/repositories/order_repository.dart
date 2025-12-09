/// Repository for managing order state (quantity and limits).
class OrderRepository {
  final int maxQuantity;
  int _quantity = 0;

  OrderRepository({required this.maxQuantity});

  /// Current quantity of items in the order.
  int get quantity => _quantity;

  /// Whether the quantity can be incremented without exceeding maxQuantity.
  bool get canIncrement => _quantity < maxQuantity;

  /// Whether the quantity can be decremented (i.e., is greater than 0).
  bool get canDecrement => _quantity > 0;

  /// Increment quantity if allowed.
  void increment() {
    if (canIncrement) {
      _quantity++;
    }
  }

  /// Decrement quantity if allowed.
  void decrement() {
    if (canDecrement) {
      _quantity--;
    }
  }

  /// Reset quantity to 0.
  void reset() {
    _quantity = 0;
  }
}
