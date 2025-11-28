import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/repositories/pricing_repository.dart';

void main() {
  late PricingRepository pricing;
  late Cart cart;

  setUp(() {
    pricing = PricingRepository();
    cart = Cart(pricingRepository: pricing);
  });

  test('adds item and merges quantities for same sandwich configuration', () {
    final sandwich = Sandwich(
      type: SandwichType.chickenTeriyaki,
      isFootlong: false,
      breadType: BreadType.wheat,
    );

    cart.addItem(CartItem(sandwich: sandwich, quantity: 1));
    cart.addItem(CartItem(sandwich: sandwich, quantity: 2));

    expect(cart.items.length, 1);
    expect(cart.items.first.quantity, 3);
    expect(cart.totalQuantity, 3);
  });

  test('removes an item', () {
    final sandwich = Sandwich(
      type: SandwichType.veggieDelight,
      isFootlong: false,
      breadType: BreadType.white,
    );

    final item = CartItem(sandwich: sandwich, quantity: 1);
    cart.addItem(item);
    final removed = cart.removeItem(item);

    expect(removed, isTrue);
    expect(cart.isEmpty, isTrue);
  });

  test('updates item quantity and removes when quantity set to zero', () {
    final sandwich = Sandwich(
      type: SandwichType.tunaMelt,
      isFootlong: false,
      breadType: BreadType.wholemeal,
    );

    final item = CartItem(sandwich: sandwich, quantity: 5);
    cart.addItem(item);

    final updated = cart.updateItemQuantity(item, 2);
    expect(updated, isTrue);
    expect(cart.items.first.quantity, 2);

    final removed = cart.updateItemQuantity(item, 0);
    expect(removed, isTrue);
    expect(cart.isEmpty, isTrue);
  });

  test('clears the cart', () {
    final s1 = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: false,
        breadType: BreadType.white);
    final s2 = Sandwich(
        type: SandwichType.meatballMarinara,
        isFootlong: true,
        breadType: BreadType.wheat);

    cart.addItem(CartItem(sandwich: s1, quantity: 1));
    cart.addItem(CartItem(sandwich: s2, quantity: 2));

    expect(cart.isEmpty, isFalse);
    cart.clear();
    expect(cart.isEmpty, isTrue);
    expect(cart.totalQuantity, 0);
  });

  test(
      'calculates item and cart totals using PricingRepository and applies discount',
      () {
    final sandwich = Sandwich(
      type: SandwichType.chickenTeriyaki,
      isFootlong: false,
      breadType: BreadType.wheat,
    );

    // Based on PricingRepository rules: chickenTeriyaki base 6.00, wheat 1.05 -> 6.30 per unit
    cart.addItem(CartItem(sandwich: sandwich, quantity: 2));

    final itemTotal = cart.getItemTotal(cart.items.first);
    expect(itemTotal, 12.60);

    final cartTotal = cart.getTotal();
    expect(cartTotal, 12.60);

    final applied = cart.applyPercentageDiscount('TEN_OFF', 10.0);
    expect(applied, isTrue);
    final discounted = cart.getTotal();
    // 12.60 * 0.9 = 11.34
    expect(discounted, closeTo(11.34, 0.001));
  });
}
