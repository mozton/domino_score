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

void showPointsDialog(BuildContext context, List<int> points) {
  showDialog(
    context: context,
    builder: (context) {
      return Consumer<GameProvider>(
        builder: (context, prov, child) {
          int selectedValue = prov.pointsToWin;

          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            title: const Text(
              'Select Points to Win',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: StatefulBuilder(
              builder: (context, setState) {
                return DropdownButtonFormField<int>(
                  value: selectedValue,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                  ),
                  items: points
                      .map(
                        (point) => DropdownMenuItem(
                          value: point,
                          child: Text('$point'),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        selectedValue = value;
                      });
                    }
                  },
                );
              },
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  prov.pointsToWin = selectedValue;
                  Navigator.pop(context);
                },
                child: const Text('Done'),
              ),
            ],
          );
        },
      );
    },
  );
}
