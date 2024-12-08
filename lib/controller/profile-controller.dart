import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:redline/global.dart';
import 'package:redline/models/person.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profilecontroller extends GetxController {
  final Rx<List<Person>> usersProfileList = Rx<List<Person>>([]);

  List<Person> get allUserProfileList => usersProfileList.value;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Rx<Map<String, List<String>>> userImageUrlsMap =
      Rx<Map<String, List<String>>>({});

  final storage = GetStorage();

  @override
  void onInit() {
    super.onInit();
    GetStorage.init();

    loadCachedData();

    fetchAndCacheCurrentUserData();

    // Bind Firestore stream to keep the list updated
    usersProfileList.bindStream(_fetchProfilesFromFirestore());

    // Observe profile list and fetch image URLs when profiles are loaded
    ever(usersProfileList, (_) {
      if (usersProfileList.value.isNotEmpty) {
        fetchUserImageUrlsMap();
      }
    });

    listenToCurrentUserDataChanges();
  }

  void fetchAndCacheCurrentUserData() async {
    // Fetch current user data from Firestore
    try {
      String currentUserUid = FirebaseAuth.instance.currentUser!.uid;
      DocumentSnapshot currentUserSnapshot =
          await _firestore.collection("users").doc(currentUserUid).get();

      if (currentUserSnapshot.exists) {
        Map<String, dynamic> currentUserData =
            currentUserSnapshot.data() as Map<String, dynamic>;

        // Assuming Person.fromJson() can handle the structure of the current user data
        Person currentUser = Person.fromDataSnapshot(currentUserSnapshot);

        // Cache current user data
        storage.write('currentUserData', currentUser.toJson());
        print("Current user data saved to cache. :${currentUserData}");
        print(storage.read("currentUserData"));
      } else {
        print("Current user document does not exist.");
      }
    } catch (e) {
      print("Error fetching current user data: $e");
    }
  }

  // void listenToCurrentUserDataChanges() {
  Future<void> listenToCurrentUserDataChanges() async {
    try {
      String currentUserUid = FirebaseAuth.instance.currentUser!.uid;

      // Fetch current user data once (instead of using snapshots.listen)
      DocumentSnapshot documentSnapshot =
          await _firestore.collection("users").doc(currentUserUid).get();

      if (documentSnapshot.exists) {
        Map<String, dynamic> currentUserData =
            documentSnapshot.data() as Map<String, dynamic>;

        // Assuming Person.fromJson() can handle the structure of the current user data
        Person currentUser = Person.fromDataSnapshot(documentSnapshot);

        // Cache the updated user data
        await storage.write('currentUserData', currentUser.toJson());
        print(
            "new Updated for current user and saved to cache: $currentUserData profile-controller");

        // Optionally return the current user if needed elsewhere
        return; // Can return currentUser if needed
      } else {
        print("Current user document no longer exists.  profile-controller");
      }
    } catch (e) {
      print(
          "Error setting up listener for current user data: $e  profile-controller");
    }
  }

// 這個function 是來看裡面的data有沒有改變而已 最主要的是cache() 可是不包過正在使用的用戶UID
  Stream<List<Person>> _fetchProfilesFromFirestore() {
    return _firestore
        .collection("users")
        .where("uid", isNotEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .snapshots()
        .map((QuerySnapshot querySnapshot) {
      List<Person> profilesList = [];

      // Debug: Print number of documents fetched
      print(
          'Fetched ${querySnapshot.docs.length} profiles from Firestore. - _fetchProfilesFromFirestore() profile controller');

      for (var eachProfile in querySnapshot.docs) {
        try {
          // Add each profile using the fromDataSnapshot method
          profilesList.add(Person.fromDataSnapshot(eachProfile));
        } catch (error) {
          print(
              'Error parsing profile: ${eachProfile.data()} - Error: $error - _fetchProfilesFromFirestore() profile controller');
        }
      }

      // Assign the list to the observable value and cache the data
      usersProfileList.value = profilesList;

      if (profilesList.isNotEmpty) {
        print(
            'Profiles added: ${profilesList.length} profiles. - _fetchProfilesFromFirestore() profile controller');
        cacheData(); // Optional: cache the profiles
      } else {
        print('No profiles fetched.');
      }

      return profilesList;
    }).handleError((error) {
      print(
          'Error fetching profiles: $error - _fetchProfilesFromFirestore() profile controller');
    });
  }

// 把firebase 資料存在storage裡面
  void cacheData() {
    if (usersProfileList.value.isNotEmpty) {
      print('Saving profiles to cache...');

      storage.write('cachedProfiles not including current user',
          usersProfileList.value.map((p) => p.toJson()).toList());

      print(
          "Cache successfully saved. Profiles: ${usersProfileList.value.length} profiles saved. cacheData() profile controller");

      int uidCount = usersProfileList.value.map((p) => p.uid).toSet().length;

      print(
          "Total unique UIDs cached: $uidCount cacheData() profile controller");
    } else {
      print('No profiles to save to cache.');
    }

    if (userImageUrlsMap.value.isNotEmpty) {
      // Cache user image URLs
      storage.write('cachedImageUrls', userImageUrlsMap.value);
      print(
          "Cache successfully saved. Image URLs: ${userImageUrlsMap.value.length} user images saved. cacheData() profile controller");
      int imageUrlMapSize = userImageUrlsMap.value.length;
      print(
          "Total users with cached imageUrlMapSize: $imageUrlMapSize cacheData() profile controller");
    } else {
      print('No image URLs to save to cache.');
    }
    debugPrint(
        "Caching profiles: ${usersProfileList.value.map((p) => p.toJson()).toList()} cacheData() profile controller");
  }

  void loadCachedData() {
    var cachedProfiles = storage.read('cachedProfiles');
    print('Raw cached profiles: $cachedProfiles');

    if (cachedProfiles != null && cachedProfiles.isNotEmpty) {
      usersProfileList.value = cachedProfiles
          .map<Person>((profile) => Person.fromJson(profile))
          .toList();
      print(
          'Profiles loaded from cache.  - loadCachedData() profile controller');
    } else {
      print(
          'No profiles found in cache. - loadCachedData() profile controller');
    }
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
      print("userImageUrlsMap.value: ${userImageUrlsMap.value}");

      int imageUrlMapSize = userImageUrlsMap.value.length;
      print("Total imageUrlMapSize: $imageUrlMapSize");
    } catch (e) {
      print("Error fetching profiles: $e");
    } finally {
      // isLoading.value = false;
    }
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
