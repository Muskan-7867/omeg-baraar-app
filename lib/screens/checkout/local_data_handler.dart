import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalDataHandler {
  static Future<Map<String, dynamic>> loadUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final authToken = prefs.getString('authToken');
      final addressJson = prefs.getString('useraddress');
      final userDataString = prefs.getString('user_data');

      Map<String, dynamic>? userAddress;
      if (addressJson != null && addressJson.isNotEmpty) {
        try {
          dynamic decoded = jsonDecode(addressJson);
          if (decoded is String) {
            decoded = jsonDecode(decoded);
          }
          if (decoded is Map<String, dynamic>) {
            userAddress = decoded;
          }
        } catch (e) {
          debugPrint('Error decoding address: $e');
        }
      }

      Map<String, dynamic>? userData;
      if (userDataString != null) {
        try {
          userData = json.decode(userDataString) as Map<String, dynamic>;
        } catch (e) {
          debugPrint('Error decoding user data: $e');
        }
      }

      return {
        'authToken': authToken,
        'userAddress': userAddress,
        'userData': userData,
      };
    } catch (e) {
      debugPrint('Error loading local data: $e');
      throw Exception('Failed to load user data');
    }
  }

  static Map<String, dynamic> standardizeAddress(Map<String, dynamic> address) {
    return {
      'phone': address['phoneNumber'] ?? address['phone'],
      'street': address['street'] ?? '',
      'city': address['city'],
      'state': address['state'],
      'pincode': address['postalCode'] ?? address['pincode'],
      'country': address['country'],
      'address': address['addressLine1'] ?? address['address'],
      'address1': address['addressLine2'] ?? address['address1'],
      '_id': address['_id'],
    };
  }
}
