import 'package:dominos_score/core/di/injection.dart';
import 'package:dominos_score/features/auth/domain/entities/user_entity.dart';
import 'package:dominos_score/features/auth/domain/usecase/privacy_policy_usecases.dart';
import 'package:dominos_score/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:dominos_score/features/auth/presentation/pages/login_page.dart';
import 'package:dominos_score/features/games/data/database/database_manager.dart';
import 'package:dominos_score/features/games/presentation/pages/home_page.dart';
import 'package:dominos_score/presentation/router/route_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthBloc>().add(const AuthStatusChecked());
    });
  }

  Future<void> _afterAuth(User user) async {
    try {
      final databaseManager = getIt<DatabaseManager>();
      final dbExists = await databaseManager.databaseExists(user.id);
      if (!dbExists) {
        const storage = FlutterSecureStorage();
        await storage.delete(key: 'free_game_consumed');
        await storage.delete(key: 'privacy_policy_accepted');
      }

      final accepted = await getIt<IsPrivacyPolicyAcceptedUseCase>().call();
      if (!mounted) return;

      if (!accepted) {
        Future.microtask(() {
          if (!mounted) return;
          Navigator.pushNamedAndRemoveUntil(
            context,
            RouteNames.privacyPolicy,
            (route) => false,
          );
        });
        return;
      }

      await databaseManager.open(user.id);

      if (!mounted) return;
      _navigateTo(const HomeScreen());
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
    Future.microtask(() {
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => screen),
        (route) => false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.unauthenticated) {
          _navigateTo(const LoginScreen());
        } else if (state.status == AuthStatus.authenticated &&
            state.user != null) {
          _afterAuth(state.user!);
        } else if (state.status == AuthStatus.error) {
          setState(() {
            _status = _AuthCheckStatus.error;
            _errorMessage = state.errorMessage;
          });
        }
      },
      child: Scaffold(body: _buildBody()),
    );
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
                    context.read<AuthBloc>().add(const AuthStatusChecked());
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
