// lib/utils/quantity_spinner.dart
import 'package:flutter/material.dart';

class QuantitySpinner extends StatefulWidget {
  final int initialQuantity;
  final Function(int) onQuantityChanged;

  const QuantitySpinner({
    super.key,
    this.initialQuantity = 1,
    required this.onQuantityChanged,
  });

  @override
  State<QuantitySpinner> createState() => _QuantitySpinnerState();
}

class _QuantitySpinnerState extends State<QuantitySpinner> {
  late int _quantity;
  final TextEditingController _quantityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _quantity = widget.initialQuantity;
    _quantityController.text = _quantity.toString();
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  void _increment() {
    setState(() {
      _quantity++;
      _quantityController.text = _quantity.toString();
      widget.onQuantityChanged(_quantity);
    });
  }

  void _decrement() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
        _quantityController.text = _quantity.toString();
        widget.onQuantityChanged(_quantity);
      });
    }
  }

  void _onTextChange(String value) {
    int? newQuantity = int.tryParse(value);
    if (newQuantity != null && newQuantity >= 1) {
      setState(() {
        _quantity = newQuantity;
        _quantityController.text = _quantity.toString();
        widget.onQuantityChanged(_quantity);
      });
    } else if (value.isEmpty) {
      setState(() {
        _quantity = 1;
        _quantityController.text = '1';
        widget.onQuantityChanged(_quantity);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.brown),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: const Icon(Icons.remove, size: 16, color: Colors.brown),
            onPressed: _decrement,
          ),
          Expanded(
            child: TextField(
              controller: _quantityController,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              onChanged: _onTextChange,
              style: const TextStyle(fontSize: 16, color: Colors.brown),
              decoration: const InputDecoration(
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add, size: 16, color: Colors.brown),
            onPressed: _increment,
          ),
        ],
      ),
    );
  }
}