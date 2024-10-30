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
        senderName = dataSnapshot.data()!["name"].toString();
      });
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

  Future<void> preloadProfileUserInterests() async {
    // Preload interests for all profiles
    for (var profile in profileController.allUserProfileList) {
      String profileUserId = profile.uid.toString();
      if (!interestsCache.containsKey(profileUserId)) {
        List<String> profileInterests =
            await fetchProfileUserInterests(profileUserId);
        interestsCache[profileUserId] = profileInterests;
      }
    }

    // After preloading, update swipeItems and commonInterests
    updateSwipeItems();
  }

  // Future<void> updateCommonInterests() async {
  //   currentUserInterests = await retrieveCurrentUserInterests();

  //   // Calculate common interests for each profile
  //   commonInterests = interestsCache.entries.map((entry) {
  //     String profileId = entry.key;
  //     List<String> profileInterests = entry.value;
  //     return {
  //       'profileId': profileId,
  //       'commonInterests': currentUserInterests
  //           .where((interest) => profileInterests.contains(interest))
  //           .toList()
  //     };
  //   }).toList();
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
// ========================

  // Future<List<String>> retrieveCurrentUserInterests(
  //     String currentUserID) async {
  //   List<String> interests = [];
  //   DocumentSnapshot currentUserSnapshot = await FirebaseFirestore.instance
  //       .collection("users")
  //       .doc(currentUserID)
  //       .get();

  //   if (currentUserSnapshot.exists) {
  //     // Explicitly cast the data to Map<String, dynamic>
  //     Map<String, dynamic>? data =
  //         currentUserSnapshot.data() as Map<String, dynamic>?;

  //     interests = List<String>.from(data?['interests'] ?? []);
  //     print("Current User Interests: $interests");
  //   } else {
  //     print("Current user document does not exist.");
  //   }

  //   return interests;
  // }

  // Future<List<String>> fetchProfileUserInterests(String profileUserId) async {
  //   DocumentSnapshot profileUserSnapshot = await FirebaseFirestore.instance
  //       .collection("users")
  //       .doc(profileUserId)
  //       .get();

  //   List<String> profileUserInterests = [];
  //   if (profileUserSnapshot.exists) {
  //     // Explicitly cast the data to Map<String, dynamic>
  //     Map<String, dynamic>? data =
  //         profileUserSnapshot.data() as Map<String, dynamic>?;

  //     profileUserInterests = List<String>.from(data?['interests'] ?? []);
  //     print("Profile User Interests for $profileUserId: $profileUserInterests");
  //   } else {
  //     print("Profile user document does not exist.");
  //   }

  //   return profileUserInterests;
  // }

  // Future<Map<String, List<String>>> retrieveBothInterests(
  //     String currentUserID, String profileUserId) async {
  //   List<String> currentUserInterests =
  //       await retrieveCurrentUserInterests(currentUserID);
  //   List<String> profileUserInterests =
  //       await fetchProfileUserInterests(profileUserId);

  //   return {
  //     'currentUserInterests': currentUserInterests,
  //     'profileUserInterests': profileUserInterests,
  //   };
  // }

  // Future<void> updateCommonInterests(String profileUserId) async {
  //   if (!interestsCache.containsKey(profileUserId)) {
  //     // Fetch from Firestore if not cached
  //     interestsCache[profileUserId] =
  //         await fetchProfileUserInterests(profileUserId);
  //   }

  //   // Get current user interests from Firestore if needed, or if you already have it saved, use it
  //   currentUserInterests = await retrieveCurrentUserInterests(currentUserID);

  //   // Calculate common interests
  //   setState(() {
  //     commonInterests = currentUserInterests
  //         .where((interest) =>
  //             interestsCache[profileUserId]?.contains(interest) ?? false)
  //         .toList();
  //   });
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   readUserData();

  //   // Retrieve current user interests once, if not already done
  //   retrieveCurrentUserInterests(currentUserID).then((interests) {
  //     setState(() {
  //       currentUserInterests = interests;
  //     });
  //   });

  //   // Initialize swipeItems and matchEngine
  //   matchEngine = MatchEngine(swipeItems: swipeItems);
  // }

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
                    // final profileUserId = eachProfileInfo.uid!;

                    // // Fetch interests for the currently displayed profile if not cached
                    // if (!interestsCache.containsKey(profileUserId)) {
                    //   retrieveBothInterests(currentUserID, profileUserId)
                    //       .then((interests) {
                    //     setState(() {
                    //       interestsCache[profileUserId] =
                    //           interests['currentUserInterests'] ?? [];
                    //     });
                    //   });
                    // }

                    // final currentUserInterests =
                    //     interestsCache[profileUserId] ?? [];
                    // final profileUserInterests = eachProfileInfo.interests ??
                    //     []; // Assuming interests is a List<String>

                    // final commonInterests = currentUserInterests
                    //     .where((interest) =>
                    //         profileUserInterests.contains(interest))
                    //     .toList();

                    // print("Common Interests: $commonInterests"); // Debug print

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
                                  "${eachProfileInfo.city}",
                                  // "${eachProfileInfo.age} ⦾ ${eachProfileInfo.city}",
                                  style: TextStyle(
                                      fontSize: 14,
                                      letterSpacing: 2,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "${eachProfileInfo.interests}",
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
                                                  horizontal: 20, vertical: 10),
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
                                    : Text(
                                        "No interests available",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),

                                // Wrap(
                                //   spacing: 6,
                                //   children: interestsCache[eachProfileInfo.uid]
                                //           ?.map<Widget>((interest) {
                                //         return ElevatedButton(
                                //           onPressed: () {},
                                //           style: ElevatedButton.styleFrom(
                                //             backgroundColor:
                                //                 Colors.white.withOpacity(0.2),
                                //             padding: EdgeInsets.symmetric(
                                //                 horizontal: 12, vertical: 8),
                                //             shape: RoundedRectangleBorder(
                                //               borderRadius:
                                //                   BorderRadius.circular(18),
                                //             ),
                                //           ),
                                //           child: Text(
                                //             interest,
                                //             style: TextStyle(
                                //               fontSize: 12,
                                //               color: Colors.white,
                                //             ),
                                //           ),
                                //         );
                                //       }).toList() ??
                                //       [],
                                // ),

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
                                                  horizontal: 20, vertical: 10),
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
                                    : Text(
                                        "No interests available",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                          fontStyle: FontStyle.italic,
                                        ),
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
                                    "${eachProfileInfo.email}",
                                    style: TextStyle(
                                      fontSize: 14,
                                      letterSpacing: 4,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                // commonInterests.isNotEmpty
                                //     ? Column(
                                //         crossAxisAlignment:
                                //             CrossAxisAlignment.start,
                                //         children: commonInterests
                                //             .map((interest) => Container(
                                //                   margin: EdgeInsets.symmetric(
                                //                       vertical:
                                //                           4), // Margin between items
                                //                   padding: EdgeInsets.all(
                                //                       12), // Padding inside the button
                                //                   decoration: BoxDecoration(
                                //                     color: Colors
                                //                         .blueAccent, // Background color
                                //                     borderRadius:
                                //                         BorderRadius.circular(
                                //                             8), // Rounded corners
                                //                     boxShadow: [
                                //                       BoxShadow(
                                //                         color: Colors.black
                                //                             .withOpacity(0.2),
                                //                         spreadRadius: 1,
                                //                         blurRadius: 3,
                                //                         offset: Offset(0, 1),
                                //                       ),
                                //                     ],
                                //                   ),
                                //                   child: Text(
                                //                     interest,
                                //                     style: TextStyle(
                                //                       fontSize: 14,
                                //                       color: Colors.white,
                                //                     ),
                                //                   ),
                                //                 ))
                                //             .toList(),
                                //       )
                                //     : Container(
                                //         margin:
                                //             EdgeInsets.symmetric(vertical: 4),
                                //         padding: EdgeInsets.all(12),
                                //         decoration: BoxDecoration(
                                //           color: Colors
                                //               .grey, // Background color for the default message
                                //           borderRadius:
                                //               BorderRadius.circular(8),
                                //         ),
                                //         child: Text(
                                //           "No common interests found.",
                                //           style: TextStyle(
                                //             fontSize: 14,
                                //             color: Colors.white,
                                //           ),
                                //         ),
                                //       ),
                                // SizedBox(height: 4),

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
