import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/models/sandwich.dart';

void main() {
  group('Sandwich model', () {
    test('name is derived from SandwichType', () {
      final s = Sandwich(
        type: SandwichType.chickenTeriyaki,
        isFootlong: false,
        breadType: BreadType.wheat,
      );

      expect(s.name, 'Chicken Teriyaki');
    });

    test('image path contains correct type and size for six inch', () {
      final s = Sandwich(
        type: SandwichType.tunaMelt,
        isFootlong: false,
        breadType: BreadType.white,
      );

      expect(
          s.image, 'assets/images/${SandwichType.tunaMelt.name}_six_inch.png');
    });

    test('image path contains correct type and size for footlong', () {
      final s = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: true,
        breadType: BreadType.wholemeal,
      );

      expect(s.image,
          'assets/images/${SandwichType.veggieDelight.name}_footlong.png');
    });

    test('all enum types have expected human-readable names', () {
      final mapping = {
        SandwichType.veggieDelight: 'Veggie Delight',
        SandwichType.chickenTeriyaki: 'Chicken Teriyaki',
        SandwichType.tunaMelt: 'Tuna Melt',
        SandwichType.meatballMarinara: 'Meatball Marinara',
      };

      for (final entry in mapping.entries) {
        final s = Sandwich(
          type: entry.key,
          isFootlong: false,
          breadType: BreadType.white,
        );
        expect(s.name, entry.value);
      }
    });
  });
}
