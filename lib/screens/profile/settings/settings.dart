import 'package:flutter/material.dart';
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
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Local data deleted successfully')),
        );
        Future.delayed(const Duration(milliseconds: 1500), () {
          Navigator.pushReplacementNamed(context, '/home');
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete local data: ${e.toString()}'),
          ),
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
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const ProfileScreen()),
            );
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
