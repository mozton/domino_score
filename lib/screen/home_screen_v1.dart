import 'package:dominos_score/provider/providers.dart';
import 'package:dominos_score/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreenV1 extends StatelessWidget {
  const HomeScreenV1({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, prov, child) {
        return Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [const Color(0xFFE4E9F2), const Color(0xFFFAFAFA)],
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,

            appBar: AppBar(
              toolbarHeight: MediaQuery.of(context).size.height * 0.099,
              backgroundColor: const Color(0xFFE4E9F2),
              title: Text(
                'Dominos App',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Poppins',
                ),
              ),
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: InkWell(
                    onTap: () => Navigator.of(context).pushNamed('/setting'),
                    child: Image(
                      height: 28,
                      width: 28,
                      image: AssetImage('assets/icon/settings.png'),
                    ),
                  ),
                ),
              ],
            ),
            body: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CardTeam(
                      teamName: prov.team1Name,
                      points: prov.team1Total,
                      colorCard: const Color(0xFFF7E7AF),
                      colorButton: Color(0xFFD4AF37),
                      onTap: () {},
                    ),
                    CardTeam(
                      teamName: prov.team2Name,
                      points: prov.team2Total,
                      colorCard: const Color(0xFFFFFFFF),
                      colorButton: const Color(0xFF1E2B43),
                      onTap: () {},
                    ),
                  ],
                ),
                // Row(children:  [ButtonAddTeamAndScoreV1()]),
                SizedBox(height: 27),
                ScoreList(nameTeam1: prov.team1Name, nameTeam2: prov.team2Name),
              ],
            ),
          ),
        );
      },
    );
  }
}
