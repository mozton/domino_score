// import 'dart:io';

// import 'package:dominos_score/dialogs/new_game_dialog.dart';
// import 'package:dominos_score/provider/providers.dart';
// import 'package:dominos_score/widgets/widgets.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:provider/provider.dart';

// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: FocusScope.of(context).unfocus,
//       child: Scaffold(
//         appBar: AppBar(
//           leading: IconButton(
//             onPressed: () {
//               Navigator.pushNamed(context, '/homescreenv1');
//             },
//             icon: Icon(Icons.sync_alt_rounded),
//           ),
//           backgroundColor: Colors.blueAccent,
//           title: const Text(
//             'Domino Score',
//             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
//           ),
//           centerTitle: true,
//           actions: [
//             IconButton(
//               onPressed: () {
//                 Navigator.of(context).pushNamed('/setting');
//               },
//               icon: const Icon(Icons.settings, size: 25, color: Colors.grey),
//             ),
//           ],
//         ),
//         body: _buildScorePage(context),
//       ),
//     );
//   }

//   Widget _buildScorePage(BuildContext context) {
//     return Consumer<GameProvider>(
//       builder: (context, provider, _) {
//         return Container(
//           decoration: BoxDecoration(
//             // image: DecorationImage(
//             //   image: AssetImage('assets/fondoblanco.jpg'), // Ruta completa
//             //   fit: BoxFit.cover,
//             //   opacity: 0.9, // Hacemos la imagen semi-transparente
//             // ),
//           ),
//           child: SingleChildScrollView(
//             physics: NeverScrollableScrollPhysics(),
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   Card(
//                     elevation: 4,
//                     child: Padding(
//                       padding: const EdgeInsets.all(16.0),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceAround,
//                         children: [
//                           Column(
//                             children: [
//                               SizedBox(
//                                 width: MediaQuery.of(context).size.width * 0.35,
//                                 child: Text(
//                                   provider.team1Name,
//                                   maxLines: 1,
//                                   overflow: TextOverflow.ellipsis,
//                                   style: const TextStyle(
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                   textAlign: TextAlign.center,
//                                 ),
//                               ),
//                               const SizedBox(height: 8),
//                               Text(
//                                 '${provider.team1Total}',
//                                 style: const TextStyle(
//                                   fontSize: 50,
//                                   color: Colors.green,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                                 textAlign: TextAlign.center,
//                               ),
//                             ],
//                           ),
//                           const Text(
//                             'VS',
//                             style: TextStyle(
//                               fontSize: 20,
//                               fontWeight: FontWeight.bold,
//                             ),
//                             textAlign: TextAlign.center,
//                           ),
//                           Column(
//                             children: [
//                               SizedBox(
//                                 width: MediaQuery.of(context).size.width * 0.35,
//                                 child: Text(
//                                   maxLines: 1,
//                                   overflow: TextOverflow.ellipsis,
//                                   provider.team2Name,
//                                   style: const TextStyle(
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                   textAlign: TextAlign.center,
//                                 ),
//                               ),
//                               const SizedBox(height: 8),
//                               Text(
//                                 '${provider.team2Total}',
//                                 style: const TextStyle(
//                                   fontSize: 50,
//                                   color: Colors.green,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                                 textAlign: TextAlign.center,
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   Column(
//                     children: [
//                       TextField(
//                         autofocus: false,
//                         focusNode: provider.focusNode,

//                         maxLength: 3,
//                         inputFormatters: [
//                           FilteringTextInputFormatter.digitsOnly,
//                         ],
//                         keyboardType: TextInputType.number,
//                         controller: provider.pointController,
//                         decoration: InputDecoration(
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(15),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 10),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           SizedBox(
//                             width: MediaQuery.of(context).size.width * 0.35,
//                             child: ElevatedButton.icon(
//                               onPressed: () {
//                                 final points =
//                                     int.tryParse(
//                                       provider.pointController.text,
//                                     ) ??
//                                     0;
//                                 if (points > 0) {
//                                   provider.addRound(provider.team1Name, points);
//                                   provider.pointController.clear();
//                                   provider.focusNode.unfocus();
//                                   FocusScope.of(context).unfocus();
//                                   if (Platform.isIOS) {
//                                     dialogWinIOS(context, provider.team1Name);
//                                   } else {
//                                     dialogWinsAndroid(
//                                       context,
//                                       provider.team1Name,
//                                     );
//                                   }
//                                 }
//                               },
//                               icon: const Icon(Icons.add),
//                               label: Text(
//                                 provider.team1Name,
//                                 overflow: TextOverflow.ellipsis,
//                                 maxLines: 1,
//                               ),
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: Colors.blue[600],
//                                 foregroundColor: Colors.white,
//                               ),
//                             ),
//                           ),
//                           SizedBox(
//                             width: MediaQuery.of(context).size.width * 0.35,
//                             child: ElevatedButton.icon(
//                               onLongPress: () {},
//                               onPressed: () {
//                                 final points =
//                                     int.tryParse(
//                                       provider.pointController.text,
//                                     ) ??
//                                     0;
//                                 if (points > 0) {
//                                   provider.addRound(provider.team2Name, points);
//                                   provider.pointController.clear();
//                                   provider.focusNode.unfocus();
//                                   FocusScope.of(context).unfocus();
//                                   if (Platform.isIOS) {
//                                     dialogWinIOS(context, provider.team2Name);
//                                   } else {
//                                     dialogWinsAndroid(
//                                       context,
//                                       provider.team2Name,
//                                     );
//                                   }
//                                   FocusScope.of(context).unfocus();
//                                 }
//                               },

//                               icon: const Icon(Icons.add),
//                               label: Text(
//                                 provider.team2Name,
//                                 overflow: TextOverflow.ellipsis,
//                                 maxLines: 1,
//                               ),
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: Colors.green,
//                                 foregroundColor: Colors.white,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 10),
//                   ElevatedButton(
//                     onPressed: () {
//                       if (Platform.isIOS) {
//                         newGameIOSDialog(context);
//                       } else {
//                         newGameDialog(context);
//                       }
//                     },

//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.grey[600],
//                       foregroundColor: Colors.white,
//                     ),
//                     child: const Text('NEW GAME'),
//                   ),
//                   SizedBox(height: 15),
//                   ScoreView(provider: provider),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
