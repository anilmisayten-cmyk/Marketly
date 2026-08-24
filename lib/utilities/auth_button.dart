import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marketplace_app/constants/colors.dart';

class AuthButton extends StatelessWidget {
  AuthButton({Key? key, this.imageLoc, required this.text, this.onPressed, required this.color, required this.overlayColor, this.textColor})
      : super(key: key);

  final String? imageLoc;
  final String text;
  void Function()? onPressed;
  final Color color;
  final Color overlayColor;
  final Color? textColor;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        overlayColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
            return overlayColor; // No overlay color
          },
        ),
      ),
      onPressed: onPressed,
      child: Container(
        // width: MediaQuery.of(context).size.width * 6/7,
        height: MediaQuery.of(context).size.height / 15,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.0),
          color: color,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            imageLoc != null ? SizedBox(
              height: 27,
              width: 27,
              child: Image.asset(
                'images/$imageLoc',
              ),
            ) : SizedBox(),
            imageLoc != null ? SizedBox(width: 17) : SizedBox(),
            Text(
              text,
              style: GoogleFonts.nunito(
                  textStyle: TextStyle(color: textColor ?? Colors.white, fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
