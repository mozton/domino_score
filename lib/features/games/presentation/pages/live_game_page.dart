import 'package:dominos_score/core/di/injection.dart';
import 'package:dominos_score/features/games/domain/entities/game_entity.dart';
import 'package:dominos_score/features/games/domain/entities/live_game_entity.dart';
import 'package:dominos_score/features/games/domain/entities/round_entity.dart';
import 'package:dominos_score/features/games/presentation/bloc/live_game_bloc.dart';
import 'package:dominos_score/features/games/presentation/widgets/team_palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

/// Partida en vivo: cualquier persona con el código puede seguir el marcador.
///
/// Si se abre desde una partida propia, [initialCode] llega con el código ya
/// cargado; si no, se pide escribirlo a mano.
class LiveGameScreen extends StatelessWidget {
  final String? initialCode;

  const LiveGameScreen({super.key, this.initialCode});

  @override
  Widget build(BuildContext context) {
    final code = initialCode?.trim() ?? '';

    return BlocProvider<LiveGameBloc>(
      create: (_) {
        final bloc = getIt<LiveGameBloc>();
        if (code.isNotEmpty) {
          bloc.add(LiveGameWatched(code: code));
        } else {
          // Sin código: se intenta reabrir la última partida que se vio.
          bloc.add(const LiveGameRestored());
        }
        return bloc;
      },
      child: _LiveGameView(initialCode: code),
    );
  }
}

class _LiveGameView extends StatefulWidget {
  /// Código con el que se abrió la pantalla (si se abrió desde una partida).
  final String initialCode;

  const _LiveGameView({required this.initialCode});

  @override
  State<_LiveGameView> createState() => _LiveGameViewState();
}

class _LiveGameViewState extends State<_LiveGameView> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialCode);
  }

  @override
  void dispose() {
    // El BLoC cancela el refresco automático al cerrarse (BlocProvider.close),
    // así que aquí solo se libera el controlador del campo de texto.
    _controller.dispose();
    super.dispose();
  }

  void _search() {
    FocusScope.of(context).unfocus();
    context.read<LiveGameBloc>().add(
      LiveGameWatched(code: _controller.text),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: MediaQuery.of(context).size.height * 0.099,
        backgroundColor: isDark
            ? const Color(0x00000000)
            : const Color(0xFFE4E9F2),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(TablerIcons.arrow_back),
        ),
        automaticallyImplyLeading: false,
        title: Text(
          'Partida en vivo',
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.height * (16 / 852),
            fontWeight: FontWeight.w700,
            fontFamily: 'Poppins',
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        actions: [
          BlocBuilder<LiveGameBloc, LiveGameState>(
            builder: (context, state) {
              if (state.status != LiveGameStatus.loaded) {
                return const SizedBox.shrink();
              }
              return IconButton(
                tooltip: 'Actualizar',
                onPressed: () => context.read<LiveGameBloc>().add(
                  const LiveGameRefreshed(),
                ),
                icon: const Icon(TablerIcons.refresh),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // El campo se rellena solo con el último código visto.
          BlocListener<LiveGameBloc, LiveGameState>(
            listenWhen: (previous, current) => previous.code != current.code,
            listener: (context, state) {
              final code = state.code;
              if (code != null &&
                  code.isNotEmpty &&
                  _controller.text.trim().isEmpty) {
                _controller.text = code;
              }
            },
            child: _codeField(isDark),
          ),
          Expanded(
            child: BlocBuilder<LiveGameBloc, LiveGameState>(
              builder: (context, state) {
                switch (state.status) {
                  case LiveGameStatus.idle:
                  case LiveGameStatus.loading:
                    return _centered(
                      state.status == LiveGameStatus.loading
                          ? LoadingAnimationWidget.progressiveDots(
                              color: isDark ? Colors.white : Colors.black,
                              size: 40,
                            )
                          : _hint(
                              state.errorMessage ??
                                  'Escribe el código que te compartió '
                                      'el anfitrión.',
                              isDark,
                            ),
                    );
                  case LiveGameStatus.notFound:
                  case LiveGameStatus.error:
                    return _centered(
                      _hint(
                        state.errorMessage ?? 'No se pudo cargar la partida.',
                        isDark,
                        isError: true,
                      ),
                    );
                  case LiveGameStatus.loaded:
                    return _LiveContent(
                      liveGame: state.liveGame!,
                      lastUpdate: state.lastUpdate,
                      onRefresh: () async {
                        context.read<LiveGameBloc>().add(
                          const LiveGameRefreshed(),
                        );
                      },
                    );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _centered(Widget child) => Center(child: child);

  Widget _hint(String message, bool isDark, {bool isError = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isError ? TablerIcons.alert_triangle : TablerIcons.broadcast,
            size: 42,
            color: isError
                ? Colors.redAccent
                : (isDark ? Colors.white38 : Colors.black26),
          ),
          const SizedBox(height: 12),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              fontFamily: 'Poppins',
              color: isError
                  ? Colors.redAccent
                  : (isDark ? Colors.white70 : Colors.black54),
            ),
          ),
        ],
      ),
    );
  }

  Widget _codeField(bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              textCapitalization: TextCapitalization.characters,
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => _search(),
              inputFormatters: [
                LengthLimitingTextInputFormatter(8),
                UpperCaseTextFormatter(),
              ],
              decoration: InputDecoration(
                isDense: true,
                hintText: 'Código de la partida',
                prefixIcon: const Icon(TablerIcons.hash, size: 18),
                filled: true,
                fillColor: isDark
                    ? const Color(0xFF0F1822)
                    : Colors.white.withValues(alpha: 0.9),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: isDark
                        ? const Color(0xFF22303F)
                        : const Color(0xFFDADDE2),
                  ),
                ),
              ),
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
                letterSpacing: 2,
              ),
            ),
          ),
          const SizedBox(width: 10),
          ElevatedButton(
            onPressed: _search,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD4AF37),
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Ver',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Convierte lo que se escribe a mayúsculas (los códigos van en mayúsculas).
class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return newValue.copyWith(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

class _LiveContent extends StatelessWidget {
  final LiveGame liveGame;
  final DateTime? lastUpdate;
  final Future<void> Function() onRefresh;

  const _LiveContent({
    required this.liveGame,
    required this.lastUpdate,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final game = liveGame.game;
    final teams = game.teams;
    final winner = game.winnerTeamName;

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
        children: [
          _header(context, isDark),
          const SizedBox(height: 12),
          if (winner != null && winner.isNotEmpty)
            _winnerBanner(winner, isDark)
          else
            const SizedBox.shrink(),
          if (winner != null && winner.isNotEmpty) const SizedBox(height: 12),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 10,
            runSpacing: 12,
            children: [
              for (var i = 0; i < teams.length; i++)
                _teamCard(context, i, teams[i].name, teams[i].totalScore,
                    teams[i].player1, teams[i].player2, isDark),
            ],
          ),
          const SizedBox(height: 18),
          _roundsTable(context, game, isDark),
        ],
      ),
    );
  }

  Widget _header(BuildContext context, bool isDark) {
    final code = liveGame.code;
    final updated = lastUpdate ?? liveGame.updatedAt;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                liveGame.groupName.isEmpty ? 'Grupo' : liveGame.groupName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Poppins',
                  color: isDark ? Colors.white : const Color(0xFF1E2B43),
                ),
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Color(0xFF16A34A),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'EN VIVO · ${_formatTime(updated)}',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',
                      letterSpacing: 0.6,
                      color: isDark ? Colors.white54 : Colors.black45,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () async {
            await Clipboard.setData(ClipboardData(text: code));
            if (!context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Código $code copiado')),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                const Icon(
                  TablerIcons.hash,
                  size: 15,
                  color: Color(0xFFB8912B),
                ),
                const SizedBox(width: 4),
                Text(
                  code,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Poppins',
                    letterSpacing: 1.5,
                    color: Color(0xFF8A6D1F),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _winnerBanner(String winner, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF16A34A).withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF16A34A).withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        children: [
          const Icon(TablerIcons.trophy, color: Color(0xFF16A34A), size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '¡Ganó $winner!',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                fontFamily: 'Poppins',
                color: isDark ? Colors.white : const Color(0xFF14532D),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _teamCard(
    BuildContext context,
    int index,
    String name,
    int points,
    String? player1,
    String? player2,
    bool isDark,
  ) {
    final players = [player1, player2]
        .where((p) => p != null && p.trim().isNotEmpty)
        .join(' · ');

    return Container(
      width: MediaQuery.of(context).size.width * 0.43,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF0F1822)
            : TeamPalette.card(index),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: TeamPalette.button(index).withValues(alpha: 0.45),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1F000000),
            offset: Offset(2, 3),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            '$points',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              fontFamily: 'Poppins',
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              fontFamily: 'Poppins',
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          if (players.isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(
              players,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                fontFamily: 'Poppins',
                color: isDark ? Colors.white54 : Colors.black45,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _roundsTable(BuildContext context, Game game, bool isDark) {
    final rounds = game.rounds;
    final teamNames = game.teams.map((t) => t.name).toList();

    final header = TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w700,
      fontFamily: 'Poppins',
      color: isDark ? Colors.white : const Color(0xFF1E2B43),
    );
    final cell = TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      fontFamily: 'Poppins',
      color: isDark ? Colors.white70 : Colors.black54,
    );

    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF0F1822).withValues(alpha: 0.7)
            : Colors.white.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? const Color(0xFF22303F) : const Color(0xFFDADDE2),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: 52,
                child: Text(
                  'Ronda',
                  textAlign: TextAlign.center,
                  style: header,
                ),
              ),
              ...teamNames.map(
                (name) => Expanded(
                  child: Text(
                    name,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: header,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          if (rounds.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 18),
              child: Text(
                'Todavía no hay rondas',
                style: cell.copyWith(color: Colors.black38),
              ),
            )
          else
            ...rounds.reversed.map(
              (round) => _roundRow(round, teamNames, cell, isDark),
            ),
        ],
      ),
    );
  }

  Widget _roundRow(
    Round round,
    List<String> teamNames,
    TextStyle cell,
    bool isDark,
  ) {
    final events = round.events;

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFF16222E)
                  : const Color(0xFFDADDE2).withValues(alpha: 0.55),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 52,
                  child: Text(
                    '${round.number}',
                    textAlign: TextAlign.center,
                    style: cell,
                  ),
                ),
                ...List.generate(teamNames.length, (i) {
                  final points = round.pointsFor(i);
                  return Expanded(
                    child: Text(
                      '$points',
                      textAlign: TextAlign.center,
                      style: cell.copyWith(
                        fontWeight: points > 0
                            ? FontWeight.w700
                            : FontWeight.w500,
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
          if (events.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 52, top: 4),
              child: Wrap(
                spacing: 6,
                runSpacing: 4,
                children: events.map((event) {
                  final team = event.teamIndex >= 0 &&
                          event.teamIndex < teamNames.length
                      ? teamNames[event.teamIndex]
                      : 'Equipo ${event.teamIndex + 1}';
                  final player = event.playerName;
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD4AF37).withValues(alpha: 0.16),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      player == null || player.isEmpty
                          ? '${event.type.label} · $team'
                          : '${event.type.label} · $player ($team)',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                        color: isDark
                            ? const Color(0xFFE8CE85)
                            : const Color(0xFF8A6D1F),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }

  static String _formatTime(DateTime date) {
    String two(int value) => value.toString().padLeft(2, '0');
    return '${two(date.hour)}:${two(date.minute)}:${two(date.second)}';
  }
}
