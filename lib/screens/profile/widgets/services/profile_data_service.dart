import 'package:flutter/widgets.dart';
import 'package:omeg_bazaar/services/user/fetch_user_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileDataService {
  static Future<Map<String, dynamic>> loadUserData() async {
    try {
      final cachedOrders = await UserService.getSavedUserOrders();
      final userData = await _fetchUserData();
      final processedOrders = _processOrders(
        cachedOrders ?? userData['userOrders'],
      );
      return {'userData': userData['userData'], 'userOrders': processedOrders};
    } catch (e) {
      rethrow;
    }
  }

  static List<dynamic> _processOrders(List<dynamic> orders) {
    final processedOrders = [];

    for (final order in orders) {
      // Ensure order is a Map and has orderItems
      if (order is Map<String, dynamic> && order.containsKey('orderItems')) {
        final orderItems = order['orderItems'] as List<dynamic>;

        // Create individual entries for each item in the order
        for (final item in orderItems) {
          processedOrders.add({
            ...order, // Copy all order-level fields
            'orderItems': [item], // Replace with single-item list
            'expandedItem': item, // Add direct reference to the item
          });
        }
      } else {
        // Keep orders without items as-is
        processedOrders.add(order);
      }
    }

    return processedOrders;
  }

  static Future<Map<String, dynamic>> _fetchUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('authToken');

      if (token != null) {
        final userResponse = await UserService.getUser(token);
        debugPrint(userResponse.toString());
        return {
          'userData':
              userResponse['user'] is Map
                  ? Map<String, dynamic>.from(userResponse['user'])
                  : {},
          'userOrders':
              userResponse['user'] is Map &&
                      userResponse['user']['order'] is List
                  ? List<dynamic>.from(userResponse['user']['order'])
                  : [],
        };
      } else {
        throw Exception('No authentication token found');
      }
    } catch (e) {
      return {'userData': {}, 'userOrders': []};
    }
  }
}
