import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:omeg_bazaar/screens/home/home.dart';
import 'package:omeg_bazaar/screens/profile/widgets/profile_dropdowns.dart';
import 'package:omeg_bazaar/screens/profile/widgets/profile_options.dart';
import 'package:omeg_bazaar/screens/profile/widgets/profile_options_data.dart';
import 'package:omeg_bazaar/screens/profile/widgets/services/profile_data_service.dart';
import 'package:omeg_bazaar/screens/profile/widgets/user_info.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? userData;
  List<dynamic>? userOrders;
  bool isLoading = false;
  bool showUserInfoLoader = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    // Show loader only if data takes more than 300ms to load
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted && isLoading) {
        setState(() => showUserInfoLoader = true);
      }
    });

    setState(() => isLoading = true);

    try {
      final data = await ProfileDataService.loadUserData();
      if (mounted) {
        setState(() {
          userData = data['userData'];
          userOrders = data['userOrders'];
          isLoading = false;
          showUserInfoLoader = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
          showUserInfoLoader = false;
          userOrders = [];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final options = getProfileOptions(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        elevation: 0,
        leading: IconButton(
          onPressed:
              () => Get.off(() => const Home()),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                UserInfo(user: userData),
                if (showUserInfoLoader)
                  SizedBox(
                    child: const Center(child: CircularProgressIndicator()),
                  ),
              ],
            ),
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
