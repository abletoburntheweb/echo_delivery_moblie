import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/dish.dart';
import 'api_service.dart';

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

  static Future<List<Dish>> loadMenuFromApi() async {
    try {
      return await ApiService.getDishes();
    } catch (e) {
      print('Ошибка при загрузке меню из API: $e');
      return await loadMenuFromAssets();
    }
  }
}