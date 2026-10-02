import 'package:dominos_score/features/games/presentation/pages/live_game_page.dart';
import 'package:dominos_score/features/groups/presentation/bloc/group_bloc.dart';
import 'package:dominos_score/features/groups/presentation/screens/group_detail_screen.dart';
import 'package:dominos_score/features/groups/presentation/widgets/create_group_dialog.dart';
import 'package:dominos_score/features/groups/presentation/widgets/group_card.dart';
import 'package:dominos_score/features/groups/presentation/widgets/join_group_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

class GroupScreen extends StatefulWidget {
  const GroupScreen({super.key});

  @override
  State<GroupScreen> createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GroupBloc>().add(const GroupsLoadRequested());
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(TablerIcons.arrow_back),
          ),
          automaticallyImplyLeading: false,
          toolbarHeight: MediaQuery.of(context).size.height * 0.099,
          backgroundColor: isDark
              ? const Color(0x00000000)
              : const Color(0xFFE4E9F2),
          title: Text(
            'Mis Corillo',
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.height * (16 / 852),
              fontWeight: FontWeight.w700,
              fontFamily: 'Poppins',
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          actions: [
            IconButton(
              tooltip: 'Ver partida en vivo',
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const LiveGameScreen(),
                ),
              ),
              icon: const Icon(TablerIcons.broadcast),
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  context.read<GroupBloc>().add(const GroupsLoadRequested());
                },
                child: BlocBuilder<GroupBloc, GroupState>(
                  builder: (context, state) {
                    final isLoading =
                        state.status == GroupStatus.loading &&
                        state.groups.isEmpty;

                    return ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.only(bottom: 16),
                      children: [
                        const SizedBox(height: 12),
                        Center(child: _buildCommunityCard(context, isDark)),
                        const SizedBox(height: 16),
                        Center(child: _buildSectionTitle(state.groups.length)),
                        const SizedBox(height: 6),
                        if (isLoading)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 40),
                            child: Center(child: CircularProgressIndicator()),
                          )
                        else if (state.groups.isEmpty)
                          _buildEmpty(isDark)
                        else
                          ...state.groups.map(
                            (group) => Center(
                              child: GroupCard(
                                group: group,
                                isOwner: group.ownerId == state.myUserId,
                                onTap: () => _openDetail(group.id),
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ),
            _buildBottomButtons(context),
          ],
        ),
      ),
    );
  }

  void _openDetail(String groupId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => GroupDetailScreen(groupId: groupId),
      ),
    );
  }

  Future<void> _handleCreate() async {
    final input = await showCreateGroupDialog(context);
    if (input == null || !mounted) return;
    context.read<GroupBloc>().add(
      GroupCreateRequested(name: input.name, description: input.description),
    );
  }

  Future<void> _handleJoin() async {
    final code = await showJoinGroupDialog(context);
    if (code == null || !mounted) return;
    context.read<GroupBloc>().add(GroupJoinRequested(code));
  }

  Container _buildCommunityCard(BuildContext context, bool isDark) {
    return Container(
      width: MediaQuery.of(context).size.width * .9,
      height: MediaQuery.of(context).size.height * .1,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F1822) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            offset: const Offset(4, 4),
            blurRadius: 12,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFFF7E7AF),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: Icon(TablerIcons.users_group, color: Color(0xFFD4AF37)),
              ),
            ),
            const SizedBox(width: 10),
            SizedBox(
              width: MediaQuery.of(context).size.width * .65,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Comunidad & Grupos',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height * (14 / 852),
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Poppins',
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  Text(
                    'Administra tus grupos y lleva el control de cada partida',
                    overflow: TextOverflow.fade,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Poppins',
                      color: Colors.black38,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(int count) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'TUS GRUPOS ACTIVOS',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
            fontFamily: 'Poppins',
            color: Color(0xFF637187),
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: const Color(0xFFE4EDF8),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '$count',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              fontFamily: 'Poppins',
              color: Color(0xFF456A99),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmpty(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
      child: Column(
        children: [
          Icon(
            TablerIcons.users_group,
            size: 56,
            color: isDark ? Colors.white24 : Colors.black26,
          ),
          const SizedBox(height: 12),
          Text(
            'Aún no tienes grupos',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              fontFamily: 'Poppins',
              color: isDark ? Colors.white70 : const Color(0xFF637187),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Crea un Coro o únete con un código de invitación.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontFamily: 'Poppins',
              color: isDark ? Colors.white38 : Colors.black45,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButtons(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 14),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF0F1822)
            : const Color(0xFFF1F4F8),
        border: Border(
          top: BorderSide(color: Colors.black.withValues(alpha: 0.04)),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 56,
              child: ElevatedButton.icon(
                onPressed: _handleJoin,
                icon: const Icon(Icons.key_rounded, size: 22),
                label: const Text(
                  'Unirme a Coro',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFC88F20),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: SizedBox(
              height: 56,
              child: OutlinedButton.icon(
                onPressed: _handleCreate,
                icon: const Icon(Icons.add_circle_outline_rounded, size: 22),
                label: const Text(
                  'Crear Coro',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF536176),
                  side: const BorderSide(color: Color(0xFFD0D9E4), width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
