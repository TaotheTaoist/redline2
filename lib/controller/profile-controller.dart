import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:redline/global.dart';
import 'package:redline/models/person.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:redline/tabScreens/swipping_screen.dart';

class Profilecontroller extends GetxController {
  final Rx<List<Person>> usersProfileList = Rx<List<Person>>([]);

  List<Person> get allUserProfileList => usersProfileList.value;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Rx<Map<String, List<String>>> userImageUrlsMap =
      Rx<Map<String, List<String>>>({});

  @override
  void onInit() {
    super.onInit();

    usersProfileList.bindStream(FirebaseFirestore.instance
        .collection("users")
        .where("uid", isNotEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .snapshots()
        .map((QuerySnapshot queryDataSnapshot) {
      List<Person> profilesList = [];

      // Debugging
      print(
          'Number of profiles fetched: ${queryDataSnapshot.size} - profile-controller');
      if (queryDataSnapshot.size == 0) {
        print('No profiles found');
      }

      for (var eachProfile in queryDataSnapshot.docs) {
        // print('Profile data: ${eachProfile.data()}');
        profilesList.add(Person.fromDataSnapshot(eachProfile));
      }

      return profilesList;
    }).handleError((error) {
      print('Error fetching profiles: $error');
    }));
    // Use `ever()` to watch the usersProfileList and call fetchUserImageUrlsMap once profiles are loaded
    ever(usersProfileList, (_) {
      if (usersProfileList.value.isNotEmpty) {
        // Call the method to fetch image URLs only after the profiles are loaded
        fetchUserImageUrlsMap();
      }
    });

    print("Profile Controller Initialized");
    print("Function finished at: ${DateTime.now()} Profile Controller ");
    // SwipeableProfiles().selectedUserUid = profileController.userImageUrlsMap.value[0] as String;
  }

  Future<void> fetchUserImageUrlsMap() async {
    // isLoading.value = true;
    Map<String, List<String>> resultMap = {};

    try {
      if (allUserProfileList.isEmpty) {
        usersProfileList.bindStream(_firestore
            .collection("users")
            .where("uid", isNotEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .snapshots()
            .map((QuerySnapshot query) {
          print("profile exists");
          return query.docs.map((doc) => Person.fromDataSnapshot(doc)).toList();
        }));
      }

      for (var user in allUserProfileList) {
        if (user.uid != null) {
          var snapshot =
              await _firestore.collection("users").doc(user.uid).get();
          if (snapshot.exists) {
            Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
            if (data["imageUrls"] is List &&
                (data["imageUrls"] as List).isNotEmpty) {
              resultMap[user.uid!] = List<String>.from(data["imageUrls"] ?? []);
            }
          }
        }
      }
      userImageUrlsMap.value = resultMap;
      print(
          "userImageUrlsMap from profilecontroller original func ${userImageUrlsMap}");
      // print("userImageUrlsMap.value: ${userImageUrlsMap.value}");
    } catch (e) {
      print("Error fetching profiles: $e");
    } finally {
      // isLoading.value = false;
    }
  }
  // Future<Map<String, List<String>>> generateUserImageUrlsMap() async {
  //   // Initialize an empty map to store UIDs and corresponding image URLs
  //   Map<String, List<String>> userImageUrlsMap = {};

  //   if (allUserProfileList.isEmpty) {
  //     print("No user profiles found in the list.");
  //     return userImageUrlsMap; // Return early if the list is empty
  //   }

  //   // Iterate over all profiles in allUserProfileList
  //   for (var user in allUserProfileList) {
  //     if (user.uid != null) {
  //       print("Fetching user images for user ID: ${user.uid}");

  //       try {
  //         // Fetch the user's data from Firestore
  //         var snapshot =
  //             await _firestore.collection("users").doc(user.uid).get();

  //         if (snapshot.exists) {
  //           print("Snapshot exists for user ID: ${user.uid}");

  //           Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

  //           // Log the entire data to see its structure
  //           print("Data for user ID ${user.uid}: $data");

  //           // Ensure the imageUrls field exists and is a non-empty array
  //           if (data["imageUrls"] is List &&
  //               (data["imageUrls"] as List).isNotEmpty) {
  //             List<String> imageUrls =
  //                 List<String>.from(data["imageUrls"] ?? []);

  //             // Log the retrieved imageUrls
  //             print("Image URLs for user ID ${user.uid}: $imageUrls");

  //             // Update the map only if imageUrls is not empty
  //             userImageUrlsMap[user.uid!] = imageUrls;
  //           } else {
  //             print("No image URLs found for user ID: ${user.uid}");
  //           }
  //         } else {
  //           print("No data found for user ID: ${user.uid}");
  //         }
  //       } catch (e) {
  //         print("Error fetching user data for ${user.uid}: $e");
  //       }
  //     }
  //   }

  //   // Log the final userImageUrlsMap for debugging
  //   print("Final userImageUrlsMap: $userImageUrlsMap");

  //   return userImageUrlsMap;
  // }

  favoriteSentReceieved(String toUserID, String senderName) async {
    var receivedDocRef = FirebaseFirestore.instance
        .collection("users")
        .doc(toUserID)
        .collection("favoriteReceived")
        .doc(currentUserID);

    var sentDocRef = FirebaseFirestore.instance
        .collection("users")
        .doc(currentUserID)
        .collection("favoriteSent")
        .doc(toUserID);

    var receivedDoc = await receivedDocRef.get();

    // Check if the favorite already exists
    if (receivedDoc.exists) {
      // If the favorite exists, remove it from both locations
      await receivedDocRef.delete();
      await sentDocRef.delete();
      print("Favorite removed for ${receivedDoc.id}");
    } else {
      // If the favorite does not exist, add it to both locations
      await receivedDocRef.set({
        'senderName': senderName,
        'timestamp': FieldValue.serverTimestamp(),
      });

      await sentDocRef.set({
        'senderName': senderName,
        'timestamp': FieldValue.serverTimestamp(),
      });
      print("Favorite added for ${receivedDocRef.id}");
    }
  }

  Future<void> LikeSentReceieved(String toUserID, String senderName) async {
    try {
      // Check if toUserID and currentUserID are not empty
      assert(toUserID.isNotEmpty, "toUserID is empty");
      assert(currentUserID.isNotEmpty, "currentUserID is empty");

      // Check if the like already exists
      var document = await FirebaseFirestore.instance
          .collection("users")
          .doc(toUserID)
          .collection("LikeReceived")
          .doc(currentUserID)
          .get();

      // If the like does not exist, add it
      if (!document.exists) {
        // Add like to the target user's `LikeReceived`
        await FirebaseFirestore.instance
            .collection("users")
            .doc(toUserID)
            .collection("LikeReceived")
            .doc(currentUserID)
            .set({
          'senderName': senderName,
          'timestamp': FieldValue.serverTimestamp(),
        });

        // Add like to the current user's `LikeSent`
        await FirebaseFirestore.instance
            .collection("users")
            .doc(currentUserID)
            .collection("LikeSent")
            .doc(toUserID)
            .set({
          'senderName': senderName,
          'timestamp': FieldValue.serverTimestamp(),
        });
      } else {
        // Optionally, provide feedback that the like already exists
        print("You have already liked this user.");
      }
    } catch (e) {
      // Handle errors here (e.g., log the error)
      print("Error while sending like: $e");
    }
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
}
