import 'package:flutter/material.dart';

class MiembroCard extends StatelessWidget {
  final String iniciales;
  final String nombre;
  final String apodo;
  final int partidas;
  final int capicuas;
  final bool isAdmin;
  final Color avatarColor;
  final VoidCallback? onTap;

  const MiembroCard({
    super.key,
    required this.iniciales,
    required this.nombre,
    required this.apodo,
    required this.partidas,
    required this.capicuas,
    this.isAdmin = false,
    required this.avatarColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(18.0),
        child: InkWell(
          borderRadius: BorderRadius.circular(18.0),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 14.0,
            ),
            child: Row(
              children: [
                // Avatar circular con iniciales
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: avatarColor,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    iniciales,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(width: 14),

                // Información del miembro
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nombre + Apodo
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.black87,
                          ),
                          children: [
                            TextSpan(
                              text: nombre,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const TextSpan(text: ' · '),
                            TextSpan(
                              text: apodo,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(
                                  0xFFC48B28,
                                ), // Color dorado/marrón del apodo
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),

                      // Partidas y capicúas
                      Text(
                        '$partidas partidas · $capicuas capicúas',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade500,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                // Badge de ADMIN (si aplica)
                if (isAdmin) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E2530),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'ADMIN',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],

                // Flecha a la derecha
                Icon(
                  Icons.chevron_right,
                  color: Colors.grey.shade400,
                  size: 22,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
