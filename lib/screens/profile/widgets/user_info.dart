import 'package:flutter/material.dart';

class UserInfo extends StatelessWidget {
  final Map<String, dynamic>? user;
  // Add this to accept user data

  const UserInfo({
    super.key,
    this.user,
  }); // Update constructor to include 'user'

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(radius: 50, child: Icon(Icons.person_3_sharp, size: 60)),
          const SizedBox(height: 10),
          Text(
            user?['username'] ?? 'No username provided',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 90, 90, 90),
            ),
          ),
          Text(
            user?['email'] ?? 'No email provided',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.normal,
              color: Color.fromARGB(255, 90, 90, 90),
            ),
          ),
        ],
      ),
    );
  }
}
