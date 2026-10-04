import 'package:dominos_score/core/di/injection.dart';
import 'package:dominos_score/features/games/domain/entities/game_entity.dart';
import 'package:dominos_score/features/games/domain/entities/team_entity.dart';
import 'package:dominos_score/features/games/presentation/pages/home_page.dart';
import 'package:dominos_score/features/games/presentation/pages/live_game_page.dart';
import 'package:dominos_score/features/groups/domain/entities/group_entity.dart';
import 'package:dominos_score/features/groups/domain/entities/group_member_entity.dart';
import 'package:dominos_score/features/groups/presentation/bloc/group_bloc.dart';
import 'package:dominos_score/features/groups/presentation/widgets/edit_group_dialog.dart';
import 'package:dominos_score/features/profiles/domain/usecases/compute_achievements_usecase.dart';
import 'package:dominos_score/features/profiles/presentation/pages/player_profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GroupDetailScreen extends StatefulWidget {
  final String groupId;

  const GroupDetailScreen({super.key, required this.groupId});

  @override
  State<GroupDetailScreen> createState() => _GroupDetailScreenState();
}

class _GroupDetailScreenState extends State<GroupDetailScreen> {
  int _selectedTabIndex = 0; // 0: Tabla de Líderes, 1: Miembros

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final bloc = context.read<GroupBloc>();
      bloc.add(GroupDetailRequested(widget.groupId));
      bloc.add(GroupGamesLoadRequested(widget.groupId));
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GroupBloc, GroupState>(
      listenWhen: (previous, current) =>
          previous.errorMessage != current.errorMessage ||
          previous.successMessage != current.successMessage,
      listener: (context, state) {
        final message = state.errorMessage ?? state.successMessage;
        if (message == null || message.isEmpty) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: state.errorMessage != null
                ? Colors.redAccent
                : const Color(0xFF2E7D32),
          ),
        );
        context.read<GroupBloc>().add(const GroupMessagesCleared());
      },
      child: BlocBuilder<GroupBloc, GroupState>(
        builder: (context, state) {
          final detail = state.detail;

          if (detail == null) {
            return _buildLoadingOrError(state);
          }

          final group = detail.group;
          final members = _sortedMembers(detail.members);
          final activeGame = _activeGame(state.groupGames);

          return Scaffold(
            backgroundColor: const Color(0xFFF8FAFC),
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              scrolledUnderElevation: 0,
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundColor: const Color(0xFFF1F5F9),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black87),
                    onPressed: () => Navigator.of(context).maybePop(),
                  ),
                ),
              ),
              title: Text(
                group.name,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              centerTitle: true,
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundColor: const Color(0xFFF1F5F9),
                    child: IconButton(
                      icon: const Icon(
                        Icons.edit_outlined,
                        color: Colors.black87,
                      ),
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) =>
                              EditarGrupoDialog(detail: detail),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
                child: Column(
                  children: [
                    _buildHeaderCard(group.name, group.membersCount,
                        group.gamesCount, group.joinCode),
                    if (activeGame != null) ...[
                      const SizedBox(height: 16),
                      _buildActiveGameCard(group, activeGame),
                    ],
                    const SizedBox(height: 16),

                    // Selector de pestañas dinámico
                    _buildTabSelector(members.length),
                    const SizedBox(height: 20),

                    // Contenido según la pestaña seleccionada
                    IndexedStack(
                      index: _selectedTabIndex,
                      children: [
                        // Pestaña 0: Tabla de Líderes + Podio
                        Column(
                          children: [
                            _buildPodium(members),
                            const SizedBox(height: 20),
                            _buildLeaderboardTable(members),
                          ],
                        ),

                        // Pestaña 1: Lista de Miembros
                        _buildMembersList(members, group.name),

                        // Pestaña 2: Historial de partidas del grupo
                        _buildHistoryTab(state),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () => _startGroupGame(group),
              backgroundColor: const Color(0xFFD97706),
              foregroundColor: Colors.white,
              icon: const Icon(Icons.casino_outlined),
              label: const Text(
                'Nueva Partida',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoadingOrError(GroupState state) {
    final isError = state.status == GroupStatus.error;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: const Color(0xFFF1F5F9),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black87),
              onPressed: () => Navigator.of(context).maybePop(),
            ),
          ),
        ),
      ),
      body: Center(
        child: isError
            ? Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.cloud_off_rounded,
                      size: 56,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      state.errorMessage ?? 'No se pudo cargar el grupo',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Color(0xFF475569)),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => context.read<GroupBloc>().add(
                        GroupDetailRequested(widget.groupId),
                      ),
                      child: const Text('Reintentar'),
                    ),
                  ],
                ),
              )
            : const CircularProgressIndicator(),
      ),
    );
  }

  List<GroupMember> _sortedMembers(List<GroupMember> members) {
    final sorted = [...members];
    sorted.sort((a, b) {
      final byWins = b.stats.wins.compareTo(a.stats.wins);
      if (byWins != 0) return byWins;
      return b.stats.totalPoints.compareTo(a.stats.totalPoints);
    });
    return sorted;
  }

  Color _colorFor(String seed) {
    const palette = [
      Color(0xFFFEF3C7),
      Color(0xFFDBEAFE),
      Color(0xFFFFEDD5),
      Color(0xFFEFE2FE),
      Color(0xFFF1F5F9),
      Color(0xFFDCFCE7),
    ];
    final hash = seed.codeUnits.fold<int>(0, (acc, c) => acc + c);
    return palette[hash % palette.length];
  }

  String _tagFor(GroupMember member) {
    final top = getIt<ComputeAchievementsUseCase>().topObtained(member.stats);
    return top != null ? '🏅 ${top.title}' : '🎲 Jugador';
  }

  void _openMemberProfile(GroupMember member, String groupName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PlayerProfileScreen(
          member: member,
          groupName: groupName,
        ),
      ),
    );
  }

  // --- CARD SUPERIOR ---
  Widget _buildHeaderCard(
    String name,
    int membersCount,
    int gamesCount,
    String joinCode,
  ) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: const Color(0xFFFDE68A),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.groups,
                  color: Colors.black87,
                  size: 28,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$membersCount miembros · $gamesCount partidas jugadas',
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: RichText(
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 13,
                      ),
                      children: [
                        const TextSpan(text: 'Código de mesa: '),
                        TextSpan(
                          text: '#$joinCode',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: joinCode));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Código copiado al portapapeles'),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.copy_outlined,
                    size: 16,
                    color: Colors.black87,
                  ),
                  label: const Text(
                    'Copiar',
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(50, 30),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- SELECTOR DE PESTAÑAS (ANIMADO) ---
  Widget _buildTabSelector(int memberCount) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFE2E8F0),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          _buildTabItem(
            index: 0,
            icon: Icons.emoji_events_outlined,
            label: 'Tabla de Líderes',
          ),
          _buildTabItem(
            index: 1,
            icon: Icons.account_circle_outlined,
            label: 'Miembros ($memberCount)',
          ),
          _buildTabItem(
            index: 2,
            icon: Icons.history_rounded,
            label: 'Historial',
          ),
        ],
      ),
    );
  }

  Widget _buildTabItem({
    required int index,
    required IconData icon,
    required String label,
  }) {
    final bool isSelected = _selectedTabIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTabIndex = index;
          });
        },
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isSelected
                ? const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ]
                : [],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16,
                color: isSelected ? Colors.black87 : Colors.grey.shade600,
              ),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                    color: isSelected ? Colors.black87 : Colors.grey.shade600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- PODIO (1, 2, 3) ---
  Widget _buildPodium(List<GroupMember> members) {
    if (members.isEmpty) {
      return const SizedBox.shrink();
    }

    GroupMember? at(int index) =>
        index < members.length ? members[index] : null;

    final first = at(0);
    final second = at(1);
    final third = at(2);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (second != null)
          _buildPodiumStep(
            member: second,
            rank: '2',
            height: 70,
            color: const Color(0xFFE2E8F0),
            isWinner: false,
          ),
        if (second != null) const SizedBox(width: 8),
        if (first != null)
          _buildPodiumStep(
            member: first,
            rank: '1',
            height: 100,
            color: const Color(0xFFFDE68A),
            isWinner: true,
          ),
        if (third != null) const SizedBox(width: 8),
        if (third != null)
          _buildPodiumStep(
            member: third,
            rank: '3',
            height: 55,
            color: const Color(0xFFE2E8F0),
            isWinner: false,
          ),
      ],
    );
  }

  Widget _buildPodiumStep({
    required GroupMember member,
    required String rank,
    required double height,
    required Color color,
    required bool isWinner,
  }) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: _colorFor(member.userId),
            child: Text(
              member.initials,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: isWinner ? const Color(0xFFD97706) : Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            member.nickname,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            '${member.stats.winRate.toStringAsFixed(0)}% Win',
            style: const TextStyle(color: Colors.grey, fontSize: 11),
          ),
          const SizedBox(height: 6),
          Container(
            height: height,
            width: double.infinity,
            decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
            ),
            child: Center(
              child: Text(
                rank,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- TABLA DE POSICIONES ---
  Widget _buildLeaderboardTable(List<GroupMember> members) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: Row(
              children: [
                SizedBox(
                  width: 30,
                  child: Text(
                    '#',
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'JUGADOR',
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ),
                SizedBox(
                  width: 60,
                  child: Text(
                    'VICTORIAS',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                ),
                SizedBox(
                  width: 60,
                  child: Text(
                    'DERROTAS',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          if (members.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Text(
                'Todavía no hay jugadores.',
                style: TextStyle(color: Colors.grey.shade500),
              ),
            )
          else
            ...members.asMap().entries.map((entry) {
              final rank = entry.key + 1;
              final member = entry.value;
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 4.0,
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 30,
                      child: CircleAvatar(
                        radius: 12,
                        backgroundColor: _colorFor(member.userId),
                        child: Text(
                          '$rank',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            member.nickname,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            _tagFor(member),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 60,
                      child: Text(
                        '${member.stats.wins}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 60,
                      child: Text(
                        '${member.stats.losses}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }

  // --- VISTA DE LISTA DE MIEMBROS ---
  Widget _buildMembersList(List<GroupMember> members, String groupName) {
    if (members.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Text(
          'Todavía no hay miembros.',
          style: TextStyle(color: Colors.grey.shade500),
        ),
      );
    }

    return Column(
      children: members.map((member) {
        return GestureDetector(
          onTap: () => _openMemberProfile(member, groupName),
          child: Container(
            margin: const EdgeInsets.only(bottom: 10.0),
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 14.0,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                // Avatar
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: _colorFor(member.userId),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    member.initials,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(width: 14),

                // Info Nombre + Apodo
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.black87,
                          ),
                          children: [
                            TextSpan(
                              text: member.displayName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const TextSpan(text: ' · '),
                            TextSpan(
                              text: member.nickname,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFC48B28),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${member.stats.gamesPlayed} partidas · ${member.stats.capicuas} capicúas',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade500,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                // Admin Tag
                if (member.isAdmin) ...[
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

                // Flecha navegación
                Icon(
                  Icons.chevron_right,
                  color: Colors.grey.shade400,
                  size: 22,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  // --- NUEVA PARTIDA / HISTORIAL DEL GRUPO ---

  /// ¿La partida ya tiene ganador?
  bool _isFinished(Game game) {
    if (game.winnerTeamName != null && game.winnerTeamName!.isNotEmpty) {
      return true;
    }
    final goal = game.pointsToWin;
    return goal > 0 && game.teams.any((t) => t.totalScore >= goal);
  }

  /// La partida que sigue en curso: la más reciente del grupo si todavía no
  /// tiene ganador.
  ///
  /// Se usa la última (y no una más vieja abandonada) porque es justo la que
  /// carga el marcador al entrar con [GameInitialized] en el mismo grupo.
  Game? _activeGame(List<Game> games) {
    if (games.isEmpty) return null;
    final last = games.last;
    return _isFinished(last) ? null : last;
  }

  Future<void> _openGroupGame(Group group, {required bool startNew}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => HomeScreen(
          groupId: group.id,
          groupName: group.name,
          startNew: startNew,
        ),
      ),
    );
    if (!mounted) return;
    final bloc = context.read<GroupBloc>();
    bloc.add(GroupGamesLoadRequested(group.id));
    bloc.add(GroupDetailRequested(group.id));
  }

  /// Sigue la partida que ya está en juego (mantiene su código en vivo).
  Future<void> _continueGroupGame(Group group) =>
      _openGroupGame(group, startNew: false);

  Future<void> _startGroupGame(Group group) =>
      _openGroupGame(group, startNew: true);

  /// Tarjeta con la partida en curso: continuar jugando o verla en vivo.
  Widget _buildActiveGameCard(Group group, Game game) {
    final code = game.liveCode;
    final scores = game.teams
        .map((team) => '${team.name} ${team.totalScore}')
        .join('   ·   ');

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFD97706).withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFD97706).withValues(alpha: 0.35),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.play_circle_fill_rounded,
                color: Color(0xFFD97706),
                size: 20,
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Partida en curso',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Color(0xFF92400E),
                  ),
                ),
              ),
              if (code != null && code.isNotEmpty) _buildLiveCodeChip(code),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            scores.isEmpty ? 'Todavía sin equipos' : scores,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _continueGroupGame(group),
                  icon: const Icon(Icons.play_arrow_rounded, size: 20),
                  label: const Text(
                    'Continuar partida',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD97706),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              if (code != null && code.isNotEmpty) ...[
                const SizedBox(width: 8),
                IconButton(
                  tooltip: 'Ver la partida en vivo',
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => LiveGameScreen(initialCode: code),
                    ),
                  ),
                  icon: const Icon(
                    Icons.sensors_rounded,
                    color: Color(0xFFD97706),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  /// Chip con el código en vivo; al tocarlo se copia para compartirlo.
  Widget _buildLiveCodeChip(String code) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () async {
        await Clipboard.setData(ClipboardData(text: code));
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Código $code copiado')),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: const Color(0xFFD97706).withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.sensors_rounded,
              size: 13,
              color: Color(0xFF92400E),
            ),
            const SizedBox(width: 5),
            Text(
              code,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                letterSpacing: 1.2,
                color: Color(0xFF92400E),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryTab(GroupState state) {
    if (state.isLoadingGames && state.groupGames.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 40),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    final games = state.groupGames;
    if (games.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Column(
          children: [
            Icon(
              Icons.history_rounded,
              size: 48,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 10),
            Text(
              'Este grupo todavía no tiene partidas.',
              style: TextStyle(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 4),
            Text(
              'Pulsa "Nueva Partida" para jugar.',
              style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
            ),
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Column(
        children: games.asMap().entries.map((entry) {
          return Column(
            children: [
              if (entry.key > 0)
                Divider(height: 1, color: Colors.grey.shade200),
              _buildGameTile(entry.value),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildGameTile(Game game) {
    final names = game.teams.map((t) => t.name).toList();
    final scores = game.teams.map((t) => t.totalScore).toList();
    final finished = _isFinished(game);
    final winner = _winnerOf(game);
    final code = game.liveCode;
    final hasCode = code != null && code.isNotEmpty;
    final players = _playersOf(game);

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => _openGameRounds(game),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    names.isEmpty ? 'Partida' : names.join(' vs '),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${scores.isEmpty ? '0' : scores.join(' - ')} • ${game.rounds.length} rondas',
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  if (players.isNotEmpty)
                    Text(
                      players.join(' · '),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.black45,
                        fontSize: 11,
                      ),
                    ),
                  if (!finished)
                    const Text(
                      'En curso',
                      style: TextStyle(
                        color: Color(0xFFD97706),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  if (winner != null)
                    Text(
                      'Ganó ${winner.name}',
                      style: const TextStyle(
                        color: Color(0xFF16A34A),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            if (hasCode) ...[
              // El código con el que se puede volver a ver esta partida.
              InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () => _copyLiveCode(code),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD97706).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '#$code',
                    style: const TextStyle(
                      color: Color(0xFF92400E),
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
            ],
            Text(
              _formatShortDate(game.createdAt),
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.chevron_right,
              color: Colors.grey.shade400,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  /// Equipo que alcanzó los puntos para ganar, si lo hay.
  Team? _winnerOf(Game game) {    final goal = game.pointsToWin;
    if (goal <= 0) return null;
    for (final team in game.teams) {
      if (team.totalScore >= goal) return team;
    }
    return null;
  }

  /// Jugadores de la partida (miembros del grupo o invitados).
  ///
  /// Se saltan los repetidos, los que son iguales al nombre del equipo (en
  /// individual el equipo se llama como el jugador) y los "Jugador N" que
  /// quedan por defecto cuando nadie los ha elegido.
  List<String> _playersOf(Game game) {
    final players = <String>[];
    for (final team in game.teams) {
      for (final player in [team.player1, team.player2]) {
        final name = player?.trim() ?? '';
        if (name.isEmpty || name == team.name) continue;
        if (name.startsWith('Jugador ')) continue;
        if (players.contains(name)) continue;
        players.add(name);
      }
    }
    return players;
  }

  Future<void> _copyLiveCode(String code) async {
    await Clipboard.setData(ClipboardData(text: code));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Código $code copiado')),
    );
  }

  String _formatShortDate(DateTime date) {
    const months = [
      'Ene',
      'Feb',
      'Mar',
      'Abr',
      'May',
      'Jun',
      'Jul',
      'Ago',
      'Sep',
      'Oct',
      'Nov',
      'Dic',
    ];
    return '${date.day} ${months[date.month - 1]}';
  }

  void _openGameRounds(Game game) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _GroupGameRoundsSheet(game: game),
    );
  }
}

/// Detalle (solo lectura) de las rondas de una partida del grupo.
class _GroupGameRoundsSheet extends StatelessWidget {
  final Game game;

  const _GroupGameRoundsSheet({required this.game});

  @override
  Widget build(BuildContext context) {
    final teams = game.teams;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
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
          const Text(
            'Detalle de la partida',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const SizedBox(
                width: 48,
                child: Text(
                  'Ronda',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                    color: Colors.grey,
                  ),
                ),
              ),
              ...teams.map(
                (t) => Expanded(
                  child: Text(
                    t.name,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const Divider(),
          if (game.rounds.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Text(
                'Sin rondas registradas.',
                style: TextStyle(color: Colors.grey),
              ),
            )
          else
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  children: game.rounds.reversed.map((round) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: 48,
                                child: Text(
                                  '${round.number}',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: 13),
                                ),
                              ),
                              ...List.generate(
                                teams.length,
                                (i) => Expanded(
                                  child: Text(
                                    '${round.pointsFor(i)}',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (round.events.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 2),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  round.events
                                      .map(
                                        (event) => event.playerName == null
                                            ? event.type.label
                                            : '${event.type.label} (${event.playerName})',
                                      )
                                      .join(' · '),
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
