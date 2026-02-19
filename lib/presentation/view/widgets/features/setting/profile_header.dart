import 'package:dominos_score/domain/models/auth/user_model.dart';
import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final UserModel user;

  const ProfileHeader({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    String maskEmail(String email) {
      final parts = email.split('@');
      if (parts.length < 2) return email;
      final name = parts[0];
      final domain = parts[1];
      final maskedName = name.length > 3 ? '${name.substring(0, 3)}****' : name;
      return '$maskedName@$domain';
    }

    return Column(
      children: [
        const SizedBox(height: 30),
        CircleAvatar(
          radius: 50,
          backgroundColor: isDark ? Colors.grey[800] : Colors.grey[300],
          backgroundImage: user.photoUrl != null
              ? NetworkImage(user.photoUrl!)
              : null,
          child: user.photoUrl == null
              ? Icon(
                  Icons.person,
                  size: 50,
                  color: isDark ? Colors.white : Colors.grey[600],
                )
              : null,
        ),
        const SizedBox(height: 20),
        Text(
          user.name,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          maskEmail(user.email),
          style: TextStyle(
            fontSize: 16,
            fontFamily: 'Poppins',
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}
