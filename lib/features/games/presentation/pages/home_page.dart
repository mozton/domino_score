import 'package:dominos_score/features/games/presentation/bloc/game_bloc.dart';
import 'package:dominos_score/features/games/presentation/pages/live_game_page.dart';
import 'package:dominos_score/features/games/presentation/widgets/card_team.dart';
import 'package:dominos_score/features/games/presentation/widgets/button/button_start_game.dart';
import 'package:dominos_score/features/games/presentation/widgets/live_code_badge.dart';
import 'package:dominos_score/features/games/presentation/widgets/my_team_dialog.dart';
import 'package:dominos_score/features/games/presentation/widgets/score_list.dart';
import 'package:dominos_score/features/games/presentation/widgets/team_palette.dart';
import 'package:dominos_score/features/games/presentation/widgets/ui_helpers.dart';
import 'package:dominos_score/features/games/presentation/widgets/win_and_new_game.dart';
import 'package:dominos_score/features/settings/presentation/widgets/settings_popup.dart';
import 'package:dominos_score/presentation/router/route_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

/// Pantalla de juego.
///
/// Si [groupId] es `null` se juega el historial **general** (local). Si se pasa
/// un grupo, la partida se guarda en Firestore bajo ese grupo y la ven sus
/// miembros.
class HomeScreen extends StatefulWidget {
  final String? groupId;
  final String? groupName;

  /// Si es `true`, arranca una partida nueva al entrar (botón "Nueva Partida").
  final bool startNew;

  const HomeScreen({
    super.key,
    this.groupId,
    this.groupName,
    this.startNew = false,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GameBloc? _bloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bloc = context.read<GameBloc>();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final bloc = context.read<GameBloc>();
      if (widget.startNew && widget.groupId != null) {
        bloc.add(
          GroupGameStarted(
            groupId: widget.groupId!,
            groupName: widget.groupName,
            mode: bloc.state.gameMode,
          ),
        );
      } else {
        bloc.add(
          GameInitialized(
            groupId: widget.groupId,
            groupName: widget.groupName,
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    // Al salir de una partida de grupo se restaura el historial general local.
    if (widget.groupId != null) {
      _bloc?.add(const GameInitialized());
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey settingsKey = GlobalKey();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocListener<GameBloc, GameState>(
      listenWhen: (previous, current) =>
          previous.errorMessage != current.errorMessage,
      listener: (context, state) {
        final message = state.errorMessage;
        if (message == null || message.isEmpty) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), backgroundColor: Colors.redAccent),
        );
      },
      child: BlocBuilder<GameBloc, GameState>(
        builder: (context, state) {
          final game = state.currentGame;
          final teams = game?.teams ?? const [];
          final winnerTeam = state.winnerTeam;

          if (winnerTeam != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (ModalRoute.of(context)?.isCurrent == true) {
                _showWinnerModal(context, winnerTeam.name);
                context.read<GameBloc>().add(const WinnerReset());
              }
            });
          }

          return teams.isNotEmpty
              ? Container(
                  height: double.infinity,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: isDark
                          ? [const Color(0x00000000), const Color(0x00000000)]
                          : [const Color(0xFFE4E9F2), const Color(0xFFFAFAFA)],
                    ),
                  ),
                  child: Scaffold(
                    backgroundColor: Colors.transparent,
                    appBar: _appBarHome(context, settingsKey),
                    body: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Wrap(
                              alignment: WrapAlignment.center,
                              spacing: 10,
                              runSpacing: 12,
                              children: [
                                for (var i = 0; i < teams.length; i++)
                                  CardTeam(
                                    teamName: teams[i].name,
                                    points: teams[i].totalScore,
                                    colorCard: TeamPalette.card(i),
                                    colorButton: TeamPalette.button(i),
                                    widthFactor: TeamPalette.widthFactor(
                                      teams.length,
                                    ),
                                    onTap: () => UiHelpers.showAddScoreDialog(
                                      context,
                                      i,
                                    ),
                                    onTapname: () => UiHelpers.changeNameTeam(
                                      context,
                                      teams[i].id!,
                                      i,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                          ScoreList(
                            teamNames: teams.map((t) => t.name).toList(),
                          ),
                          SizedBox(height: 17),
                          ButtonStartGame(),
                        ],
                      ),
                    ),
                  ),
                )
              : Container(
                  color: isDark ? Colors.black : Colors.white,
                  child: Center(
                    child: LoadingAnimationWidget.progressiveDots(
                      color: isDark ? Colors.white : Colors.black,
                      size: 40,
                    ),
                  ),
                );
        },
      ),
    );
  }

  AppBar _appBarHome(BuildContext context, GlobalKey settingsKey) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isGroupGame = widget.groupId != null;

    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: MediaQuery.of(context).size.height * 0.099,
      backgroundColor: isDark
          ? const Color(0x00000000)
          : const Color(0xFFE4E9F2),
      title: Text(
        widget.groupName ?? 'Corillo',
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: MediaQuery.of(context).size.height * (16 / 852),
          fontWeight: FontWeight.w500,
          fontFamily: 'Poppins',
          color: isDark ? Colors.white : Colors.black,
        ),
      ),
      leading: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: IconButton(
          onPressed: () {
            if (isGroupGame) {
              Navigator.pop(context);
            } else {
              Navigator.pushNamed(context, RouteNames.groups);
            }
          },
          icon: Icon(
            isGroupGame ? TablerIcons.arrow_back : TablerIcons.users_group,
          ),
        ),
      ),
      actions: [
        // Código para que los invitados sigan la partida en vivo.
        BlocBuilder<GameBloc, GameState>(
          builder: (context, state) {
            final code = state.currentGame?.liveCode;
            if (code == null || code.isEmpty) return const SizedBox.shrink();
            return LiveCodeBadge(
              code: code,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => LiveGameScreen(initialCode: code),
                ),
              ),
            );
          },
        ),
        // Los invitados pueden ver una partida escribiendo su código.
        if (!isGroupGame)
          IconButton(
            tooltip: 'Ver partida en vivo',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const LiveGameScreen()),
            ),
            icon: Icon(
              TablerIcons.broadcast,
              color: isDark ? Colors.white70 : Colors.black54,
            ),
          ),
        Builder(
          builder: (context) {
            final game = context.read<GameBloc>().state.currentGame;
            if (game == null) return const SizedBox.shrink();
            final hasTeam = game.myTeamIndex != null;
            return IconButton(
              tooltip: hasTeam ? 'Mi equipo: ${game.myTeam?.name}' : 'Mi equipo',
              onPressed: () async {
                final selection = await showMyTeamDialog(context, game);
                if (selection != null && context.mounted) {
                  context.read<GameBloc>().add(
                    MyTeamSelected(selection.teamIndex),
                  );
                }
              },
              icon: Icon(
                hasTeam
                    ? TablerIcons.user_check
                    : TablerIcons.user_question,
                color: hasTeam
                    ? const Color(0xFFD4AF37)
                    : (isDark ? Colors.white70 : Colors.black54),
              ),
            );
          },
        ),
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: ElevatedButton(
            key: settingsKey,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
            ),
            onPressed: () {
              SettingsPopup.show(context, settingsKey);
            },
            child: Image(
              height: MediaQuery.of(context).size.height * (28 / 852),
              width: MediaQuery.of(context).size.width * (28 / 393),
              image: AssetImage('assets/icon/settings.png'),
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
        ),
      ],
    );
  }

  static void _showWinnerModal(BuildContext context, String teamWiner) {
    showModalBottomSheet(
      sheetAnimationStyle: const AnimationStyle(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOutBack,
      ),
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return WinAndNewGame(teamWiner: teamWiner);
      },
    );
  }
}
