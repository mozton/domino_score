import 'package:flutter/material.dart';

class AddScore extends StatelessWidget {
  final Color colorButton;
  final VoidCallback onTap;
  final TextEditingController controller;
  final VoidCallback onTapPass;
  const AddScore({
    super.key,
    required this.onTap,
    required this.colorButton,
    required this.controller,
    required this.onTapPass,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      height: size.height * (174 / 852),
      width: size.width * (300 / 393),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Color(0xFFFFFFFF),
      ),
      child: Column(
        children: [
          SizedBox(height: 30),
          Stack(
            children: [
              SizedBox(
                // width: size.width * (281 / 393),
                child: TextField(
                  controller: controller,

                  maxLines: 1,

                  keyboardType: TextInputType.numberWithOptions(decimal: false),
                  textCapitalization: TextCapitalization.words,
                  maxLength: 3,
                  cursorColor: Color(0xFFD9D9D9),
                  decoration: InputDecoration(
                    counterText: '',

                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFD9D9D9)),
                    ),
                  ),
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    fontSize: 36,
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
                    color: Color(0XFF1C1400),
                    image: AssetImage('assets/icon/square-rounded-x.png'),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _ButtonSaveName(colorButton: colorButton, onTap: onTap),

              GestureDetector(
                onTap: onTapPass,
                child: Container(
                  height: size.height * (43 / 852),
                  width: size.width * (70 / 393),
                  decoration: BoxDecoration(
                    color: Color(0xFFFFFFFF),
                    borderRadius: BorderRadius.circular(22),
                    border: BoxBorder.all(width: 1.4, color: Color(0xFFDADDE2)),
                  ),
                  child: Image(
                    height: 28,
                    color: Color(0xFF1E2B43),
                    image: AssetImage('assets/icon/rewind-forward-30.png'),
                  ),
                ),
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: size.height * (43 / 852),
        width: size.width * (175 / 393),
        decoration: BoxDecoration(
          color: colorButton,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Color(0xFFD4AF37).withOpacity(0.149),
              offset: Offset(0, 2),
              blurRadius: 8,
              spreadRadius: 0,
            ),
          ],
        ),
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
                  image: AssetImage('assets/icon/plus.png'),
                ),
                SizedBox(width: 10),
                Text(
                  'Añadir puntos',
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
