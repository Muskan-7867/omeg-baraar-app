import 'dart:convert';
import 'package:http/http.dart' as http;

class ResetPasswordApi {
  static const String baseurl =
      "https://omeg-bazaar-backend.onrender.com/api/v1";

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
