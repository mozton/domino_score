import 'package:dominos_score/core/di/injection.dart';
import 'package:dominos_score/core/services/url_launcher_service.dart';
import 'package:dominos_score/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:dominos_score/features/games/data/database/database_manager.dart';
import 'package:dominos_score/features/games/presentation/bloc/game_bloc.dart';
import 'package:dominos_score/features/games/presentation/widgets/game_mode_dialog.dart';
import 'package:dominos_score/features/games/presentation/widgets/ui_helpers.dart';
import 'package:dominos_score/features/settings/domain/entities/theme_mode_option.dart';
import 'package:dominos_score/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:dominos_score/presentation/router/route_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsPopup extends StatelessWidget {
  final GlobalKey settingsKey;

  const SettingsPopup({super.key, required this.settingsKey});

  @override
  Widget build(BuildContext context) {
    return _buildPopup(context);
  }

  static void show(BuildContext context, GlobalKey settingsKey) {
    final RenderBox box =
        settingsKey.currentContext!.findRenderObject() as RenderBox;
    final Offset btnPos = box.localToGlobal(Offset.zero);

    final Size screenSize = MediaQuery.of(context).size;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withValues(alpha: 0.35),
      barrierLabel: '',
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (_, __, ___) {
        return Stack(
          children: [
            Positioned(
              top: btnPos.dy + 35,
              right: screenSize.width - btnPos.dx - 28,
              child: Material(
                color: isDark ? Colors.transparent : Colors.transparent,
                child: SettingsPopup(settingsKey: settingsKey),
              ),
            ),
          ],
        );
      },
      transitionBuilder: (_, anim, __, child) {
        final scale = Tween<double>(
          begin: 0.85,
          end: 1.0,
        ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOutBack));

        final fade = Tween<double>(
          begin: 0,
          end: 1,
        ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOut));

        return FadeTransition(
          opacity: fade,
          child: ScaleTransition(
            scale: scale,
            alignment: Alignment.topRight,
            child: child,
          ),
        );
      },
    );
  }

  Widget _buildPopup(BuildContext context) {
    final width = MediaQuery.of(context).size.width * (244 / 393);
    final height = MediaQuery.of(context).size.height * (360 / 851);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: isDark ? Color(0xFF0F1822) : Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          const SizedBox(height: 8),
          _component(
            context,
            'Mi cuenta',
            'assets/icon/user.png',
            () {
              Navigator.pop(context);
              Future.delayed(Duration.zero);
              Navigator.pushNamed(context, RouteNames.accountSettings);
            },
            const Color(0xFF6B7280),
            Color(0xFF6B7280),
            true,
          ),
          _component(
            context,
            'Mi perfil',
            'assets/icon/user-scan.png',
            () {
              Navigator.pop(context);
              Future.delayed(Duration.zero);
              Navigator.pushNamed(context, RouteNames.profile);
            },
            const Color(0xFF6B7280),
            Color(0xFF6B7280),
            true,
          ),
          BlocBuilder<SettingsBloc, SettingsState>(
            builder: (context, state) {
              String themeTitle;
              String iconAsset;
              Color color;
              Color colorIcon;
              switch (state.themeMode) {
                case ThemeModeOption.system:
                  themeTitle = 'Modo Sistema';
                  iconAsset = 'assets/icon/sun-moon.png';
                  color = Color(0xFF6B7280);
                  colorIcon = Color(0xFF6B7280);
                  break;
                case ThemeModeOption.light:
                  themeTitle = 'Modo Claro';
                  iconAsset = 'assets/icon/sun-high.png';
                  color = Color(0xFF6B7280);
                  colorIcon = Color(0xFF6B7280);
                  break;
                case ThemeModeOption.dark:
                  themeTitle = 'Modo Oscuro';
                  iconAsset = 'assets/icon/moon.png';
                  color = Color(0xFF6B7280);
                  colorIcon = Color(0xFFD4AF37);
                  break;
              }
              return _component(
                context,
                themeTitle,
                iconAsset,
                () => context.read<SettingsBloc>().add(
                  const SettingsThemeCycled(),
                ),
                color,
                colorIcon,
                true,
              );
            },
          ),
          _component(
            context,
            'Historial de partidas',
            'assets/icon/list.png',
            () {
              context.read<GameBloc>().add(const GamesLoaded());
              Navigator.pop(context);
              Future.delayed(Duration.zero);
              Navigator.pushNamed(context, RouteNames.historyDemo);
            },
            const Color(0xFF6B7280),
            Color(0xFF6B7280),
            true,
          ),
          _component(
            context,
            'Puntos por partida',
            'assets/icon/pencil-plus.png',
            () {
              Navigator.pop(context);
              Future.delayed(Duration.zero);
              UiHelpers.selectPointToWin(context);
            },
            const Color(0xFF6B7280),
            Color(0xFF6B7280),
            true,
          ),
          BlocBuilder<GameBloc, GameState>(
            builder: (context, gameState) {
              return _component(
                context,
                gameState.gameMode.label,
                'assets/icon/users-group.png',
                () async {
                  final bloc = context.read<GameBloc>();
                  final mode = await showGameModeDialog(
                    context,
                    gameState.gameMode,
                  );
                  if (mode != null) {
                    bloc.add(GameModeSelected(mode));
                  }
                  if (context.mounted) Navigator.pop(context);
                },
                const Color(0xFF6B7280),
                Color(0xFF6B7280),
                true,
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Divider(height: 20, color: Color(0xFFE5E7EB)),
          ),
          _component(
            context,
            'Acerca de la app',
            'assets/icon/info-circle.png',
            () {
              getIt<UrlLauncherService>().openInstagram();
            },
            Color(0xFF6B7280),
            Color(0xFF6B7280),
            false,
          ),
          _component(
            context,
            'Cerrar sesión',
            'assets/icon/logout-2.png',
            () async {
              await getIt<DatabaseManager>().close();
              if (!context.mounted) return;
              context.read<AuthBloc>().add(const SignOutRequested());
              Navigator.pushNamedAndRemoveUntil(
                context,
                RouteNames.checking,
                (route) => false,
              );
            },
            Color(0xFFEF4444),
            Color(0xFFEF4444),
            false,
          ),
        ],
      ),
    );
  }

  Widget _component(
    BuildContext context,
    String title,
    String iconAsset,
    VoidCallback onTap,
    Color colorFont,
    Color colorIcon,
    bool havePoint,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          height: MediaQuery.of(context).size.height * (36 / 851),
          width: MediaQuery.of(context).size.width * (220 / 393),
          padding: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
          child: Row(
            children: [
              Image(
                image: AssetImage(iconAsset),
                height: 20,
                width: 20,
                color: colorIcon,
              ),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Poppins',
                    color: colorFont,
                  ),
                ),
              ),
              SizedBox(width: 5),
              if (havePoint)
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: colorFont,
                    shape: BoxShape.circle,
                  ),
                ),
              const SizedBox(width: 5),
            ],
          ),
        ),
      ),
    );
  }
}
