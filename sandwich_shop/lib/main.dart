import 'package:flutter/material.dart';
import 'package:sandwich_shop/views/app_styles.dart';
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/repositories/order_repository.dart';
import 'package:sandwich_shop/repositories/pricing_repository.dart';

extension BreadTypeName on BreadType {
  String get name {
    switch (this) {
      case BreadType.white:
        return 'White';
      case BreadType.wheat:
        return 'Wheat';
      case BreadType.wholemeal:
        return 'Multigrain';
    }
  }
}

class StyledButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData icon;
  final String label;
  final Color backgroundColor;

  const StyledButton({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.label,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label, style: normalText.copyWith(color: Colors.white)),
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
    );
  }
}

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
  late final OrderRepository _orderRepository;
  late final PricingRepository _pricingRepository;
  late final Cart _cart;
  final TextEditingController _notesController = TextEditingController();
  bool _isFootlong = true;
  bool _isToasted = false;
  BreadType _selectedBreadType = BreadType.white;
  String _confirmationMessage = '';

  @override
  void initState() {
    super.initState();
    _orderRepository = OrderRepository(maxQuantity: widget.maxQuantity);
    _pricingRepository = PricingRepository();
    _cart = Cart(pricingRepository: _pricingRepository);
    _notesController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  VoidCallback? _getIncreaseCallback() {
    if (_orderRepository.canIncrement) {
      return () {
        setState(() {
          _orderRepository.increment();
          _addCurrentSandwichToCart();
        });
        _showConfirmationMessage('Item added to cart!');
      };
    }
    return null;
  }

  void _showConfirmationMessage(String message) {
    setState(() {
      _confirmationMessage = message;
    });
    // Clear message after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _confirmationMessage = '';
        });
      }
    });
  }

  VoidCallback? _getDecreaseCallback() {
    if (_orderRepository.canDecrement) {
      return () => setState(() {
            _orderRepository.decrement();
            _removeCurrentSandwichFromCart();
          });
    }
    return null;
  }

  void _onSandwichTypeChanged(bool value) {
    setState(() => _isFootlong = value);
  }

  void _onBreadTypeSelected(BreadType? value) {
    if (value != null) {
      setState(() => _selectedBreadType = value);
    }
  }

  List<DropdownMenuEntry<BreadType>> _buildDropdownEntries() {
    List<DropdownMenuEntry<BreadType>> entries = [];
    for (BreadType bread in BreadType.values) {
      DropdownMenuEntry<BreadType> newEntry = DropdownMenuEntry<BreadType>(
        value: bread,
        label: bread.name,
      );
      entries.add(newEntry);
    }
    return entries;
  }

  Sandwich _buildCurrentSandwich() {
    // Default sandwich type is Veggie Delight; size and bread come from UI state.
    return Sandwich(
      type: SandwichType.veggieDelight,
      isFootlong: _isFootlong,
      breadType: _selectedBreadType,
    );
  }

  void _addCurrentSandwichToCart() {
    final sandwich = _buildCurrentSandwich();
    final item = CartItem(sandwich: sandwich, quantity: 1);
    _cart.addItem(item);
  }

  void _removeCurrentSandwichFromCart() {
    final sandwich = _buildCurrentSandwich();
    final existingIndex = _cart.items.indexWhere((i) => i.sandwich == sandwich);
    if (existingIndex >= 0) {
      final existing = _cart.items[existingIndex];
      final newQty = existing.quantity - 1;
      if (newQty <= 0) {
        _cart.removeItem(existing);
      } else {
        _cart.updateItemQuantity(existing, newQty);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String sandwichType = 'footlong';
    if (!_isFootlong) {
      sandwichType = 'six-inch';
    }

    String noteForDisplay;
    if (_notesController.text.isEmpty) {
      noteForDisplay = 'No notes added.';
    } else {
      noteForDisplay = _notesController.text;
    }

    return Scaffold(
      appBar: AppBar(
        leading: SizedBox(
          height: 100,
          child: Image.asset('assets/images/logo.png'),
        ),
        title: const Text(
          'Sandwich Counter',
          style: heading1,
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (_confirmationMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      border: Border.all(color: Colors.green),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _confirmationMessage,
                      style: normalText.copyWith(
                        color: Colors.green.shade800,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Text(
                  'Cart: ${_cart.totalQuantity} item(s) • Total: \$${_cart.getTotal().toStringAsFixed(2)}',
                  style: normalText.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              OrderItemDisplay(
                quantity: _orderRepository.quantity,
                itemType: sandwichType,
                breadType: _selectedBreadType,
                orderNote: noteForDisplay,
                isToasted: _isToasted,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('six-inch', style: normalText),
                  Switch(
                    // ignore: prefer_const_constructors
                    key: Key("size"),
                    value: _isFootlong,
                    onChanged: _onSandwichTypeChanged,
                  ),
                  const Text('footlong', style: normalText),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('untoasted', style: normalText),
                  Switch(
                    value: _isToasted,
                    onChanged: (value) {
                      setState(() => _isToasted = value);
                    },
                  ),
                  const Text('toasted', style: normalText),
                ],
              ),
              const SizedBox(height: 10),
              DropdownMenu<BreadType>(
                textStyle: normalText,
                initialSelection: _selectedBreadType,
                onSelected: _onBreadTypeSelected,
                dropdownMenuEntries: _buildDropdownEntries(),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(40.0),
                child: TextField(
                  key: const Key('notes_textfield'),
                  controller: _notesController,
                  decoration: const InputDecoration(
                    labelText: 'Add a note (e.g., no onions)',
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  StyledButton(
                    onPressed: _getIncreaseCallback(),
                    icon: Icons.add,
                    label: 'Add',
                    backgroundColor: Colors.green,
                  ),
                  const SizedBox(width: 8),
                  StyledButton(
                    onPressed: _getDecreaseCallback(),
                    icon: Icons.remove,
                    label: 'Remove',
                    backgroundColor: Colors.red,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OrderItemDisplay extends StatelessWidget {
  final int quantity;
  final String itemType;
  final BreadType breadType;
  final String orderNote;
  final bool isToasted;

  const OrderItemDisplay({
    super.key,
    required this.quantity,
    required this.itemType,
    required this.breadType,
    required this.orderNote,
    required this.isToasted,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$quantity $itemType sandwich(es): ${'🥪' * quantity}',
          style: normalText.copyWith(
            color: Colors.green,
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 6),
        Text('Bread: ${breadType.name}', style: normalText),
        const SizedBox(height: 4),
        Text('Toasted: ${isToasted ? 'Yes' : 'No'}', style: normalText),
        const SizedBox(height: 4),
        Text('Note: $orderNote',
            style: normalText.copyWith(fontStyle: FontStyle.italic)),
      ],
    );
  }
}
