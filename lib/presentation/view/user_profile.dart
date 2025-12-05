import 'package:flutter/material.dart';

class UserProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: CircleAvatar()),

      body: Center(child: Text('Hola Mundo')),
    );
  }
}
