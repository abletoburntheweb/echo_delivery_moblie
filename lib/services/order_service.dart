// lib/services/order_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/dish.dart';

class OrderService {
  static const String baseUrl = 'http://192.168.0.11:8000/api';

  static Future<Map<String, String>> _getHeaders() async {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }

  static Future<bool> createOrder({
    required int companyId,
    required DateTime deliveryDate,
    required String deliveryTime,
    required String deliveryAddress,
    required List<Dish> dishes,
  }) async {
    try {
      final headers = await _getHeaders();

      final orderData = {
        'id_company': companyId,
        'delivery_date': _formatDate(deliveryDate),
        'delivery_time': deliveryTime,
        'delivery_address': deliveryAddress,
        'status': 'новый',
        'items': dishes.map((dish) => {
          'id_dish': dish.id,
          'quantity': dish.quantity,
        }).toList(),
      };

      final response = await http.post(
        Uri.parse('$baseUrl/orders/'),
        headers: headers,
        body: json.encode(orderData),
      );

      print('Order creation response: ${response.statusCode}');
      print('Response body: ${response.body}');

      return response.statusCode == 201;
    } catch (e) {
      print('Error creating order: $e');
      return false;
    }
  }

  static String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  static Future<List<dynamic>> getCompanyOrders(int companyId) async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/orders/?id_company=$companyId'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load orders: ${response.statusCode}');
      }
    } catch (e) {
      print('Error loading orders: $e');
      return [];
    }
  }
}