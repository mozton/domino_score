import 'package:dominos_score/viewmodel/game_provider.dart';
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
                activeThumbColor: Colors.white,
                activeTrackColor: Colors.blue,
                inactiveTrackColor: Colors.grey,
                inactiveThumbColor: Colors.white,
                trackOutlineWidth: WidgetStateProperty.all(0.1),
                onChanged: (value) {
                  if (prov.isSystemTheme == true) {
                    null;
                  } else {
                    prov.toggleTheme(value);
                  }
                  // print(value);
                },
              ),
          ],
        );
      },
    );
  }
}
