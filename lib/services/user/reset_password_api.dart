import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:omegbazaar/utills/api_constants.dart';

class ResetPasswordApi {
  static const String baseurl =  ApiConstants.baseUrl;

  Future<Map<String, dynamic>> resetpassword(
    String token,
    String newPassword,
  ) async {
    final uri = Uri.parse("$baseurl/user/resetpassword/$token");

    try {
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'newPassword': newPassword}),
      );

      final responsedata = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return {"success": true, "message": responsedata['message']};
      } else {
        return {
          'success': false,
          'message': responsedata['message'] ?? 'Request failed',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }
}
