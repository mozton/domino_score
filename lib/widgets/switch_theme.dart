import 'package:dominos_score/provider/game_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SwitchThemeWidget extends StatelessWidget {
  const SwitchThemeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<GameProvider>(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Tema oscuro', style: TextStyle(fontSize: 18)),
        Switch(
          value: themeProvider.isDarkMode,
          onChanged: (value) {
            themeProvider.toggleTheme(value);
            // print(value);
          },
        ),
      ],
    );
  }
}
