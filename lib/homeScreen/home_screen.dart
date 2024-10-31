// import 'package:flutter/material.dart';

// class HomeScreen extends StatelessWidget {
//   final String userName;

//   // Optional: You can pass the user's name or any other info to the home screen
//   HomeScreen({required this.userName});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Welcome, $userName!"),
//         centerTitle: true,
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               "Welcome to your HomeScreen!",
//               style: TextStyle(fontSize: 24),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 // You can add logout or other actions here
//               },
//               child: Text("Log Out"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// import 'package:datingapp/tabScreens/favorite_sent_receieved_screen.dart';
// import 'package:datingapp/tabScreens/like_sent_like_recieved_screen.dart';
// import 'package:datingapp/tabScreens/swipping_screen.dart';
// import 'package:datingapp/tabScreens/user_details_screen.dart';
// import 'package:datingapp/tabScreens/view_sent_view_received_screen.dart';
// import 'package:flutter/material.dart';

// class HomeScreen extends StatefulWidget {
//   HomeScreen({Key? key}) : super(key: key);

//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   int screenIndex = 0;
//   List tabScreensList = [
//     SwippingScreen(),
//     ViewSentViewReceivedScreen(),
//     FavoriteSentReceievedScreen(),
//     LikeSentLikeRecievedScreen(),
//     UserDetailsScreen()
//   ];
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       bottomNavigationBar: BottomNavigationBar(
//         onTap: (indexNumber) {
//           setState(() {
//             screenIndex = indexNumber;
//           });
//         },
//         type: BottomNavigationBarType.fixed,
//         backgroundColor: Colors.black,
//         selectedItemColor: Colors.white,
//         unselectedItemColor: Colors.white12,
//         currentIndex: screenIndex,
//         items: [
//           BottomNavigationBarItem(icon: Icon(Icons.home, size: 30)),
//           BottomNavigationBarItem(icon: Icon(Icons.remove_red_eye, size: 30)),
//           BottomNavigationBarItem(icon: Icon(Icons.star, size: 30)),
//           BottomNavigationBarItem(icon: Icon(Icons.favorite, size: 30)),
//           BottomNavigationBarItem(icon: Icon(Icons.person, size: 30)),
//         ],
//       ),

//       body: tabScreensList[screenIndex],
//       // appBar: AppBar(
//       //   // Static title without the userName
//       //   title: Text("Home Screen"),
//       //   centerTitle: true,
//       // ),
//       // body: Center(
//       //   child: Column(
//       //     mainAxisAlignment: MainAxisAlignment.center,
//       //     children: [
//       //       Text(
//       //         "Welcome to your HomeScreen!",
//       //         style: TextStyle(fontSize: 24),
//       //       ),
//       //       SizedBox(height: 20),
//       //       ElevatedButton(
//       //         onPressed: () {
//       //           // You can add logout or other actions here
//       //           setState(() {
//       //             // Example: Add logic here if state needs to be updated
//       //           });
//       //         },
//       //         child: Text("Log Out"),
//       //       ),
//       //     ],
//       //   ),
//       // ),
//     );
//   }
// }
import 'package:redline/tabScreens/favorite_sent_receieved_screen.dart';
import 'package:redline/tabScreens/like_sent_like_recieved_screen.dart';
import 'package:redline/tabScreens/swipping_screen.dart';
import 'package:redline/tabScreens/user_details_screen.dart';
import 'package:redline/tabScreens/view_sent_view_received_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int screenIndex = 0;

  // List of tab screens
  List<Widget> tabScreensList = [
    // SwippingScreen(),
    SwipeableProfiles(),
    ViewSentViewReceivedScreen(),
    FavoriteSentReceivedScreen(),
    LikeSentLikeRecievedScreen(),
    UserDetailsScreen(
      userID: FirebaseAuth.instance.currentUser!.uid,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        onTap: (indexNumber) {
          setState(() {
            screenIndex = indexNumber;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.grey,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white54,
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
            icon: Icon(Icons.favorite, size: 30),
            label: 'Likes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, size: 30),
            label: 'Profile',
          ),
        ],
      ),
      body: tabScreensList[screenIndex],
    );
  }
}
