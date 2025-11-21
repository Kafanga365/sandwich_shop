import 'package:flutter/material.dart';
import 'package:sandwich_shop/views/app_styles.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Sandwich Shop App',
      home: OrderScreen(maxQuantity: 5),
    );
  }
}

class OrderScreen extends StatefulWidget {
  final int maxQuantity;

  const OrderScreen({super.key, this.maxQuantity = 10});

  @override
  State<OrderScreen> createState() {
    return _OrderScreenState();
  }
}

class _OrderScreenState extends State<OrderScreen> {
  int _quantity = 0;
  // selected sandwich size
  String _selectedSize = 'Footlong';

  void _increaseQuantity() {
    if (_quantity < widget.maxQuantity) {
      setState(() => _quantity++);
    }
  }

  void _decreaseQuantity() {
    if (_quantity > 0) {
      setState(() => _quantity--);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sandwich Counter'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Size selector (Material 3 SegmentedButton)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: SegmentedButton<String>(
                segments: const <ButtonSegment<String>>[
                  ButtonSegment(value: 'Footlong', label: Text('Footlong')),
                  ButtonSegment(value: 'Six-inch', label: Text('Six-inch')),
                ],
                selected: <String>{_selectedSize},
                onSelectionChanged: (Set<String> newSelection) {
                  setState(() {
                    // take the first (and only) selected value
                    _selectedSize = newSelection.first;
                  });
                },
              ),
            ),
            const SizedBox(height: 12.0),
            OrderItemDisplay(
              _quantity,
              _selectedSize,
            ),
            const SizedBox(height: 12.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  child: ElevatedButton(
                    onPressed: _increaseQuantity,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Add'),
                  ),
                ),
                const SizedBox(width: 12.0),
                SizedBox(
                  child: ElevatedButton(
                    onPressed: _decreaseQuantity,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Remove'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class OrderItemDisplay extends StatelessWidget {
  final int quantity;
  final String itemType;

  const OrderItemDisplay(this.quantity, this.itemType, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      '$quantity $itemType sandwich(es): ${'🥪' * quantity}',
      style: normalText.copyWith(
        color: Colors.green,
        fontWeight: FontWeight.bold,
        fontSize: 18.0,
      ),
      textAlign: TextAlign.center,
    );
  }
}
