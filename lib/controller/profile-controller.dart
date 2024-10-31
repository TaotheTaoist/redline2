import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:redline/global.dart';
import 'package:redline/models/person.dart';
import 'package:redline/tabScreens/favorite_sent_receieved_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class Profilecontroller extends GetxController {
  final Rx<List<Person>> usersProfileList = Rx<List<Person>>([]);

  List<Person> get allUserProfileList => usersProfileList.value;

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

  // version 1, if click twice, it deletes
  // favoriteSentReceieved(String toUserID, String senderName) async {
  //   var document = await FirebaseFirestore.instance
  //       .collection("users")
  //       .doc(toUserID)
  //       .collection("favoriteReceived")
  //       .doc(currentUserID)
  //       .get();

  //   //remove the favorite from database
  //   if (document.exists) {
  //     //remove currentId from the favoriteReceieve List of that profile person [toUserID]
  //     await FirebaseFirestore.instance
  //         .collection("users")
  //         .doc(toUserID)
  //         .collection("favoriteReceived")
  //         .doc(currentUserID)
  //         .delete();

  //     //remove profile person [toUserID] from the favoriteReceieve List of the currentUser
  //     await FirebaseFirestore.instance
  //         .collection("users")
  //         .doc(currentUserID)
  //         .collection("favoriteSent")
  //         .doc(toUserID)
  //         .delete();
  //   } else
  //   // mark  as favorite // add favorite in database
  //   {
  //     await FirebaseFirestore.instance
  //         .collection("users")
  //         .doc(toUserID)
  //         .collection("favoriteReceived")
  //         .doc(currentUserID)
  //         .set({
  //       'senderName': senderName,
  //       'timestamp': FieldValue.serverTimestamp(),
  //     });

  //     await FirebaseFirestore.instance
  //         .collection("users")
  //         .doc(currentUserID)
  //         .collection("favoriteSent")
  //         .doc(toUserID)
  //         .set({
  //       'senderName': senderName,
  //       'timestamp': FieldValue.serverTimestamp(),
  //     });
  //   }
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

// no delete version
//   favoriteSentReceieved(String toUserID, String senderName) async {
//     var receivedDocRef = FirebaseFirestore.instance
//         .collection("users")
//         .doc(toUserID)
//         .collection("favoriteReceived")
//         .doc(currentUserID);

//     var sentDocRef = FirebaseFirestore.instance
//         .collection("users")
//         .doc(currentUserID)
//         .collection("favoriteSent")
//         .doc(toUserID);

//     var receivedDoc = await receivedDocRef.get();

//     // Check if the favorite already exists
//     if (receivedDoc.exists) {
//       // If the favorite exists, do nothing
//       print("Favorite already exists for ${receivedDoc.id}");
//       return;
//     }

//     // If the favorite does not exist, add it to both locations
//     await receivedDocRef.set({
//       'senderName': senderName,
//       'timestamp': FieldValue.serverTimestamp(),
//     });

//     await sentDocRef.set({
//       'senderName': senderName,
//       'timestamp': FieldValue.serverTimestamp(),
//     });

//     print("Favorite added for ${receivedDocRef.id}");
//   }

  // version2 doesnt delete if click twice
  // favoriteSentReceieved(String toUserID, String senderName) async {
  //   var document = await FirebaseFirestore.instance
  //       .collection("users")
  //       .doc(toUserID)
  //       .collection("favoriteReceived")
  //       .doc(currentUserID)
  //       .get();

  //   // Check if the favorite already exists
  //   if (!document.exists) {
  //     // Mark as favorite and add to the database
  //     await FirebaseFirestore.instance
  //         .collection("users")
  //         .doc(toUserID)
  //         .collection("favoriteReceived")
  //         .doc(currentUserID)
  //         .set({
  //       'senderName': senderName,
  //       'timestamp': FieldValue.serverTimestamp(),
  //     });

  //     await FirebaseFirestore.instance
  //         .collection("users")
  //         .doc(currentUserID)
  //         .collection("favoriteSent")
  //         .doc(toUserID)
  //         .set({
  //       'senderName': senderName,
  //       'timestamp': FieldValue.serverTimestamp(),
  //     });
  //   }
  //   // If the document exists, do nothing (or provide feedback if desired)
  // }

// ================================================================================

  //version1 it deletes if click twice
  // LikeSentReceieved(String toUserID, String senderName) async {
  //   var document = await FirebaseFirestore.instance
  //       .collection("users")
  //       .doc(toUserID)
  //       .collection("LikeReceived")
  //       .doc(currentUserID)
  //       .get();

  //   // If the user has already liked, remove the like
  //   if (document.exists) {
  //     // Remove the like from `LikeReceived` of the target user
  //     await FirebaseFirestore.instance
  //         .collection("users")
  //         .doc(toUserID)
  //         .collection("LikeReceived")
  //         .doc(currentUserID)
  //         .delete();

  //     // Remove the like from `LikeSent` of the current user
  //     await FirebaseFirestore.instance
  //         .collection("users")
  //         .doc(currentUserID)
  //         .collection("LikeSent")
  //         .doc(toUserID)
  //         .delete();
  //   } else {
  //     // Add like to the target user's `LikeReceived`
  //     await FirebaseFirestore.instance
  //         .collection("users")
  //         .doc(toUserID)
  //         .collection("LikeReceived")
  //         .doc(currentUserID)
  //         .set({
  //       'senderName': senderName,
  //       'timestamp': FieldValue.serverTimestamp(),
  //     });

  //     // Add like to the current user's `LikeSent`
  //     await FirebaseFirestore.instance
  //         .collection("users")
  //         .doc(currentUserID)
  //         .collection("LikeSent")
  //         .doc(toUserID)
  //         .set({
  //       'senderName': senderName,
  //       'timestamp': FieldValue.serverTimestamp(),
  //     });
  //   }
  // }

  // LikeSentReceieved(String toUserID, String senderName) async {
  //   var document = await FirebaseFirestore.instance
  //       .collection("users")
  //       .doc(toUserID)
  //       .collection("LikeReceived")
  //       .doc(currentUserID)
  //       .get();

  //   // If the like does not exist, add it
  //   if (!document.exists) {
  //     // Add like to the target user's `LikeReceived`
  //     await FirebaseFirestore.instance
  //         .collection("users")
  //         .doc(toUserID)
  //         .collection("LikeReceived")
  //         .doc(currentUserID)
  //         .set({
  //       'senderName': senderName,
  //       'timestamp': FieldValue.serverTimestamp(),
  //     });

  //     // Add like to the current user's `LikeSent`
  //     await FirebaseFirestore.instance
  //         .collection("users")
  //         .doc(currentUserID)
  //         .collection("LikeSent")
  //         .doc(toUserID)
  //         .set({
  //       'senderName': senderName,
  //       'timestamp': FieldValue.serverTimestamp(),
  //     });
  //   }
  //   // If the like already exists, do nothing (or provide feedback if desired)
  // }
  // Future<void> LikeSentReceieved(String toUserID, String senderName) async {
  //   try {
  //     // Check if the like already exists
  //     var document = await FirebaseFirestore.instance
  //         .collection("users")
  //         .doc(toUserID)
  //         .collection("LikeReceived")
  //         .doc(currentUserID)
  //         .get();

  //     // If the like does not exist, add it
  //     if (!document.exists) {
  //       // Add like to the target user's `LikeReceived`
  //       await FirebaseFirestore.instance
  //           .collection("users")
  //           .doc(toUserID)
  //           .collection("LikeReceived")
  //           .doc(currentUserID)
  //           .set({
  //         'senderName': senderName,
  //         'timestamp': FieldValue.serverTimestamp(),
  //       });

  //       // Add like to the current user's `LikeSent`
  //       await FirebaseFirestore.instance
  //           .collection("users")
  //           .doc(currentUserID)
  //           .collection("LikeSent")
  //           .doc(toUserID)
  //           .set({
  //         'senderName': senderName,
  //         'timestamp': FieldValue.serverTimestamp(),
  //       });
  //     } else {
  //       // Optionally, provide feedback that the like already exists
  //       print("You have already liked this user.");
  //     }
  //   } catch (e) {
  //     // Handle errors here (e.g., log the error)
  //     print("Error while sending like: $e");
  //   }
  // }
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
