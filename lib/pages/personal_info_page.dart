import 'package:flutter/material.dart';
import 'package:marketplace_app/constants/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:email_validator/email_validator.dart';
import 'package:marketplace_app/database/profile_controller.dart';
import 'package:marketplace_app/database/user_model.dart';
import 'package:marketplace_app/utilities/auth_button.dart';
import 'package:get/get.dart';

class PersonalInfoPage extends StatefulWidget {
  const PersonalInfoPage({Key? key}) : super(key: key);

  @override
  State<PersonalInfoPage> createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {

  bool _obscureText = true;

  bool isChecked = true;
  bool isDisabled = false;

  bool? valueFirst = false;

  final formKey = GlobalKey<FormState>();

  String? updateUserName;
  String? updatePassword;
  String? updateEmail;



  @override
  Widget build(BuildContext context) {

    final controller = Get.put(ProfileController());

    return Scaffold(
        appBar: AppBar(
          title: Text(
              'Personal Information',
            style: GoogleFonts.nunito(
              textStyle: TextStyle(color: Colors.white)
            ),
          )
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Expanded(
              child: FutureBuilder(
                future: controller.getUserData(),
                builder: (context,snapshot){
                  if(snapshot.connectionState == ConnectionState.done){
                    if(snapshot.hasData) {

                      UserModel userData = snapshot.data as UserModel;

                      return Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 3 / 4,
                            width: double.infinity,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.0),
                              child: Form(
                                key: formKey,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'Manage your Account',
                                          style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                                color: Colors.white,
                                                fontSize: MediaQuery.of(context).size.width / 16,
                                              )),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Username',
                                          style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                                color: Colors.white,
                                              )),
                                        ),
                                        TextFormField(
                                          // controller: controller.username,
                                          initialValue: userData.fullName,
                                          autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                          validator: (username) => (username == '')
                                              ? 'Enter a user name'
                                              : null,
                                          style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                                color: Colors.white70,
                                              )),
                                          decoration: InputDecoration(
                                            hintText: 'Update your username',
                                            hintStyle: GoogleFonts.poppins(
                                                textStyle:
                                                TextStyle(color: Colors.white24)),
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide:
                                              BorderSide(color: kDefaultRedColor),
                                            ),
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide:
                                              BorderSide(color: kDefaultRedColor),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Email',
                                          style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                                color: Colors.white,
                                              )),
                                        ),
                                        TextFormField(
                                          // controller: controller.email,
                                          initialValue: userData.email,
                                          autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                          validator: (email) => email != null &&
                                              !EmailValidator.validate(email)
                                              ? 'Enter a valid email'
                                              : null,
                                          style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                                color: Colors.white70,
                                              )),
                                          decoration: InputDecoration(
                                            hintText: 'Update your Email',
                                            hintStyle: GoogleFonts.poppins(
                                                textStyle:
                                                TextStyle(color: Colors.white24)),
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide:
                                              BorderSide(color: kDefaultRedColor),
                                            ),
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide:
                                              BorderSide(color: kDefaultRedColor),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Password',
                                          style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                                color: Colors.white,
                                              )),
                                        ),
                                        TextFormField(
                                          // controller: controller.password,
                                          initialValue: userData.password,
                                          autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                          validator: (value) =>
                                          value != null && value.length < 6
                                              ? 'Enter min. 6 characters'
                                              : null,
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
                                                _obscureText
                                                    ? Icons.visibility
                                                    : Icons.visibility_off,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            hintText: 'Update your password',
                                            hintStyle: GoogleFonts.poppins(
                                                textStyle:
                                                TextStyle(color: Colors.white24)),
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide:
                                              BorderSide(color: kDefaultRedColor),
                                            ),
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide:
                                              BorderSide(color: kDefaultRedColor),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox()
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height * 2 / 14,
                            width: double.infinity,
                            color: kDefaultGreyColor,
                            child: AuthButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              text: 'Go Back',
                              color: kDefaultRedColor,
                              overlayColor: kDefaultGreyColor,
                            ),
                          )
                        ],
                      );
                    } else if(snapshot.hasError){

                      return Center(child: Text(snapshot.error.toString()));
                    } else {
                      return const Center(child: Text('Something went wrong'));
                    }
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ),
        ));
  }
}


