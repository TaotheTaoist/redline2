import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_storage/get_storage.dart';
import 'package:redline/global.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redline/models/person.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:swipe_cards/swipe_cards.dart';
import 'package:redline/controller/profile-controller.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:carousel_slider/carousel_slider.dart';

class SwipeableProfiles extends StatefulWidget {
  const SwipeableProfiles({Key? key}) : super(key: key);
  @override
  _SwipeableProfilesState createState() => _SwipeableProfilesState();
}

class _SwipeableProfilesState extends State<SwipeableProfiles> {
  // for images
  // =============================================================================================
  List<String> interestList = [];

  Future<SharedPreferences> prefs = SharedPreferences.getInstance();

  Map<String, List<String>> userImageUrlsMap = {};

  int currentIndex = 0;
  int carouselIndex = 0;

  List<SwipeItem> swipeItems1 = [];

  bool isLoading = true;

  // =============================================================================================

  List<String> profileKeys = [];

  String senderName = "";
  Profilecontroller profileController = Get.put(Profilecontroller());

  String selectedUserUid = "";
  List<String> images = [];

  PageController pageController = PageController();
  CarouselController carouselController = CarouselController();

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
        // print("readUserData() - Data snapshot: ${dataSnapshot.data()}");

        // Print the specific field value (senderName)
        print("Sender name: $senderName");
      });
    }).catchError((error) {
      // Handle potential errors (optional)
      print("Error fetching data: $error");
    });
  }

//

  Future<Map<String, List<String>>> generateUserImageUrlsMap(
      Profilecontroller profileController) async {
    // Initialize an empty map to store UIDs and corresponding image URLs

    if (profileController.allUserProfileList.isEmpty) {
      // print("No user profiles found in the list. generateUserImageUrlsMap");
      return userImageUrlsMap; // Return early if the list is empty
    }

    for (var user in profileController.allUserProfileList) {
      if (user.uid != null) {
        // print(
        // "Fetching user images for user ID: ${user.uid}  generateUserImageUrlsMap");
        var snapshot = await FirebaseFirestore.instance
            .collection("users")
            .doc(user.uid)
            .get();

        if (snapshot.exists) {
          // print(
          //     "Snapshot exists for user ID: ${user.uid} generateUserImageUrlsMap");
          Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

          // Log the entire data to see its structure
          // print("Data for user ID ${user.uid}: $data");

          // Ensure the imageUrls field exists and is a non-empty array
          if (data["imageUrls"] is List &&
              (data["imageUrls"] as List).isNotEmpty) {
            List<String> imageUrls = List<String>.from(data["imageUrls"] ?? []);

            // Log the retrieved imageUrls
            print("Image URLs for user ID ${user.uid}: $imageUrls");

            // Update the map only if imageUrls is not empty
            userImageUrlsMap[user.uid!] = imageUrls;
          } else {
            // print("No image URLs found for user ID: ${user.uid}");
          }
        } else {
          // print(
          // "No data found for user ID: ${user.uid} generateUserImageUrlsMap");
        }
      }
    }

    // print("Final userImageUrlsMap: $userImageUrlsMap generateUserImageUrlsMap");
    return userImageUrlsMap;
  }

  Future<void> updateSwipeItemsInitonly() async {
    Profilecontroller profileController = Get.find<Profilecontroller>();

    if (profileController.allUserProfileList.isNotEmpty) {
      await generateUserImageUrlsMap(profileController);

      if (userImageUrlsMap.isNotEmpty) {
        setState(() {
          selectedUserUid = userImageUrlsMap.keys.first;
          profileKeys = userImageUrlsMap.keys.toList();
          isLoading = false;
        });
        print("selectedUserUid assigned to ${userImageUrlsMap.keys.first}");
      } else {
        print("userImageUrlsMap is empty");
      }
    } else {
      print(
          "profileController.allUserProfileList.isNotEmpty${profileController.allUserProfileList.isNotEmpty} updateSwipeItemsInitonly()");
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        // isLoading = false; // Set loading to false after 3 seconds
      });
    });

// Error while sending like: 'package:redline/controller/profile-controller.dart': Failed assertion: line 334 pos 14: 'currentUserID.isNotEmpty': currentUserID is empty
// I/flutter (11412): Like icon tapped!
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        // User is logged in
        currentUserID = user.uid; // Set the global variable
        readUserData(); // Fetch user data after login
        setState(() {
          updateSwipeItemsInitonly(); //
        });
      } else {
        // User is logged out
        currentUserID = ''; // Clear the current user ID
        setState(() {
          print("User logged out. Current User ID cleared.");
        });
      }
    });
    print("Current User ID: $currentUserID swipping_screen.dart");
    // readUserData();

    print("currentIndex$currentIndex at init");
    // Future.delayed(Duration(seconds: 3), () {
    //   setState(() {
    //     isLoading = false; // Set loading to false after 3 seconds
    //   });
    // });
    final storage = GetStorage();
    print("storage.getValues()${storage.getValues()}");

    loadCachedProfiles();
    print(
        " current cached cachedProfiles: ${cachedProfiles[currentIndex].name}");
  }

// ----------- dont use Ever in init, this didchangeDependecies fix the tab change issue
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Profilecontroller profileController = Get.find<Profilecontroller>();

    // Set up the listener after the widget dependencies are ready
    ever(profileController.usersProfileList, (_) {
      updateSwipeItemsInitonly(); // Perform action when data changes
    });
  }

  List<Person> cachedProfiles = [];
  void loadCachedProfiles() {
    final storage = GetStorage();
    List<dynamic> cachedProfilesData = storage.read('cachedProfiles') ?? [];

    // If there are cached profiles, map them to Person objects
    if (cachedProfilesData.isNotEmpty) {
      setState(() {
        cachedProfiles = cachedProfilesData
            .map((profileData) => Person.fromJson(profileData))
            .toList();
      });
      print('Loaded ${cachedProfiles.length} profiles from cache.');
    } else {
      print('No cached profiles found.');
    }
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void _showPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Popup Title'),
          content: Text('This is a simple pop-up dialog!'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    // double screenWidth = MediaQuery.of(context).size.width;
    // List<String> images = userImageUrlsMap[selectedUserUid] ?? [];
    // List<String>
    images = profileController.userImageUrlsMap.value[selectedUserUid] ?? [];
    // images = (selectedUserUid.isNotEmpty &&
    //         userImageUrlsMap[selectedUserUid] != null)
    //     ? userImageUrlsMap[selectedUserUid] ?? []
    //     : [];
    // images = userImageUrlsMap[selectedUserUid] ?? [];
    // print(
    //     "profileController.userImageUrlsMap.value[selectedUserUid] ${profileController.userImageUrlsMap.value}");
    print("Function finished at: ${DateTime.now()} build, swipping_screen");
    // print("User image URLs for $selectedUserUid: $images");

    // print(profileController.userImageUrlsMap.value[selectedUserUid]);

    // print("images:$images");

    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: const Color.fromARGB(255, 255, 216, 216),
      //   elevation: 0,
      // ),
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
                  color: Colors.blue, // Icon color
                ),
                onPressed: () {
                  _showPopup(context); // Call the popup function when clicked
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
                      EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 15),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (images.isNotEmpty)
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
                                  height: screenHeight * 0.8,
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
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        child: Stack(
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              child: Image.network(
                                                imageUrl,
                                                fit: BoxFit.cover,
                                                width: double.infinity,
                                                height: screenHeight * 1,
                                              ),
                                            ),
                                            // First set of buttons - above the three
                                            Positioned(
                                              top:
                                                  30, // Positioning above the second row of buttons
                                              left: 0,
                                              right: 0,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  ElevatedButton(
                                                    child: Text(
                                                      _getDisplayText(
                                                          cachedProfiles[
                                                              currentIndex],
                                                          carouselIndex),
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      profileController
                                                          .LikeSentReceieved(
                                                        "eachProfileInfo.uid.toString()",
                                                        senderName,
                                                      );
                                                      print(
                                                          'Like icon tapped!');
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      shape: StadiumBorder(),
                                                      padding:
                                                          EdgeInsets.all(10),
                                                      backgroundColor:
                                                          Color.fromARGB(255,
                                                                  58, 225, 164)
                                                              .withOpacity(1),
                                                      shadowColor:
                                                          const Color.fromARGB(
                                                                  255,
                                                                  212,
                                                                  211,
                                                                  211)
                                                              .withOpacity(0.3),
                                                      elevation: 5,
                                                    ),
                                                  ),
                                                  SizedBox(width: 8),
                                                  ElevatedButton(
                                                    child: Text(
                                                      "",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      profileController
                                                          .LikeSentReceieved(
                                                        "eachProfileInfo.uid.toString()",
                                                        senderName,
                                                      );
                                                      print(
                                                          'Like icon tapped!');
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      shape: StadiumBorder(),
                                                      padding:
                                                          EdgeInsets.all(10),
                                                      backgroundColor:
                                                          Color.fromARGB(255,
                                                                  58, 225, 164)
                                                              .withOpacity(1),
                                                      shadowColor: Colors.black
                                                          .withOpacity(0.3),
                                                      elevation: 5,
                                                    ),
                                                  ),
                                                  SizedBox(width: 8),
                                                  ElevatedButton(
                                                    child: Text(
                                                      'Seoul',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      print(
                                                          'Close icon tapped!');
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      shape: StadiumBorder(),
                                                      padding:
                                                          EdgeInsets.all(10),
                                                      backgroundColor:
                                                          const Color.fromARGB(
                                                                  255,
                                                                  58,
                                                                  225,
                                                                  164)
                                                              .withOpacity(1),
                                                      shadowColor: Colors.black
                                                          .withOpacity(0.3),
                                                      elevation: 5,
                                                    ),
                                                  ),
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
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      shape: CircleBorder(),
                                                      padding:
                                                          EdgeInsets.all(10),
                                                      backgroundColor:
                                                          const Color.fromARGB(
                                                                  255,
                                                                  255,
                                                                  255,
                                                                  255)
                                                              .withOpacity(0.7),
                                                      shadowColor: Colors.black
                                                          .withOpacity(0.3),
                                                      elevation: 5,
                                                    ),
                                                    child: Icon(
                                                      Icons.heat_pump_rounded,
                                                      color:
                                                          const Color.fromARGB(
                                                              255,
                                                              255,
                                                              255,
                                                              255),
                                                      size: 30,
                                                    ),
                                                  ),
                                                  SizedBox(width: 4),
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        profileController
                                                            .LikeSentReceieved(
                                                                selectedUserUid,
                                                                senderName);
                                                        currentIndex++;
                                                        print(
                                                            'Like heart tapped!');
                                                        selectedUserUid =
                                                            profileKeys[1];
                                                        print(
                                                            'selectedUserUid:$selectedUserUid');
                                                      });
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      shape: CircleBorder(),
                                                      padding:
                                                          EdgeInsets.all(10),
                                                      backgroundColor: Colors
                                                          .grey
                                                          .withOpacity(0.7),
                                                      shadowColor: Colors.black
                                                          .withOpacity(0.3),
                                                      elevation: 5,
                                                    ),
                                                    child: Icon(
                                                      Icons.favorite,
                                                      color:
                                                          const Color.fromARGB(
                                                              255, 255, 0, 0),
                                                      size: 30,
                                                    ),
                                                  ),
                                                  SizedBox(width: 4),
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      print(
                                                          'Close icon tapped!');
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      shape: CircleBorder(),
                                                      padding:
                                                          EdgeInsets.all(10),
                                                      backgroundColor: Colors
                                                          .grey
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

  String _getDisplayText(Person profile, int carouselIndex) {
    switch (carouselIndex) {
      case 1:
        return "Test";
      case 2:
        return "Age";
      case 3:
        return profile.email ?? "No City";
      default:
        return profile.name ?? "No Name";
    }
  }
}
