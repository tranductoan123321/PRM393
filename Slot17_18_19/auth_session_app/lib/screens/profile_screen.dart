import 'package:flutter/material.dart';
import '../services/session_service.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void logout(BuildContext context) async {
    await SessionService.clearSession();
    if (!context.mounted) return;
    Navigator.pushReplacementNamed(context, "/login");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("User Profile"),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => logout(context),
              child: const Text("Logout"),
            ),
          ],
        ),
      ),
    );
  }
}
