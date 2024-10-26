// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:datingapp/global.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:swipe_cards/swipe_cards.dart'; // New Import

// import 'package:datingapp/controller/profile-controller.dart';

// class SwipeableProfiles extends StatefulWidget {
//   @override
//   _SwipeableProfilesState createState() => _SwipeableProfilesState();
// }

// class _SwipeableProfilesState extends State<SwipeableProfiles> {
//   String senderName = "";

//   readUserData() async {
//     await FirebaseFirestore.instance
//         .collection("users")
//         .doc(currentUserID)
//         .get()
//         .then((dataSnapshot) {
//       setState(() {
//         senderName = dataSnapshot.data()!["name"].toString();
//       });
//     });
//   }

//   Profilecontroller profileController = Get.put(Profilecontroller());
//   List<SwipeItem> swipeItems = []; // New variable to hold swipe items
//   late MatchEngine matchEngine; // Engine for controlling swipe actions

//   @override
//   void initState() {
//     readUserData();

//     // Initialize swipeItems and matchEngine
//     swipeItems = profileController.allUserProfileList.map((profile) {
//       return SwipeItem(
//         content: profile,
//         likeAction: () {
//           print('Liked ${profile.name}');
//           profileController.LikeSentReceieved(
//             profile.uid.toString(),
//             senderName,
//           );
//         },
//         nopeAction: () {
//           print('Disliked ${profile.name}');
//         },
//         superlikeAction: () {
//           print('Superliked ${profile.name}');
//           profileController.favoriteSentReceieved(
//             profile.uid.toString(),
//             senderName,
//           );
//         },
//       );
//     }).toList();

//     matchEngine =
//         MatchEngine(swipeItems: swipeItems); // Initialize match engine

//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Obx(() {
//         // Check if the profile list is empty
//         if (profileController.allUserProfileList.isEmpty) {
//           return Center(
//             child: Text(
//               'No profiles found',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 18,
//               ),
//             ),
//           );
//         }

//         // Ensure matchEngine is initialized before using it
//         if (matchEngine == null) {
//           return Center(
//             child: CircularProgressIndicator(),
//           );
//         }

//         // Swipe Cards inside a Container with margin
//         return Container(
//           margin: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
//           decoration: BoxDecoration(
//             color:
//                 Colors.white.withOpacity(0.1), // Background color behind cards
//             borderRadius:
//                 BorderRadius.circular(25), // Rounded corners for the box
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.2), // Shadow effect
//                 spreadRadius: 5,
//                 blurRadius: 7,
//                 offset: Offset(0, 3), // Shadow position
//               ),
//             ],
//           ),
//           child: ClipRRect(
//             borderRadius:
//                 BorderRadius.circular(25), // Ensure clipping of the corners
//             child: SwipeCards(
//               matchEngine: matchEngine, // Updated to use match engine
//               itemBuilder: (context, index) {
//                 final eachProfileInfo =
//                     profileController.allUserProfileList[index];

//                 return Stack(
//                   children: [
//                     // Profile Image Background
//                     Positioned.fill(
//                       child: DecoratedBox(
//                         decoration: BoxDecoration(
//                           image: DecorationImage(
//                             image: NetworkImage(
//                                 eachProfileInfo.imageProfile ?? ''),
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                       ),
//                     ),

//                     // IconButton for filter
//                     Align(
//                       alignment: Alignment.topRight,
//                       child: Padding(
//                         padding: EdgeInsets.only(top: 40, right: 30),
//                         child: IconButton(
//                           onPressed: () {
//                             // Add your onPressed functionality here
//                           },
//                           icon: const Icon(
//                             Icons.filter_list,
//                             size: 30,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                     ),

//                     // Profile info (name, buttons) in a Column layout
//                     Positioned(
//                       bottom: 20, // Ensure this is placed near the bottom
//                       left: 0,
//                       right: 0,
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                         child: Column(
//                           mainAxisSize: MainAxisSize
//                               .min, // Adjust the size of the column to fit its content
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             // Profile name
//                             Text(
//                               eachProfileInfo.name.toString(),
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 24,
//                                 letterSpacing: 4,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             SizedBox(height: 4),

//                             // Profile age and city button
//                             ElevatedButton(
//                               onPressed: () {},
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: Colors.white.withOpacity(0.5),
//                                 padding: EdgeInsets.symmetric(
//                                     horizontal: 20, vertical: 10),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(30),
//                                 ),
//                               ),
//                               child: Text(
//                                 "${eachProfileInfo.age} ⦾ ${eachProfileInfo.city}",
//                                 style: TextStyle(
//                                   fontSize: 14,
//                                   letterSpacing: 2,
//                                   color: Colors.black,
//                                 ),
//                               ),
//                             ),
//                             SizedBox(height: 10),

//                             // Religion button
//                             ElevatedButton(
//                               onPressed: () {},
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: Colors.white.withOpacity(0.2),
//                                 padding: EdgeInsets.symmetric(
//                                     horizontal: 20, vertical: 10),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(18),
//                                 ),
//                               ),
//                               child: Text(
//                                 "${eachProfileInfo.religion}",
//                                 style: TextStyle(
//                                   fontSize: 14,
//                                   letterSpacing: 4,
//                                   color: Colors.black,
//                                 ),
//                               ),
//                             ),
//                             SizedBox(height: 10),

//                             // Favorite, Like, and Close buttons in a row
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 ElevatedButton(
//                                   onPressed: () {
//                                     profileController.favoriteSentReceieved(
//                                       eachProfileInfo.uid.toString(),
//                                       senderName,
//                                     );
//                                     print('Favorite icon tapped!');
//                                   },
//                                   style: ElevatedButton.styleFrom(
//                                     shape: CircleBorder(),
//                                     padding: EdgeInsets.all(10),
//                                     backgroundColor: Colors.transparent,
//                                     shadowColor: Colors.transparent,
//                                   ),
//                                   child: Icon(
//                                     Icons.heat_pump_rounded,
//                                     color: Colors.red,
//                                     size: 30,
//                                   ),
//                                 ),
//                                 SizedBox(width: 10),
//                                 ElevatedButton(
//                                   onPressed: () {
//                                     profileController.LikeSentReceieved(
//                                       eachProfileInfo.uid.toString(),
//                                       senderName,
//                                     );
//                                     print('Like icon tapped!');
//                                   },
//                                   style: ElevatedButton.styleFrom(
//                                     shape: CircleBorder(),
//                                     padding: EdgeInsets.all(10),
//                                     backgroundColor: Colors.transparent,
//                                     shadowColor: Colors.transparent,
//                                   ),
//                                   child: Icon(
//                                     Icons.favorite,
//                                     color: Colors.red,
//                                     size: 30,
//                                   ),
//                                 ),
//                                 SizedBox(width: 10),
//                                 ElevatedButton(
//                                   onPressed: () {
//                                     print('Close icon tapped!');
//                                   },
//                                   style: ElevatedButton.styleFrom(
//                                     shape: CircleBorder(),
//                                     padding: EdgeInsets.all(10),
//                                     backgroundColor: Colors.transparent,
//                                     shadowColor: Colors.transparent,
//                                   ),
//                                   child: Icon(
//                                     Icons.close,
//                                     color: Colors.red,
//                                     size: 30,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 );
//               },
//               onStackFinished: () {
//                 print('Stack Finished');
//               },
//               upSwipeAllowed: true, // Allow swiping up
//               rightSwipeAllowed: true, // Allow swiping right
//               leftSwipeAllowed: true, // Allow swiping left
//             ),
//           ),
//         );
//       }),
//     );
//   }
// }
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:datingapp/global.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:swipe_cards/swipe_cards.dart';
// import 'package:datingapp/controller/profile-controller.dart';

// class SwipeableProfiles extends StatefulWidget {
//   @override
//   _SwipeableProfilesState createState() => _SwipeableProfilesState();
// }

// class _SwipeableProfilesState extends State<SwipeableProfiles> {
//   String senderName = "";
//   Profilecontroller profileController = Get.put(Profilecontroller());
//   List<SwipeItem> swipeItems = [];
//   late MatchEngine matchEngine;

//   readUserData() async {
//     await FirebaseFirestore.instance
//         .collection("users")
//         .doc(currentUserID)
//         .get()
//         .then((dataSnapshot) {
//       setState(() {
//         senderName = dataSnapshot.data()!["name"].toString();
//       });
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     readUserData();

//     // Initialize swipeItems and matchEngine
//     swipeItems = profileController.allUserProfileList.map((profile) {
//       return SwipeItem(
//         content: profile,
//         likeAction: () {
//           print('Liked ${profile.name}');
//           profileController.LikeSentReceieved(
//             profile.uid.toString(),
//             senderName,
//           );
//         },
//         nopeAction: () {
//           print('Disliked ${profile.name}');
//         },
//         superlikeAction: () {
//           print('Superliked ${profile.name}');
//           profileController.favoriteSentReceieved(
//             profile.uid.toString(),
//             senderName,
//           );
//         },
//       );
//     }).toList();

//     matchEngine = MatchEngine(swipeItems: swipeItems);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         // Set the gradient background for the entire scaffold
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [
//               Colors.blue, // Start color
//               Colors.purple, // End color
//             ],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//         ),
//         child: Obx(() {
//           // Check if the profile list is empty
//           if (profileController.allUserProfileList.isEmpty) {
//             return Center(
//               child: Text(
//                 'No profiles found',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 18,
//                 ),
//               ),
//             );
//           } else {
//             // Swipe Cards inside a Container with margin and rounded corners
//             return Container(
//               margin: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
//               decoration: BoxDecoration(
//                 color: Colors.white
//                     .withOpacity(0.1), // Slightly opaque background for cards
//                 borderRadius: BorderRadius.circular(25), // Rounded corners
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.2),
//                     spreadRadius: 5,
//                     blurRadius: 7,
//                     offset: Offset(0, 3),
//                   ),
//                 ],
//               ),
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(
//                     25), // Ensure the child content respects the rounded corners
//                 child: SwipeCards(
//                   matchEngine: matchEngine,
//                   itemBuilder: (context, index) {
//                     final eachProfileInfo =
//                         profileController.allUserProfileList[index];

//                     return Stack(
//                       children: [
//                         // Profile Image Background
//                         Positioned.fill(
//                           child: DecoratedBox(
//                             decoration: BoxDecoration(
//                               image: DecorationImage(
//                                 image: NetworkImage(
//                                     eachProfileInfo.imageProfile ?? ''),
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                           ),
//                         ),

//                         // IconButton for filter
//                         Align(
//                           alignment: Alignment.topRight,
//                           child: Padding(
//                             padding: EdgeInsets.only(top: 40, right: 30),
//                             child: IconButton(
//                               onPressed: () {
//                                 // Add your onPressed functionality here
//                               },
//                               icon: const Icon(
//                                 Icons.filter_list,
//                                 size: 30,
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ),
//                         ),

//                         // Profile info (name, buttons) in a Column layout
//                         Positioned(
//                           bottom: 20,
//                           left: 0,
//                           right: 0,
//                           child: Padding(
//                             padding:
//                                 const EdgeInsets.symmetric(horizontal: 16.0),
//                             child: Column(
//                               mainAxisSize: MainAxisSize.min,
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               children: [
//                                 // Profile name
//                                 Text(
//                                   eachProfileInfo.name.toString(),
//                                   style: TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 24,
//                                     letterSpacing: 4,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                                 SizedBox(height: 4),

//                                 // Profile age and city button
//                                 ElevatedButton(
//                                   onPressed: () {},
//                                   style: ElevatedButton.styleFrom(
//                                     backgroundColor:
//                                         Colors.white.withOpacity(0.5),
//                                     padding: EdgeInsets.symmetric(
//                                         horizontal: 20, vertical: 10),
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(30),
//                                     ),
//                                   ),
//                                   child: Text(
//                                     "${eachProfileInfo.age} ⦾ ${eachProfileInfo.city}",
//                                     style: TextStyle(
//                                       fontSize: 14,
//                                       letterSpacing: 2,
//                                       color: Colors.black,
//                                     ),
//                                   ),
//                                 ),
//                                 SizedBox(height: 10),

//                                 // Religion button
//                                 ElevatedButton(
//                                   onPressed: () {},
//                                   style: ElevatedButton.styleFrom(
//                                     backgroundColor:
//                                         Colors.white.withOpacity(0.2),
//                                     padding: EdgeInsets.symmetric(
//                                         horizontal: 20, vertical: 10),
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(18),
//                                     ),
//                                   ),
//                                   child: Text(
//                                     "${eachProfileInfo.religion}",
//                                     style: TextStyle(
//                                       fontSize: 14,
//                                       letterSpacing: 4,
//                                       color: Colors.black,
//                                     ),
//                                   ),
//                                 ),
//                                 SizedBox(height: 10),

//                                 // Favorite, Like, and Close buttons in a row
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     ElevatedButton(
//                                       onPressed: () {
//                                         profileController.favoriteSentReceieved(
//                                           eachProfileInfo.uid.toString(),
//                                           senderName,
//                                         );
//                                         print('Favorite icon tapped!');
//                                       },
//                                       style: ElevatedButton.styleFrom(
//                                         shape: CircleBorder(),
//                                         padding: EdgeInsets.all(10),
//                                         backgroundColor: Colors.transparent,
//                                         shadowColor: Colors.transparent,
//                                       ),
//                                       child: Icon(
//                                         Icons.heat_pump_rounded,
//                                         color: Colors.red,
//                                         size: 30,
//                                       ),
//                                     ),
//                                     SizedBox(width: 10),
//                                     ElevatedButton(
//                                       onPressed: () {
//                                         profileController.LikeSentReceieved(
//                                           eachProfileInfo.uid.toString(),
//                                           senderName,
//                                         );
//                                         print('Like icon tapped!');
//                                       },
//                                       style: ElevatedButton.styleFrom(
//                                         shape: CircleBorder(),
//                                         padding: EdgeInsets.all(10),
//                                         backgroundColor: Colors.transparent,
//                                         shadowColor: Colors.transparent,
//                                       ),
//                                       child: Icon(
//                                         Icons.favorite,
//                                         color: Colors.red,
//                                         size: 30,
//                                       ),
//                                     ),
//                                     SizedBox(width: 10),
//                                     ElevatedButton(
//                                       onPressed: () {
//                                         print('Close icon tapped!');
//                                       },
//                                       style: ElevatedButton.styleFrom(
//                                         shape: CircleBorder(),
//                                         padding: EdgeInsets.all(10),
//                                         backgroundColor: Colors.transparent,
//                                         shadowColor: Colors.transparent,
//                                       ),
//                                       child: Icon(
//                                         Icons.close,
//                                         color: Colors.red,
//                                         size: 30,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ],
//                     );
//                   },
//                   onStackFinished: () {
//                     print('Stack Finished');
//                   },
//                   upSwipeAllowed: true,
//                   rightSwipeAllowed: true,
//                   leftSwipeAllowed: true,
//                 ),
//               ),
//             );
//           }
//         }),
//       ),
//     );
//   }
// }

// // the version that onstart, profile picture shows
// import 'package:datingapp/controller/profile-controller.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class SwipeableProfiles extends StatefulWidget {
//   const SwipeableProfiles({super.key});

//   @override
//   State<SwipeableProfiles> createState() => _SwippingScreenState();
// }

// class _SwippingScreenState extends State<SwipeableProfiles> {
//   Profilecontroller profileController = Get.put(Profilecontroller());

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Obx(() {
//         // Check if the profile list is not empty
//         if (profileController.allUserProfileList.isEmpty) {
//           return Center(
//             child: CircularProgressIndicator(),
//           );
//         } else {
//           return PageView.builder(
//             itemCount: profileController.allUserProfileList.length,
//             controller: PageController(initialPage: 0, viewportFraction: 1),
//             scrollDirection: Axis.horizontal,
//             itemBuilder: (context, index) {
//               final eachProfileInfo =
//                   profileController.allUserProfileList[index];

//               return Stack(
//                 children: [
//                   // Display background profile image
//                   Positioned.fill(
//                     child: DecoratedBox(
//                       decoration: BoxDecoration(
//                         image: DecorationImage(
//                           image: NetworkImage(
//                             eachProfileInfo.imageProfile ?? '',
//                           ),
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                     ),
//                   ),
//                   // You can add other widgets on top of the image here
//                   Positioned(
//                     bottom: 20,
//                     left: 20,
//                     child: Text(
//                       eachProfileInfo.name ?? 'Unknown User',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ],
//               );
//             },
//           );
//         }
//       }),
//     );
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:redline/global.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swipe_cards/swipe_cards.dart';
import 'package:redline/controller/profile-controller.dart';

class SwipeableProfiles extends StatefulWidget {
  @override
  _SwipeableProfilesState createState() => _SwipeableProfilesState();
}

class _SwipeableProfilesState extends State<SwipeableProfiles> {
  String senderName = "";
  Profilecontroller profileController = Get.put(Profilecontroller());
  List<SwipeItem> swipeItems = [];
  late MatchEngine matchEngine;

  readUserData() async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(currentUserID)
        .get()
        .then((dataSnapshot) {
      setState(() {
        senderName = dataSnapshot.data()!["name"].toString();
      });
    });
  }

  @override
  void initState() {
    super.initState();
    readUserData();

    // Initialize swipeItems and matchEngine reactively inside Obx
    matchEngine = MatchEngine(swipeItems: swipeItems);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Set the gradient background for the entire scaffold
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.grey, // Start color
              Colors.grey.shade100, // End color
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        // Wrap the entire UI inside Obx to reactively rebuild on profile list changes
        child: Obx(() {
          // Check if the profile list is empty
          if (profileController.allUserProfileList.isEmpty) {
            return Center(
              child: Text(
                'No profiles found',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            );
          } else {
            // Update swipeItems and matchEngine dynamically based on profile changes
            swipeItems = profileController.allUserProfileList.map((profile) {
              return SwipeItem(
                content: profile,
                likeAction: () {
                  print('Liked ${profile.name}');
                  profileController.LikeSentReceieved(
                    profile.uid.toString(),
                    senderName,
                  );
                },
                nopeAction: () {
                  print('Disliked ${profile.name}');
                },
                superlikeAction: () {
                  print('Superliked ${profile.name}');
                  profileController.favoriteSentReceieved(
                    profile.uid.toString(),
                    senderName,
                  );
                },
              );
            }).toList();

            matchEngine = MatchEngine(swipeItems: swipeItems);

            // Swipe Cards inside a Container with margin and rounded corners
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              decoration: BoxDecoration(
                color: Colors.white
                    .withOpacity(0.1), // Slightly opaque background for cards
                borderRadius: BorderRadius.circular(25), // Rounded corners
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                    25), // Ensure the child content respects the rounded corners
                child: SwipeCards(
                  matchEngine: matchEngine,
                  itemBuilder: (context, index) {
                    final eachProfileInfo =
                        profileController.allUserProfileList[index];

                    return Stack(
                      children: [
                        // Profile Image Background
                        Positioned.fill(
                          child:
                              //   DecoratedBox(

                              //     decoration: BoxDecoration(
                              //       image: DecorationImage(
                              //         image: NetworkImage(
                              //             eachProfileInfo.imageProfile ?? ''),
                              //         fit: BoxFit.cover,
                              //       ),
                              //     ),
                              //   ),
                              // ),
                              ClipRRect(
                            borderRadius: BorderRadius.circular(
                                25), // Apply rounded corners
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(
                                      eachProfileInfo.imageProfile ?? ''),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                        // IconButton for filter
                        Align(
                          alignment: Alignment.topRight,
                          child: Padding(
                            padding: EdgeInsets.only(top: 40, right: 30),
                            child: IconButton(
                              onPressed: () {
                                // Add your onPressed functionality here
                              },
                              icon: const Icon(
                                Icons.filter_list,
                                size: 30,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),

                        // Profile info (name, buttons) in a Column layout
                        Positioned(
                          bottom: 20,
                          left: 0,
                          right: 0,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Profile name
                                Text(
                                  eachProfileInfo.name.toString(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    letterSpacing: 4,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4),

                                // Profile age and city button
                                // ElevatedButton(
                                //   onPressed: () {},
                                //   style: ElevatedButton.styleFrom(
                                //     backgroundColor:
                                //         Colors.white.withOpacity(0.5),
                                //     padding: EdgeInsets.symmetric(
                                //         horizontal: 20, vertical: 10),
                                //     shape: RoundedRectangleBorder(
                                //       borderRadius: BorderRadius.circular(30),
                                //     ),
                                //   ),
                                //   child: Text(
                                //     "${eachProfileInfo.age} ⦾ ${eachProfileInfo.city}",
                                //     style: TextStyle(
                                //       fontSize: 14,
                                //       letterSpacing: 2,
                                //       color: Colors.black,
                                //     ),
                                //   ),
                                // ),
                                Text(
                                  "${eachProfileInfo.age} ⦾ ${eachProfileInfo.city}",
                                  style: TextStyle(
                                      fontSize: 14,
                                      letterSpacing: 2,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),

                                SizedBox(height: 4),

                                // Religion button
                                ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Colors.white.withOpacity(0.2),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                  ),
                                  child: Text(
                                    "${eachProfileInfo.religion}",
                                    style: TextStyle(
                                      fontSize: 14,
                                      letterSpacing: 4,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 4),

                                // Favorite, Like, and Close buttons in a row
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        profileController.favoriteSentReceieved(
                                          eachProfileInfo.uid.toString(),
                                          senderName,
                                        );
                                        print('Favorite icon tapped!');
                                      },
                                      style: ElevatedButton.styleFrom(
                                        shape: CircleBorder(),
                                        padding: EdgeInsets.all(10),
                                        backgroundColor: Colors.transparent,
                                        shadowColor: Colors.transparent,
                                      ),
                                      child: Icon(
                                        Icons.heat_pump_rounded,
                                        color: Colors.red,
                                        size: 30,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    ElevatedButton(
                                      onPressed: () {
                                        profileController.LikeSentReceieved(
                                          eachProfileInfo.uid.toString(),
                                          senderName,
                                        );
                                        print('Like icon tapped!');
                                      },
                                      style: ElevatedButton.styleFrom(
                                        shape: CircleBorder(),
                                        padding: EdgeInsets.all(10),
                                        backgroundColor: Colors.transparent,
                                        shadowColor: Colors.transparent,
                                      ),
                                      child: Icon(
                                        Icons.favorite,
                                        color: Colors.red,
                                        size: 30,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    ElevatedButton(
                                      onPressed: () {
                                        print('Close icon tapped!');
                                      },
                                      style: ElevatedButton.styleFrom(
                                        shape: CircleBorder(),
                                        padding: EdgeInsets.all(10),
                                        backgroundColor: Colors.transparent,
                                        shadowColor: Colors.transparent,
                                      ),
                                      child: Icon(
                                        Icons.close,
                                        color: Colors.red,
                                        size: 30,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                  onStackFinished: () {
                    print('Stack Finished');
                  },
                  upSwipeAllowed: true,
                  rightSwipeAllowed: true,
                  leftSwipeAllowed: true,
                ),
              ),
            );
          }
        }),
      ),
    );
  }
}
