import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marketplace_app/constants/colors.dart';
import 'package:marketplace_app/constants/images.dart';
import 'package:marketplace_app/pages/create_post_page.dart';
import 'package:marketplace_app/pages/profile_page.dart';
import 'package:marketplace_app/pages/chat_page.dart';
import 'package:marketplace_app/utilities/floating_bar_add_button.dart';
import 'package:marketplace_app/utilities/floating_bar_buttons.dart';
import 'package:carousel_slider/carousel_slider.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({Key? key}) : super(key: key);

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {

  late User? user;
  @override
  void initState() {

    super.initState();
    user = FirebaseAuth.instance.currentUser;
  }
  int _currentImageIndex = 0;
  int _currentImageIndex2 = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(
       title: Text('Discover Here',style: GoogleFonts.nunito(textStyle: TextStyle(fontSize: 19)),),
       leading: Center(child: Image.asset('images/$gooseLogo')),
       actions: [
         IconButton(
           tooltip: 'Mesajlar',
           onPressed: () => Navigator.of(context).push(
             MaterialPageRoute(builder: (_) => const ConversationsPage()),
           ),
           icon: const Icon(Icons.chat_bubble_outline_rounded),
         ),
         PopupMenuButton(
           itemBuilder: (BuildContext context) {
             return [
               PopupMenuItem(
                 value: 'signOut',
                 child: Text('Sign out', style: GoogleFonts.nunito(textStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 18)),),
               ),
             ];
           },
           onSelected: (value) {
             if (value == 'signOut') {
               FirebaseAuth.instance.signOut();
             }
           },
         ),
       ],
     ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 60),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: 'Discover the',
                  style: GoogleFonts.nunito(
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: ' Limitless Potential',
                      style: GoogleFonts.nunito(
                        textStyle: TextStyle(color: kDefaultRedColor, fontWeight: FontWeight.bold, fontSize: 42),
                      ),
                    ),
                    TextSpan(
                      text: ' of Goose!',
                      style:  GoogleFonts.nunito(
                        textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 42),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 30),
            SizedBox(
              height: 30,
            ),
            SizedBox(
              width: 200,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: Card(
                  color: kDefaultRedColor,
                  child: InkWell(
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 36.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              'Explore Now ',
                              style: GoogleFonts.nunito(
                                textStyle: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              )
                          ),
                          Icon(
                            Icons.east,
                            color: Colors.white,
                            size: 25,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: CarouselSlider.builder(
                itemCount: kSliderImagesCourses.length,
                options: CarouselOptions(
                  height: MediaQuery.of(context).size.height * 1 / 4,
                  initialPage: _currentImageIndex,
                  enableInfiniteScroll: true,
                  autoPlay: true,
                  autoPlayInterval: Duration(seconds: 2),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  onPageChanged: (int index, CarouselPageChangedReason reason) {
                    setState(() {
                      _currentImageIndex = index;
                    });
                  },
                ),
                itemBuilder: (BuildContext context, int index, int realIndex) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Center(
                        child: Image.asset(
                          kSliderImagesCourses[index],
                          height: (index == _currentImageIndex)
                              ? MediaQuery.of(context).size.height * 2 / 3
                              : MediaQuery.of(context).size.height * 3 / 5,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

          ],
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
            FloatingNavButtons(icon: Icons.home, buttonName: 'Discover', onPressed: (){}),
            FloatingNavButtons(icon: Icons.category, buttonName: 'Items', onPressed: (){}),
            SizedBox(width: 40.0),
            FloatingNavButtons(icon: Icons.auto_awesome, buttonName: 'Services', onPressed: (){}),
            FloatingNavButtons(icon: Icons.person, buttonName: 'Profile', onPressed: (){
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>  ProfileSettingsPage(),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
//
// SizedBox(
// width: double.infinity,
// height: MediaQuery.of(context).size.height,
// child: Padding(
// padding: EdgeInsets.symmetric(horizontal: 20.0),
// child: Column(
// mainAxisAlignment: MainAxisAlignment.start,
// crossAxisAlignment: CrossAxisAlignment.start,
// children: [
// SizedBox(height: 20),
// Row(
// children: [
// Text(
// 'Welcome, ',
// style: GoogleFonts.nunito(
// textStyle: TextStyle(
// color: Colors.white,
// fontSize: 26
// )),
// ),
// Text(
// FirebaseAuth.instance.currentUser!.email!,
// style: GoogleFonts.nunito(
// textStyle: TextStyle(
// color: Colors.white,
// fontSize: 26
//
// )),
// ),
// ],
// ),
// ],
// ),
// ),
// ),