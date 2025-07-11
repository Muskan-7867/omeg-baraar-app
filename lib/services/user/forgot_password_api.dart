import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:omeg_bazaar/utills/api_constants.dart';

class ForgotPassword {
  static const String baseurl =  ApiConstants.baseUrl;

  Future<Map<String, dynamic>> forgetpassword(String email) async {
    final uri = Uri.parse("$baseurl/user/forgotpassword");

    try {
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      final responsedata = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {'success': true, 'message': responsedata['message']};
      } else {
        return {'success': false, 'message': responsedata['message'] ?? 'Request failed'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }
}
