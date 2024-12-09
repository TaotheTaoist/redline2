import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:redline/controller/authenticationController.dart';
import 'package:redline/controller/profile-controller.dart';
import 'package:redline/tabScreens/baxiDetailScreen.dart';
import 'package:redline/tabScreens/favorite_sent_receieved_screen.dart';
import 'package:redline/tabScreens/like_sent_like_recieved_screen.dart';
import 'package:redline/tabScreens/profilepage.dart';
import 'package:redline/tabScreens/swipping_screen.dart';
import 'package:redline/tabScreens/user_details_screen.dart';
import 'package:redline/tabScreens/view_sent_view_received_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int screenIndex = 0;

  // List of tab screens
  List<Widget> tabScreensList = [
    // SwippingScreen(),
    // SwipeableProfiles(key: PageStorageKey('SwipeableProfiles')),
    SwipeableProfiles(),
    ViewSentViewReceivedScreen(),
    ProfilePage(),
    // FavoriteSentReceivedScreen(),
    LikeSentLikeRecievedScreen(),
    UserDetailsScreen(
      userID: FirebaseAuth.instance.currentUser!.uid,
    ),
  ];
  void _listenToBaxiDetailsData() {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      print("User is not logged in.");
      return;
    }

    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .snapshots()
        .listen((userDoc) {
      if (userDoc.exists) {
        final data = userDoc.data();
        final birthday = data?['birthday'] as String? ?? 'Unknown';
        final bdTime = data?['bdTime'] as String? ?? 'Unknown';
        final sex = data?['sex'] as String? ?? 'male';
        final sure = data?['sure'] as String? ?? 'false';

        // Update the tabScreensList with the new data
        setState(() {
          tabScreensList[1] = BaxiDetailsScreen(
            birthday: birthday,
            time: bdTime,
            sex: sex,
            sure: sure,
          );
        });
      } else {
        print("User data does not exist. home_screen");
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchBaxiDetailsData();
    _listenToBaxiDetailsData();
  }

  Future<void> _fetchBaxiDetailsData() async {
    // Fetch birthday and time
    final data = await Authenticationcontroller.authenticationcontroller
        .fetchUserBirthdayAndTime();

    // Replace placeholder with actual BaxiDetailsScreen once data is fetched
    setState(() {
      tabScreensList[1] = BaxiDetailsScreen(
        birthday: data['birthday'] ?? 'Unknown',
        time: data['bdTime'] ?? 'Unknown',
        sex: data['sex'] ?? "male",
        sure: data['sure'] ?? "false",
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        decoration: BoxDecoration(),
        child: BottomNavigationBar(
          onTap: (indexNumber) {
            setState(() {
              screenIndex = indexNumber;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: const Color.fromARGB(255, 255, 106, 180),
          unselectedItemColor: const Color.fromARGB(136, 148, 148, 148),
          currentIndex: screenIndex,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home, size: 30),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.remove_red_eye, size: 30),
              label: 'View',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.star, size: 30),
              label: 'Favorites',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat, size: 30),
              label: 'Likes',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person, size: 30),
              label: 'Profile',
            ),
          ],
        ),
      ),
      body: tabScreensList[screenIndex],
    );
  }
}
