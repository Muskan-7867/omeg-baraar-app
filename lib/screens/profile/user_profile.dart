import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:omeg_bazaar/screens/home/home.dart';
import 'package:omeg_bazaar/screens/profile/widgets/profile_dropdowns.dart';
import 'package:omeg_bazaar/screens/profile/widgets/profile_options.dart';
import 'package:omeg_bazaar/screens/profile/widgets/profile_options_data.dart';
import 'package:omeg_bazaar/screens/profile/widgets/services/profile_data_service.dart';
import 'package:omeg_bazaar/screens/profile/widgets/user_info.dart';
import 'package:omeg_bazaar/utills/app_colour.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? userData;
  bool isLoading = true;
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');

    if (token == null) {
      if (mounted) {
        setState(() {
          isLoggedIn = false;
          isLoading = false;
        });
      }
      return;
    }

    try {
      final data = await ProfileDataService.loadUserData();
      if (mounted) {
        setState(() {
          userData = data['userData'];
          isLoggedIn = true;
          isLoading = false;
        });
        await prefs.setString('userData', jsonEncode(userData));
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
      await prefs.remove('authToken');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Handle redirect if not logged in
    if (!isLoggedIn && !isLoading) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.offAll(() => const Home());
      });
    }

    if (isLoading) {
      return Scaffold(
        backgroundColor: Colors.white, // Prevent black screen
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColour.primaryColor),
          ),
        ),
      );
    }

    if (!isLoggedIn) {
      return const SizedBox.shrink(); // Will redirect momentarily
    }

    final options = getProfileOptions(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.off(() => const Home()),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            UserInfo(user: userData),
            const SizedBox(height: 20),
            const ProfileOptions(),
            const SizedBox(height: 20),
            ...options.map(
              (item) => Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    child: ProfileDropdown(
                      icon: item['icon'] as IconData,
                      title: item['title'] as String,
                      onTap: item['onTap'] as VoidCallback,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
