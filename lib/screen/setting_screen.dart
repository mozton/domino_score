import 'package:dominos_score/provider/game_provider.dart';
import 'package:dominos_score/widgets/dropdown_point_to_win.dart';
import 'package:dominos_score/widgets/switch_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'dart:io';

class SettingScreen extends StatelessWidget {
  SettingScreen({super.key});
  final TextEditingController team1Controller = TextEditingController();
  final TextEditingController team2Controller = TextEditingController();

  final style = TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey);
  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, prov, child) => GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },

        child: Scaffold(
          appBar: AppBar(
            title: Text('Setting ', style: style),
            leading: IconButton(
              onPressed: () {
                FocusScope.of(context).unfocus();
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back_ios_new_rounded),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(15.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Divider(),
                  Center(child: Text('Teams Name', style: style)),
                  SizedBox(height: 15),

                  SizedBox(
                    width: 250,
                    child: TextField(
                      textCapitalization: TextCapitalization.words,
                      inputFormatters: [],
                      maxLength: 15,
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
                  SizedBox(height: 5),
                  SizedBox(
                    width: 250,
                    child: TextField(
                      textCapitalization: TextCapitalization.words,
                      maxLength: 15,
                      controller: team2Controller,
                      decoration: InputDecoration(
                        label: Text(
                          'Team 2',
                          style: TextStyle(color: Colors.grey[400]),
                        ),
                        hintText: 'New name',
                        hintStyle: TextStyle(color: Colors.grey[400]),

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  CupertinoButton(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[400],

                    onPressed: () {
                      if (team1Controller.text.isNotEmpty) {
                        prov.team1Name = team1Controller.text;
                      }

                      if (team2Controller.text.isNotEmpty) {
                        prov.team2Name = team2Controller.text;
                      }

                      Navigator.pop(context);
                    },
                    child: Text(
                      'Save',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey,
                      ),
                    ),
                  ),
                  Divider(),

                  Text('Points', style: style),
                  SizedBox(height: 15),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: ElevatedButton(
                      child: Row(
                        children: [
                          Text(
                            'Change',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blueGrey,
                            ),
                          ),
                          Spacer(),
                          Text(
                            prov.pointToWin.toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blueGrey,
                            ),
                          ),
                        ],
                      ),
                      onPressed: () {
                        if (Platform.isIOS) {
                          cupertinoPicker(context, prov.pointsToWins);
                        } else {
                          showPointsDialog(context, prov.pointsToWins);
                          return;
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 15),
                  Divider(),
                  SizedBox(height: 15),
                  Text('Other Settings', style: style),
                  SizedBox(height: 15),

                  Row(
                    children: [
                      Text(
                        'Theme system',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Spacer(),

                      // Text(
                      //   prov.isSystemTheme ? 'Manual' : 'Automatic',
                      //   style: TextStyle(fontWeight: FontWeight.bold),
                      // ),
                      if (Platform.isIOS)
                        CupertinoSwitch(
                          value: prov.isSystemTheme,
                          onChanged: (value) {
                            prov.toggleSystemTheme(value);
                          },
                        ),
                      if (Platform.isAndroid)
                        Switch(
                          activeThumbColor: Colors.white,
                          activeTrackColor: Colors.blue,
                          inactiveTrackColor: Colors.grey,
                          inactiveThumbColor: Colors.white,
                          trackOutlineWidth: WidgetStateProperty.all(0.1),
                          value: prov.isSystemTheme,
                          onChanged: (value) {
                            prov.toggleSystemTheme(value);
                          },
                        ),
                    ],
                  ),
                  prov.isSystemTheme
                      ? SizedBox.shrink()
                      : Row(
                          children: [
                            Text(
                              'Dark Mode: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              prov.isDarkMode ? 'On' : 'Off',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Spacer(),

                            SwitchThemeWidget(),
                          ],
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
