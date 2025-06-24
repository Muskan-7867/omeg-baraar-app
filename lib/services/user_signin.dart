import 'dart:convert';

import 'package:http/http.dart' as http;

class UserAuth {
  static const String baseurl =
      "https://omeg-bazaar-backend.onrender.com/api/v1";

  Future<Map<String, dynamic>> loginUser(String email, String password) async {
    final uri = Uri.parse("$baseurl/user/login");

    try {
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      final responsedata = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'token': responsedata['token'],
          'message': responsedata['user']['message'],
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
