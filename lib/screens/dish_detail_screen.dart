// lib/screens/dish_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flutterprojects/screens/profile_screen.dart';
import '../widgets/common_app_bar.dart';
import '../utils/quantity_spinner.dart';
import '../utils/colors.dart';

class DishDetailScreen extends StatefulWidget {
  final String name;
  final String description;
  final String price;

  const DishDetailScreen({
    super.key,
    required this.name,
    required this.description,
    required this.price,
  });

  @override
  State<DishDetailScreen> createState() => _DishDetailScreenState();
}

class _DishDetailScreenState extends State<DishDetailScreen> {
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildCommonAppBar(
        title: 'ECHO corp',
        onProfilePressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ProfileScreen()),
        ),
        showBackButton: true,
        onBackPressed: () => Navigator.pop(context),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: hexColor('#885F3A').withOpacity(0.1),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    widget.name[0],
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              Text(
                widget.name,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              Text(
                widget.description,
                style: const TextStyle(fontSize: 16, height: 1.5),
              ),
              const SizedBox(height: 30),

              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: ElevatedButton(
                      onPressed: () {
                        print('Добавлено: ${widget.name}, кол-во: $_quantity');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Добавлено: ${widget.name}, кол-во: $_quantity')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: textOnPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: const Text('Добавить', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 2,
                    child: QuantitySpinner(
                      initialQuantity: _quantity,
                      onQuantityChanged: (newQuantity) {
                        setState(() {
                          _quantity = newQuantity;
                        });
                      },
                    ),
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