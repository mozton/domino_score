import 'package:dominos_score/presentation/view/widgets/features/game/button/button_start_game.dart';
import 'package:dominos_score/presentation/view/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:path/path.dart';

class GroupScreen extends StatelessWidget {
  const GroupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      //=============================//AppBar//=============================
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(TablerIcons.arrow_back),
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
      ),

      //=============================//Head//=============================
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * .71,
            width: double.infinity,
            decoration: BoxDecoration(
              // color: Colors.amber,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: isDark
                    ? [const Color(0x00000000), const Color(0x00000000)]
                    : [const Color(0xFFE4E9F2), const Color(0xFFFAFAFA)],
              ),
            ),

            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildCommunityCard(context, isDark),
                  SizedBox(height: 10),

                  //=============================//body//=============================
                  Text(
                    'TUS GRUPOS ACTIVOS',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                      color: Colors.black38,
                    ),
                  ),

                  SizedBox(height: 10),

                  _buildGroupCard(
                    name: 'Los de la Marquesina',
                    code: '#XLM782',
                    category: 'Principal',
                    members: '8 Miembros',
                    games: '34 Partidas',
                    leader: 'Carlos "El Capicúero"',
                    isPrincipal: true,
                    context: context,
                  ),
                  SizedBox(height: 10),
                  _buildGroupCard(
                    name: 'Los de la Marquesina',
                    code: '#XLM782',
                    category: 'Principal',
                    members: '8 Miembros',
                    games: '34 Partidas',
                    leader: 'Carlos "El Capicúero"',
                    isPrincipal: true,
                    context: context,
                  ),
                  SizedBox(height: 10),
                  _buildGroupCard(
                    name: 'Los de la Marquesina',
                    code: '#XLM782',
                    category: 'Principal',
                    members: '8 Miembros',
                    games: '34 Partidas',
                    leader: 'Carlos "El Capicúero"',
                    isPrincipal: true,
                    context: context,
                  ),
                ],
              ),
            ),
          ),
          Row(children: []),
        ],
      ),
    );
  }

  Container _buildCommunityCard(BuildContext context, bool isDark) {
    return Container(
      width: MediaQuery.of(context).size.width * .9,
      height: MediaQuery.of(context).size.height * .1,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black12, width: 0.5),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.amber.withValues(alpha: .5),
                borderRadius: BorderRadius.circular(15),
              ),
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                child: Center(
                  child: Icon(TablerIcons.users_group, color: Colors.black26),
                ),
              ),
            ),
            SizedBox(width: 10),
            SizedBox(
              width: MediaQuery.of(context).size.width * .65,
              // color: Colors.amber,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Comunidad & Grupos',
                    textAlign: TextAlign.start,
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
                    style: TextStyle(
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

  // ----------------------------------------------------------
  // SECTION TITLE
  // ----------------------------------------------------------

  Widget _buildSectionTitle() {
    return Row(
      children: [
        const Text(
          'TUS GRUPOS ACTIVOS',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
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
          child: const Text(
            '3',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: Color(0xFF456A99),
            ),
          ),
        ),
      ],
    );
  }

  // ----------------------------------------------------------
  // GROUP CARD
  // ----------------------------------------------------------

  Widget _buildGroupCard({
    required String name,
    required String code,
    required String category,
    required String members,
    required String games,
    required String leader,
    required BuildContext context,
    bool isPrincipal = true,
  }) {
    return Container(
      width: MediaQuery.of(context).size.width * .9,
      height: MediaQuery.of(context).size.height * .175,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: isPrincipal ? Colors.black12 : Colors.transparent,
          width: isPrincipal ? 1 : 0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.035),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Nombre + código + flecha
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        name,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF26354A),
                          letterSpacing: -0.4,
                        ),
                      ),
                    ),

                    const SizedBox(width: 6),

                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        code,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF8A96A8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // const Icon(
              //   Icons.chevron_right_rounded,
              //   size: 30,
              //   color: Color(0xFF26354A),
              // ),
            ],
          ),

          const SizedBox(height: 5),

          // Categoría
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 6),
            decoration: BoxDecoration(
              color: isPrincipal
                  ? const Color(0xFFF0F2F6)
                  : const Color(0xFFF0F3F7),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              category,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: Color(0xFF68768A),
              ),
            ),
          ),

          const SizedBox(height: 5),

          // Miembros / partidas
          Row(
            children: [
              _buildStat(icon: Icons.people_outline_rounded, text: members),

              const SizedBox(width: 10),

              _buildStat(icon: Icons.emoji_events_outlined, text: games),
            ],
          ),

          const SizedBox(height: 8),

          Container(height: 1, color: const Color(0xFFE9EDF2)),
          const SizedBox(height: 8),

          // Líder
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
                  color: Color(0xFF9AA5B5),
                ),
              ),

              const SizedBox(width: 7),

              Expanded(
                child: Text(
                  leader,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF26354A),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  // STAT
  // ----------------------------------------------------------

  Widget _buildStat({required IconData icon, required String text}) {
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
              color: Color(0xFF59687D),
            ),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  // BOTTOM BUTTONS
  // ----------------------------------------------------------

  Widget _buildBottomButtons() {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F4F8),
        border: Border(top: BorderSide(color: Colors.black.withOpacity(0.04))),
      ),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 62,
              child: ElevatedButton.icon(
                onPressed: () {
                  // Unirse a coro
                },
                icon: const Icon(Icons.key_rounded, size: 26),
                label: const Text(
                  'Unirme a Coro',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
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
              height: 62,
              child: OutlinedButton.icon(
                onPressed: () {
                  // Crear coro
                },
                icon: const Icon(Icons.add_circle_outline_rounded, size: 26),
                label: const Text(
                  'Crear Coro',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
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
