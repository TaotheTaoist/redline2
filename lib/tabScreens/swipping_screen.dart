import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:redline/global.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redline/models/person.dart';
import 'package:swipe_cards/swipe_cards.dart';
import 'package:redline/controller/profile-controller.dart';

class SwipeableProfiles extends StatefulWidget {
  @override
  _SwipeableProfilesState createState() => _SwipeableProfilesState();
}

class _SwipeableProfilesState extends State<SwipeableProfiles> {
  // for images
  // =============================================================================================
  List<String> urlsList = [];

  Map<String, List<String>> userImageUrlsMap = {};

  final List<String> placeholderUrls = [
    'https://firebasestorage.googleapis.com/v0/b/dating-app-18f5d.appspot.com/o/placeholder%2FprofileAvatar.png?alt=media&token=a1fb4ae4-c16a-44fe-8ac7-858c0be0f5b3',
    'https://firebasestorage.googleapis.com/v0/b/dating-app-18f5d.appspot.com/o/placeholder%2FprofileAvatar.png?alt=media&token=a1fb4ae4-c16a-44fe-8ac7-858c0be0f5b3',
    'https://firebasestorage.googleapis.com/v0/b/dating-app-18f5d.appspot.com/o/placeholder%2FprofileAvatar.png?alt=media&token=a1fb4ae4-c16a-44fe-8ac7-858c0be0f5b3',
    'https://firebasestorage.googleapis.com/v0/b/dating-app-18f5d.appspot.com/o/placeholder%2FprofileAvatar.png?alt=media&token=a1fb4ae4-c16a-44fe-8ac7-858c0be0f5b3',
    'https://firebasestorage.googleapis.com/v0/b/dating-app-18f5d.appspot.com/o/placeholder%2FprofileAvatar.png?alt=media&token=a1fb4ae4-c16a-44fe-8ac7-858c0be0f5b3',
    'https://firebasestorage.googleapis.com/v0/b/dating-app-18f5d.appspot.com/o/placeholder%2FprofileAvatar.png?alt=media&token=a1fb4ae4-c16a-44fe-8ac7-858c0be0f5b3',
  ];

  final String placeholderUrl =
      'https://your-placeholder-image-url.com/image.png';
  int currentIndex = 0;

  late MatchEngine matchEngine;
  bool isLoading = true;
  String nowImage = '';
  String lateImage = '';
  // =============================================================================================
  String stableUID = "";
  Map<String, int> profilePhotoIndexes = {};

  String senderName = "";
  Profilecontroller profileController = Get.put(Profilecontroller());

  List<SwipeItem> swipeItems = [];
  List<SwipeItem> swipeItemsuid = [];

  List<String> currentUserInterests = [];
  Map<String, List<String>> interestsCache = {};
  List<String> commonInterests = [];

  Future<Map<String, List<String>>> generateUserImageUrlsMap(
      Profilecontroller profileController) async {
    // Initialize an empty map to store UIDs and corresponding image URLs

    if (profileController.allUserProfileList.isEmpty) {
      print("No user profiles found in the list.");
      return userImageUrlsMap; // Return early if the list is empty
    }

    // Iterate over all profiles in allUserProfileList
    for (var user in profileController.allUserProfileList) {
      if (user.uid != null) {
        print(
            "Fetching user images for user ID: ${user.uid}  generateUserImageUrlsMap");
        var snapshot = await FirebaseFirestore.instance
            .collection("users")
            .doc(user.uid)
            .get();

        if (snapshot.exists) {
          print(
              "Snapshot exists for user ID: ${user.uid} generateUserImageUrlsMap");
          Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

          // Log the entire data to see its structure
          print("Data for user ID ${user.uid}: $data");

          // Ensure the imageUrls field exists and is a non-empty array
          if (data["imageUrls"] is List &&
              (data["imageUrls"] as List).isNotEmpty) {
            List<String> imageUrls = List<String>.from(data["imageUrls"] ?? []);

            // Log the retrieved imageUrls
            print("Image URLs for user ID ${user.uid}: $imageUrls");

            // Update the map only if imageUrls is not empty
            userImageUrlsMap[user.uid!] = imageUrls;
          } else {
            print("No image URLs found for user ID: ${user.uid}");
          }
        } else {
          print(
              "No data found for user ID: ${user.uid} generateUserImageUrlsMap");
        }
      }
    }

    print("Final userImageUrlsMap: $userImageUrlsMap");
    return userImageUrlsMap;
  }

  String getNextImageUrl(Map<String, List<String>> userImageUrlsMap,
      String userId, int currentIndex) {
    // Check if the userId is not empty and exists in the map
    if (userId.isEmpty || !userImageUrlsMap.containsKey(userId)) {
      print("User ID is empty or does not exist in the map. getNextImageUrl");
      return ""; // Return null or handle as needed
    }
    print("currentIndex:$currentIndex) getNextImageUrl");

    // Get the list of image URLs for the specified user ID
    List<String> imageUrls = userImageUrlsMap[userId]!;

    // Ensure the imageUrls list is not empty
    if (imageUrls.isEmpty) {
      print("No image URLs found for user ID: $userId. getNextImageUrl");
      return ""; // Return null if there are no image URLs
    }

    // Increment the index, ensuring it wraps around to the start if it exceeds the list length
    currentIndex = (currentIndex + 1); // Use modulo to wrap around

    // Return the image URL at the new index
    return imageUrls[currentIndex];
  }

  String?
      lastFetchedUserID; // Track the last fetched user ID globally or within a relevant class

  Future<List<String>> retrieveUserImages(String userID) async {
    if (lastFetchedUserID == userID) {
      print(
          "User ID is the same as the last fetched. Skipping fetch. retrieveUserImages etNextImageUrl");
      return urlsList; // Return current urlsList if ID hasn't changed
    }

    lastFetchedUserID = userID;
    print("Starting to fetch user images... etNextImageUrl");

    try {
      isLoading = true;
      urlsList = [];
      nowImage = "";

      print("Fetching user images for user ID: $userID");
      var snapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(userID)
          .get();

      if (snapshot.exists) {
        print("Snapshot exists for user ID: $userID");
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        List<String> imageUrls = List<String>.from(data["imageUrls"] ?? []);

        urlsList = imageUrls; // Directly set urlsList

        // Set nowImage if urlsList is not empty
        if (urlsList.isNotEmpty) {
          nowImage = urlsList[currentIndex];
        } else {
          nowImage = "";
        }

        print("Fetched image URLs: $urlsList retrieveUserImages()");
      } else {
        print("No document found for user ID: $userID");
        urlsList = [];
        nowImage = "";
      }

      isLoading = false;
    } catch (e) {
      print("Error fetching images: $e");
      urlsList = [];
      nowImage = "";
      isLoading = false;
    }

    return urlsList; // Return the fetched urlsList
  }

  readUserData() async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(currentUserID)
        .get()
        .then((dataSnapshot) {
      setState(() {
        // Retrieve and set the sender's name
        senderName = dataSnapshot.data()?["name"]?.toString() ?? "No name";

        // Print the entire document data
        print("readUserData() - Data snapshot: ${dataSnapshot.data()}");

        // Print the specific field value (senderName)
        print("Sender name: $senderName");
      });
    }).catchError((error) {
      // Handle potential errors (optional)
      print("Error fetching data: $error");
    });
  }

// =============
  Future<List<String>> retrieveCurrentUserInterests() async {
    List<String> interests = [];
    DocumentSnapshot currentUserSnapshot = await FirebaseFirestore.instance
        .collection("users")
        .doc(currentUserID)
        .get();

    if (currentUserSnapshot.exists) {
      Map<String, dynamic>? data =
          currentUserSnapshot.data() as Map<String, dynamic>?;

      interests = List<String>.from(data?['interests'] ?? []);
      print("Current User Interests: $interests");
    } else {
      print("Current user document does not exist.");
    }

    return interests;
  }

  Future<List<String>> fetchProfileUserInterests(String profileUserId) async {
    DocumentSnapshot profileUserSnapshot = await FirebaseFirestore.instance
        .collection("users")
        .doc(profileUserId)
        .get();

    List<String> profileUserInterests = [];
    if (profileUserSnapshot.exists) {
      Map<String, dynamic>? data =
          profileUserSnapshot.data() as Map<String, dynamic>?;

      profileUserInterests = List<String>.from(data?['interests'] ?? []);
      print("Profile User Interests for $profileUserId: $profileUserInterests");
    } else {
      print("Profile user document does not exist.");
    }

    return profileUserInterests;
  }

  Future<void> updateSwipeItemsInitonly() async {
    //this function makes sure urlsList are generated and the currentIndex must be 0
// =========================================================================
    if (profileController.allUserProfileList.isNotEmpty) {
      print(
          'First Profile ID: ${profileController.allUserProfileList[0].uid} in updateSwipeItemsInitonly()');

      print(
          'profileController.allUserProfileList: ${profileController.allUserProfileList[0]} in updateSwipeItemsInitonly()');

      await generateUserImageUrlsMap(profileController);
      print("userImageUrlsMap:$userImageUrlsMap updateSwipeItemsInitonly() ");
// =========================================================================

      // Await retrieveUserImages and get the fetched image URLs
      // List<String> fetchedUrlsList = await retrieveUserImages(
      //     profileController.allUserProfileList[0].uid!);

      // // Now you can work with the fetchedUrlsList which is updated
      // print("why: $fetchedUrlsList updateSwipedIteminitOnly");
      // print("the length${urlsList.length} updateSwipeItemsInitonly");

      // ======================below lines are causing issue

      // swipeItems = profileController.allUserProfileList.map((profile) {
      //   return SwipeItem(
      //     content: profile,
      //     likeAction: () {},
      //     nopeAction: () {},
      //     superlikeAction: () {},
      //   );
      // }).toList();

      // matchEngine = MatchEngine(swipeItems: swipeItems);
    }
  }

  // void updateSwipeItems() {
  //   swipeItems = profileController.allUserProfileList.map((profile) {
  //     // Assuming 'content' is the field in SwipeItem holding the data you want to print
  //     return SwipeItem(content: profile.imageProfile);
  //   }).toList();

  //   if (profileController.allUserProfileList.isNotEmpty) {
  //     // Print the ID of the first profile
  //     print(
  //         'First Profile ID: ${profileController.allUserProfileList[0].uid} updateSwipeItems()');
  //     print("swipeItems contents:");

  //     // Loop through each SwipeItem to print its content
  //     for (var item in swipeItems) {
  //       print(
  //           "item.content ${item.content} updateSwipeItems()"); // Assuming 'content' holds the data you want to display
  //     }
  //     matchEngine = MatchEngine(swipeItems: swipeItems);
  //   }
  // }
  // Future<void> updateSwipeItems() async {
  //   // Assuming allUserProfileList might be populated asynchronously

  //   swipeItems = profileController.allUserProfileList.map((profile) {
  //     // Assuming 'content' is the field in SwipeItem holding the data you want to print
  //     return SwipeItem(content: profile.imageProfile);
  //   }).toList();

  //   if (profileController.allUserProfileList.isNotEmpty) {
  //     // Print the ID of the first profile
  //     print(
  //         'First Profile ID: ${profileController.allUserProfileList[0].uid} updateSwipeItems()');
  //     print("swipeItems contents:");

  //     // Loop through each SwipeItem to print its content
  //     for (var item in swipeItems) {
  //       print("item.content ${item.content} updateSwipeItems()");
  //     }

  //     // Since matchEngine is assigned synchronously here, you don’t need async/await for this line
  //     matchEngine = MatchEngine(swipeItems: swipeItems);
  //   }
  // }
  Future<void> updateSwipeItems() async {
    if (currentIndex == 0) {
      // Create swipeItems from the user profiles
      swipeItems = profileController.allUserProfileList.map((profile) {
        return SwipeItem(content: profile.imageProfile);
      }).toList();

      swipeItemsuid = profileController.allUserProfileList.map((profile) {
        return SwipeItem(content: profile.uid);
      }).toList();

      print("swipeItemsuid: $swipeItemsuid updateSwipeItems()");

      if (swipeItems.isNotEmpty) {
        // Print the ID of the first profile
        print(
            'First Profile ID: ${profileController.allUserProfileList[0].uid} updateSwipeItems()');
        print("swipeItems contents:");

        // Loop through each SwipeItem to print its content
        for (var item in swipeItems) {
          print("item.content ${item.content} updateSwipeItems()");
        }

        for (var item in swipeItemsuid) {
          print("swipeItemsuid ${item.content} updateSwipeItems()");
        }

        // Initialize matchEngine only if swipeItems is not empty
        matchEngine = MatchEngine(swipeItems: swipeItems);
      }
    } else {
      if (profileController.allUserProfileList.isNotEmpty &&
          userImageUrlsMap.isNotEmpty) {
        // Get the URL from userImageUrlsMap for the first key
        String newImageUrl =
            await userImageUrlsMap[userImageUrlsMap.keys.elementAt(0)]?.first ??
                '';

        // Change the image profile of the first user
        profileController.allUserProfileList[0].imageProfile = newImageUrl;

        // Re-create the swipeItems based on updated profile image
        swipeItems = profileController.allUserProfileList.map((profile) {
          return SwipeItem(content: profile.imageProfile);
        }).toList();

        // Optionally, if you want to print the change for verification
        print("Updated first profile's image to: $newImageUrl");
      }

      // Reinitialize matchEngine with updated swipeItems
      matchEngine = MatchEngine(swipeItems: swipeItems);
    }
  }

  @override
  void initState() {
    super.initState();
    updateSwipeItems();
    // profileController.usersProfileList.bindStream(FirebaseFirestore.instance
    //     .collection("users")
    //     .where("uid", isNotEqualTo: FirebaseAuth.instance.currentUser!.uid)
    //     .snapshots()
    //     .map((QuerySnapshot queryDataSnapshot) {
    //   List<Person> profilesList = [];

    //   // Debugging
    //   print(
    //       'Number of profiles fetched: ${queryDataSnapshot.size} - profile-controller');
    //   if (queryDataSnapshot.size == 0) {
    //     print('No profiles found');
    //   }

    //   for (var eachProfile in queryDataSnapshot.docs) {
    //     profilesList.add(Person.fromDataSnapshot(eachProfile));
    //   }

    //   return profilesList;
    // }).handleError((error) {
    //   print('Error fetching profiles: $error');
    // }));

    ever(profileController.usersProfileList, (_) {
      if (profileController.allUserProfileList.isNotEmpty) {
        updateSwipeItemsInitonly();
      }
    });

    // the function below solves this issue
// Error while sending like: 'package:redline/controller/profile-controller.dart': Failed assertion: line 334 pos 14: 'currentUserID.isNotEmpty': currentUserID is empty
// I/flutter (11412): Like icon tapped!
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        // User is logged in
        currentUserID = user.uid; // Set the global variable
        readUserData(); // Fetch user data after login
      } else {
        // User is logged out
        currentUserID = ''; // Clear the current user ID
      }
    });
    print("Current User ID: $currentUserID");
    // readUserData();

    // // Initialize swipeItems and matchEngine
    // matchEngine = MatchEngine(swipeItems: swipeItems);
    print("currentIndex$currentIndex at init");
  }

  @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [
//               Colors.grey,
//               Colors.grey.shade100,
//             ],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//         ),
//         child: Obx(() {
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
//           }

//           // Call updateSwipeItems to refresh swipe items and matchEngine

//           updateSwipeItems();
//           //  indexImage(index, eachProfileInfo.imageProfile!);

//           return Container(
//             margin: EdgeInsets.only(left: 15, right: 15, top: 40, bottom: 15),
//             decoration: BoxDecoration(
//               color: Colors.white.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(25),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.2),
//                   spreadRadius: 5,
//                   blurRadius: 7,
//                   offset: Offset(0, 3),
//                 ),
//               ],
//             ),
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(25),
//               child: SwipeCards(
//                 matchEngine: matchEngine,
//                 itemBuilder: (context, index) {
//                   double screenWidth = MediaQuery.of(context).size.width;
//                   double screenHeight = MediaQuery.of(context).size.height;
//                   // print("screenWidth:$screenWidth");
//                   // print("screenHeight:$screenHeight");

//                   //important to generate current and next profile first profile
// // =========================================================================
//                   final eachProfileInfo =
//                       profileController.allUserProfileList[index];
//                   print("builder:$index ");
//                   // nowImage = eachProfileInfo.imageProfile ?? '';
// // =========================================================================
// // swipeItems[index].content
//                   // indexImage(currentIndex, eachProfileInfo.imageProfile!);
//                   // stableUID = eachProfileInfo.uid!;

//                   // print("stableUID:$stableUID");
//                   return Stack(
//                     children: [
//                       Positioned.fill(
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.circular(25),
//                           child: DecoratedBox(
//                             decoration: BoxDecoration(
//                               image: DecorationImage(
//                                 image: NetworkImage(swipeItems[index].content),
//                                 // NetworkImage(imageToDisplay),

//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                       Align(
//                         alignment: Alignment.topRight,
//                         child: Padding(
//                           padding: EdgeInsets.only(top: 40, right: 30),
//                           child: IconButton(
//                             onPressed: () {
//                               // Add your onPressed functionality here
//                             },
//                             icon: const Icon(
//                               Icons.filter_list,
//                               size: 30,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ),
//                       ),
//                       Positioned(
//                         bottom: 20,
//                         left: 0,
//                         right: 0,
//                         child: Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                           child: Column(
//                             mainAxisSize: MainAxisSize.min,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               Text(
//                                 eachProfileInfo.name.toString(),
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 24,
//                                   letterSpacing: 4,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               SizedBox(height: 4),
//                               Text(
//                                 "${eachProfileInfo.uid}",
//                                 style: TextStyle(
//                                     fontSize: 14,
//                                     letterSpacing: 2,
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.bold),
//                               ),
//                               SizedBox(height: 4),
//                               Text(
//                                 "${eachProfileInfo.photoNo}",
//                                 style: TextStyle(
//                                     fontSize: 14,
//                                     letterSpacing: 1,
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.bold),
//                               ),
//                               SizedBox(height: 3),
//                               eachProfileInfo.interests!.isNotEmpty
//                                   ? Wrap(
//                                       spacing: 8.0,
//                                       runSpacing: 4.0,
//                                       children: eachProfileInfo.interests!
//                                           .map((interest) {
//                                         return ElevatedButton(
//                                           onPressed: () {
//                                             // Define your action here if needed
//                                           },
//                                           style: ElevatedButton.styleFrom(
//                                             backgroundColor:
//                                                 Colors.white.withOpacity(0.2),
//                                             padding: EdgeInsets.symmetric(
//                                                 horizontal: 4, vertical: 4),
//                                             shape: RoundedRectangleBorder(
//                                               borderRadius:
//                                                   BorderRadius.circular(18),
//                                             ),
//                                           ),
//                                           child: Text(
//                                             interest,
//                                             style: TextStyle(
//                                               fontSize: 14,
//                                               letterSpacing: 4,
//                                               color: const Color.fromARGB(
//                                                   255, 255, 255, 255),
//                                             ),
//                                           ),
//                                         );
//                                       }).toList(),
//                                     )
//                                   : SizedBox(),
//                               SizedBox(height: 4),
//                               ElevatedButton(
//                                 onPressed: () {},
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor:
//                                       Colors.white.withOpacity(0.2),
//                                   padding: EdgeInsets.symmetric(
//                                       horizontal: 20, vertical: 10),
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(18),
//                                   ),
//                                 ),
//                                 child: Text(
//                                   "${eachProfileInfo.email}",
//                                   style: TextStyle(
//                                     fontSize: 14,
//                                     letterSpacing: 4,
//                                     color: Colors.black,
//                                   ),
//                                 ),
//                               ),
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   ElevatedButton(
//                                     onPressed: () {
//                                       profileController.favoriteSentReceieved(
//                                         eachProfileInfo.uid.toString(),
//                                         senderName,
//                                       );
//                                       print('Favorite icon tapped!');
//                                     },
//                                     style: ElevatedButton.styleFrom(
//                                       shape: CircleBorder(),
//                                       padding: EdgeInsets.all(10),
//                                       backgroundColor: Colors.transparent,
//                                       shadowColor: Colors.transparent,
//                                     ),
//                                     child: Icon(
//                                       Icons.heat_pump_rounded,
//                                       color: Colors.red,
//                                       size: 30,
//                                     ),
//                                   ),
//                                   SizedBox(width: 4),
//                                   ElevatedButton(
//                                     onPressed: () {
//                                       profileController.LikeSentReceieved(
//                                         eachProfileInfo.uid.toString(),
//                                         senderName,
//                                       );
//                                       print('Like icon tapped!');
//                                     },
//                                     style: ElevatedButton.styleFrom(
//                                       shape: CircleBorder(),
//                                       padding: EdgeInsets.all(10),
//                                       backgroundColor: Colors.transparent,
//                                       shadowColor: Colors.transparent,
//                                     ),
//                                     child: Icon(
//                                       Icons.favorite,
//                                       color: Colors.red,
//                                       size: 30,
//                                     ),
//                                   ),
//                                   SizedBox(width: 4),
//                                   ElevatedButton(
//                                     onPressed: () {
//                                       print('Close icon tapped!');
//                                     },
//                                     style: ElevatedButton.styleFrom(
//                                       shape: CircleBorder(),
//                                       padding: EdgeInsets.all(10),
//                                       backgroundColor: Colors.transparent,
//                                       shadowColor: Colors.transparent,
//                                     ),
//                                     child: Icon(
//                                       Icons.close,
//                                       color: Colors.red,
//                                       size: 30,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       // Row with GestureDetector wrapped boxes
//                       Positioned(
//                         bottom: 100,
//                         left: 0,
//                         right: 0,
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             GestureDetector(
//                               onTap: () {
//                                 // Action for left box tap
//                                 print('Left box tapped!');

//                                 // print(urlsList);
//                                 // print("index:$index");
//                                 // print(
//                                 //     "eachprofile info:${eachProfileInfo.imageProfile}");
//                                 print(eachProfileInfo.uid!);
//                                 // retrieveUserImages(eachProfileInfo.uid!);
//                                 // decreaseIndex();
//                                 // indexImage(currentIndex,
//                                 //     eachProfileInfo.imageProfile!);
//                               },
//                               child: Container(
//                                 width: screenWidth / 2.5,
//                                 height: screenHeight - 70,
//                                 decoration: BoxDecoration(
//                                   color: Colors.transparent,
//                                   borderRadius: BorderRadius.circular(15),
//                                 ),
//                               ),
//                             ),
//                             GestureDetector(
//                               onTap: () {
//                                 setState(() {
//                                   print('Right box tapped!');
//                                   print(userImageUrlsMap.keys.elementAt(0));
//                                   print(userImageUrlsMap[userImageUrlsMap.keys
//                                               .elementAt(0)]
//                                           ?.first ??
//                                       '');
//                                   print(
//                                       "eachProfileInfo.uid! ${eachProfileInfo.uid!}");
//                                   // print("index:$index");
//                                   print(
//                                       "swipeItems[index].content${swipeItemsuid[index].content} line 763");

//                                   print(
//                                       "swipeItems[index].content${swipeItems[index].content}");
//                                   nowImage = getNextImageUrl(userImageUrlsMap,
//                                       eachProfileInfo.uid!, currentIndex);
//                                   print("nowImage:$nowImage line 768");
//                                 });

//                                 currentIndex++;
//                                 print(currentIndex);

//                                 // Action for right box tap
//                               },
//                               child: Container(
//                                 width: screenWidth / 2.5,
//                                 height: screenHeight - 70,
//                                 decoration: BoxDecoration(
//                                   color: Colors.blue.withOpacity(0.5),
//                                   borderRadius: BorderRadius.circular(15),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   );
//                 },
//                 onStackFinished: () {
//                   print('Stack Finished');
//                 },
//                 upSwipeAllowed: true,
//                 rightSwipeAllowed: true,
//                 leftSwipeAllowed: true,
//               ),
//             ),
//           );
//         }),
//       ),
//     );
//   }
  @override
  Widget build(BuildContext context) {
    updateSwipeItems();
    return Container(
      margin: EdgeInsets.only(left: 15, right: 15, top: 40, bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(25),
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
        borderRadius: BorderRadius.circular(25),
        child: SwipeCards(
          matchEngine: matchEngine,
          itemBuilder: (context, index) {
            double screenWidth = MediaQuery.of(context).size.width;
            double screenHeight = MediaQuery.of(context).size.height;

            final eachProfileInfo = profileController.allUserProfileList[index];
            print("builder:$index ");

            return Stack(
              children: [
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(swipeItems[index].content),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
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
                Positioned(
                  bottom: 20,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
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
                        Text(
                          "${eachProfileInfo.uid}",
                          style: TextStyle(
                            fontSize: 14,
                            letterSpacing: 2,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "${eachProfileInfo.photoNo}",
                          style: TextStyle(
                            fontSize: 14,
                            letterSpacing: 1,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 3),
                        eachProfileInfo.interests!.isNotEmpty
                            ? Wrap(
                                spacing: 8.0,
                                runSpacing: 4.0,
                                children:
                                    eachProfileInfo.interests!.map((interest) {
                                  return ElevatedButton(
                                    onPressed: () {
                                      // Define your action here if needed
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Colors.white.withOpacity(0.2),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 4, vertical: 4),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(18),
                                      ),
                                    ),
                                    child: Text(
                                      interest,
                                      style: TextStyle(
                                        fontSize: 14,
                                        letterSpacing: 4,
                                        color: const Color.fromARGB(
                                            255, 255, 255, 255),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              )
                            : SizedBox(),
                        SizedBox(height: 4),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white.withOpacity(0.2),
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                          child: Text(
                            "${eachProfileInfo.email}",
                            style: TextStyle(
                              fontSize: 14,
                              letterSpacing: 4,
                              color: Colors.black,
                            ),
                          ),
                        ),
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
                            SizedBox(width: 4),
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
                            SizedBox(width: 4),
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
                Positioned(
                  bottom: 100,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          // Action for left box tap
                          print('Left box tapped!');
                          print(eachProfileInfo.uid!);
                        },
                        child: Container(
                          width: screenWidth / 2.5,
                          height: screenHeight - 70,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            print('Right box tapped!');
                            nowImage = getNextImageUrl(userImageUrlsMap,
                                eachProfileInfo.uid!, currentIndex);
                            currentIndex++;
                            print(currentIndex);
                          });
                        },
                        child: Container(
                          width: screenWidth / 2.5,
                          height: screenHeight - 70,
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    ],
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
}
