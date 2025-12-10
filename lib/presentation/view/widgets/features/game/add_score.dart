import 'package:flutter/material.dart';

class AddScore extends StatefulWidget {
  final Color colorButton;
  final VoidCallback onGetDominoesPointbyImage;
  final Function(String points) onAddPoints; // Llamar al VM para sumar
  final VoidCallback onTapPass;

  const AddScore({
    super.key,
    required this.colorButton,
    required this.onAddPoints,
    required this.onTapPass,
    required this.onGetDominoesPointbyImage,
  });

  @override
  State<AddScore> createState() => _AddScoreState();
}

class _AddScoreState extends State<AddScore> {
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
    final size = MediaQuery.of(context).size;

    return Container(
      height: size.height * (214 / 853),
      width: size.width * (340 / 393),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Color(0xFFFFFFFF),
      ),
      child: Column(
        children: [
          SizedBox(height: 30),
          Stack(
            children: [
              SizedBox(
                width: size.width * (295 / 393),
                child: TextFormField(
                  controller: _controller,

                  maxLines: 1,

                  keyboardType: TextInputType.numberWithOptions(decimal: false),
                  textCapitalization: TextCapitalization.words,
                  maxLength: 3,
                  cursorColor: Color(0xFFD9D9D9),
                  decoration: InputDecoration(
                    counterText: '',
                    hintText: 'Agrega puntos',
                    hintStyle: TextStyle(
                      fontSize: size.height * (18 / 852),
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF1E2B43).withValues(alpha: 0.3),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        width: 1.5,
                        color: Color(0xFFD9D9D9).withValues(alpha: 0.9),
                      ),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        width: 1.5,
                        color: Color(0xFFD9D9D9).withValues(alpha: 0.9),
                      ),
                    ),
                  ),
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    fontSize: 50,
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
                    height: size.height * (25 / 852),
                    color: Color(0XFF1C1400),
                    image: AssetImage('assets/icon/square-rounded-x.png'),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _ButtonSaveScore(
                colorButton: widget.colorButton,
                onTap: () {
                  widget.onAddPoints(_controller.text);
                },
              ),

              buttonCamAnd30(
                size,
                widget.onTapPass,
                'assets/icon/rewind-forward-30.png',
              ),
              buttonCamAnd30(
                size,
                widget.onGetDominoesPointbyImage,
                'assets/icon/camera.png',
              ),
            ],
          ),
        ],
      ),
    );
  }

  GestureDetector buttonCamAnd30(
    Size size,
    VoidCallback onTap,
    String iconAsset,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: size.height * (44 / 852),
        width: size.width * (70 / 393),
        decoration: BoxDecoration(
          color: Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(22),
          border: BoxBorder.all(width: 1.9, color: Color(0xFFDADDE2)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(7.0),
          child: Image(
            fit: BoxFit.contain,
            color: Color(0xFF1E2B43),
            image: AssetImage(iconAsset),
          ),
        ),
      ),
    );
  }
}

class _ButtonSaveScore extends StatelessWidget {
  final Color colorButton;
  final VoidCallback onTap;
  const _ButtonSaveScore({required this.onTap, required this.colorButton});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height * (43 / 852),
      width: size.width * (129 / 393),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: colorButton,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          elevation: 4,
          shadowColor: const Color(0xFFD4AF37).withValues(alpha: 0.15),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/icon/plus.png',
              height: size.height * (23 / 852),
              width: size.width * (23 / 393),
              color: colorButton == const Color(0xFFD4AF37)
                  ? const Color(0xFF000000)
                  : const Color(0xFFFFFFFF),
            ),

            Text(
              'Añadir puntos',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                fontSize: size.height * (13 / 852),
                color: colorButton == const Color(0xFFD4AF37)
                    ? const Color(0xFF000000)
                    : const Color(0xFFFFFFFF),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
