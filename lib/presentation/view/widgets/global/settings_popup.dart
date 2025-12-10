import 'package:dominos_score/data/remote/remote_auth_data_source_impl.dart';
import 'package:dominos_score/domain/datasourse/remote_auth_data_source.dart';
import 'package:dominos_score/domain/repositories/auth_repository.dart';
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

  /// --------------------------------------------------------------------------
  /// 🔥 SHOW POPUP (CON ANIMACIÓN SCALE + FADE)
  /// --------------------------------------------------------------------------
  static void show(BuildContext context, GlobalKey settingsKey) {
    final Offset btnPos = context.read<SettingViewModel>().getButtonPosition(
      settingsKey,
    );

    final Size screenSize = MediaQuery.of(context).size;

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.35),
      barrierLabel: '',
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (_, __, ___) {
        return Stack(
          children: [
            Positioned(
              top: btnPos.dy + 35,
              right: screenSize.width - btnPos.dx - 28,
              child: Material(
                color: Colors.transparent,
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

  /// --------------------------------------------------------------------------
  /// 📌 POPUP UI
  /// --------------------------------------------------------------------------
  Widget _buildPopup(BuildContext context) {
    final width = MediaQuery.of(context).size.width * (234 / 393);
    final height = MediaQuery.of(context).size.height * (217 / 851);

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          const SizedBox(height: 8),

          _component(
            context,
            'Modo Sistema',
            'assets/icon/sun-moon.png',
            () {},
            const Color(0xFF6B7280),
            true,
          ),

          _component(
            context,
            'Historial de partidas',
            'assets/icon/list.png',
            () {},
            const Color(0xFF6B7280),
            true,
          ),

          _component(
            context,
            'Lenguage',
            'assets/icon/language.png',
            () {},
            const Color(0xFF6B7280),
            true,
          ),

          const SizedBox(height: 10),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Divider(height: 1.5, color: Color(0xFFE5E7EB)),
          ),

          _component(
            context,
            'Configuración de cuenta',
            'assets/icon/user-cog.png',
            () {},
            Colors.black,
            false,
          ),

          _component(
            context,
            'Sign Out',
            'assets/icon/logout-2.png',
            () {
              final authRepository = Provider.of<AuthRepository>(
                context,
                listen: false,
              );
              print('sign out');

              authRepository.signOut();
            },
            Colors.red,
            false,
          ),
        ],
      ),
    );
  }

  /// --------------------------------------------------------------------------
  /// COMPONENTE INDIVIDUAL
  /// --------------------------------------------------------------------------
  Widget _component(
    BuildContext context,
    String title,
    String iconAsset,
    VoidCallback onTap,
    Color colorFont,
    bool havePoint,
  ) {
    return Container(
      height: MediaQuery.of(context).size.height * (36 / 851),
      width: MediaQuery.of(context).size.width * (220 / 393),
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: ListTile(
        dense: true,
        contentPadding: EdgeInsets.zero,
        onTap: onTap,
        leading: Image(
          image: AssetImage(iconAsset),
          height: 20,
          width: 20,
          color: colorFont,
        ),
        title: Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            fontFamily: 'Poppins',
            color: colorFont,
          ),
        ),
        trailing: havePoint
            ? Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: colorFont,
                  shape: BoxShape.circle,
                ),
              )
            : const SizedBox.shrink(),
      ),
    );
  }
}
