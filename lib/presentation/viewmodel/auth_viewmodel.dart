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

  Future<void> transformAuthRepository(
    BuildContext context,
    String email,
  ) async {
    // This is a placeholder since the valid logic is inside LoginScreen using Provider directly
    // Ideally, the ViewModel should hold the Repository.
    // For now, I will add the method but the direct call will likely be from UI or I need to refactor ViewModel.
  }
}
