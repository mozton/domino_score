import 'package:dominos_score/provider/game_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';

class SwitchThemeWidget extends StatelessWidget {
  const SwitchThemeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, prov, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (Platform.isIOS)
              CupertinoSwitch(
                value: prov.isDarkMode,

                activeTrackColor: Colors.white,
                thumbColor: Colors.grey,
                onChanged: (value) {
                  if (prov.isSystemTheme == true) {
                    null;
                  } else {
                    prov.toggleTheme(value);
                  }

                  // print(value);
                },
              )
            else
              Switch(
                value: prov.isDarkMode,
                activeColor: Colors.white,
                activeTrackColor: Colors.grey,
                onChanged: (value) {
                  prov.toggleTheme(value);

                  // print(value);
                },
              ),
          ],
        );
      },
    );
  }
}
