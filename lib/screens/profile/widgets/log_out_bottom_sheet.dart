import 'package:flutter/material.dart';
import 'package:omeg_bazaar/utills/app_colour.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogOutSheetCart extends StatelessWidget {
  const LogOutSheetCart({super.key});

  Future<void> _logOut(BuildContext context) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      Navigator.of(
        context,
      ).pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Logged out successfully'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      // Show error message if logout fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Logout failed: ${e.toString()}'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 260,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              'Log Out',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColour.primaryColor,
              ),
            ),
            const Divider(),
            const SizedBox(height: 20),
            const Text(
              'Are you Sure you want to log out?',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 180,
                  child: TextButton(
                    style: ButtonStyle(
                      side: WidgetStateProperty.all(
                        const BorderSide(
                          color: AppColour.primaryColor,
                          width: 1,
                        ),
                      ),
                    ),

                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel'),
                  ),
                ),
                SizedBox(
                  width: 180,
                  child: TextButton(
                    onPressed: () => _logOut(context),
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(
                        AppColour.primaryColor,
                      ),
                    ),
                    child: const Text(
                      'Log Out',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
