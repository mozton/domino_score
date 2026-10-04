import 'package:dominos_score/features/games/presentation/widgets/button/button_add_score.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

class CardTeam extends StatelessWidget {
  final String teamName;
  final int points;
  final Color colorCard;
  final Color colorButton;
  final double widthFactor;
  final VoidCallback onTap;
  final VoidCallback onTapname;

  /// Si se pasa, muestra el acceso para elegir los jugadores del equipo
  /// (miembros del grupo o invitados). Solo se usa en partidas de grupo.
  final VoidCallback? onTapPlayers;

  const CardTeam({
    super.key,
    required this.teamName,
    required this.points,
    required this.colorCard,
    required this.colorButton,
    this.widthFactor = 0.43,
    required this.onTap,
    required this.onTapname,
    this.onTapPlayers,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTapname,
          child: Card(
            elevation: 5,
            color: colorCard,
            shadowColor: const Color(0x1F000000),
            borderOnForeground: false,
            child: Stack(
              children: [
                AnimatedContainer(
                  curve: Curves.linear,
                  duration: Duration(milliseconds: 300),
                  height: MediaQuery.of(context).size.height * 0.12,
                  width: MediaQuery.of(context).size.width * widthFactor,
                  padding: EdgeInsets.only(
                    top: 20,
                    bottom: 20,
                    left: 12,
                    right: 12,
                  ),
                  decoration: BoxDecoration(
                    color: colorCard,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0x26000000),
                        offset: const Offset(4, 4),
                        blurRadius: 12,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        points.toString(),
                        style: TextStyle(
                          fontSize:
                              MediaQuery.of(context).size.height * (28 / 852),
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Poppins',
                          color: Colors.black,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Text(
                              teamName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.height *
                                    (13 / 852),
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Poppins',
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 5,
                  right: 5,
                  child: Image(
                    height: MediaQuery.of(context).size.height * (20 / 852),
                    color: Colors.black26,
                    image: AssetImage('assets/icon/pencil-plus.png'),
                  ),
                ),
                // Elegir quién juega (miembros del grupo o invitados).
                if (onTapPlayers != null)
                  Positioned(
                    top: 2,
                    left: 2,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: onTapPlayers,
                      child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: Icon(
                          TablerIcons.users_plus,
                          size: 20,
                          color: Colors.black.withValues(alpha: 0.35),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        SizedBox(height: 13),
        ButtonAddScore(colorButton: colorButton, onTap: onTap),
      ],
    );
  }
}
