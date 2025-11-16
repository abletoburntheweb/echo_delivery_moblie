import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/dish.dart';

class ApiService {
  static const String baseUrl = 'http://192.168.0.11:8000/api';

  static Future<Map<String, String>> _getHeaders() async {
    return {
      'Content-Type': 'application/json',
    };
  }

  static Future<List<Dish>> getDishes() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/dishes/'),
        headers: headers,
      );

      print('🔵 API Response status: ${response.statusCode}');
      print('🔵 API Response body: ${response.body}');

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        print('🟢 Parsed data length: ${data.length}');

        List<Dish> dishes = data.map((item) {
          print('🍽️ Raw item: $item');
          Dish dish = Dish.fromJson(item);
          print('✅ Parsed dish: ${dish.name}, ${dish.price}, ${dish.image}');
          return dish;
        }).toList();

        return dishes;
      } else {
        throw Exception('Failed to load dishes: ${response.statusCode}');
      }
    } catch (e) {
      print('🔴 API Error: $e');
      throw Exception('Failed to load dishes: $e');
    }
  }

  static Future<List<Dish>> getDishesByCategory(int categoryId) async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/dishes/by_category/?category_id=$categoryId'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((item) => Dish.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load dishes by category');
      }
    } catch (e) {
      throw Exception('Failed to load dishes by category: $e');
    }
  }
  static Future<Map<String, dynamic>> getSiteStatus() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/site/status/'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return {
          'site_available': true,
          'site_blocked': false,
          'maintenance_mode': false
        };
      }
    } catch (e) {
      print('Error getting site status: $e');
      return {
        'site_available': true,
        'site_blocked': false,
        'maintenance_mode': false
      };
    }
  }
  static Future<List<dynamic>> getCategories() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/categories/'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      throw Exception('Failed to load categories: $e');
    }
  }
}