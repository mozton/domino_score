import 'package:dominos_score/data/local/database_helper.dart';
import 'package:dominos_score/domain/models/auth/user_model.dart';
import 'package:dominos_score/domain/repositories/auth_repository.dart';
import 'package:dominos_score/presentation/view/screen/auth/login_screen.dart';
import 'package:dominos_score/presentation/view/screen/home/home_screen.dart';
import 'package:dominos_score/presentation/view/screen/subscription/subscription_screen.dart';
import 'package:dominos_score/presentation/viewmodel/subscription_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

enum _AuthCheckStatus { loading, error }

class CheckAuthScreen extends StatefulWidget {
  const CheckAuthScreen({super.key});

  @override
  State<CheckAuthScreen> createState() => _CheckAuthScreenState();
}

class _CheckAuthScreenState extends State<CheckAuthScreen> {
  _AuthCheckStatus _status = _AuthCheckStatus.loading;
  String? _errorMessage;
  bool _isNavigating = false;

  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    try {
      final user = await context.read<AuthRepository>().checkAuthStatus();
      if (!mounted) return;

      if (user == null) {
        _navigateTo(const LoginScreen());
        return;
      }

      // Usuario autenticado: inicializar BD y suscripción en paralelo
      await _initializeApp(user);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _status = _AuthCheckStatus.error;
        _errorMessage = e.toString();
      });
    }
  }

  Future<void> _initializeApp(UserModel user) async {
    try {
      // Ejecutar ambas inicializaciones concurrentemente
      await Future.wait([
        DatabaseHelper().init(user.id),
        context.read<SubscriptionViewModel>().initialize(),
      ]);

      if (!mounted) return;

      final isPremium = context.read<SubscriptionViewModel>().isPremium;
      _navigateTo(isPremium ? HomeScreen() : const SubscriptionScreen());
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _status = _AuthCheckStatus.error;
        _errorMessage = e.toString();
      });
    }
  }

  void _navigateTo(Widget screen) {
    if (_isNavigating) return;
    _isNavigating = true;
    // Usamos microtask para asegurar que la navegación ocurra después del frame actual
    Future.microtask(() {
      if (!mounted) return;
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => screen));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _buildBody());
  }

  Widget _buildBody() {
    switch (_status) {
      case _AuthCheckStatus.loading:
        return _loadingIndicator();
      case _AuthCheckStatus.error:
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  'Error: $_errorMessage',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _status = _AuthCheckStatus.loading;
                      _errorMessage = null;
                      _isNavigating = false;
                    });
                    _checkAuth();
                  },
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          ),
        );
    }
  }

  Widget _loadingIndicator() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Center(
      child: LoadingAnimationWidget.progressiveDots(
        color: isDark ? Colors.white : Colors.black,
        size: 40,
      ),
    );
  }
}
