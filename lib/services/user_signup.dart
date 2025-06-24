import 'dart:convert';

import 'package:http/http.dart' as http;

class UserRegister {
  static const String baseurl =
      "https://omeg-bazaar-backend.onrender.com/api/v1";

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



