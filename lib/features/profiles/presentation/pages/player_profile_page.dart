import 'package:dominos_score/core/di/injection.dart';
import 'package:dominos_score/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:dominos_score/features/groups/domain/entities/group_member_entity.dart';
import 'package:dominos_score/features/groups/presentation/bloc/group_bloc.dart';
import 'package:dominos_score/features/profiles/domain/entities/achievement_entity.dart';
import 'package:dominos_score/features/profiles/domain/entities/match_summary_entity.dart';
import 'package:dominos_score/features/profiles/domain/entities/player_stats_entity.dart';
import 'package:dominos_score/features/profiles/domain/entities/profile_entity.dart';
import 'package:dominos_score/features/profiles/domain/usecases/compute_achievements_usecase.dart';
import 'package:dominos_score/features/profiles/presentation/bloc/profile_bloc.dart';
import 'package:dominos_score/features/profiles/presentation/pages/titulos_medallas_modal.dart';
import 'package:dominos_score/features/profiles/presentation/widgets/achievement_visuals.dart';
import 'package:dominos_score/features/profiles/presentation/widgets/edit_profile_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PlayerProfileScreen extends StatefulWidget {
  /// Si se pasa un miembro, se muestra el perfil de ese jugador. Si es `null`,
  /// se muestra el perfil del usuario autenticado.
  final GroupMember? member;
  final String? groupName;

  const PlayerProfileScreen({super.key, this.member, this.groupName});

  @override
  State<PlayerProfileScreen> createState() => _PlayerProfileScreenState();
}

class _PlayerProfileScreenState extends State<PlayerProfileScreen> {
  bool get _isMyProfile => widget.member == null;

  @override
  void initState() {
    super.initState();
    if (_isMyProfile) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final user = context.read<AuthBloc>().state.user;
        context.read<ProfileBloc>().add(
          ProfileLoadRequested(
            email: user?.email ?? '',
            displayName: user?.name ?? 'Usuario',
          ),
        );
        if (context.read<GroupBloc>().state.groups.isEmpty) {
          context.read<GroupBloc>().add(const GroupsLoadRequested());
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isMyProfile) {
      final member = widget.member!;
      final achievements = getIt<ComputeAchievementsUseCase>()(member.stats);
      return _buildProfileView(
        displayName: member.displayName,
        nickname: member.nickname,
        avatarUrl: member.avatarUrl,
        level: member.stats.level,
        groupName: widget.groupName,
        stats: member.stats,
        achievements: achievements,
        recentMatches: const [],
        onEdit: null,
      );
    }

    return BlocListener<ProfileBloc, ProfileState>(
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
        context.read<ProfileBloc>().add(const ProfileErrorCleared());
      },
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state.status == ProfileStatus.initial ||
              state.status == ProfileStatus.loading) {
            return const _ProfileLoading();
          }

          final profile = state.profile;
          if (profile == null) {
            return _ProfileError(
              message: state.errorMessage,
              onRetry: () {
                final user = context.read<AuthBloc>().state.user;
                context.read<ProfileBloc>().add(
                  ProfileLoadRequested(
                    email: user?.email ?? '',
                    displayName: user?.name ?? 'Usuario',
                  ),
                );
              },
            );
          }

          final groups = context.watch<GroupBloc>().state.groups;
          final groupName = widget.groupName ??
              (groups.isNotEmpty ? groups.first.name : null);

          return _buildProfileView(
            displayName: profile.displayName,
            nickname: profile.nickname,
            avatarUrl: profile.avatarUrl,
            level: state.stats.level,
            groupName: groupName,
            stats: state.stats,
            achievements: state.achievements,
            recentMatches: state.recentMatches,
            onEdit: () => _openEdit(profile),
          );
        },
      ),
    );
  }

  Future<void> _openEdit(Profile profile) async {
    final result = await showEditProfileSheet(context, profile);
    if (result == null || !mounted) return;
    context.read<ProfileBloc>().add(
      ProfileSaved(
        displayName: result.displayName,
        nickname: result.nickname,
        avatarUrl: result.avatarUrl,
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // VISTA
  // ---------------------------------------------------------------------------

  Widget _buildProfileView({
    required String displayName,
    required String nickname,
    required String? avatarUrl,
    required int level,
    required String? groupName,
    required PlayerStats stats,
    required List<Achievement> achievements,
    required List<MatchSummary> recentMatches,
    required VoidCallback? onEdit,
  }) {
    const backgroundColor = Color(0xFFA5F8FC);
    final obtained = achievements.where((a) => a.obtained).toList();

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.arrow_back,
              color: Colors.black87,
              size: 20,
            ),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Perfil de Jugador',
          style: TextStyle(
            color: Color(0xFF1E293B),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: [
          if (onEdit != null)
            IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.edit_outlined,
                  color: Colors.black87,
                  size: 20,
                ),
              ),
              onPressed: onEdit,
            ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // --- HEADER DEL JUGADOR ---
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                _ProfileAvatar(
                  name: displayName,
                  avatarUrl: avatarUrl,
                  radius: 40,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'LVL $level',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              displayName,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    '"$nickname"',
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFFD97706),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (groupName != null && groupName.isNotEmpty)
                  Flexible(
                    child: Text(
                      ' • $groupName',
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Color(0xFF64748B)),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),

            // Badges / Insignias
            if (obtained.isEmpty)
              _buildBadge(
                icon: Icons.emoji_events_outlined,
                label: 'Sin medallas aún',
                backgroundColor: const Color(0xFFF1F5F9),
                textColor: const Color(0xFF64748B),
              )
            else
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 8,
                runSpacing: 8,
                children: obtained
                    .take(2)
                    .map(
                      (a) => _buildBadge(
                        icon: visualForAchievement(a.icon).icon,
                        label: a.title,
                        backgroundColor:
                            visualForAchievement(a.icon).background,
                        textColor: visualForAchievement(a.icon).foreground,
                        onTap: () =>
                            _openMedals(displayName, achievements),
                      ),
                    )
                    .toList(),
              ),
            const SizedBox(height: 28),

            // --- ESTADÍSTICAS ---
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'ESTADÍSTICAS EN EL CORILLO',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF64748B),
                  letterSpacing: 0.8,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  _buildStatRow(
                    icon: Icons.pie_chart_outline,
                    label: 'Win Rate',
                    value: '${stats.winRate.toStringAsFixed(0)}%',
                    valueColor: const Color(0xFF0F172A),
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  _buildStatRow(
                    icon: Icons.emoji_events_outlined,
                    label: 'Victorias / Derrotas',
                    value: '${stats.wins} - ${stats.losses}',
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  _buildStatRow(
                    icon: Icons.all_inclusive,
                    label: 'Capicúas',
                    value: '${stats.capicuas}',
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  _buildStatRow(
                    icon: Icons.directions_run,
                    label: 'Zapateros (Blanqueadas)',
                    value: '${stats.zapateros}',
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  _buildStatRow(
                    icon: Icons.sports_esports_outlined,
                    label: 'Partidas registradas',
                    value: '${stats.gamesPlayed}',
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  _buildStatRow(
                    icon: Icons.stars_outlined,
                    label: 'Puntos anotados',
                    value: '${stats.totalPoints}',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // --- TÍTULOS Y MEDALLAS DE HONOR ---
            GestureDetector(
              onTap: () => _openMedals(displayName, achievements),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF3C7),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.military_tech,
                        color: Color(0xFFD97706),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Títulos y Medallas de Honor',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${obtained.length} de ${achievements.length} obtenidas • Ver vitrina completa',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right,
                      color: Color(0xFF94A3B8),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // --- ÚLTIMAS PARTIDAS ---
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'ÚLTIMAS PARTIDAS',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF64748B),
                  letterSpacing: 0.8,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: recentMatches.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.symmetric(vertical: 28),
                      child: Center(
                        child: Text(
                          'Todavía no hay partidas registradas.',
                          style: TextStyle(color: Color(0xFF94A3B8)),
                        ),
                      ),
                    )
                  : Column(
                      children: [
                        for (var i = 0; i < recentMatches.length; i++) ...[
                          if (i > 0)
                            const Divider(
                              height: 1,
                              indent: 16,
                              endIndent: 16,
                            ),
                          _buildMatchRow(recentMatches[i]),
                        ],
                      ],
                    ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _openMedals(String displayName, List<Achievement> achievements) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => TitulosYMedallasModal(
        nombreJugador: displayName,
        achievements: achievements,
      ),
    );
  }

  Widget _buildBadge({
    required IconData icon,
    required String label,
    required Color backgroundColor,
    required Color textColor,
    Color? iconColor,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: iconColor ?? textColor),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: textColor,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow({
    required IconData icon,
    required String label,
    required String value,
    Color valueColor = const Color(0xFF0F172A),
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Icon(icon, size: 20, color: const Color(0xFF64748B)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF475569),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMatchRow(MatchSummary match) {
    final result = match.wonByMe == true
        ? 'W'
        : match.wonByMe == false
        ? 'L'
        : '•';
    final isWin = match.wonByMe == true;
    final isLoss = match.wonByMe == false;

    final circleColor = isWin
        ? const Color(0xFFDCFCE7)
        : isLoss
        ? const Color(0xFFFEE2E2)
        : const Color(0xFFF1F5F9);
    final textColor = isWin
        ? const Color(0xFF166534)
        : isLoss
        ? const Color(0xFF991B1B)
        : const Color(0xFF64748B);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(color: circleColor, shape: BoxShape.circle),
            alignment: Alignment.center,
            child: Text(
              result,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  match.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  match.scoreDetail,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            _formatDate(match.date),
            style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final day = DateTime(date.year, date.month, date.day);
    final today = DateTime(now.year, now.month, now.day);
    final diff = today.difference(day).inDays;
    if (diff == 0) return 'Hoy';
    if (diff == 1) return 'Ayer';
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
}

class _ProfileAvatar extends StatelessWidget {
  final String name;
  final String? avatarUrl;
  final double radius;

  const _ProfileAvatar({
    required this.name,
    this.avatarUrl,
    this.radius = 40,
  });

  String get _initials {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return '?';
    final parts = trimmed.split(RegExp(r'\s+'));
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts[0].substring(0, 1) + parts[1].substring(0, 1)).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final url = avatarUrl;
    final hasUrl = url != null && url.isNotEmpty;
    return CircleAvatar(
      radius: radius,
      backgroundColor: const Color(0xFFFDE68A),
      backgroundImage: hasUrl ? NetworkImage(url) : null,
      child: hasUrl
          ? null
          : Text(
              _initials,
              style: TextStyle(
                fontSize: radius * 0.7,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1E293B),
              ),
            ),
    );
  }
}

class _ProfileLoading extends StatelessWidget {
  const _ProfileLoading();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFA5F8FC),
      body: Center(child: CircularProgressIndicator(color: Color(0xFF1E293B))),
    );
  }
}

class _ProfileError extends StatelessWidget {
  final String? message;
  final VoidCallback onRetry;

  const _ProfileError({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFA5F8FC),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.cloud_off_rounded, size: 56, color: Colors.grey),
              const SizedBox(height: 12),
              Text(
                message ?? 'No se pudo cargar el perfil',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Color(0xFF475569)),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: onRetry,
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
