import 'package:dominos_score/data/local/database_helper.dart';
import 'package:dominos_score/domain/models/auth/user_model.dart';
import 'package:dominos_score/domain/repositories/auth_repository.dart';
import 'package:flutter/material.dart';

class AuthViewmodel extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  String emailText = '';
  String passwordText = '';

  UserModel? _user;
  UserModel? get user => _user;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool isValidForm() {
    return formKey.currentState?.validate() ?? false;
  }

  Future<void> loadUser(AuthRepository repository) async {
    _isLoading = true;
    notifyListeners();
    try {
      _user = await repository.checkAuthStatus();
    } catch (e) {
      _user = null;
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> deleteAccount(AuthRepository repository) async {
    _isLoading = true;
    notifyListeners();
    try {
      await repository.deleteUser();
      await DatabaseHelper().deleteDB();
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> transformAuthRepository(
    BuildContext context,
    String email,
  ) async {
    // Placeholder
  }
}
