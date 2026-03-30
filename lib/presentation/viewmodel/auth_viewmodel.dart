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

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  bool isValidForm() {
    return formKey.currentState?.validate() ?? false;
  }

  Future<void> loadUser(AuthRepository repository) async {
    _isLoading = true;
    notifyListeners();
    try {
      _user = await repository.checkAuthStatus();
      _errorMessage = null;
    } catch (e) {
      _user = null;
      _errorMessage = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> deleteAccount(AuthRepository repository) async {
    _isLoading = true;
    notifyListeners();
    try {
      await repository.deleteUser();
      await repository.rejectPrivacyPolicy();
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
