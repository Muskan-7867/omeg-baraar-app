import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:omeg_bazaar/utills/api.constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  static const baseUrl = ApiConstants.baseUrl;
  static const _userDataKey = 'user_data';
  static const _userOrdersKey = 'user_orders';

  static Future<Map<String, dynamic>> getUser(String token) async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/user/current"),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      final data = json.decode(response.body);
      debugPrint('User data: $data');

      if (response.statusCode == 200) {
        await _saveUserData(data);
        if (data['user']['order'] != null) {
          await _saveUserOrders(data['user']['order']);
        }
        return data;
      } else {
        throw Exception('Failed to load user data');
      }
    } catch (e) {
      throw Exception('Error fetching user data: $e');
    }
  }

  static Future<void> _saveUserData(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userDataKey, json.encode(userData));
  }

  static Future<void> _saveUserOrders(List<dynamic> orders) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userOrdersKey, json.encode(orders));
  }

  static Future<List<dynamic>?> getSavedUserOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final ordersString = prefs.getString(_userOrdersKey);
    if (ordersString != null) {
      return json.decode(ordersString) as List<dynamic>;
    }
    return null;
  }

  static Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userDataKey);
    await prefs.remove(_userOrdersKey);
  }
}
