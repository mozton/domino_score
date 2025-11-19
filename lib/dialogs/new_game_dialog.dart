// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import '../provider/providers.dart';

// void newGameDialog(BuildContext context) {
//   final prov = Provider.of<GameProvider>(context, listen: false);
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         title: Center(
//           child: Text(
//             'New Game',
//             style: TextStyle(fontWeight: FontWeight.bold),
//           ),
//         ),

//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const Text(
//               'Are you sure you want a New Game?',
//               textAlign: TextAlign.center,
//               style: TextStyle(fontSize: 18),
//             ),
//             const SizedBox(height: 16),
//           ],
//         ),

//         actions: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               ElevatedButton(
//                 style: ButtonStyle(),
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                   FocusScope.of(context).unfocus();
//                 },
//                 child: const Text(
//                   'No',
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     color: Colors.red,
//                   ),
//                 ),
//               ),

//               ElevatedButton(
//                 style: ButtonStyle(),
//                 onPressed: () {
//                   prov.createNewGame();
//                   prov.pointController.clear();
//                   Navigator.of(context).pop();
//                 },
//                 child: const Text(
//                   'Yes',
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     color: Colors.green,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       );
//     },
//   );
// }

// void newGameIOSDialog(BuildContext context) {
//   final prov = Provider.of<GameProvider>(context, listen: false);
//   FocusScope.of(context).unfocus();
//   showCupertinoDialog(
//     context: context,
//     builder: (context) {
//       return CupertinoAlertDialog(
//         title: Center(
//           child: Text(
//             'New Game',
//             style: TextStyle(fontWeight: FontWeight.bold),
//           ),
//         ),

//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const Text(
//               'Are you sure you want a New Game?',
//               textAlign: TextAlign.center,
//               style: TextStyle(fontSize: 18),
//             ),
//             const SizedBox(height: 16),
//           ],
//         ),

//         actions: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               CupertinoDialogAction(
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                   FocusScope.of(context).unfocus();
//                 },

//                 child: const Text(
//                   'No',
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     color: Colors.red,
//                   ),
//                 ),
//               ),

//               CupertinoDialogAction(
//                 onPressed: () {
//                   prov.createNewGame();
//                   prov.pointController.clear();
//                   Navigator.of(context).pop();
//                 },
//                 child: const Text(
//                   'Yes',
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     color: Colors.green,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       );
//     },
//   );
// }
