import 'package:dominos_score/data/local/database_helper.dart';

import 'package:dominos_score/domain/repositories/auth_repository.dart';
import 'package:dominos_score/presentation/router/route_names.dart';
import 'package:dominos_score/presentation/viewmodel/game_viewmodel.dart';
import 'package:dominos_score/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dominos_score/presentation/viewmodel/setting_viewmodel.dart';

class SettingsPopup extends StatelessWidget {
  final GlobalKey settingsKey;

  const SettingsPopup({super.key, required this.settingsKey});

  @override
  Widget build(BuildContext context) {
    return _buildPopup(context);
  }

  static void show(BuildContext context, GlobalKey settingsKey) {
    final Offset btnPos = context.read<SettingViewModel>().getButtonPosition(
      settingsKey,
    );

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

  // COMPONENTS

  Widget _buildPopup(BuildContext context) {
    final width = MediaQuery.of(context).size.width * (244 / 393);
    final height = MediaQuery.of(context).size.height * (183 / 851);
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

          Consumer<SettingViewModel>(
            builder: (context, vm, _) {
              String themeTitle;
              String iconAsset;
              Color color;
              Color colorIcon;
              switch (vm.themeMode) {
                case ThemeMode.system:
                  themeTitle = 'Modo Sistema';
                  iconAsset = 'assets/icon/sun-moon.png';
                  color = Color(0xFF6B7280);
                  colorIcon = Color(0xFF6B7280);
                  break;
                case ThemeMode.light:
                  themeTitle = 'Modo Claro';
                  iconAsset = 'assets/icon/sun-high.png';
                  color = Color(0xFF6B7280);
                  colorIcon = Color(0xFF6B7280);
                  break;
                case ThemeMode.dark:
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
                () => vm.cycleTheme(),
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
              Provider.of<GameViewmodel>(context, listen: false).loadGames();

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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Divider(height: 20, color: Color(0xFFE5E7EB)),
          ),

          // _component(
          //   context,
          //   'Configuración de cuenta',
          //   'assets/icon/user-cog.png',
          //   () {},
          //   Color(0xFF6B7280),
          //   Color(0xFF6B7280),
          //   false,
          // ),
          _component(
            context,
            'Sign Out',
            'assets/icon/logout-2.png',
            () async {
              final authRepository = Provider.of<AuthRepository>(
                context,
                listen: false,
              );

              await DatabaseHelper().close();
              await authRepository.signOut();
              if (context.mounted) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  RouteNames.checking,
                  (route) => false,
                );
              }
            },
            Color(0xFFEF4444),
            Color(0xFFEF4444),
            false,
          ),
        ],
      ),
    );
  }

  // COMPONENTE INDIVIDUAL

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
              // Ícono
              Image(
                image: AssetImage(iconAsset),
                height: 20,
                width: 20,
                color: colorIcon,
              ),

              const SizedBox(width: 5),

              // Texto expandible con "..."
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

              // Punto opcional
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
