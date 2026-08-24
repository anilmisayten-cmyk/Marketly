import 'package:flutter/material.dart';
import 'package:marketplace_app/constants/colors.dart';
import 'package:marketplace_app/constants/images.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marketplace_app/pages/sign_in_page.dart';
import 'package:marketplace_app/pages/create_account_page.dart';
import 'package:marketplace_app/utilities/auth_button.dart';


class SignInOrSignUpPage extends StatelessWidget {
  const SignInOrSignUpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            CircleAvatar(
              radius: MediaQuery.of(context).size.width / 3,
              backgroundColor: kDefaultGreyColor,
              child: Center(child: Image.asset('images/$gooseLogo')),
            ),
            Text(
              'Let\'s get you in',
              style: GoogleFonts.nunito(
                  textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.w500
                  )
              ),
            ),
            Column(
              children: [
                AuthButton(imageLoc: googleLogo,text: 'Continue with Google',onPressed: (){},color: kDefaultGreyColor, overlayColor: kDefaultBackgroundBlack,),
                SizedBox(height: 18),
                AuthButton(imageLoc: facebookLogo,text: 'Continue with Facebook',onPressed: (){},color: kDefaultGreyColor, overlayColor: kDefaultBackgroundBlack,),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Divider(
                      color: Colors.white,
                      // thickness: MediaQuery.of(context).size.width/3,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.0),
                    child: Text('or', style: GoogleFonts.nunito(textStyle: TextStyle(color: Colors.white)),),
                  ),
                  Expanded(
                    child: Divider(
                      color: Colors.white,
                      // thickness: MediaQuery.of(context).size.width/3,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                AuthButton(text: 'Sign in with Email', onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>  SignInPage(),
                    ),
                  );
                },color: kDefaultRedColor, overlayColor: kDefaultBackgroundBlack),
                SizedBox(height: 18,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Don\'t have an account? ',
                      style: GoogleFonts.nunito(
                          textStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 14
                          )
                      ),
                    ),
                    TextButton(
                      onPressed: (){
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>  MakeAccount(),
                          ),
                        );
                      },
                      child: Text(
                        'Sign Up',
                        style: GoogleFonts.nunito(
                            textStyle: TextStyle(
                                color: kDefaultRedColor,
                                fontSize: 14
                            )
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}