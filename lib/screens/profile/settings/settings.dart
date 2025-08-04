import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:omeg_bazaar/screens/profile/user_profile.dart';
import 'package:omeg_bazaar/screens/profile/widgets/profile_dropdowns.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  Future<void> _deleteLocalData(BuildContext context) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Local Data'),
          content: const Text(
            'Are you sure you want to delete all local data?',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Get.back(result: true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.clear();
        Get.snackbar(
          '',
          'Local data deleted successfully',
          snackPosition: SnackPosition.BOTTOM,
          duration: 2.seconds,
        );
        Future.delayed(const Duration(milliseconds: 1500), () {
          Get.offAllNamed('/home');
        });
      } catch (e) {
        Get.snackbar(
          'Error',
          'Failed to delete local data: ${e.toString()}',
          colorText: Colors.white,
          backgroundColor: Colors.red,
          snackPosition: SnackPosition.BOTTOM,
          duration: 3.seconds,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Get.off(() => const ProfileScreen());
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            ProfileDropdown(
              icon: Icons.settings_accessibility,
              title: 'Notification Settings',
              onTap: () {},
            ),
            ProfileDropdown(
              icon: Icons.key,
              title: 'Password Manager',
              onTap: () {},
            ),
            ProfileDropdown(
              icon: Icons.delete,
              title: 'Delete Account',
              onTap: () => _deleteLocalData(context),
            ),
          ],
        ),
      ),
    );
  }
}
