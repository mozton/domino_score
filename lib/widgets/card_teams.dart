import 'package:flutter/material.dart';

class CardTeams extends StatelessWidget {
  final String nameTeam;
  final String points;

  const CardTeams({super.key, required this.nameTeam, required this.points});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 5,
        color: Colors.grey[200],
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.25,
          width: MediaQuery.of(context).size.width * 0.85,
          // decoration: BoxDecoration(
          //   borderRadius: BorderRadius.circular(25),
          //   border: BoxBorder.all(width: 1, color: Colors.grey),
          //   color: Colors.white,
          // ),
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              children: [
                Text(
                  nameTeam,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                ),
                Text(
                  points,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 65),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
