import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marketplace_app/constants/colors.dart';

class PostPageField extends StatefulWidget {
  PostPageField({Key? key, required this.fieldName, required this.fieldType, required this.fieldSize}) : super(key: key);

  String fieldName;
  bool fieldType; // 1 = required
  int fieldSize;

  @override
  State<PostPageField> createState() => _PostPageFieldState();
}

class _PostPageFieldState extends State<PostPageField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                widget.fieldName,
                style: GoogleFonts.nunito(
                  textStyle: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              Text(
                widget.fieldType ? "*" : "",
                style: GoogleFonts.nunito(
                  textStyle: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Container(
            height: MediaQuery.of(context).size.height * widget.fieldSize / 15,
            width: double.infinity,
            decoration: BoxDecoration(
              color: kDefaultGreyColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(18.0),
              child: TextField(
                style: TextStyle(
                  color: Colors.white,
                ),
                cursorColor: Colors.white,
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.transparent,
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.transparent,
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
