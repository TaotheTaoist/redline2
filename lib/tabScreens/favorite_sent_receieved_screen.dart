import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:redline/global.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FavoriteSentReceivedScreen extends StatefulWidget {
  const FavoriteSentReceivedScreen({Key? key}) : super(key: key);

  @override
  State<FavoriteSentReceivedScreen> createState() =>
      _FavoriteSentReceivedScreenState();
}

class _FavoriteSentReceivedScreenState
    extends State<FavoriteSentReceivedScreen> {
  List<String> favoriteReceivedList = [];
  List<String> favoriteSentList = [];
  List favoriteList = [];
  bool isFavoriteSentClick = true;

  // getFavoriteListkeys() async {
  //   if (isFavoriteSentClick) {
  //     var favoriteSentDocument = await FirebaseFirestore.instance
  //         .collection("users")
  //         .doc(currentUserID.toString())
  //         .collection("favoriteSent")
  //         .get();
  //     for (int i = 0; i < favoriteSentDocument.docs.length; i++) {
  //       favoriteSentList.add(favoriteSentDocument.docs[i].id);
  //     }
  //   } else {
  //     var favoriteReceivedDocument = await FirebaseFirestore.instance
  //         .collection("users")
  //         .doc(currentUserID.toString())
  //         .collection("favoriteReceived")
  //         .get();

  //     for (int i = 0; i < favoriteReceivedDocument.docs.length; i++) {
  //       favoriteReceivedList.add(favoriteReceivedDocument.docs[i].id);
  //     }
  //   }
  // }

  // getKeysDataFromUsersCollection(List<String> keysList) async {
  //   var allUsersDocument =
  //       await FirebaseFirestore.instance.collection("users").get();

  //   for (int i = 0; i < allUsersDocument.docs.length; i++) {
  //     for (int k = 0; k < keysList.length; k++) {
  //       // Correcting the syntax for accessing uid
  //       if (((allUsersDocument.docs[i].data()['uid'] as dynamic) ==
  //           keysList[k])) {
  //         favoriteList.add(allUsersDocument.docs[i].data());
  //       }
  //     }
  //   }
  //   setState(() {
  //     print("Refreshing UI , getKeysDataFromUsersCollection ()");
  //     favoriteList;
  //   });
  //   print("favoritesList = " + favoriteList.toString());
  // }

//  version3
  // getFavoriteListkeys() async {
  //   print("Current User ID: $currentUserID");
  //   if (isFavoriteSentClick) {
  //     var favoriteSentDocument = await FirebaseFirestore.instance
  //         .collection("users")
  //         .doc(currentUserID.toString())
  //         .collection("favoriteSent")
  //         .get();

  //     favoriteSentList.clear(); // Clear the list to avoid duplicates
  //     for (int i = 0; i < favoriteSentDocument.docs.length; i++) {
  //       favoriteSentList.add(favoriteSentDocument.docs[i].id);
  //     }
  //     print("Sent Favorite List: $favoriteSentList");
  //   } else {
  //     var favoriteReceivedDocument = await FirebaseFirestore.instance
  //         .collection("users")
  //         .doc(currentUserID.toString())
  //         .collection("favoriteReceived")
  //         .get();

  //     favoriteReceivedList.clear(); // Clear to avoid duplicates
  //     for (int i = 0; i < favoriteReceivedDocument.docs.length; i++) {
  //       favoriteReceivedList.add(favoriteReceivedDocument.docs[i].id);
  //     }
  //     print("Received Favorite List: $favoriteReceivedList");
  //   }

  //   // Always setState to refresh UI
  //   setState(() {
  //     print("Refreshing UI, favoriteSentList: $favoriteSentList");
  //     print("Refreshing UI, favoriteReceivedList: $favoriteReceivedList");
  //   });
  // }

  // getKeysDataFromUsersCollection(List<String> keysList) async {
  //   var allUsersDocument =
  //       await FirebaseFirestore.instance.collection("users").get();

  //   allUsersDocument.docs.forEach((userDoc) {
  //     if (keysList.contains(userDoc.data()['uid'])) {
  //       favoriteList.add(userDoc.data());
  //     }
  //   });

  //   setState(() {
  //     print("Refreshing UI, favoriteList: $favoriteList");
  //     favoriteList;
  //   });
  // }

//  version2 working
  getFavoriteListkeys() async {
    try {
      favoriteSentList.clear();
      favoriteReceivedList.clear();
      favoriteList.clear();
      print(
          "Fetching favorite list. isFavoriteSentClick: $isFavoriteSentClick");
      if (isFavoriteSentClick) {
        // Fetch sent favorite documents
        var favoriteSentDocument = await FirebaseFirestore.instance
            .collection("users")
            .doc(currentUserID.toString())
            .collection("favoriteSent")
            .get();

        print("Sent documents count: ${favoriteSentDocument.docs.length}");
        if (favoriteSentDocument.docs.isEmpty) {
          print("No sent favorites found for user: $currentUserID");
        }

        // Populate the favoriteSentList
        for (int i = 0; i < favoriteSentDocument.docs.length; i++) {
          print("Sent Favorite ID: ${favoriteSentDocument.docs[i].id}");
          favoriteSentList.add(favoriteSentDocument.docs[i].id);
        }

        print("Sent Favorite List: $favoriteSentList");

        // Fetch data for favoriteSentList
        await getKeysDataFromUsersCollection(favoriteSentList);
      } else {
        // Fetch received favorite documents
        var favoriteReceivedDocument = await FirebaseFirestore.instance
            .collection("users")
            .doc(currentUserID.toString())
            .collection("favoriteReceived")
            .get();
        print(
            "Received documents count: ${favoriteReceivedDocument.docs.length}");

        // Populate the favoriteReceivedList
        for (int i = 0; i < favoriteReceivedDocument.docs.length; i++) {
          print("Received Favorite ID: ${favoriteReceivedDocument.docs[i].id}");

          favoriteReceivedList.add(favoriteReceivedDocument.docs[i].id);
        }

        print("Received Favorite List: $favoriteReceivedList");

        // Fetch data for favoriteReceivedList
        await getKeysDataFromUsersCollection(favoriteReceivedList);
      }

      // Refresh UI
      setState(() {
        print("Refreshing UI");
      });
    } catch (e) {
      print("Error fetching favorite list: $e");
    }
  }

  // Fetch user data based on the favorite list
  Future<void> getKeysDataFromUsersCollection(List<String> keysList) async {
    try {
      favoriteList
          .clear(); // Clear the previous data before populating the new data

      var allUsersDocument =
          await FirebaseFirestore.instance.collection("users").get();

      for (var userDoc in allUsersDocument.docs) {
        // Match with keysList
        for (var key in keysList) {
          if ((userDoc.data()['uid'] as dynamic) == key) {
            favoriteList.add(userDoc.data());
          }
        }
      }

      // Refresh UI after fetching the data
      setState(() {
        favoriteList;
      });
    } catch (e) {
      print("Error fetching user data: $e");
    }
    print("Favorite List: $favoriteList");
  }

  @override
  void initState() {
    super.initState();
    // Fetch the initial favorite list
    getFavoriteListkeys();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          // Static title without the userName
          title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
              onPressed: () {
                setState(() {
                  isFavoriteSentClick = true;
                });
                getFavoriteListkeys();
              },
              child: Text(
                "My Favoritees",
                style: TextStyle(
                  color: isFavoriteSentClick ? Colors.white : Colors.grey,
                  fontWeight:
                      isFavoriteSentClick ? FontWeight.bold : FontWeight.normal,
                  fontSize: 14,
                ),
              )),
          const Text("   |   ",
              style: TextStyle(
                color: Colors.grey,
              )),
          TextButton(
              onPressed: () {
                setState(() {
                  isFavoriteSentClick = false;
                });
                getFavoriteListkeys();
              },
              child: Text(
                "I'm their favor",
                style: TextStyle(
                  color: isFavoriteSentClick ? Colors.grey : Colors.white,
                  fontWeight:
                      isFavoriteSentClick ? FontWeight.normal : FontWeight.bold,
                  fontSize: 14,
                ),
              ))
        ],
      )),
      body: favoriteList.isEmpty
          ? Center(
              child:
                  Icon(Icons.person_off_sharp, color: Colors.white, size: 60),
            )
          : GridView.count(
              crossAxisCount: 2,
              padding: const EdgeInsets.all(8),
              children: List.generate(favoriteList.length, (Index) {
                return GridTile(
                    child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Card(
                    color: Colors.blue.shade200,
                    child: GestureDetector(
                      onTap: () {},
                      child: DecoratedBox(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                            image: NetworkImage(
                              favoriteList[Index]["imageProfile"],
                            ),
                            fit: BoxFit.cover,
                          )),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Column(
                                children: [
                                  Text(
                                    favoriteList[Index]["name"].toString() +
                                        "" +
                                        favoriteList[Index]["age"].toString(),
                                    style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  )
                                ],
                              ),
                            ),
                          )),
                    ),
                  ),
                ));
              })),
    );
  }
}
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class FavoriteSentReceivedScreen extends StatefulWidget {
//   const FavoriteSentReceivedScreen({Key? key}) : super(key: key);

//   @override
//   State<FavoriteSentReceivedScreen> createState() =>
//       _FavoriteSentReceivedScreenState();
// }

// class _FavoriteSentReceivedScreenState
//     extends State<FavoriteSentReceivedScreen> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   late String currentUserId;

//   @override
//   void initState() {
//     super.initState();
//     currentUserId = _auth.currentUser?.uid ?? '';
//   }

//   // Function to check for mutual favorites between currentUser and other users
//   Future<List<Map<String, dynamic>>> getMutualFavorites() async {
//     List<Map<String, dynamic>> mutualFavorites = [];
//     bool isFavoriteSentClick = true; // Moved inside this function

//     if (currentUserId.isNotEmpty) {
//       // Get users who have favored the current user
//       var receivedFavSnapshot = await FirebaseFirestore.instance
//           .collection("users")
//           .doc(currentUserId)
//           .collection("favoriteReceived")
//           .get();

//       for (var doc in receivedFavSnapshot.docs) {
//         String receivedUserId = doc.id; // User who favored the current user

//         // Check if current user has also favored them
//         var sentFavSnapshot = await FirebaseFirestore.instance
//             .collection("users")
//             .doc(receivedUserId)
//             .collection("favoriteReceived")
//             .get(); // Removed .doc(currentUserId)

//         for (var sentFavDoc in sentFavSnapshot.docs) {
//           if (sentFavDoc.id == currentUserId) {
//             // Mutual favorite found, get user profile
//             var userProfileSnapshot = await FirebaseFirestore.instance
//                 .collection("users")
//                 .doc(receivedUserId)
//                 .get();

//             if (userProfileSnapshot.exists) {
//               mutualFavorites.add({
//                 'userId': receivedUserId,
//                 'profilePicture':
//                     userProfileSnapshot.data()?['profilePicture'] ?? '',
//                 'userName': userProfileSnapshot.data()?['userName'] ?? '',
//               });
//             }
//           }
//         }
//       }
//     }

//     return mutualFavorites;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Mutual Favorites'),
//         backgroundColor: Colors.black,
//       ),
//       backgroundColor: Colors.black,
//       body: FutureBuilder<List<Map<String, dynamic>>>(
//         future: getMutualFavorites(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return const Center(child: Text("Error fetching data"));
//           } else if (snapshot.data == null || snapshot.data!.isEmpty) {
//             return const Center(child: Text("No mutual favorites found"));
//           } else {
//             List<Map<String, dynamic>> favorites = snapshot.data!;

//             return GridView.builder(
//               padding: const EdgeInsets.all(10),
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 2,
//                 crossAxisSpacing: 10,
//                 mainAxisSpacing: 10,
//               ),
//               itemCount: favorites.length,
//               itemBuilder: (context, index) {
//                 String profilePicture = favorites[index]['profilePicture'];
//                 String userName = favorites[index]['userName'];

//                 return Column(
//                   children: [
//                     ClipOval(
//                       child: Image.network(
//                         profilePicture,
//                         height: 100,
//                         width: 100,
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       userName,
//                       style: const TextStyle(color: Colors.white, fontSize: 16),
//                     ),
//                   ],
//                 );
//               },
//             );
//           }
//         },
//       ),
//     );
//   }
// }
