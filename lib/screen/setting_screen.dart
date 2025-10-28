import 'package:dominos_score/provider/game_provider.dart';
import 'package:dominos_score/widgets/switch_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingScreen extends StatelessWidget {
  SettingScreen({super.key});
  final TextEditingController team1Controller = TextEditingController();
  final TextEditingController team2Controller = TextEditingController();
  final List<int> pointsToWin = [100, 200, 300, 400, 500];
  List<bool> isSelected = [true, false];

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, prov, child) => GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },

        child: Scaffold(
          appBar: AppBar(title: Text('Setting ')),
          body: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                Divider(),
                Center(child: Text('Teams Name')),
                SizedBox(height: 15),

                Container(
                  width: 250,
                  child: TextField(
                    controller: team1Controller,
                    decoration: InputDecoration(
                      label: Text(
                        'Team 1',
                        style: TextStyle(color: Colors.grey[400]),
                      ),
                      hintText: 'New name',

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Container(
                  width: 250,
                  child: TextField(
                    controller: team2Controller,
                    decoration: InputDecoration(
                      label: Text(
                        'Team 2',
                        style: TextStyle(color: Colors.grey[400]),
                      ),
                      hintText: 'New name',
                      hintStyle: TextStyle(color: Colors.green[700]),

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                TextButton(
                  onPressed: () {
                    if (team1Controller.text.isNotEmpty) {
                      prov.team1Name = team1Controller.text;
                    }

                    if (team2Controller.text.isNotEmpty) {
                      prov.team2Name = team2Controller.text;
                    }

                    Navigator.pop(context);
                  },
                  child: Text('Save'),
                ),
                Divider(),

                Text('Points'),
                Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: DropdownButtonFormField(
                    decoration: InputDecoration(
                      // contentPadding: const EdgeInsets.symmetric(vertical: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    hint: Text('Points to Win'),
                    items: [
                      for (var point in pointsToWin)
                        DropdownMenuItem(value: point, child: Text('$point')),
                    ],
                    onChanged: (Object? value) {
                      prov.pointsToWin = value as int;
                      print(prov.pointToWin);
                    },
                  ),
                ),

                Row(children: [Text('Theme'), Spacer(), SwitchThemeWidget()]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
