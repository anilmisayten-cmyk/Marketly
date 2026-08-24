import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marketplace_app/constants/colors.dart';

class PasswordTextField extends StatefulWidget {
  PasswordTextField({Key? key, required this.hintText}) : super(key: key);

  final String hintText;

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {

  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: _obscureText,
      style: GoogleFonts.poppins(
          textStyle: TextStyle(
            color: Colors.white70,
          )),
      decoration: InputDecoration(
        suffixIcon: GestureDetector(
          onTap: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
          child: Icon(
            _obscureText ? Icons.visibility : Icons.visibility_off,
            color: Colors.grey,
          ),
        ),
        hintText: widget.hintText,
        hintStyle: GoogleFonts.poppins(
            textStyle: TextStyle(color: Colors.white24)),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: kDefaultRedColor),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: kDefaultRedColor),
        ),
      ),
    );
  }
}
