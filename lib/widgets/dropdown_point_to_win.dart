import 'package:dominos_score/provider/game_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void cupertinoPicker(BuildContext context, List<int> points) {
  showCupertinoModalPopup(
    context: context,
    builder: (context) {
      return Consumer<GameProvider>(
        builder: (context, prov, child) => Container(
          height: 250,
          color: Colors.white,
          child: Column(
            children: [
              // Botón para cerrar o confirmar
              Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 5,
                ),
                child: CupertinoButton(
                  child: const Text('Done'),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              Expanded(
                child: CupertinoPicker(
                  scrollController: FixedExtentScrollController(
                    initialItem: points.indexOf(prov.pointsToWin),
                  ),
                  itemExtent: 35.0,
                  onSelectedItemChanged: (int index) {
                    prov.pointsToWin = points[index];
                  },
                  children: [for (var point in points) Text('$point')],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

void dropdownMenuAndroid(BuildContext context) {
  Consumer<GameProvider>(
    builder: (context, prov, child) => Dialog(
      child: DropdownButtonFormField(
        // style: TextStyle(fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        ),
        hint: Text('Points to Win'),
        items: [
          for (var point in prov.pointsToWins)
            DropdownMenuItem(value: point, child: Text('$point')),
        ],
        onChanged: (Object? value) {
          prov.pointsToWin = value as int;
          // print(prov.pointToWin);
        },
      ),
    ),
  );
}
