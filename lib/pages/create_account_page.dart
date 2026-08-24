import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marketplace_app/constants/colors.dart';
import 'package:marketplace_app/constants/images.dart';
import 'package:marketplace_app/database/user_model.dart';
import 'package:marketplace_app/database/user_repository.dart';
import 'package:marketplace_app/utilities/auth_button.dart';
import 'package:msh_checkbox/msh_checkbox.dart';
import 'package:marketplace_app/utilities/utils.dart';
import 'package:get/get.dart';

class MakeAccount extends StatefulWidget {
  const MakeAccount({Key? key}) : super(key: key);

  @override
  State<MakeAccount> createState() => _MakeAccountState();
}

class _MakeAccountState extends State<MakeAccount> {
  bool _obscureText = true;
  bool _obscureText2 = true;

  bool isChecked = true;
  bool isDisabled = false;

  bool? valueFirst = false;

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final userNameController = TextEditingController();

  String? password;
  String? rePassword;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Expanded(
              child: Column(
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
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Create an account ',
                                  style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 30,
                                  )),
                                ),
                                SizedBox(
                                    height: 45,
                                    width: 45,
                                    child: Image.asset('images/$accountLockLogo'))
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
                                  autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                                  validator: (username) => (username == '')
                                      ? 'Enter a user name'
                                      : null,
                                  controller: userNameController,
                                  style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                    color: Colors.white70,
                                  )),
                                  decoration: InputDecoration(
                                    hintText: 'Enter your username',
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
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (email) => email != null &&
                                          !EmailValidator.validate(email)
                                      ? 'Enter a valid email'
                                      : null,
                                  controller: emailController,
                                  style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                    color: Colors.white70,
                                  )),
                                  decoration: InputDecoration(
                                    hintText: 'abc@gmail.com',
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
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (value) =>
                                      value != null && value.length < 6
                                          ? 'Enter min. 6 characters'
                                          : null,
                                  controller: passwordController,
                                  onChanged: (value) {
                                    password = value;
                                  },
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
                                    hintText: 'Enter your Password',
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
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Confirm Password',
                                  style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                    color: Colors.white,
                                  )),
                                ),
                                TextFormField(
                                  autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                                  validator: (value) =>
                                  value != null && value.length < 6
                                      ? 'Enter min. 6 characters'
                                      : null,
                                  onChanged: (value) {
                                    rePassword = value;
                                  },
                                  obscureText: _obscureText2,
                                  style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                        color: Colors.white70,
                                      )),
                                  decoration: InputDecoration(
                                    suffixIcon: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _obscureText2 = !_obscureText2;
                                        });
                                      },
                                      child: Icon(
                                        _obscureText2
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    hintText: 'Re-enter your Password',
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                MSHCheckbox(
                                  style: MSHCheckboxStyle.stroke,
                                  size: 20,
                                  value: isChecked,
                                  isDisabled: isDisabled,
                                  colorConfig:
                                      MSHColorConfig.fromCheckedUncheckedDisabled(
                                    checkedColor: kDefaultRedColor,
                                  ),
                                  // style: style,
                                  onChanged: (selected) {
                                    setState(() {
                                      isChecked = selected;
                                    });
                                  },
                                ),
                                SizedBox(width: 8),
                                TextButton(
                                  style: ButtonStyle(
                                    overlayColor:
                                        MaterialStateProperty.resolveWith<Color>(
                                      (Set<MaterialState> states) {
                                        return kDefaultBackgroundBlack; // No overlay color
                                      },
                                    ),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      isChecked = !isChecked;
                                    });
                                  },
                                  child: Text(
                                    'Remember me',
                                    style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                            color: Colors.white, fontSize: 16)),
                                  ),
                                )
                              ],
                            ),
                            SizedBox()
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 1 / 8,
                    width: double.infinity,
                    color: kDefaultGreyColor,
                    child: AuthButton(
                      onPressed: signIn,
                      text: 'Continue',
                      color: kDefaultRedColor,
                      overlayColor: kDefaultGreyColor,
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }

  Future signIn() async {

    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
              child: CircularProgressIndicator(),
            ));

    try {
      if (password == rePassword) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

        final user = UserModel(
            fullName: userNameController.text.trim(),
            password: passwordController.text.trim(),
            email: emailController.text.trim()
        );

        final userRepo = Get.put(UserRepository());
        await userRepo.createUser(user);
      }

      Navigator.popUntil(context, (route) => route.isFirst);

    } on FirebaseAuthException catch (e) {
      print(e);

      Navigator.pop(context);
      Utils.showSnackBar(e.message);
    }
  }
}
