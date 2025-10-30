// lib/services/menu_service.dart
import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/dish.dart';

class MenuService {
  static const String _menuAssetPath = 'assets/data/menu.json';

  static Future<List<Dish>> loadMenuFromAssets() async {
    try {
      String jsonString = await rootBundle.loadString(_menuAssetPath);

      List<dynamic> jsonList = json.decode(jsonString);

      List<Dish> dishes = jsonList.map((jsonItem) {
        return Dish.fromJson(jsonItem);
      }).toList();

      return dishes;
    } catch (e) {
      print('Ошибка при загрузке меню из JSON: $e');
      return [];
    }
  }
}