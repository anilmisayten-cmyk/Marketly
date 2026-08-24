import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marketplace_app/constants/colors.dart';
import 'package:marketplace_app/constants/images.dart';
import 'package:marketplace_app/pages/profile_page.dart';
import 'package:marketplace_app/utilities/floating_bar_add_button.dart';
import 'package:marketplace_app/utilities/floating_bar_buttons.dart';
import 'package:marketplace_app/utilities/post_page_fields.dart';
import 'package:marketplace_app/utilities/auth_button.dart';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({Key? key}) : super(key: key);

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(
              'Sell an Item',
              style: GoogleFonts.nunito(textStyle: TextStyle(fontSize: 19)),
            ),
            leading: Center(child: Icon(Icons.category, color: kDefaultRedColor,))
        ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 11,
              child: Container(
                width: double.infinity,
                color: kDefaultBackgroundBlack,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 14.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 12,),
                        PostPageField(fieldName: 'Title', fieldType: true, fieldSize: 1),
                        PostPageField(fieldName: 'Category', fieldType: true, fieldSize: 3),
                        PostPageField(fieldName: 'Description', fieldType: false, fieldSize: 1),
                        PostPageField(fieldName: 'Price', fieldType: true, fieldSize: 1),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Photos',
                                style: GoogleFonts.nunito(
                                  textStyle: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              SizedBox(height: 30),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(width: 2,),
                                  Container(
                                    height: MediaQuery.of(context).size.width / 4,
                                    width: MediaQuery.of(context).size.width / 4,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: kDefaultGreyColor
                                    ),
                                    child: Icon(
                                        Icons.person,
                                      size: MediaQuery.of(context).size.width / 5,
                                      color: kDefaultRedColor,
                                    ),
                                  ),
                                  SizedBox(width: 10,),
                                  Container(
                                    height: MediaQuery.of(context).size.width / 4,
                                    width: MediaQuery.of(context).size.width / 4,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: kDefaultGreyColor
                                    ),
                                    child: Icon(
                                      Icons.person,
                                      size: MediaQuery.of(context).size.width / 5,
                                      color: kDefaultRedColor,
                                    ),
                                  ),
                                  SizedBox(width: 10,),
                                  Container(
                                    height: MediaQuery.of(context).size.width / 4,
                                    width: MediaQuery.of(context).size.width / 4,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: kDefaultGreyColor
                                    ),
                                    child: Icon(
                                      Icons.person,
                                      size: MediaQuery.of(context).size.width / 5,
                                      color: kDefaultRedColor,
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(height: 20),
                              Container(
                                height: MediaQuery.of(context).size.height * 1 / 15,
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
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.add_box, color: Colors.white38,size: 36,),
                                    SizedBox(width: 10,),
                                    Text(
                                      'Add Photos',
                                      style: GoogleFonts.nunito(
                                        textStyle: TextStyle(
                                          color: Colors.white38,
                                          fontSize: 13
                                        )
                                      ),
                                    )
                                  ],
                                )
                              ),
                              SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                width: double.infinity,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: kDefaultGreyColor,
                        spreadRadius: 5,
                        // offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: MediaQuery.of(context).size.height * 1 / 8,
                          width: double.infinity,
                          color: kDefaultGreyColor,
                          child: AuthButton(
                            overlayColor: kDefaultGreyColor,
                            onPressed: (){
                              Navigator.pop(context);
                            },
                            text: 'Discard',
                            color: Colors.white70,
                            textColor: kDefaultRedColor,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: MediaQuery.of(context).size.height * 1 / 8,
                          width: double.infinity,
                          color: kDefaultGreyColor,
                          child: AuthButton(
                            overlayColor: kDefaultGreyColor,
                            onPressed: (){},
                            text: 'Create Post',
                            color: kDefaultRedColor,
                          ),
                        ),
                      )
                    ],
                  )
              ),
            ),
          ],
        ),
      ),
    );
  }
}
