import 'package:http/http.dart' as http;
import 'package:omeg_bazaar/utills/api.constraints.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AddAddressApi {
  static const String baseUrl =  ApiConstants.baseUrl;

  static Future<Map<String, dynamic>> addAddress({
    required String phone,
    required String street,
    required String city,
    required String state,
    required String pincode,
    required String country,
    required String address,
    String? address1,
  }) async {
    final uri = Uri.parse("$baseUrl/user/address");

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('authToken');

      final response = await http.put(
        uri,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          "phone": phone,
          "street": street,
          "city": city,
          "state": state,
          "pincode": pincode,
          "country": country,
          "address": address,
          if (address1 != null) "address1": address1,
        }),
      );

      dynamic responseData;
      try {
        responseData = jsonDecode(response.body);
      } catch (e) {
        return {
          'success': false,
          'message': 'Server returned invalid JSON',
          'statusCode': response.statusCode,
          'responseBody': response.body,
        };
      }

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return {
          'success': true,
          'message': responseData['message'] ?? 'Address saved successfully',
          'data': responseData['data'],
        };
      } else {
        return {
          'success': false,
          'message':
              responseData['message'] ??
              'Request failed (Status: ${response.statusCode})',
          'statusCode': response.statusCode,
          'error': responseData['error'],
        };
      }
    } catch (error) {
      // print("API Error: $error");
      return {
        'success': false,
        'message': 'Network error: ${error.toString()}',
      };
    }
  }
}
