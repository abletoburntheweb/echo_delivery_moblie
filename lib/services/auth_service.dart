// lib/services/auth_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../models/dish.dart';

class AuthService {
  static const String baseUrl = 'http://192.168.0.11:8000/api';

  static const String _prefsKeyUser = 'current_user';
  static const String _prefsKeyUserEmail = 'current_user_email';

  static Future<Map<String, String>> _getHeaders() async {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }

  static Future<void> testConnection() async {
    try {
      print('🔍 Тестируем подключение к API...');
      print('🌐 URL: $baseUrl/dishes/');

      final response = await http.get(
        Uri.parse('$baseUrl/dishes/'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 5));

      print('✅ Подключение работает! Status: ${response.statusCode}');
      print('📄 Ответ: ${response.body.length} символов');
    } catch (e) {
      print('🔴 Нет подключения к API: $e');
    }
  }

  static Future<Map<String, dynamic>> registerWithApi({
    required String company,
    required String phone,
    required String email,
    required String password,
    required String address,
  }) async {
    try {
      print('🔄 === НАЧАЛО РЕГИСТРАЦИИ ===');

      final requestData = {
        'username': email,
        'email': email,
        'password': password,
        'company_name': company,
        'phone': phone,
        'address': address,
      };

      print('📦 Request data: $requestData');
      print('🌐 URL: $baseUrl/auth/register/');
      print('📤 Method: POST');

      final response = await http.post(
        Uri.parse('$baseUrl/auth/register/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestData),
      ).timeout(const Duration(seconds: 10));

      print('📡 Response status: ${response.statusCode}');
      print('📡 Response body: ${response.body}');

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        print('✅ === РЕГИСТРАЦИЯ УСПЕШНА ===');
        return data;
      } else {
        final errorData = json.decode(response.body);
        final errorMessage = errorData['error'] ?? errorData['detail'] ?? 'Ошибка регистрации';
        print('❌ === ОШИБКА РЕГИСТРАЦИИ ===: $errorMessage');
        throw Exception(errorMessage);
      }
    } catch (e) {
      print('🔴 === КРИТИЧЕСКАЯ ОШИБКА ===: $e');
      throw Exception('Ошибка подключения: $e');
    }
  }

  static Future<Map<String, dynamic>> loginWithApi(String email, String password) async {
    try {
      print('🔄 Логин через API: $email');

      final response = await http.post(
        Uri.parse('$baseUrl/auth/login/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      print('📡 API Response status: ${response.statusCode}');
      print('📡 API Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_prefsKeyUser, json.encode(data));
        await prefs.setString(_prefsKeyUserEmail, email);

        print('✅ Логин успешен: $email');
        return data;
      } else {
        final errorData = json.decode(response.body);
        final errorMessage = errorData['error'] ?? errorData['detail'] ?? 'Ошибка входа';
        print('❌ Ошибка логина: $errorMessage');
        throw Exception(errorMessage);
      }
    } catch (e) {
      print('🔴 Ошибка подключения при логине: $e');
      throw Exception('Ошибка подключения: $e');
    }
  }

  static Future<bool> checkApiConnection() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/dishes/'),
        headers: {'Content-Type': 'application/json'},
      );
      return response.statusCode == 200;
    } catch (e) {
      print('🔴 Нет подключения к API: $e');
      return false;
    }
  }

  static Future<bool> isUserLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_prefsKeyUser);
    return userJson != null && prefs.getString(_prefsKeyUserEmail) != null;
  }

  static Future<Map<String, dynamic>?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_prefsKeyUser);
    if (userJson != null) {
      return Map<String, dynamic>.from(json.decode(userJson));
    }
    return null;
  }

  static Future<String?> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_prefsKeyUserEmail);
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_prefsKeyUser);
    await prefs.remove(_prefsKeyUserEmail);
  }

  static Future<List<String>> getOrderDatesFromApi() async {
    try {
      print('📅 Загрузка дат заказов из БД...');

      final userEmail = await getUserEmail();
      if (userEmail == null) {
        throw Exception('Пользователь не авторизован');
      }

      print('📧 Загружаем заказы для: $userEmail');

      final url = Uri.parse('$baseUrl/user/orders/?email=$userEmail');
      print('🌐 URL запроса: $url');

      final response = await http.get(
        url,
        headers: await _getHeaders(),
      );

      print('📡 Response status: ${response.statusCode}');
      print('📡 Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> orderDates = data['order_dates'] ?? [];
        print('✅ Заказы из БД: ${orderDates.length} дат');
        return orderDates.cast<String>();
      } else {
        final errorData = json.decode(response.body);
        final errorMessage = errorData['error'] ?? 'Ошибка загрузки заказов';
        throw Exception(errorMessage);
      }
    } catch (e) {
      print('🔴 Ошибка загрузки заказов из БД: $e');
      throw Exception('Ошибка загрузки заказов: $e');
    }
  }

  static Future<Map<String, dynamic>> createOrderWithApi({
    required DateTime deliveryDate,
    required String deliveryTime,
    required String deliveryAddress,
    required List<Dish> dishes,
  }) async {
    try {
      print('📦 Создание заказа в БД...');

      final userEmail = await getUserEmail();
      if (userEmail == null) {
        throw Exception('Пользователь не авторизован');
      }

      final requestData = {
        'email': userEmail,
        'delivery_date': DateFormat('yyyy-MM-dd').format(deliveryDate),
        'delivery_time': deliveryTime,
        'delivery_address': deliveryAddress,
        'items': dishes.map((dish) => {
          'dish_id': dish.id,
          'quantity': dish.quantity,
        }).toList(),
      };

      print('📦 Order data: $requestData');

      final response = await http.post(
        Uri.parse('$baseUrl/orders/create/'),
        headers: await _getHeaders(),
        body: json.encode(requestData),
      );

      print('📡 Response status: ${response.statusCode}');
      print('📡 Response body: ${response.body}');

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        print('✅ Заказ создан в БД: ID ${data['order_id']}');
        return data;
      } else {
        final errorData = json.decode(response.body);
        final errorMessage = errorData['error'] ?? 'Ошибка создания заказа';
        throw Exception(errorMessage);
      }
    } catch (e) {
      print('🔴 Ошибка создания заказа в БД: $e');
      throw Exception('Ошибка создания заказа: $e');
    }
  }

  static Future<Map<String, dynamic>> smartLogin(String email, String password) async {
    try {
      print('🧠 УМНЫЙ ВХОД: только через API');

      if (await checkApiConnection()) {
        print('🌐 API доступно, входим через Django...');
        return await loginWithApi(email, password);
      } else {
        throw Exception('Нет подключения к серверу. Проверьте интернет.');
      }
    } catch (e) {
      print('💥 Ошибка в smartLogin: $e');
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> smartRegister({
    required String company,
    required String phone,
    required String email,
    required String password,
    required String address,
  }) async {
    try {
      print('🧠 УМНАЯ РЕГИСТРАЦИЯ: только через API');

      if (await checkApiConnection()) {
        print('🌐 API доступно, регистрируем через Django...');
        return await registerWithApi(
          company: company,
          phone: phone,
          email: email,
          password: password,
          address: address,
        );
      } else {
        throw Exception('Нет подключения к серверу. Проверьте интернет.');
      }
    } catch (e) {
      print('💥 Ошибка в smartRegister: $e');
      rethrow;
    }
  }

  static Future<List<String>> getOrderDates() async {
    return await getOrderDatesFromApi();
  }

  static Future<void> saveOrder({
    required DateTime deliveryDate,
    required String deliveryTime,
    required String deliveryAddress,
    required List<Dish> dishes,
  }) async {
    await createOrderWithApi(
      deliveryDate: deliveryDate,
      deliveryTime: deliveryTime,
      deliveryAddress: deliveryAddress,
      dishes: dishes,
    );
  }

  static Future<List<Dish>> getDishesForDate(DateTime date) async {
    print('⚠️ Получение блюд для даты еще не реализовано');
    return [];
  }
}