import 'package:flutter/material.dart';
import 'package:flutterprojects/screens/profile_screen.dart';
import '../widgets/common_app_bar.dart';
import '../utils/colors.dart';
import 'dish_detail_screen.dart';
import '../models/dish.dart';
import '../services/menu_service.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  Dish? _newlyAddedDish;
  List<Dish> _menuDishes = [];
  bool _isLoading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadMenu();
  }

  Future<void> _loadMenu() async {
    try {
      List<Dish> loadedDishes = await MenuService.loadMenuFromApi();
      setState(() {
        _menuDishes = loadedDishes;
        _isLoading = false;
      });
    } catch (e) {
      print('Ошибка при загрузке меню: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<Dish> get _filteredDishes {
    if (_searchQuery.isEmpty) {
      return _menuDishes;
    }
    return _menuDishes.where((dish) {
      return dish.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          dish.description.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, _newlyAddedDish);
        return false;
      },
      child: Scaffold(
        appBar: buildCommonAppBar(
          title: 'ECHO corp',
          showProfileButton: true,
          onProfilePressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ProfileScreen()),
          ),
          showBackButton: true,
          onBackPressed: () {
            Navigator.pop(context, _newlyAddedDish);
          },
        ),
        body: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: hexColor('#885F3A').withOpacity(0.1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                decoration: BoxDecoration(
                  color: buttonBg,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: primaryColor),
                ),
                child: Row(
                  children: [
                    Icon(Icons.search, color: primaryColor),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Поиск блюд...',
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: primaryColor.withOpacity(0.6)),
                        ),
                        style: TextStyle(color: primaryColor),
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _filteredDishes.isEmpty
                    ? const Center(child: Text('Блюд не найдено'))
                    : ListView.builder(
                  itemCount: _filteredDishes.length,
                  itemBuilder: (context, index) {
                    Dish dish = _filteredDishes[index];
                    return _buildMenuItem(
                      context: context,
                      dish: dish,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required BuildContext context,
    required Dish dish,
  }) {
    return GestureDetector(
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DishDetailScreen(
              dish: dish,
            ),
          ),
        );

        if (result != null && result is Dish) {
          setState(() {
            _newlyAddedDish = result;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Блюдо "${result.name}" добавлено в корзину! Нажмите "назад", чтобы вернуться.',
              ),
            ),
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: buttonBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: primaryColor),
        ),
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.only(bottom: 10),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
              child: dish.image.isNotEmpty
                  ? Image.network(
                dish.fullImageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                    child: Text(
                      dish.name[0],
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600],
                      ),
                    ),
                  );
                },
              )
                  : Center(
                child: Text(
                  dish.name[0],
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dish.name,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '${dish.price} ₽',
                    style: TextStyle(fontSize: 16, color: primaryColor),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}