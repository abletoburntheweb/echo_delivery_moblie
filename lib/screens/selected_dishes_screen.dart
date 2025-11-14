import 'package:flutter/material.dart';
import 'package:flutterprojects/screens/profile_screen.dart';
import '../widgets/common_app_bar.dart';
import '../utils/colors.dart';
import 'menu_screen.dart';
import 'order_confirmation_screen.dart';
import '../models/dish.dart';
import '../services/auth_service.dart';
import 'package:intl/intl.dart';

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

  @override
  void initState() {
    super.initState();
    if (widget.selectedDate != null) {
      _loadSavedDishes();
    }
  }

  Future<void> _loadSavedDishes() async {
    final dishes = await AuthService.getDishesForDate(widget.selectedDate!);
    setState(() {
      _selectedDishes = dishes;
    });
  }

  void _addDish(Dish dish) {
    setState(() {
      int existingIndex = _selectedDishes.indexWhere((d) => d.id == dish.id);

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
      int existingIndex = _selectedDishes.indexWhere((d) => d.id == dish.id);

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

  double get _totalPrice {
    double sum = 0.0;
    for (var dish in _selectedDishes) {
      sum += dish.price * dish.quantity;
    }
    return sum;
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
                onTap: () {
                  if (widget.selectedDate == null) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(const SnackBar(content: Text('Дата не выбрана')));
                    return;
                  }
                  if (_selectedDishes.isEmpty) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(const SnackBar(content: Text('Выберите хотя бы одно блюдо')));
                    return;
                  }

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => OrderConfirmationScreen(
                        selectedDate: widget.selectedDate!,
                        selectedDishes: _selectedDishes,
                      ),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Подтвердить',
                    style: TextStyle(
                      color: textOnPrimary,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),

            if (_selectedDishes.isNotEmpty)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Итого: ${_totalPrice.toStringAsFixed(2)} ₽',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 20),

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
                  final itemTotal = dish.price * dish.quantity;
                  return Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      title: Text(dish.name),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${dish.price} ₽ × ${dish.quantity}'),
                          Text('${itemTotal.toStringAsFixed(2)} ₽',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                            ),
                          ),
                        ],
                      ),
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
                                _selectedDishes[index] =
                                    dish.copyWith(quantity: dish.quantity + 1);
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