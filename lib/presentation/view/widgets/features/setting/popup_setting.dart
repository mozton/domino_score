import 'package:flutter/material.dart';

class SettingsPopupDemo extends StatelessWidget {
  const SettingsPopupDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Demo Popup Settings"),
        actions: [
          IconButton(icon: const Icon(Icons.settings), onPressed: () {}),
        ],
      ),
      body: const Center(child: Text("Pantalla principal")),
    );
  }
}
