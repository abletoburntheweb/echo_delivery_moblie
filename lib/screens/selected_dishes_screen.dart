// lib/screens/selected_dishes_screen.dart
import 'package:flutter/material.dart';
import 'package:flutterprojects/screens/profile_screen.dart';
import '../widgets/common_app_bar.dart';
import '../utils/colors.dart';
import 'menu_screen.dart';
import 'delivery_time_screen.dart';
import '../models/dish.dart';

class SelectedDishesScreen extends StatefulWidget {
  final DateTime? selectedDate;

  const SelectedDishesScreen({
    super.key,
    this.selectedDate,
  });

  @override
  State<SelectedDishesScreen> createState() => _SelectedDishesScreenState();
}

class _SelectedDishesScreenState extends State<SelectedDishesScreen> {
  List<Dish> _selectedDishes = [];

  void _addDish(Dish dish) {
    setState(() {
      int existingIndex = _selectedDishes.indexWhere((d) => d.name == dish.name);

      if (existingIndex != -1) {
        _selectedDishes[existingIndex] = _selectedDishes[existingIndex].copyWith(
          quantity: _selectedDishes[existingIndex].quantity + dish.quantity,
        );
      } else {
        _selectedDishes.add(dish);
      }
    });
  }

  void _removeDish(Dish dish) {
    setState(() {
      int existingIndex = _selectedDishes.indexWhere((d) => d.name == dish.name);

      if (existingIndex != -1) {
        if (_selectedDishes[existingIndex].quantity > 1) {
          _selectedDishes[existingIndex] = _selectedDishes[existingIndex].copyWith(
            quantity: _selectedDishes[existingIndex].quantity - 1,
          );
        } else {
          _selectedDishes.removeAt(existingIndex);
        }
      }
    });
  }

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: () async {
                  if (widget.selectedDate != null) {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DeliveryTimeScreen(
                          selectedDate: widget.selectedDate!,
                          selectedDishes: _selectedDishes,
                        ),
                      ),
                    );

                    if (result != null && result is List<Dish>) {
                      setState(() {
                        _selectedDishes = result;
                      });
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Дата не выбрана')),
                    );
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Время',
                    style: TextStyle(
                      color: textOnPrimary,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),

            Expanded(
              child: _selectedDishes.isEmpty
                  ? Center(
                child: Text(
                  'Пока здесь пусто',
                  style: TextStyle(
                    fontSize: 20,
                    color: primaryColor.withOpacity(0.6),
                  ),
                ),
              )
                  : ListView.builder(
                itemCount: _selectedDishes.length,
                itemBuilder: (context, index) {
                  final dish = _selectedDishes[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      title: Text(dish.name),
                      subtitle: Text(dish.price),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline),
                            onPressed: () => _removeDish(dish),
                          ),
                          Text('${dish.quantity}'),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline),
                            onPressed: () {
                              setState(() {
                                _selectedDishes[index] = dish.copyWith(
                                  quantity: dish.quantity + 1,
                                );
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MenuScreen()),
                  );

                  if (result != null && result is Dish) {
                    _addDish(result);
                  }
                },
                backgroundColor: buttonBg,
                child: Icon(Icons.add, color: primaryColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}