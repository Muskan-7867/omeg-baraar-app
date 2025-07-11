import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:omegbazaar/utills/api_constants.dart';

class UserRegister {
  static const String baseurl =  ApiConstants.baseUrl;

  Future<Map<String, dynamic>> registerUser(
    String username,
    String email,
    String password,
  ) async {
    final uri = Uri.parse("$baseurl/user/register");

    try {
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'email': email,
          'password': password,
        }),
      );

      final responsedata = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': responsedata['message'],
          'token': responsedata['token'],
          'user': responsedata['user'],
        };
      } else {
        return {'success': false, 'message': responsedata['message']};
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }
}



