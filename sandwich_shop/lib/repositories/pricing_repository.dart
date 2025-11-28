import '../models/priceable.dart';
import '../models/sandwich.dart';

/// A small pricing repository responsible for all pricing logic.
///
/// NOTE: The repository exposes a single entrypoint `calculatePrice` that the
/// `Cart` class uses for both per-item and whole-cart price calculations. In
/// a real project this would likely live elsewhere and contain richer rules
/// (promotions, taxes, etc.).
class PricingRepository {
  PricingRepository();

  /// Calculate price for either a single [CartItem] or for an iterable of
  /// [CartItem]s via the named parameters. One of the parameters must be
  /// provided.
  double calculatePrice({Priceable? item, Iterable<Priceable>? items}) {
    if (item == null && items == null) {
      throw ArgumentError('Either item or items must be provided');
    }

    if (item != null) {
      return _calculateItemPrice(item);
    }

    // items != null
    double total = 0.0;
    for (final i in items!) {
      total += _calculateItemPrice(i);
    }
    return total;
  }

  double _calculateItemPrice(Priceable item) {
    // Base price depends on sandwich type. These values are intentionally
    // simple and centralized here so that the cart never performs arithmetic
    // on the base prices directly.
    double basePrice = 0.0;
    switch (item.sandwich.type) {
      case SandwichType.veggieDelight:
        basePrice = 4.50;
        break;
      case SandwichType.chickenTeriyaki:
        basePrice = 6.00;
        break;
      case SandwichType.tunaMelt:
        basePrice = 5.75;
        break;
      case SandwichType.meatballMarinara:
        basePrice = 6.50;
        break;
    }

    // Footlong is 1.8x the six-inch price (example rule)
    if (item.sandwich.isFootlong) {
      basePrice *= 1.8;
    }

    // Optional: adjust by bread type (small example)
    switch (item.sandwich.breadType) {
      case BreadType.white:
        basePrice *= 1.0;
        break;
      case BreadType.wheat:
        basePrice *= 1.05;
        break;
      case BreadType.wholemeal:
        basePrice *= 1.07;
        break;
    }

    return double.parse((basePrice * item.quantity).toStringAsFixed(2));
  }
}
