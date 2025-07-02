import 'package:flutter/material.dart';
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
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final data = await ProfileDataService.loadUserData();
      setState(() {
        userData = data['userData'];
        userOrders = data['userOrders'];
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        userOrders = [];
      });
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
              () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const Home()),
              ),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
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
