import 'package:dominos_score/features/groups/domain/entities/group_member_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

/// Jugadores elegidos para un equipo.
class TeamPlayersResult {
  final String? player1;
  final String? player2;

  const TeamPlayersResult({this.player1, this.player2});
}

/// Elige los jugadores de un equipo entre los miembros del grupo o como
/// invitado con nombre propio.
///
/// Solo devuelve el resultado; quien lo abre se encarga de guardarlo.
class TeamPlayersDialog extends StatefulWidget {
  final String teamName;
  final bool isTeams;
  final String? player1;
  final String? player2;
  final List<GroupMember> members;

  const TeamPlayersDialog({
    super.key,
    required this.teamName,
    required this.isTeams,
    required this.members,
    this.player1,
    this.player2,
  });

  @override
  State<TeamPlayersDialog> createState() => _TeamPlayersDialogState();
}

class _TeamPlayersDialogState extends State<TeamPlayersDialog> {
  String? _player1;
  String? _player2;

  @override
  void initState() {
    super.initState();
    _player1 = widget.player1;
    _player2 = widget.player2;
  }

  Future<void> _pick({required bool first}) async {
    final chosen = await showPlayerPickerSheet(
      context,
      members: widget.members,
      current: first ? _player1 : _player2,
    );
    if (chosen == null || !mounted) return;
    setState(() {
      if (first) {
        _player1 = chosen;
      } else {
        _player2 = chosen;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      backgroundColor: isDark ? const Color(0xFF0F1822) : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 14),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.isTeams ? 'Jugadores del equipo' : 'Jugador',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: isDark ? Colors.white : const Color(0xFF1E2B43),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    TablerIcons.x,
                    color: isDark ? Colors.white70 : Colors.black45,
                  ),
                ),
              ],
            ),
            Text(
              widget.teamName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                color: isDark ? Colors.white54 : Colors.black45,
              ),
            ),
            const SizedBox(height: 14),
            _slot(
              context,
              label: widget.isTeams ? 'Jugador 1' : 'Jugador',
              value: _player1,
              onTap: () => _pick(first: true),
            ),
            if (widget.isTeams) ...[
              const SizedBox(height: 10),
              _slot(
                context,
                label: 'Jugador 2',
                value: _player2,
                onTap: () => _pick(first: false),
              ),
            ],
            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Cancelar',
                    style: TextStyle(fontFamily: 'Poppins'),
                  ),
                ),
                const SizedBox(width: 6),
                ElevatedButton(
                  onPressed: () => Navigator.pop(
                    context,
                    TeamPlayersResult(
                      player1: _player1,
                      player2: _player2,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD4AF37),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'Guardar',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
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

  Widget _slot(
    BuildContext context, {
    required String label,
    required String? value,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hasValue = value != null && value.trim().isNotEmpty;

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF16222E) : const Color(0xFFF5F7FA),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: hasValue
                ? const Color(0xFFD4AF37).withValues(alpha: 0.6)
                : Colors.transparent,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 11,
                      color: isDark ? Colors.white38 : Colors.black38,
                    ),
                  ),
                  Text(
                    hasValue ? value : 'Elegir jugador',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: hasValue
                          ? (isDark ? Colors.white : const Color(0xFF1E2B43))
                          : (isDark ? Colors.white38 : Colors.black38),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              TablerIcons.users_plus,
              size: 18,
              color: isDark ? Colors.white54 : Colors.black38,
            ),
          ],
        ),
      ),
    );
  }
}

/// Hoja para elegir un jugador: un miembro del grupo o un invitado con nombre.
///
/// Devuelve el nombre elegido, o `null` si se cierra sin elegir.
Future<String?> showPlayerPickerSheet(
  BuildContext context, {
  required List<GroupMember> members,
  String? current,
}) {
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _PlayerPickerSheet(members: members, current: current),
  );
}

class _PlayerPickerSheet extends StatefulWidget {
  final List<GroupMember> members;
  final String? current;

  const _PlayerPickerSheet({required this.members, this.current});

  @override
  State<_PlayerPickerSheet> createState() => _PlayerPickerSheetState();
}

class _PlayerPickerSheetState extends State<_PlayerPickerSheet> {
  late final TextEditingController _guestController;

  @override
  void initState() {
    super.initState();
    _guestController = TextEditingController();
  }

  @override
  void dispose() {
    _guestController.dispose();
    super.dispose();
  }

  void _useGuest() {
    final name = _guestController.text.trim();
    if (name.isEmpty) return;
    Navigator.pop(context, name);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final members = widget.members;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.75,
        ),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF0F1822) : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 6),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '¿Quién juega?',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: isDark ? Colors.white : const Color(0xFF1E2B43),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      TablerIcons.x,
                      color: isDark ? Colors.white70 : Colors.black45,
                    ),
                  ),
                ],
              ),
            ),

            // Invitado que no está en el grupo: se escribe su nombre.
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _guestController,
                      textCapitalization: TextCapitalization.words,
                      maxLength: 24,
                      onSubmitted: (_) => _useGuest(),
                      decoration: InputDecoration(
                        isDense: true,
                        counterText: '',
                        hintText: 'Nombre del invitado',
                        prefixIcon: const Icon(TablerIcons.user_plus, size: 18),
                        filled: true,
                        fillColor: isDark
                            ? const Color(0xFF16222E)
                            : const Color(0xFFF5F7FA),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _useGuest,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD4AF37),
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Usar',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            if (members.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 6),
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(color: Colors.grey.shade300),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        'o elige un miembro del grupo',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 11,
                          color: isDark ? Colors.white38 : Colors.black38,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(color: Colors.grey.shade300),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(bottom: 20),
                  itemCount: members.length,
                  itemBuilder: (context, index) {
                    final member = members[index];
                    final selected = widget.current != null &&
                        widget.current!.toLowerCase() ==
                            member.displayName.toLowerCase();

                    return ListTile(
                      onTap: () => Navigator.pop(context, member.displayName),
                      leading: CircleAvatar(
                        backgroundColor: const Color(
                          0xFFD4AF37,
                        ).withValues(alpha: 0.25),
                        child: Text(
                          member.initials,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                            color: Color(0xFF8A6D1F),
                          ),
                        ),
                      ),
                      title: Text(
                        member.displayName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: isDark
                              ? Colors.white
                              : const Color(0xFF1E2B43),
                        ),
                      ),
                      subtitle: member.isGuest
                          ? Text(
                              'Invitado',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 11,
                                color: isDark
                                    ? Colors.white38
                                    : Colors.black38,
                              ),
                            )
                          : null,
                      trailing: selected
                          ? const Icon(
                              TablerIcons.check,
                              color: Color(0xFF16A34A),
                              size: 20,
                            )
                          : null,
                    );
                  },
                ),
              ),
            ] else
              const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
