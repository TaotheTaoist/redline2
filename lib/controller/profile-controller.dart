import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'package:redline/global.dart';
import 'package:redline/models/person.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import 'package:get_storage/get_storage.dart';

class Profilecontroller extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//==== not including currentuser's uid=======
  final Rx<List<Person>> usersProfileList = Rx<List<Person>>([]);

  List<Person> get allUserProfileList => usersProfileList.value;

  final Rx<List<Person>> filterEdusersProfileList = Rx<List<Person>>([]);

  List<Person> get filterEdallUserProfileList => usersProfileList.value;

// about to get swipped users' properties
  // final Rx<List<String>> OtherProfileimageListaBtTogetLoop =
  //     Rx<List<String>>([]);

  Rx<Map<String, List<String>>> otherUserImageUrlsMap =
      Rx<Map<String, List<String>>>({});

// currentUser's properties
  Person? currentUserpersonData;
  final storage = GetStorage();
  RxString name = ''.obs;
  RxString email = ''.obs;
  RxList<String> imageUrls = <String>[].obs;
  RxString birthday = ''.obs;
  RxString sex = ''.obs;
  RxList<String> interests = <String>[].obs;
  RxString age = ''.obs;
  RxList<String> occupation = <String>[].obs;
  RxList<String> mbti = <String>[].obs;
  RxString aboutMe = ''.obs;
  RxString bdTime = ''.obs;
  RxList<String> bloodType = <String>[].obs;
  RxList<String> diet = <String>[].obs;
  RxList<String> education = <String>[].obs;
  RxList<String> exercise = <String>[].obs;
  RxList<String> language = <String>[].obs;
  RxList<String> lookingFor = <String>[].obs;
  RxList<String> religion = <String>[].obs;
  Rxn<int> maxAge = Rxn<int>();
  Rxn<int> minAge = Rxn<int>();
  Rxn<int> maxDistance = Rxn<int>();
  // Current User ID
  String uid = "";

  // Initialize the controller with the user ID
  void setUserId(String userId) {
    uid = userId;
    fetchCurrentUserProfile();
  }

  // Fetch user data from Firestore
  void fetchCurrentUserProfile() {
    final stopwatch = Stopwatch()..start();
    print("Listening for updates for UID: $uid");

    FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .snapshots()
        .listen((dataSnapshot) {
      if (dataSnapshot.exists) {
        print(
            "User data updated: ${dataSnapshot.data()} fetchCurrentUserProfile()"); // Debug log

        // Populate reactive variables
        name.value = dataSnapshot["name"] ?? '';
        email.value = dataSnapshot["email"] ?? '';
        imageUrls.value = List<String>.from(dataSnapshot["imageUrls"] ?? []);
        birthday.value = dataSnapshot["birthday"] ?? '';
        sex.value = dataSnapshot["sex"] ?? '';
        interests.value = List<String>.from(dataSnapshot["interests"] ?? []);
        age.value = dataSnapshot["age"] ?? '';
        occupation.value = List<String>.from(dataSnapshot["occupation"] ?? []);
        mbti.value = List<String>.from(dataSnapshot["mbti"] ?? []);
        aboutMe.value = dataSnapshot["aboutme"] ?? '';
        bdTime.value = dataSnapshot["bdTime"] ?? '';
        bloodType.value = List<String>.from(dataSnapshot["bloodtype"] ?? []);
        diet.value = List<String>.from(dataSnapshot["diet"] ?? []);
        education.value = List<String>.from(dataSnapshot["education"] ?? []);
        exercise.value = List<String>.from(dataSnapshot["exercise"] ?? []);
        language.value = List<String>.from(dataSnapshot["language"] ?? []);
        lookingFor.value = List<String>.from(dataSnapshot["lookingfor"] ?? []);
        religion.value = List<String>.from(dataSnapshot["religion"] ?? []);
        maxAge = dataSnapshot["maxAge"] ?? 50;
        minAge = dataSnapshot["maxAge"] ?? 18;
        maxDistance = dataSnapshot["maxDistance"] ?? 18;
      } else {
        print("User document does not exist."); // Debug log
      }
    }).onError((error) {
      print("Error fetching user data: $error"); // Debug log
    });
    print(
        "Time taken to fetch and cache images: ${stopwatch.elapsed} fetchCurrentUserProfile()");
  }

  @override
  void onInit() {
    super.onInit();
    GetStorage.init();

    // readUserData();
    // initializeProfileList();
    // loadCachedData();

    // fetchAndCacheCurrentUserData();

    // Bind Firestore stream to keep the list updated
    // usersProfileList.bindStream(_fetchOhterUsersProfilesFromFirestore());

    // ever(usersProfileList, (_) async {
    //   if (usersProfileList.value.isNotEmpty) {
    //     // Run cachedAllOtherUserImage only after usersProfileList is updated
    //     await cachedallOtherUserImage();
    //   }
    // });

    // Observe profile list and fetch image URLs when profiles are loaded
    // ever(usersProfileList, (_) {
    //   if (usersProfileList.value.isNotEmpty) {
    //     fetchUserImageUrlsMap();
    //     // listenToCurrentUserDataChanges();
    //   }
    // });
  }

  Future<void> initializeProfileList() async {
    print("DateTime.now() ${DateTime.now()} initializeProfileList() starts  ");
    usersProfileList.bindStream(_fetchOhterUsersProfilesFromFirestore());
    // await Future.delayed(Duration(milliseconds: 500));

    print("DateTime.now() ${DateTime.now()} initializeProfileList() ends  ");
  }

  // fetchAndCacheCurrentUserData() async {
  //   final stopwatch = Stopwatch()..start();

  //   try {
  //     // Get the current user from Firebase Authentication
  //     User? currentUser = FirebaseAuth.instance.currentUser;

  //     // Check if the user is logged in
  //     if (currentUser == null) {
  //       print("No user is currently logged in.");
  //       print(
  //           "Time taken to fetch and cache images: ${stopwatch.elapsed} fetchAndCacheCurrentUserData()");
  //       return; // Exit the function if no user is logged in
  //     }

  //     // Proceed with fetching user data from Firestore if the user is logged in
  //     String currentUserUid = currentUser.uid;
  //     DocumentSnapshot currentUserSnapshot =
  //         await _firestore.collection("users").doc(currentUserUid).get();

  //     if (currentUserSnapshot.exists) {
  //       Map<String, dynamic> currentUserData =
  //           currentUserSnapshot.data() as Map<String, dynamic>;
  //       // print(
  //       //     "currentUserData: $currentUserData fetchAndCacheCurrentUserData()");

  //       // Assuming Person.fromJson() can handle the structure of the current user data
  //       currentUserpersonData = Person.fromDataSnapshot(currentUserSnapshot);
  //       print(
  //           "currentUserpersonData: $currentUserpersonData fetchAndCacheCurrentUserData()");
  //       // Cache current user data
  //       storage.write('currentUserData', currentUserpersonData!.toJson());
  //       print("Current user data saved to cache: $currentUserData");
  //       print(storage.read("currentUserData"));
  //     } else {
  //       print("Current user document does not exist.");
  //     }
  //   } catch (e) {
  //     print(
  //         "Error fetching current user data: $e fetchAndCacheCurrentUserData()");
  //   }
  //   print(
  //       "Time taken to fetch and cache images: ${stopwatch.elapsed} fetchAndCacheCurrentUserData()");
  // }

  // Future<void> cachedallOtherUserImage() async {
  //   final stopwatch = Stopwatch()..start();
  //   if (allUserProfileList.isEmpty) {
  //     print("No user profiles found in the list. cachedallOtherUserImage()");
  //     return;
  //   } else {
  //     for (var user in allUserProfileList) {
  //       if (user.uid != null) {
  //         // print(
  //         //     "Fetching user images for user ID: ${user.uid}  cachedallOtherUserImage()");
  //         var snapshot = await FirebaseFirestore.instance
  //             .collection("users")
  //             .doc(user.uid)
  //             .get();
  //         if (snapshot.exists) {
  //           // print(
  //           //     "Snapshot exists for user ID: ${user.uid} cachedallOtherUserImage()");

  //           print(
  //               "Snapshot data for user ID ${user.uid}: ${snapshot.data()} cachedallOtherUserImage()");

  //           Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

  //           if (data["imageUrls"] is List &&
  //               (data["imageUrls"] as List).isNotEmpty) {
  //             List<String> imageUrls =
  //                 List<String>.from(data["imageUrls"] ?? []);
  //             for (String imageUrl in imageUrls) {
  //               await _cacheImage(imageUrl);
  //             }

  //             // // Log the retrieved imageUrls
  //             // print(
  //             //     "Image URLs for user ID ${user.uid}: $imageUrls cachedallOtherUserImage()");

  //             // Update the map only if imageUrls is not empty
  //             // otherUserImageUrlsMap[user.uid!] = imageUrls;
  //           } else {
  //             // print(
  //             //     "No image URLs found for user ID: ${user.uid} cachedallOtherUserImage()");
  //           }
  //         }
  //       }
  //     }
  //   }
  //   print(
  //       "Time taken to fetch and cache images: ${stopwatch.elapsed}  cachedallOtherUserImage()");
  // }

  // Future<void> listenToCurrentUserDataChanges() async {
  //   try {
  //     String currentUserUid = FirebaseAuth.instance.currentUser!.uid;

  //     DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
  //         .collection("users")
  //         .doc(currentUserUid)
  //         .get();

  //     if (documentSnapshot.exists) {
  //       Person currentUser = Person.fromDataSnapshot(documentSnapshot);

  //       // Cache the updated user data
  //       await storage.write('currentUserData', currentUser.toJson());
  //       print(
  //           "Updated current user and saved to cache: ${currentUser.toJson()}");
  //     } else {
  //       print("Current user document no longer exists.");
  //     }
  //   } catch (e) {
  //     print("Error setting up listener for current user data: $e");
  //   }
  // }

  // readUserData() async {
  //   await FirebaseFirestore.instance
  //       .collection("users")
  //       .doc(currentUserID)
  //       .get()
  //       .then((dataSnapshot) {
  //     // Retrieve and set the sender's name
  //     senderName = dataSnapshot.data()?["name"]?.toString() ?? "No name";

  //     // Print the entire document data
  //     print("readUserData() - Data snapshot: ${dataSnapshot.data()}");

  //     // Print the specific field value (senderName)
  //     print("Sender name: $senderName sender means current profileController");
  //     print("setState called at readUserData() profileController");
  //   }).catchError((error) {
  //     // Handle potential errors (optional)
  //     print("Error fetching data: $error");
  //   });
  // }

  // working version
// 這個function 是來看裡面的data有沒有改變而已 最主要的是cache() 可是不包過正在使用的用戶UID
  Stream<List<Person>> _fetchOhterUsersProfilesFromFirestore() {
    final stopwatch = Stopwatch()..start();

    print(
        "DateTime.now() ${DateTime.now()} fetchOhterUsersProfilesFromFirestore() starts  ");
    // Safely check if the current user is logged in

    if (currentUserID == "") {
      print(
          "No user is currently logged in. fetchOhterUsersProfilesFromFirestore()");
      return Stream.value([]); // Return an empty stream if no user is logged in
    }

    return _firestore
        .collection("users")
        .where("uid", isNotEqualTo: currentUserID)
        .snapshots()
        .map((QuerySnapshot querySnapshot) {
      List<Person> profilesList = [];

      // Debug: Print number of documents fetched
      print(
          'Fetched ${querySnapshot.docs.length} profiles from Firestore. - fetchOhterUsersProfilesFromFirestore() profile controller');

      for (var eachProfile in querySnapshot.docs) {
        try {
          // Add each profile using the fromDataSnapshot method
          profilesList.add(Person.fromDataSnapshot(eachProfile));
          print(
              "profilesList: $profilesList fetchOhterUsersProfilesFromFirestore() profile controller");
        } catch (error) {
          print(
              'Error parsing profile: ${eachProfile.data()} - Error: $error - fetchOhterUsersProfilesFromFirestore() profile controller');
        }
      }

      // Assign the list to the observable value and cache the data
      usersProfileList.value = profilesList;
      // print(
      // "usersProfileList: $usersProfileList fetchOhterUsersProfilesFromFirestore() profile controller");

      print(
          "Time taken to fetch and cache images: ${stopwatch.elapsed}  usersProfileList generated at fetchOhterUsersProfilesFromFirestore()");
      print(
          "usersProfileList.value: ${usersProfileList.value} fetchOhterUsersProfilesFromFirestore() profile controller");
      if (profilesList.isNotEmpty) {
        print(
            'Profiles added: ${profilesList.length} profiles. - fetchOhterUsersProfilesFromFirestore() profile controller');
        cacheDataForSwippingScreen();
      } else {
        print('No profiles fetched.');
      }
      // print(
      //     "Time taken to fetch and cache images: ${stopwatch.elapsed} func ends at fetchOhterUsersProfilesFromFirestore()");

      print(
          "DateTime.now() ${DateTime.now()} fetchOhterUsersProfilesFromFirestore() ends  ");
      return profilesList;
    }).handleError((error) {
      print(
          'Error fetching profiles: $error - _fetchProfilesFromFirestore() profile controller');
    });
  }

// 把firebase 資料存在storage裡面
  Future<void> cacheDataForSwippingScreen() async {
    print(
        "DateTime.now() ${DateTime.now()} cacheDataForSwippingScreen() starts  ");
    final stopwatch = Stopwatch()..start();
    if (usersProfileList.value.isNotEmpty) {
      print('Saving profiles to cache...');
      await Future.delayed(Duration(milliseconds: 400));
      storage.write('cachedProfiles',
          usersProfileList.value.map((p) => p.toJson()).toList());

      print(
          "Cache successfully saved. Profiles: ${usersProfileList.value.length} profiles saved. cacheData() profile controller");
      print(
          "Time taken to fetch and cache images: ${stopwatch.elapsed} storage.write('cachedProfiles', cacheDataForSwippingScreen()");

      int uidCount = usersProfileList.value.map((p) => p.uid).toSet().length;

      print(
          "Total unique UIDs cached: $uidCount cacheData() profile controller");
    } else {
      print('No profiles to save to cache.');
    }

    debugPrint(
        "Caching profiles: ${usersProfileList.value.map((p) => p.toJson()).toList()} cacheData() profile controller");
    // print(
    //     "Time taken to fetch and cache images: ${stopwatch.elapsed}  func ends cacheDataForSwippingScreen()");
    print(
        "DateTime.now() ${DateTime.now()} cacheDataForSwippingScreen() ends  ");
  }

  // loadCachedData() async {
  //   await Future.delayed(Duration(milliseconds: 2000));
  //   final stopwatch = Stopwatch()..start();
  //   try {
  //     var cachedProfiles = storage.read('cachedProfiles');
  //     print('Raw cached profiles: $cachedProfiles');

  //     if (cachedProfiles != null && cachedProfiles.isNotEmpty) {
  //       // Check the raw data before mapping
  //       print('Checking the first profile: ${cachedProfiles}');

  //       usersProfileList.value = cachedProfiles
  //           .map<Person>((profile) => Person.fromJson(profile))
  //           .toList();
  //       print(
  //           'Profiles loaded from cache. - loadCachedData() profile controller');
  //     } else {
  //       print(
  //           'No profiles found in cache. - loadCachedData() profile controller');
  //     }
  //   } catch (error) {
  //     print('Error loading cached data: $error');
  //   }
  //   print(
  //       "Time taken to fetch and cache images: ${stopwatch.elapsed} loadCachedData()");
  // }

  // Future<void> fetchUserImageUrlsMap() async {
  //   // isLoading.value = true;
  //   Map<String, List<String>> resultMap = {};

  //   try {
  //     final stopwatch = Stopwatch()..start();
  //     if (allUserProfileList.isEmpty) {
  //       print("fetchUserImageUrlsMap() is empty atfetchUserImageUrlsMap() ");
  //       usersProfileList.bindStream(_firestore
  //           .collection("users")
  //           .where("uid", isNotEqualTo: FirebaseAuth.instance.currentUser!.uid)
  //           .snapshots()
  //           .map((QuerySnapshot query) {
  //         return query.docs.map((doc) => Person.fromDataSnapshot(doc)).toList();
  //       }));
  //     }

  //     for (var user in allUserProfileList) {
  //       if (user.uid != null) {
  //         var snapshot =
  //             await _firestore.collection("users").doc(user.uid).get();
  //         if (snapshot.exists) {
  //           Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
  //           if (data["imageUrls"] is List &&
  //               (data["imageUrls"] as List).isNotEmpty) {
  //             resultMap[user.uid!] = List<String>.from(data["imageUrls"] ?? []);
  //           }
  //         }
  //       }
  //     }
  //     otherUserImageUrlsMap.value = resultMap;
  //     print("allUserProfileList: ${allUserProfileList}");
  //     print(
  //         "otherUserImageUrlsMap from profilecontroller original func ${otherUserImageUrlsMap}");
  //     print(
  //         "otherUserImageUrlsMap.value: ${otherUserImageUrlsMap.value} fetchUserImageUrlsMap()");

  //     int imageUrlMapSize = otherUserImageUrlsMap.value.length;
  //     print("Total imageUrlMapSize: $imageUrlMapSize");
  //     stopwatch.stop();
  //     print(
  //         "Time taken to fetch and cache images: ${stopwatch.elapsed}  fetchUserImageUrlsMap()");
  //   } catch (e) {
  //     print("Error fetching profiles: $e");
  //   } finally {
  //     // isLoading.value = false;
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

  List<Person> filterProfilesByDistance(
    Person currentUser, // Accept Person object
    List<Person> cachedProfiles,
    double minDistance,
    double maxDistance,
  ) {
    // Get the current user's latitude and longitude
    double currentUserLat = currentUser.latitude ?? 0.0;
    double currentUserLon = currentUser.longitude ?? 0.0;

    // Create a new list to store filtered profiles
    List<Person> filteredProfiles = [];

    for (var profile in cachedProfiles) {
      // Get the latitude and longitude of the profile
      double profileLat = profile.latitude ?? 24.1630;
      double profileLon = profile.longitude ?? 120.6746;

      // Calculate the distance in miles between the current user and the profile
      double distanceInMiles = Geolocator.distanceBetween(
            currentUserLat,
            currentUserLon,
            profileLat,
            profileLon,
          ) /
          1609.34; // Convert meters to miles

      // Add the profile to the filtered list if the distance is within the range
      if (distanceInMiles >= minDistance && distanceInMiles <= maxDistance) {
        filteredProfiles.add(profile);
      }
    }

    return filteredProfiles;
  }

  void updateUserProfiles(List<Person> profiles) {
    filterEdusersProfileList.value = profiles;
  }

  // Function to cache the image using CachedNetworkImage
}
