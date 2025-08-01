import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:omeg_bazaar/utills/api_constants.dart';


class VerificationService {
  static const String baseUrl = ApiConstants.baseUrl;

  static Future<Map<String, dynamic>> registerUser({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/user/registerapp'),
        body: jsonEncode({
          'username': username,
          'email': email,
          'password': password,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      return jsonDecode(response.body);
    } catch (e) {
      throw Exception('Failed to register user');
    }
  }

static Future<Map<String, dynamic>> verifyOtp({
  required String userId,
  required String otp,
}) async {
  try {
    final response = await http.post(
      Uri.parse('$baseUrl/user/verify'),
      body: jsonEncode({'userId': userId, 'otp': otp}),
      headers: {'Content-Type': 'application/json'},
    );

    final responseData = jsonDecode(response.body);
    
    if (response.statusCode == 200) {
      if (responseData['success'] == true) {
        return responseData;
      } else {
        throw Exception(responseData['message'] ?? 'Verification failed');
      }
    } else {
      throw Exception(responseData['message'] ?? 'Verification failed');
    }
  } catch (e) {
    // print('Verification error: $e');
    rethrow;
  }
}

  static Future<Map<String, dynamic>> resendOtp({
    required String userId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/user/resendotp'),
        body: jsonEncode({'userId': userId}),
        headers: {'Content-Type': 'application/json'},
      );

      return jsonDecode(response.body);
    } catch (e) {
      throw Exception('Failed to resend OTP');
    }
  }
}
