import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  List<String> currentUserInterests = [];
  Map<String, List<String>> interestsCache = {};
  List<String> commonInterests = [];

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

//probably not in use
  // Future<void> preloadProfileUserInterests() async {
  //   // Preload interests for all profiles
  //   for (var profile in profileController.allUserProfileList) {
  //     String profileUserId = profile.uid.toString();
  //     if (!interestsCache.containsKey(profileUserId)) {
  //       List<String> profileInterests =
  //           await fetchProfileUserInterests(profileUserId);
  //       interestsCache[profileUserId] = profileInterests;
  //     }
  //   }

  //   // After preloading, update swipeItems and commonInterests
  //   updateSwipeItems();
  // }

  void updateSwipeItems() {
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
  }

  @override
  void initState() {
    super.initState();

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

    // Retrieve current user interests once, if not already done
    // retrieveCurrentUserInterests(currentUserID).then((interests) {
    //   setState(() {
    //     currentUserInterests = interests;
    //   });
    // });

    // // Initialize swipeItems and matchEngine
    // matchEngine = MatchEngine(swipeItems: swipeItems);
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
                          child: ClipRRect(
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

                                Text(
                                  "${eachProfileInfo.uid}",
                                  style: TextStyle(
                                      fontSize: 14,
                                      letterSpacing: 2,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),

                                SizedBox(height: 4),
                                Text(
                                  "${eachProfileInfo.photoNo}",
                                  // "${eachProfileInfo.age} ⦾ ${eachProfileInfo.city}",
                                  style: TextStyle(
                                      fontSize: 14,
                                      letterSpacing: 2,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),

                                SizedBox(height: 4),
                                eachProfileInfo.interests!.isNotEmpty
                                    ? Wrap(
                                        spacing: 8.0,
                                        runSpacing: 4.0,
                                        children: eachProfileInfo.interests!
                                            .map((interest) {
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
                                                borderRadius:
                                                    BorderRadius.circular(18),
                                              ),
                                            ),
                                            child: Text(
                                              interest,
                                              style: TextStyle(
                                                fontSize: 14,
                                                letterSpacing: 4,
                                                color: Colors.black,
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      )
                                    : SizedBox(),

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
