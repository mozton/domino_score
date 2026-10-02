import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

/// Chip con el código de la partida en vivo.
///
/// Al tocarlo abre la vista en vivo y con el icono de copiar lo comparte.
class LiveCodeBadge extends StatelessWidget {
  final String code;

  /// Se llama al tocar el código (normalmente: abrir la vista en vivo).
  final VoidCallback? onTap;

  const LiveCodeBadge({super.key, required this.code, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFD4AF37).withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFFD4AF37).withValues(alpha: 0.6),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            borderRadius: const BorderRadius.horizontal(
              left: Radius.circular(10),
            ),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 6, 6, 6),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    TablerIcons.broadcast,
                    size: 15,
                    color: Color(0xFFB8912B),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    code,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Poppins',
                      letterSpacing: 1.4,
                      color: Color(0xFF8A6D1F),
                    ),
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            borderRadius: const BorderRadius.horizontal(
              right: Radius.circular(10),
            ),
            onTap: () async {
              await Clipboard.setData(ClipboardData(text: code));
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Código $code copiado')),
              );
            },
            child: const Padding(
              padding: EdgeInsets.fromLTRB(2, 6, 9, 6),
              child: Icon(
                TablerIcons.copy,
                size: 14,
                color: Color(0xFFB8912B),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
