import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FloatingNavButtons extends StatelessWidget {
  FloatingNavButtons({Key? key, required this.icon, required this.buttonName, required this.onPressed}) : super(key: key);

  final String buttonName;
  final IconData icon;
  void Function()? onPressed;


  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
        overlayColor: MaterialStateProperty.all<Color>(Colors.white),
      ),
      onPressed: onPressed,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon),
          SizedBox(height: 5.0),
          Text(buttonName, style: GoogleFonts.nunito(),),
        ],
      ),
    );
  }
}
