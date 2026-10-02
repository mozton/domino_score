import 'package:dominos_score/features/profiles/domain/entities/achievement_entity.dart';
import 'package:dominos_score/features/profiles/presentation/pages/title_medals_tile.dart';
import 'package:dominos_score/features/profiles/presentation/widgets/achievement_visuals.dart';
import 'package:flutter/material.dart';

class TitulosYMedallasModal extends StatelessWidget {
  final String nombreJugador;
  final List<Achievement> achievements;

  const TitulosYMedallasModal({
    super.key,
    required this.nombreJugador,
    required this.achievements,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.0)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Barra de arrastre superior
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Encabezado: Título y Botón Cerrar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Títulos y Medallas',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Logros y honores de $nombreJugador',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
              CircleAvatar(
                radius: 16,
                backgroundColor: Colors.grey.shade100,
                child: IconButton(
                  icon: const Icon(
                    Icons.close,
                    size: 18,
                    color: Colors.black54,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Divider(height: 1, color: Colors.grey.shade200),
          const SizedBox(height: 12),

          // Lista de Medallas
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                children: achievements.isEmpty
                    ? [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 32),
                          child: Text(
                            'Todavía no hay medallas disponibles.',
                            style: TextStyle(color: Colors.grey.shade500),
                          ),
                        ),
                      ]
                    : achievements.map(_buildCard).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(Achievement achievement) {
    final visual = visualForAchievement(achievement.icon);
    return TitleAndMedalsCard(
      icon: visual.icon,
      iconBgColor: visual.background,
      iconColor: visual.foreground,
      titulo: achievement.title,
      descripcion: achievement.description,
      obtenida: achievement.obtained,
      progresoTexto: achievement.progressText,
    );
  }
}
