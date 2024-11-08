import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:redline/global.dart';
import 'package:redline/models/person.dart';
import 'package:redline/tabScreens/favorite_sent_receieved_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class Profilecontroller extends GetxController {
  final Rx<List<Person>> usersProfileList = Rx<List<Person>>([]);

  List<Person> get allUserProfileList => usersProfileList.value;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
  }

  Future<Map<String, List<String>>> generateUserImageUrlsMap(
      Profilecontroller profileController) async {
    // Initialize an empty map to store UIDs and corresponding image URLs
    Map<String, List<String>> userImageUrlsMap = {};

    if (profileController.allUserProfileList.isEmpty) {
      print("No user profiles found in the list.");
      return userImageUrlsMap; // Return early if the list is empty
    }

    // Iterate over all profiles in allUserProfileList
    for (var user in profileController.allUserProfileList) {
      if (user.uid != null) {
        print("Fetching user images for user ID: ${user.uid}");

        try {
          // Fetch the user's data from Firestore
          var snapshot = await FirebaseFirestore.instance
              .collection("users")
              .doc(user.uid)
              .get();

          if (snapshot.exists) {
            print("Snapshot exists for user ID: ${user.uid}");

            Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

            // Log the entire data to see its structure
            print("Data for user ID ${user.uid}: $data");

            // Ensure the imageUrls field exists and is a non-empty array
            if (data["imageUrls"] is List &&
                (data["imageUrls"] as List).isNotEmpty) {
              List<String> imageUrls =
                  List<String>.from(data["imageUrls"] ?? []);

              // Log the retrieved imageUrls
              print("Image URLs for user ID ${user.uid}: $imageUrls");

              // Update the map only if imageUrls is not empty
              userImageUrlsMap[user.uid!] = imageUrls;
            } else {
              print("No image URLs found for user ID: ${user.uid}");
            }
          } else {
            print("No data found for user ID: ${user.uid}");
          }
        } catch (e) {
          print("Error fetching user data for ${user.uid}: $e");
        }
      }
    }

    // Log the final userImageUrlsMap for debugging
    print("Final userImageUrlsMap: $userImageUrlsMap");

    return userImageUrlsMap;
  }

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
}
