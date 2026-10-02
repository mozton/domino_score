import 'package:dominos_score/features/groups/domain/entities/group_entity.dart';
import 'package:flutter/material.dart';

class GroupCard extends StatelessWidget {
  final Group group;
  final bool isOwner;
  final VoidCallback onTap;

  const GroupCard({
    super.key,
    required this.group,
    required this.onTap,
    this.isOwner = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width * .9,
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF0F1822) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark
                ? const Color(0xFF2A323C)
                : (isOwner ? Colors.black12 : Colors.transparent),
            width: isOwner ? 1 : 0,
          ),
          boxShadow: [
            if (!isDark)
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.035),
                blurRadius: 14,
                offset: const Offset(0, 5),
              ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    group.name,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'Poppins',
                      color: isDark ? Colors.white : const Color(0xFF26354A),
                      letterSpacing: -0.4,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    '#${group.joinCode}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Poppins',
                      color: Color(0xFF8A96A8),
                    ),
                  ),
                ),
              ],
            ),
            if (isOwner)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7E7AF),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Dueño',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'Poppins',
                      color: Color(0xFF8A6D1B),
                    ),
                  ),
                ),
              ),
            if (group.description != null && group.description!.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                group.description!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: 'Poppins',
                  color: isDark ? Colors.white60 : const Color(0xFF8A96A8),
                ),
              ),
            ],
            const SizedBox(height: 8),
            Row(
              children: [
                _stat(Icons.people_outline_rounded, '${group.membersCount} Miembros'),
                const SizedBox(width: 10),
                _stat(Icons.emoji_events_outlined, '${group.gamesCount} Partidas'),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              height: 1,
              color: isDark ? const Color(0xFF2A323C) : const Color(0xFFE9EDF2),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(
                  Icons.local_fire_department_rounded,
                  size: 15,
                  color: Color(0xFFF2A51A),
                ),
                const SizedBox(width: 5),
                const Text(
                  'Líder actual:',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Poppins',
                    color: Color(0xFF9AA5B5),
                  ),
                ),
                const SizedBox(width: 7),
                Expanded(
                  child: Text(
                    group.currentLeaderName ?? 'Sin asignar',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'Poppins',
                      color: isDark ? Colors.white : const Color(0xFF26354A),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _stat(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F4F8),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: const Color(0xFF627187)),
          const SizedBox(width: 7),
          Text(
            text,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              fontFamily: 'Poppins',
              color: Color(0xFF59687D),
            ),
          ),
        ],
      ),
    );
  }
}
