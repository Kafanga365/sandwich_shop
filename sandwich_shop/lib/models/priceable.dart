import 'sandwich.dart';

/// Minimal interface describing something the [PricingRepository] can price.
abstract class Priceable {
  Sandwich get sandwich;
  int get quantity;
}
