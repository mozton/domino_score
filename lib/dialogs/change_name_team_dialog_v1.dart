import 'package:dominos_score/view/widgets/change_name_team_widget_v1.dart';
import 'package:flutter/material.dart';

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
            teamId: 1,
            // controller: context.read<GameViewModel>().team1NameController,
            // onTap: () {
            //   final prov = context.read<GameViewModel>();
            //   // final team = Team(name: prov.team1NameController.text.trim());
            //   prov.updateTeamName(1, prov.team1NameController.text.trim());
            //   // print(prov.actualTeam1);
            //   prov.team1NameController.clear();
            //   Navigator.pop(context);
            // },
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
            teamId: 2,
            // controller: context.read<GameViewModel>().team2NameController,
            // onTap: () {
            //   final prov = context.read<GameViewModel>();
            //   prov.updateTeamName(2, prov.team2NameController.text.trim());

            //   prov.team2NameController.clear();
            //   Navigator.pop(context);
            // },
          ),
        ],
      );
    },
  );
}
