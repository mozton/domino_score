// import 'package:flutter/widgets.dart';

// class ButtonNewGameV1 extends StatelessWidget {
//   final VoidCallback onTapNewGame;
//   const ButtonNewGameV1({super.key, required this.onTapNewGame});

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     return GestureDetector(
//       onTap: onTapNewGame,
//       child: Container(
//         height: size.height * 0.0504,
//         width: size.width * 0.508,
//         decoration: BoxDecoration(
//           color: Color(0xFFB28B32),
//           borderRadius: BorderRadius.circular(22),
//           boxShadow: [
//             BoxShadow(
//               color: Color(0x00000000),
//               blurRadius: 10,
//               offset: Offset(0, 4),
//               spreadRadius: 0.0,
//             ),
//           ],
//         ),
//         child: Center(
//           child: Text(
//             'Nueva Partida',
//             style: TextStyle(
//               fontSize: 13,
//               fontWeight: FontWeight.w600,
//               fontFamily: 'Poppins',
//               color: Color(0xFFFFFFFF),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
