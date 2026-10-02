import 'package:flutter/material.dart';

class TitleAndMedalsCard extends StatelessWidget {
  final IconData icon;
  final Color iconBgColor;
  final Color iconColor;
  final String titulo;
  final String descripcion;
  final bool obtenida;
  final String?
  progresoTexto; // Ej: "4 de 5 victorias" para cuando no está obtenida

  const TitleAndMedalsCard({
    super.key,
    required this.icon,
    required this.iconBgColor,
    required this.iconColor,
    required this.titulo,
    required this.descripcion,
    this.obtenida = true,
    this.progresoTexto,
  });

  @override
  Widget build(BuildContext context) {
    // Opacidad y colores según si está obtenida o bloqueada
    final Color titleColor = obtenida ? Colors.black87 : Colors.grey.shade500;
    final Color descriptionColor = obtenida
        ? Colors.black54
        : Colors.grey.shade400;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(color: Colors.grey.shade200, width: 1.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icono con fondo redondeado
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: obtenida ? iconBgColor : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(14.0),
            ),
            alignment: Alignment.center,
            child: Icon(
              icon,
              color: obtenida ? iconColor : Colors.grey.shade400,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),

          // Título, Descripción y Estado (Obtenida / Progreso)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        titulo,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: titleColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Badge "OBTENIDA" o Progreso ("4 de 5 victorias")
                    if (obtenida)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F5E9), // Verde suave
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'OBTENIDA',
                          style: TextStyle(
                            color: Color(0xFF2E7D32),
                            fontSize: 11,
                            // fontWeight: FontWeight.extrabold,
                            letterSpacing: 0.3,
                          ),
                        ),
                      )
                    else if (progresoTexto != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          progresoTexto!,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  descripcion,
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.3,
                    color: descriptionColor,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
