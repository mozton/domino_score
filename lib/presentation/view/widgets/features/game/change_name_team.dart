import 'package:dominos_score/presentation/viewmodel/game_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChangeNameTeam extends StatefulWidget {
  final Color colorButton;
  final int teamId;

  const ChangeNameTeam({
    super.key,
    required this.colorButton,
    required this.teamId,
  });

  @override
  State<ChangeNameTeam> createState() => _ChangeNameTeamState();
}

class _ChangeNameTeamState extends State<ChangeNameTeam> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

    return Container(
      height: size.height * (194 / 852),
      width: size.width * (327 / 393),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: isDark ? Color(0xFF0F1822) : Color(0xFFFFFFFF),
      ),
      child: Column(
        children: [
          SizedBox(height: 30),
          Stack(
            children: [
              SizedBox(
                width: size.width * (281 / 393),
                child: TextFormField(
                  keyboardType: TextInputType.name,
                  controller: _controller,
                  maxLines: 1,
                  textCapitalization: TextCapitalization.words,
                  maxLength: 15,
                  cursorColor: Color(0xFFD9D9D9),
                  decoration: InputDecoration(
                    counterText: '',
                    hintText: 'Nombre de team',
                    hintStyle: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                      color: isDark
                          ? Color(0xFFFFFFFF).withValues(alpha: 0.5)
                          : Color(0xFF1E2B43).withValues(alpha: 0.5),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFD9D9D9)),
                    ),
                  ),
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    fontSize: 44,
                    color: Color(0xFF1E2B43),
                  ),
                ),
              ),
              Positioned(
                top: 5,
                right: 5,
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Image(
                    height: 25,
                    width: 25,
                    color: isDark ? Colors.white : Color(0XFF1C1400),
                    image: AssetImage('assets/icon/square-rounded-x.png'),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 15),
          Row(
            children: [
              SizedBox(width: 20),
              _ButtonSaveName(
                colorButton: widget.colorButton,
                onTap: () {
                  final newName = _controller.text.trim();
                  if (newName.isNotEmpty) {
                    context.read<GameViewmodel>().updateTeamName(
                      widget.teamId,
                      newName,
                    );

                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ButtonSaveName extends StatelessWidget {
  final Color colorButton;
  final VoidCallback onTap;
  const _ButtonSaveName({required this.onTap, required this.colorButton});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height * (43 / 852),
      width: size.width * (165 / 393),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorButton,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),

          elevation: 2,
        ),
        onPressed: onTap,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(
                  height: 23,
                  width: 23,
                  color: colorButton == Color(0xFFD4AF37)
                      ? Color(0xFF000000)
                      : Color(0xFFFFFFFF),
                  image: AssetImage('assets/icon/pencil-plus.png'),
                ),
                SizedBox(width: 10),
                Text(
                  'Guardar',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                    color: colorButton == Color(0xFFD4AF37)
                        ? Color(0xFF000000)
                        : Color(0xFFFFFFFF),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
