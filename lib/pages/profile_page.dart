import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marketplace_app/constants/colors.dart';
import 'package:marketplace_app/pages/account_update_page.dart';
import 'package:marketplace_app/pages/create_post_page.dart';
import 'package:marketplace_app/pages/personal_info_page.dart';
import 'package:marketplace_app/utilities/floating_bar_buttons.dart';
import 'package:marketplace_app/utilities/floating_bar_add_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:marketplace_app/pages/chat_page.dart';
import 'package:marketplace_app/constants/theme.dart';

class ProfileSettingsPage extends StatelessWidget {
  const ProfileSettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Settings', style: GoogleFonts.nunito(),),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 24),
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    width: 125,
                    height: 125,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[300],
                    ),
                    child: Icon(
                      Icons.person,
                      size: 64,
                      color: Colors.white,
                    ),
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(10),
                      color: kDefaultRedColor,
                    ),
                    child: IconButton(
                      onPressed: (){},
                      icon: Icon(Icons.edit),
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),
              buildButton(
                icon: Icons.person,
                title: 'Personal Information',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>  PersonalInfoPage(),
                    ),
                  );
                },
              ),
              _buildNotificationButton(
                icon: Icons.notifications,
                title: 'Push Notifications',
                subtitle: 'Receive alerts for bid activity',
                value: true,
                onToggle: (value) {},
              ),
              _buildNotificationButton(
                icon: Icons.email,
                title: 'Subscribe to Email',
                subtitle: 'Receive marketing emails',
                value: false,
                onToggle: (value) {
                },
              ),
              buildButton(
                icon: Icons.chat_bubble_rounded,
                title: 'Messages',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const ConversationsPage()),
                  );
                },
              ),
              buildButton(
                icon: Icons.brightness_6_rounded,
                title: 'Switch Theme',
                onTap: () => themeToggle(context)?.call(),
              ),
              buildButton(
                icon: Icons.language,
                title: 'Language',
                onTap: () {},
              ),
              buildButton(
                icon: Icons.manage_accounts,
                title: 'Update Account',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>  UpdateAccPage(),
                    ),
                  );
                },
              ),
              buildButton(
                icon: Icons.logout,
                title: 'Logout',
                onTap: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingNavAddButton(onPressed: (){
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) =>  CreatePostPage(),
          ),
        );
      },),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        height: MediaQuery.of(context).size.width * 2 / 13,
        shape: CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            FloatingNavButtons(icon: Icons.home, buttonName: 'Discover', onPressed: (){Navigator.pop(context);}),
            FloatingNavButtons(icon: Icons.category, buttonName: 'Items', onPressed: (){}),
            SizedBox(width: 40.0),
            FloatingNavButtons(icon: Icons.auto_awesome, buttonName: 'Services', onPressed: (){}),
            FloatingNavButtons(icon: Icons.person, buttonName: 'Profile', onPressed: null),
          ],
        ),
      ),
    );
  }

  Widget buildButton({
    required IconData icon,
    required String title,
    required void Function()? onTap,
  }) {
    return TextButton(
      style: ButtonStyle(
        overlayColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
            return kDefaultGreyColor; // No overlay color
          },
        ),
      ),
      onPressed: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Container(width: 48, height: 48, decoration: BoxDecoration(color: kDefaultGreyColor, borderRadius: BorderRadius.circular(16)), child: Icon(icon,color: Colors.white,size: 22)),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.nunito(textStyle: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: Colors.grey,size: 22,),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationButton({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onToggle,
  }) {
    return TextButton(
      style: ButtonStyle(
        overlayColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
            return kDefaultGreyColor; // No overlay color
          },
        ),
      ),
      onPressed: (){},
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Container(width: 48, height: 48, decoration: BoxDecoration(color: kDefaultGreyColor, borderRadius: BorderRadius.circular(16)), child: Icon(icon,color: Colors.white,size: 22)),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.nunito(textStyle: TextStyle(fontSize: 18, color: Colors.white)),
                  ),
                  SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: GoogleFonts.nunito(textStyle: TextStyle(fontSize: 14, color: Colors.grey),)
                  ),
                ],
              ),
            ),
            Switch(
              value: value,
              onChanged: onToggle,
            ),
          ],
        ),

      ),
    );
  }
}
