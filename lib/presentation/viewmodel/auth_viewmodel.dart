import 'package:flutter/material.dart';

class AuthViewmodel extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';

  bool isValidForm() {
    return formKey.currentState?.validate() ?? false;
  }

  // void signOut() async {
  //   print('signOut');
  // }
}
