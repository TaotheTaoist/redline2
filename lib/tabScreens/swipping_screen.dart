import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_storage/get_storage.dart';
import 'package:redline/custom_popup/custom_popup.dart';
import 'package:redline/global.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redline/models/person.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:swipe_cards/swipe_cards.dart';
import 'package:redline/controller/profile-controller.dart';

import 'package:shared_preferences/shared_preferences.dart';

class SwipeableProfiles extends StatefulWidget {
  const SwipeableProfiles({Key? key}) : super(key: key);
  @override
  _SwipeableProfilesState createState() => _SwipeableProfilesState();
}

class _SwipeableProfilesState extends State<SwipeableProfiles> {
  Profilecontroller profileController = Get.find<Profilecontroller>();
  static int initCounter = 0;

  // =============================================================================================
  List<String> interestList = [];

  Future<SharedPreferences> prefs = SharedPreferences.getInstance();

  Map<String, List<String>> otherUserImageUrlsMap = {};
  List<Person> cachedProfiles = [];

  int currentIndex = 0;
  int carouselIndex = 0;
  List<String> profileKeys = [];
  String selectedUserUid = "";

  List<String> images = [];
  // =============================================================================================

  bool isLoading = true;

  CarouselController carouselController = CarouselController();

  @override
  void initState() {
    super.initState();
    print("DateTime.now() ${DateTime.now()} build swipping_screen.dart  ");
    initCounter++; // Increment the counter
    print("initState has been called $initCounter time(s)");

    final stopwatch = Stopwatch()..start();
    profileController.initializeProfileList();

    updateSwipeItemsInitonly();
    print(
        "DateTime.now() at: ${DateTime.now()}  Current User ID: $currentUserID Function finished  build swipping_screen.dart  DateTime.now()");

    print(
        "currentIndex: $currentIndex at init Function finished at: ${DateTime.now()} build - swipingdart");

    final storage = GetStorage();
    print("storage.getValues()${storage.getValues()}");
    print(
        "Time taken to fetch and cache images: ${stopwatch.elapsed} initState() swipping screen");
    loadCachedProfiles();

    // print(
    // " current cached cachedProfiles: ${cachedProfiles[currentIndex].name}");
    // checkAlignment(otherUserImageUrlsMap, cachedProfiles);
    Future.delayed(Duration(seconds: 3), () {
      if (mounted) {
        // Ensure the widget is still in the tree
        setState(() {
          readUserData();
          isLoading = false; // Set loading to false after 3 seconds
          print(
              "setState called at Future.delayed(Duration(seconds: 3) swipping screen");
        });
      }
    });
  }

  Future<Map<String, List<String>>> generateUserImageUrlsMap(
      Profilecontroller profileController) async {
    // Initialize an empty map to store UIDs and corresponding image URLs
    print(
        "DateTime.now() ${DateTime.now()} - generateUserImageUrlsMap started");
    if (profileController.allUserProfileList.isEmpty) {
      print("No user profiles found in the list. generateUserImageUrlsMap");
      return otherUserImageUrlsMap;
    }

    final String currentUserId =
        FirebaseAuth.instance.currentUser!.uid; // Get current user ID
    final stopwatch = Stopwatch()..start();
    for (var user in profileController.allUserProfileList) {
      if (user.uid != null && user.uid != currentUserId) {
        // Exclude current user
        print(
            "Fetching user images for user ID: ${user.uid} generateUserImageUrlsMap");
        var snapshot = await FirebaseFirestore.instance
            .collection("users")
            .doc(user.uid)
            .get();

        if (snapshot.exists) {
          print(
              "Snapshot exists for user ID: ${user.uid} generateUserImageUrlsMap");

          print(
              "Snapshot data for user ID ${user.uid}: ${snapshot.data()} generateUserImageUrlsMap");
          Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

          // Ensure the imageUrls field exists and is a non-empty array
          if (data["imageUrls"] is List &&
              (data["imageUrls"] as List).isNotEmpty) {
            List<String> imageUrls = List<String>.from(data["imageUrls"] ?? []);
            for (String imageUrl in imageUrls) {
              await _cacheImage(imageUrl); // Cache each image URL
            }

            // Log the retrieved imageUrls
            print(
                "Image URLs for user ID ${user.uid}: $imageUrls swiping screen");

            // Update the map only if imageUrls is not empty
            otherUserImageUrlsMap[user.uid!] = imageUrls;

            print(
                "user.uid! ${user.uid!} generateUserImageUrlsMap swiping screen");
          } else {
            print(
                "No image URLs found for user ID: ${user.uid} swiping screen ");
          }
        } else {
          print(
              "No data found for user ID: ${user.uid} generateUserImageUrlsMap swiping screen");
        }
        stopwatch.stop();
        // print(
        //     "Time taken to fetch and cache images: ${stopwatch.elapsed} generateUserImageUrlsMap");

        print(
            " DateTime.now() ${DateTime.now()} - generateUserImageUrlsMap  ends");
      }
    }

    print(
        "Final otherUserImageUrlsMap: $otherUserImageUrlsMap generateUserImageUrlsMap");
    print(
        "Final otherUserImageUrlsMap.values: ${otherUserImageUrlsMap.values} generateUserImageUrlsMap");
    return otherUserImageUrlsMap;
  }

  Future<void> updateSwipeItemsInitonly() async {
    final stopwatch = Stopwatch()..start();

    print("${DateTime.now()} - updateSwipeItemsInitonly() started");
    await Future.delayed(Duration(milliseconds: 2000));
    print("${DateTime.now()} - Delay completed in updateSwipeItemsInitonly()");
    print(
        "check profileController.allUserProfileList again at updateSwipeItemsInitonly() ${profileController.allUserProfileList}");

    if (profileController.allUserProfileList.isNotEmpty) {
      print("List is not empty, continuing...");
      await validateAndCleanUpUserProfiles(profileController);
      await generateUserImageUrlsMap(profileController);

      if (otherUserImageUrlsMap.isNotEmpty) {
        // Check if the widget is still mounted before calling setState
        // if (mounted) {
        //   setState(() {
        selectedUserUid = otherUserImageUrlsMap.keys.first;
        print(
            "otherUserImageUrlsMap.keys.first inside of a setState inside of updateSwipeItemsInitonly ${otherUserImageUrlsMap.keys.first}");
        // profileKeys = otherUserImageUrlsMap.keys.toList();

        List<String> tempProfileKeys = otherUserImageUrlsMap.keys.toList();
        if (tempProfileKeys.isNotEmpty) {
          profileKeys = tempProfileKeys;
          print("profilekeys updated to: $profileKeys swiping screen");
        } else {
          print("No valid profile keys found; profileKeys remains unchanged.");
        }

        print("profilekeys $profileKeys swiping screen");
        print("${DateTime.now()} - Updated profileKeys: $profileKeys");

        // print(
        //     "setState called at updateSwipeItemsInitonly() profile Keys loop swiping screen");
        //   });
        // }
        print(
            "selectedUserUid assigned to ${otherUserImageUrlsMap.keys.first} Function finished at: ${DateTime.now()} build, swipping_screen");
        print(
            "selectedUserUid: $selectedUserUid Function finished at: ${DateTime.now()} build, swipping_screen Function finished at: ${DateTime.now()}");
        print(
            "profileController.otherUserImageUrlsMap.value[selectedUserUid]  ${profileController.otherUserImageUrlsMap.value[selectedUserUid]} Function finished at: ${DateTime.now()}");

        images = otherUserImageUrlsMap[selectedUserUid]!;
      } else {
        print("otherUserImageUrlsMap is empty");
      }
    } else {
      print("profileController.allUserProfileList.is 無");
    }
    print(
        "Time taken to fetch and cache images: ${stopwatch.elapsed} updateSwipeItemsInitonly()");
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
        print(
            "Sender name: $senderName sender means current userswiping screen");
        print("setState called at readUserData() swipping screen");
      });
    }).catchError((error) {
      // Handle potential errors (optional)
      print("Error fetching data: $error");
    });
  }

  Future<void> loadCachedProfiles() async {
    await Future.delayed(Duration(milliseconds: 2000));
    final stopwatch = Stopwatch()..start();
    final storage = GetStorage();
    List<dynamic> cachedProfilesData = storage.read('cachedProfiles') ?? [];

    // If there are cached profiles, map them to Person objects
    if (cachedProfilesData.isNotEmpty) {
      setState(() {
        cachedProfiles = cachedProfilesData
            .map((profileData) => Person.fromJson(profileData))
            .toList();
        print(
            "cachedProfiles: $cachedProfiles loadCachedProfiles() swiping page");
        for (var profile in cachedProfiles) {
          print("Profile: $profile loadCachedProfiles() swiping page ");
        }

        print("setState called at loadCachedProfiles() swipping_screen");
      });
      print(
          'Loaded ${cachedProfiles.length} profiles from cache. swipping_screen');
    } else {
      print('No cached profiles found.swipping_screen ');
    }
    print(
        "Time taken to fetch and cache images: ${stopwatch.elapsed} checkAlignment");
    stopwatch.stop();
  }

// 這個function很重要 它查看firebase所有uid 跟alluserprofileList裡面的UID, 如果多餘的直接移除
  Future<void> validateAndCleanUpUserProfiles(
      Profilecontroller profileController) async {
    // Initialize a list to keep track of UIDs that need to be removed
    List<String> removedUids = [];
    final stopwatch = Stopwatch()..start();
    // Loop through each user in the profile list
    for (var user in List.from(profileController.allUserProfileList)) {
      // Creating a copy to avoid modifying the list while iterating
      if (user.uid != null) {
        // Check if the user exists in Firestore
        var userDoc = await FirebaseFirestore.instance
            .collection("users")
            .doc(user.uid)
            .get();

        if (!userDoc.exists) {
          // If the user does not exist in Firestore, remove them from the profile list
          profileController.allUserProfileList.remove(user);
          removedUids.add(user.uid!); // Add UID to the list of removed UIDs
          print(
              "Removed user UID: ${user.uid} as they do not exist in Firestore.");
        }
      }
    }

    // After the cleanup, print the list of removed UIDs
    if (removedUids.isNotEmpty) {
      print(
          "The following UIDs were removed because they do not exist in Firestore:");
      print(removedUids);
    } else {
      print("No invalid UIDs found in profileController.allUserProfileList.");
    }
    print(
        "Time taken to fetch and cache images: ${stopwatch.elapsed} validateAndCleanUpUserProfiles");
  }

  Future<void> checkAlignment(Map<String, List<String>> otherUserImageUrlsMap,
      List<Person> cachedProfiles) async {
    await Future.delayed(Duration(milliseconds: 3000));
    final stopwatch = Stopwatch()..start();
    for (var profile in cachedProfiles) {
      // Check if the uid exists in otherUserImageUrlsMap
      if (otherUserImageUrlsMap.containsKey(profile.uid)) {
        // Retrieve the list of image URLs from the map
        List<String>? mapImageUrls = otherUserImageUrlsMap[profile.uid];

        // Ensure both mapImageUrls and profile.imageUrls are non-null
        if (mapImageUrls != null && profile.imageUrls != null) {
          // Compare image URLs
          bool urlsMatch =
              mapImageUrls.every((url) => profile.imageUrls!.contains(url)) &&
                  profile.imageUrls!.every((url) => mapImageUrls.contains(url));

          // Log the result
          if (urlsMatch) {
            print('UID ${profile.uid} aligns correctly with image URLs.');
          } else {
            print('Mismatch found for UID ${profile.uid}.');
            print('Map URLs: $mapImageUrls');
            print('Profile URLs: ${profile.imageUrls}');
          }
        } else {
          print('One of the image URL lists is null for UID ${profile.uid}.');
        }
      } else {
        print('UID ${profile.uid} is not found in otherUserImageUrlsMap.');
      }
    }
    print(
        "Time taken to fetch and cache images: ${stopwatch.elapsed} checkAlignment");
    stopwatch.stop();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    // images = profileController.otherUserImageUrlsMap.value[selectedUserUid] ?? [];

    // print("Function finished at: ${DateTime.now()} build, swipping_screen");

    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(40.0), // Set the height here (e.g., 50.0)
        child: AppBar(
          backgroundColor: const Color.fromARGB(255, 255, 177, 177),
          title: Text(''), // Empty title or you can add a title here
          actions: <Widget>[
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: 16.0), // Padding for spacing
              child: IconButton(
                icon: Icon(
                  Icons.filter_alt,
                  size: 35.0, // Icon size
                  color: const Color.fromARGB(255, 107, 107, 107), // Icon color
                ),
                onPressed: () {
                  // Show the CustomPopup when the icon is pressed
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return CustomPopup(); // Use the CustomPopup widget here
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color.fromARGB(255, 255, 177, 177),
                      const Color.fromARGB(255, 247, 233, 233),
                      const Color.fromARGB(255, 255, 255, 255),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                padding: EdgeInsets.zero,
                margin: EdgeInsets.zero,
                child: Padding(
                  padding:
                      EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 0),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // if (images.isNotEmpty)

                        // if (cachedProfiles.isNotEmpty)
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: SmoothPageIndicator(
                                controller: PageController(
                                  initialPage: carouselIndex,
                                ),
                                count: images.length,
                                effect: WormEffect(
                                  dotHeight: 12,
                                  dotWidth: 12,
                                  activeDotColor: Colors.blue,
                                  dotColor: Colors.grey,
                                ),
                              ),
                            ),
                            CarouselSlider(
                              options: CarouselOptions(
                                height: screenHeight * 0.72,
                                autoPlay: false,
                                enlargeCenterPage: true,
                                enableInfiniteScroll: true,
                                autoPlayInterval: Duration(seconds: 2),
                                viewportFraction: 1.0,
                                onPageChanged: (index, reason) {
                                  setState(() {
                                    carouselIndex = index;
                                  });
                                },
                              ),
                              items: images.map((imageUrl) {
                                return Builder(
                                  builder: (BuildContext context) {
                                    return Container(
                                      // margin: EdgeInsets.all(1),
                                      decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                                255, 255, 255, 255)
                                            .withOpacity(0.0),
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: Stack(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            child: CachedNetworkImage(
                                              imageUrl: imageUrl,
                                              fit: BoxFit.cover,
                                              width: double.infinity,
                                              height: screenHeight * 1,
                                            ),
                                          ),
                                          // First set of buttons - above the three
                                          Positioned(
                                            top: screenHeight *
                                                0.5, // Positioning above the second row of buttons
                                            left: 0,
                                            right: 0,
                                            bottom: 0,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                // ElevatedButton(
                                                // child:
                                                Text(
                                                  _getDisplayText(
                                                      cachedProfiles[
                                                          currentIndex],
                                                      carouselIndex),
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize:
                                                        24, // Adjust the size of the text
                                                    fontFamily:
                                                        'YourFontFamily', // Specify the font family (if custom font is available)
                                                    fontWeight: FontWeight
                                                        .bold, // Optional: Make the text bold
                                                    letterSpacing:
                                                        1.5, // Optional: Adjust spacing between letters
                                                  ),
                                                ),
                                                //   onPressed: () {
                                                //     profileController
                                                //         .LikeSentReceieved(
                                                //       "eachProfileInfo.uid.toString()",
                                                //       senderName,
                                                //     );
                                                //     print('Like icon tapped!');
                                                //   },
                                                //   style:
                                                //       ElevatedButton.styleFrom(
                                                //     shape: StadiumBorder(),
                                                //     padding: EdgeInsets.all(10),
                                                //     backgroundColor:
                                                //         Color.fromARGB(
                                                //                 255, 82, 82, 82)
                                                //             .withOpacity(0.8),
                                                //     shadowColor:
                                                //         const Color.fromARGB(
                                                //                 255,
                                                //                 212,
                                                //                 211,
                                                //                 211)
                                                //             .withOpacity(0.3),
                                                //     elevation: 5,
                                                //   ),
                                                // ),
                                                SizedBox(width: 8),
                                                // ElevatedButton(
                                                Text(
                                                  _getDisplayText2(
                                                      cachedProfiles[
                                                          currentIndex],
                                                      carouselIndex),
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize:
                                                        24, // Adjust the size of the text
                                                    fontFamily:
                                                        'YourFontFamily', // Specify the font family (if custom font is available)
                                                    fontWeight: FontWeight
                                                        .bold, // Optional: Make the text bold
                                                    letterSpacing:
                                                        1.5, // Optional: Adjust spacing between letters
                                                  ),
                                                ),

                                                // SizedBox(width: 8),
                                                // ElevatedButton(
                                                //   child: Text(
                                                //     'Not Set',
                                                //     style: TextStyle(
                                                //       color: Colors.white,
                                                //     ),
                                                //   ),
                                                //   onPressed: () {
                                                //     print('Close icon tapped!');
                                                //   },
                                                //   style:
                                                //       ElevatedButton.styleFrom(
                                                //     shape: StadiumBorder(),
                                                //     padding: EdgeInsets.all(10),
                                                //     backgroundColor:
                                                //         Color.fromARGB(
                                                //                 255, 82, 82, 82)
                                                //             .withOpacity(0.8),
                                                //     shadowColor: Colors.black
                                                //         .withOpacity(0.3),
                                                //     elevation: 5,
                                                //   ),
                                                // ),
                                              ],
                                            ),
                                          ),
                                          // The three buttons (like, favorite, close)
                                          Positioned(
                                            bottom:
                                                20, // Positioning below the first row of buttons
                                            left: 0,
                                            right: 0,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                ElevatedButton(
                                                  onPressed: () {
                                                    profileController
                                                        .favoriteSentReceieved(
                                                            "eachProfileInfo.uid.toString()",
                                                            senderName);
                                                    print(
                                                        'Favorite icon tapped!');
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    shape: CircleBorder(),
                                                    padding: EdgeInsets.all(10),
                                                    backgroundColor:
                                                        const Color.fromARGB(
                                                            255, 110, 110, 110),
                                                    shadowColor: Colors.black
                                                        .withOpacity(0.3),
                                                    elevation: 5,
                                                  ),
                                                  child: Icon(
                                                    Icons.heat_pump_rounded,
                                                    color: const Color.fromARGB(
                                                        255, 255, 255, 255),
                                                    size: 30,
                                                  ),
                                                ),
                                                SizedBox(width: 4),
                                                ElevatedButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      handleLikeReceived();

                                                      // profileController
                                                      //     .LikeSentReceieved(
                                                      //         selectedUserUid,
                                                      //         senderName);
                                                      // currentIndex++;
                                                      // print(
                                                      //     "currentIndex: $currentIndex at likedReceivebutton swipingdart");
                                                      // print(
                                                      //     'Like heart tapped!');
                                                      // selectedUserUid =
                                                      //     profileKeys[
                                                      //         currentIndex];
                                                      // print(
                                                      //     'selectedUserUid:$selectedUserUid Function finished at: ${DateTime.now()} build, swipping_screen"');
                                                      // images =
                                                      //     otherUserImageUrlsMap[
                                                      //             selectedUserUid] ??
                                                      //         [];
                                                    });
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    shape: CircleBorder(),
                                                    padding: EdgeInsets.all(10),
                                                    backgroundColor:
                                                        const Color.fromARGB(
                                                            255, 255, 121, 121),
                                                    elevation: 5,
                                                  ),
                                                  child: Icon(Icons.favorite,
                                                      color:
                                                          const Color.fromARGB(
                                                              255,
                                                              110,
                                                              110,
                                                              110)),
                                                ),
                                                SizedBox(width: 4),
                                                ElevatedButton(
                                                  onPressed: () {
                                                    print('Close icon tapped!');
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    shape: CircleBorder(),
                                                    padding: EdgeInsets.all(10),
                                                    backgroundColor:
                                                        Color.fromARGB(255, 110,
                                                                110, 110)
                                                            .withOpacity(0.7),
                                                    shadowColor: Colors.black
                                                        .withOpacity(0.3),
                                                    elevation: 5,
                                                  ),
                                                  child: Icon(
                                                    Icons.close,
                                                    color: Colors.red,
                                                    size: 30,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  void handleLikeReceived() {
    // First, update all necessary variables and logic
    profileController.LikeSentReceieved(selectedUserUid, senderName);
    print('Like heart tapped!');
    print("Before increment, currentIndex: $currentIndex");
    currentIndex++;
    print("After increment, currentIndex: $currentIndex");
    selectedUserUid = profileKeys[currentIndex];
    print(
        'selectedUserUid:$selectedUserUid Function finished at: ${DateTime.now()} build, swipping_screen');
    images = otherUserImageUrlsMap[selectedUserUid] ?? [];

    // Then call setState() to trigger the rebuild
    setState(() {});
  }

  Future<void> _cacheImage(String imageUrl) async {
    // print(" DateTime.now() ${DateTime.now()} - cacheImage start");
    await CachedNetworkImageProvider(imageUrl).obtainKey(ImageConfiguration());
    print('Image cached: $imageUrl _cacheImage profileContoller.dart');

    // print(" DateTime.now() ${DateTime.now()} - cacheImage ends");
  }

  String _getDisplayText(Person profile, int carouselIndex) {
    switch (carouselIndex) {
      case 1:
        return "Test";
      case 2:
        return profile.age ?? "No Age";
      case 3:
        return profile.email ?? "No City";
      default:
        return profile.name ?? "No Name";
    }
  }

  String _getDisplayText2(Person profile, int carouselIndex) {
    switch (carouselIndex) {
      case 1:
        return "Test";
      case 2:
        return profile.age ?? "No Age";
      case 3:
        return profile.email ?? "No City";
      default:
        return profile.age ?? "No Age";
    }
  }

  String _getDisplayText3(Person profile, int carouselIndex) {
    switch (carouselIndex) {
      case 1:
        return "Test";
      case 2:
        return profile.age ?? "No Age";
      case 3:
        return profile.email ?? "No City";
      default:
        return profile.age ?? "No Age";
    }
  }
}
