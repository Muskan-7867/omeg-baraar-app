import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalDataHandler {
  static Future<Map<String, dynamic>> loadUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final authToken = prefs.getString('authToken');
      final addressJson = prefs.getString('useraddress');
      Map<String, dynamic>? userAddress;

      if (addressJson != null && addressJson.isNotEmpty) {
        try {
          dynamic decoded = jsonDecode(addressJson);
          if (decoded is String) {
            decoded = jsonDecode(decoded);
          }
          if (decoded is Map<String, dynamic>) {
            userAddress = decoded;
          } else {
            debugPrint('Unexpected address format: ${decoded.runtimeType}');
          }
        } catch (e) {
          debugPrint('Error decoding address: $e');
          try {
            userAddress = jsonDecode(addressJson) as Map<String, dynamic>?;
          } catch (e) {
            debugPrint('Fallback decoding failed: $e');
          }
        }
      }

      return {
        'authToken': authToken,
        'userAddress': userAddress,
        'error': null,
      };
    } catch (e) {
      debugPrint('Error loading data: $e');
      return {
        'authToken': null,
        'userAddress': null,
        'error': 'Failed to load address',
      };
    }
  }
}
