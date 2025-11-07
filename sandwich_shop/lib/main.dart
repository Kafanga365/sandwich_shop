import 'package:flutter/material.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sandwich Shop App',
      home: Scaffold(
        appBar: AppBar(title: const Text('Sandwich Counter')),
        body: Center(
          child: Container(
            width: 220.0,
            height: 180.0,
            color: Colors.blue,
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const OrderItemDisplay(1, '6-inch'),
                const SizedBox(height: 8.0),
                const OrderItemDisplay(2, 'Footlong'),
                const SizedBox(height: 8.0),
                const OrderItemDisplay(3, 'Club'),
              ],
            ),
          ),
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
      style: TextStyle(
        color: Colors.green,
        fontWeight: FontWeight.bold,
        fontSize: 18.0,
      ),
      textAlign: TextAlign.center,
    );
  }
}
