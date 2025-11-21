import 'package:dominos_score/model/models.dart';
import 'package:dominos_score/provider/game_provider.dart';
import 'package:dominos_score/widgets/change_name_team_widget_v1.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void addNameTeam1Dialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Color(0xFFFFFFFF),
        insetPadding: EdgeInsets.zero,

        actions: [
          ChangeNameTeam(
            colorButton: Color(0xFFD4AF37),
            controller: context.read<GameProvider>().team1NameController,
            onTap: () {
              final prov = context.read<GameProvider>();
              // final team = Team(name: prov.team1NameController.text.trim());
              prov.updateTeamName(0, prov.team1NameController.text.trim());
              // print(prov.actualTeam1);
              prov.team1NameController.clear();
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}

void addNameTeam2Dialog(BuildContext context) {
  showDialog(
    context: context,

    builder: (context) {
      return AlertDialog(
        backgroundColor: Color(0xFFFFFFFF),
        insetPadding: EdgeInsets.zero,

        actions: [
          ChangeNameTeam(
            colorButton: Color(0xFF1E2B43),
            controller: context.read<GameProvider>().team2NameController,
            onTap: () {
              final prov = context.read<GameProvider>();
              final team = Team(
                id: null,
                name: prov.team2NameController.text.trim(),
              );

              prov.team2NameController.clear();
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}
