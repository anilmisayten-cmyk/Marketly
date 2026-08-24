import 'package:flutter/material.dart';
import 'package:marketplace_app/constants/colors.dart';

class Utils{

  static final messengerKey = GlobalKey<ScaffoldMessengerState>();

  static showSnackBar(String? text){

    if(text == null) return;

    final snackBar = SnackBar(content: Text(text), backgroundColor: Colors.red,);

    messengerKey.currentState!
    ..removeCurrentSnackBar()
    ..showSnackBar(snackBar);
  }
}