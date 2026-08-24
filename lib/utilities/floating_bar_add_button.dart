import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FloatingNavAddButton extends StatelessWidget {
  FloatingNavAddButton({Key? key, required this.onPressed}) : super(key: key);

  void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      elevation: 8.0,
      child: Icon(Icons.add),
    );
  }
}
