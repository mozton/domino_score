import 'package:dominos_score/features/games/domain/entities/round_action.dart';
import 'package:flutter/material.dart';

/// Popup de anotación con **metodología de juego**.
///
/// Los puntos se anotan igual que siempre (manual, +30 o cámara). Además se
/// pueden marcar acciones de la ronda (capicúa, pase redondo, trancao,
/// zapatero, pase individual) y, si el equipo tiene varios jugadores, quién la
/// hizo. Las acciones **no** modifican los puntos.
class AddScore extends StatefulWidget {
  final Color colorButton;
  final String teamName;
  final List<String> players;

  final void Function(
    int points,
    List<RoundActionType> actions,
    String? player,
  )
  onAddPoints;

  final void Function(List<RoundActionType> actions, String? player) onTapPass;

  final void Function(List<RoundActionType> actions, String? player) onCamera;

  const AddScore({
    super.key,
    required this.colorButton,
    required this.teamName,
    this.players = const [],
    required this.onAddPoints,
    required this.onTapPass,
    required this.onCamera,
  });

  @override
  State<AddScore> createState() => _AddScoreState();
}

class _AddScoreState extends State<AddScore> {
  final _controller = TextEditingController();
  final Set<RoundActionType> _actions = {};
  String? _player;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<RoundActionType> get _selectedActions => _actions.toList();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

    return Container(
      width: size.width * (340 / 393),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: isDark ? const Color(0xFF0F1822) : const Color(0xFFFFFFFF),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Equipo + cerrar
          Row(
            children: [
              Expanded(
                child: Text(
                  widget.teamName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: isDark ? Colors.white : const Color(0xFF1E2B43),
                  ),
                ),
              ),
              InkWell(
                onTap: () => Navigator.pop(context),
                child: Image(
                  height: 22,
                  color: isDark ? Colors.white : const Color(0XFF1C1400),
                  image: const AssetImage('assets/icon/square-rounded-x.png'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Puntos
          TextFormField(
            controller: _controller,
            maxLines: 1,
            keyboardType: const TextInputType.numberWithOptions(decimal: false),
            maxLength: 3,
            cursorColor: const Color(0xFFD9D9D9),
            decoration: InputDecoration(
              counterText: '',
              hintText: 'Agrega puntos',
              hintStyle: TextStyle(
                fontSize: size.height * (16 / 852),
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
                color: isDark
                    ? Colors.white.withValues(alpha: 0.3)
                    : const Color(0xFF1E2B43).withValues(alpha: 0.3),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  width: 1.5,
                  color: const Color(0xFFD9D9D9).withValues(alpha: 0.9),
                ),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  width: 1.5,
                  color: const Color(0xFFD9D9D9).withValues(alpha: 0.9),
                ),
              ),
            ),
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w700,
              fontSize: 36,
              color: isDark ? Colors.white : const Color(0xFF1E2B43),
            ),
          ),
          const SizedBox(height: 10),

          // Acciones de la metodología
          Text(
            'Acciones de la ronda',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white54 : Colors.black45,
            ),
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: RoundActionType.values
                .map((action) => _actionChip(action, isDark))
                .toList(),
          ),

          // Jugador (solo si el equipo tiene más de uno)
          if (widget.players.length > 1) ...[
            const SizedBox(height: 12),
            Text(
              '¿Quién la hizo?',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white54 : Colors.black45,
              ),
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: widget.players
                  .map((player) => _playerChip(player, isDark))
                  .toList(),
            ),
          ],

          const SizedBox(height: 16),

          // Botones: añadir puntos / +30 / cámara
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _ButtonSaveScore(
                colorButton: widget.colorButton,
                onTap: () {
                  final points = int.tryParse(_controller.text.trim()) ?? 0;
                  widget.onAddPoints(points, _selectedActions, _player);
                },
              ),
              _smallButton(
                size,
                () => widget.onTapPass(_selectedActions, _player),
                'assets/icon/rewind-forward-30.png',
                isDark,
              ),
              _smallButton(
                size,
                () => widget.onCamera(_selectedActions, _player),
                'assets/icon/camera.png',
                isDark,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _actionChip(RoundActionType action, bool isDark) {
    final selected = _actions.contains(action);
    return GestureDetector(
      onTap: () {
        setState(() {
          if (selected) {
            _actions.remove(action);
          } else {
            _actions.add(action);
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
        decoration: BoxDecoration(
          color: selected
              ? widget.colorButton.withValues(alpha: 0.15)
              : (isDark ? const Color(0xFF1A222D) : const Color(0xFFF1F5F9)),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? widget.colorButton : Colors.transparent,
            width: 1.2,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _iconFor(action),
              size: 13,
              color: selected
                  ? widget.colorButton
                  : (isDark ? Colors.white38 : Colors.black38),
            ),
            const SizedBox(width: 4),
            Text(
              action.label,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 11,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                color: isDark ? Colors.white : const Color(0xFF1E2B43),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _playerChip(String player, bool isDark) {
    final selected = _player == player;
    return GestureDetector(
      onTap: () {
        setState(() {
          _player = selected ? null : player;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFFD4AF37).withValues(alpha: 0.18)
              : (isDark ? const Color(0xFF1A222D) : const Color(0xFFF1F5F9)),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? const Color(0xFFD4AF37) : Colors.transparent,
            width: 1.2,
          ),
        ),
        child: Text(
          player,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 11,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            color: isDark ? Colors.white : const Color(0xFF1E2B43),
          ),
        ),
      ),
    );
  }

  IconData _iconFor(RoundActionType action) {
    switch (action) {
      case RoundActionType.capicua:
        return Icons.all_inclusive_rounded;
      case RoundActionType.paseRedondo:
        return Icons.rotate_right_rounded;
      case RoundActionType.trancao:
        return Icons.lock_outline_rounded;
      case RoundActionType.zapatero:
        return Icons.directions_run_rounded;
      case RoundActionType.paseIndividual:
        return Icons.directions_walk_rounded;
    }
  }

  SizedBox _smallButton(
    Size size,
    VoidCallback onTap,
    String iconAsset,
    bool isDark,
  ) {
    return SizedBox(
      height: size.height * (44 / 852),
      width: size.width * (70 / 393),
      child: ElevatedButton(
        onPressed: onTap,
        child: Image(
          fit: BoxFit.cover,
          color: isDark ? Colors.white : const Color(0xFF1E2B43),
          image: AssetImage(iconAsset),
        ),
      ),
    );
  }
}

class _ButtonSaveScore extends StatelessWidget {
  final Color colorButton;
  final VoidCallback onTap;

  const _ButtonSaveScore({required this.onTap, required this.colorButton});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height * (43 / 852),
      width: size.width * (139 / 393),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: colorButton,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          elevation: 4,
          shadowColor: const Color(0xFFD4AF37).withValues(alpha: 0.15),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/icon/plus.png',
              height: size.height * (20 / 852),
              width: size.width * (20 / 393),
              color: isDark
                  ? Colors.white
                  : colorButton == const Color(0xFFD4AF37)
                  ? const Color(0xFF000000)
                  : const Color(0xFFFFFFFF),
            ),
            Text(
              'Añadir puntos',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                fontSize: size.height * (13 / 852),
                color: isDark
                    ? Colors.white
                    : colorButton == const Color(0xFFD4AF37)
                    ? const Color(0xFF000000)
                    : const Color(0xFFFFFFFF),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
