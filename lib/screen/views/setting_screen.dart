import 'package:dominos_score/auth/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: const Text("Settings"),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            "Account",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          _settingsTile(icon: Icons.person, title: "Profile", onTap: () {}),
          _settingsTile(
            icon: Icons.lock,
            title: "Change Password",
            onTap: () {},
          ),

          const SizedBox(height: 30),
          const Text(
            "Preferences",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          _settingsTile(
            icon: Icons.dark_mode,
            title: "Dark Mode",
            trailing: Switch(value: false, onChanged: (v) {}),
            onTap: () {},
          ),
          _settingsTile(
            icon: Icons.notifications,
            title: "Notifications",
            onTap: () {},
          ),

          const SizedBox(height: 30),
          const Text(
            "More",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          _settingsTile(icon: Icons.info, title: "About App", onTap: () {}),
          _settingsTile(
            icon: Icons.logout,
            title: "Logout",
            titleColor: Colors.red,
            iconColor: Colors.red,
            onTap: () {
              final authServices = Provider.of<AuthService>(
                context,
                listen: false,
              );

              authServices.loguot();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
    );
  }

  Widget _settingsTile({
    required IconData icon,
    required String title,
    Color? iconColor,
    Color? titleColor,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        leading: Icon(icon, color: iconColor ?? Colors.black),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: titleColor,
          ),
        ),
        trailing: trailing ?? const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
