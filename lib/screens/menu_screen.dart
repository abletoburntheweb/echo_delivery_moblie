// lib/screens/menu_screen.dart
import 'package:flutter/material.dart';
import 'package:flutterprojects/screens/profile_screen.dart';
import '../widgets/common_app_bar.dart';
import '../utils/colors.dart';
import 'dish_detail_screen.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildCommonAppBar(
        title: 'ECHO corp',
        showProfileButton: true,
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
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Expanded(
              child: ListView(
                children: [
                  _buildMenuItem(
                    context: context,
                    name: 'Плов',
                    price: '250 ₽',
                    description: 'Плов очень вкусный. Я его люблю. Правда он жирный и не особо полезный, но, как говорится, сердцу не прикажешь.',
                  ),
                  const SizedBox(height: 20),

                  _buildMenuItem(
                    context: context,
                    name: 'Пельмени',
                    price: '200 ₽',
                    description: 'Пельмени — это классика. Готовятся с мясом, сыром или грибами. Подавайте со сметаной!',
                  ),
                  const SizedBox(height: 20),

                  _buildMenuItem(
                    context: context,
                    name: 'Борщ',
                    price: '180 ₽',
                    description: 'Борщ — традиционное украинское блюдо. Готовится с капустой, свеклой и мясом. Очень сытный и вкусный.',
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required BuildContext context,
    required String name,
    required String price,
    required String description,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DishDetailScreen(
              name: name,
              description: description,
              price: price,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: buttonBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: primaryColor),
        ),
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  name[0],
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
                    name,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    price,
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