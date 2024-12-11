import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'package:redline/controller/profile-controller.dart';
import 'package:redline/models/person.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter/material.dart';

class PersonCarousel extends StatefulWidget {
  @override
  _PersonCarouselState createState() => _PersonCarouselState();
}

class _PersonCarouselState extends State<PersonCarousel> {
  final Profilecontroller profileController = Get.find<Profilecontroller>();
  int carouselIndex = 0; // This will represent the current profile index
  bool isLoading = false;
  List<List<String>> userImages = []; // List to store images for each profile
  int currentProfileIndex = 0; // Track the current profile

  @override
  void initState() {
    super.initState();

    // Initially load images for the first profile
    userImages = profileController.allUserProfileList
        .map((person) => person.imageUrls?.isNotEmpty == true
            ? List<String>.from(person.imageUrls!)
            : <String>[])
        .toList();

    // Ensure we're only showing images of the first profile initially
    userImages = [userImages[0]]; // Just load the first profile's images
  }

  // Function to switch to the next profile
  void _switchProfile(int index) {
    if (index >= 0 && index < profileController.allUserProfileList.length) {
      setState(() {
        currentProfileIndex = index;
        userImages = [
          userImages[currentProfileIndex]
        ]; // Only show the images of the selected profile
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40.0), // Set the height here
        child: AppBar(
          backgroundColor: Color.fromARGB(255, 255, 177, 177),
          title: Text(''), // Empty title or you can add a title here
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: IconButton(
                icon: Icon(
                  Icons.filter_alt,
                  size: 35.0,
                  color: Color.fromARGB(255, 107, 107, 107),
                ),
                onPressed: () {
                  // Call the popup function
                  _showPopup(context);
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
                      Color.fromARGB(255, 255, 177, 177),
                      Color.fromARGB(255, 247, 233, 233),
                      Color.fromARGB(255, 255, 255, 255),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: SmoothPageIndicator(
                            controller:
                                PageController(initialPage: carouselIndex),
                            count: userImages[carouselIndex]
                                .length, // Use the length of images for current person
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
                            viewportFraction: 1.0,
                            onPageChanged: (index, reason) {
                              setState(() {
                                carouselIndex = index;
                              });
                            },
                          ),
                          items: userImages[carouselIndex].map((imageUrl) {
                            return Builder(
                              builder: (BuildContext context) {
                                return Container(
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(16),
                                        child: CachedNetworkImage(
                                          imageUrl: imageUrl,
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          height: screenHeight,
                                        ),
                                      ),
                                      Positioned(
                                        top: screenHeight * 0.5,
                                        left: 0,
                                        right: 0,
                                        bottom: 0,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            // ElevatedButton(
                                            //   onPressed: () {
                                            //     // Replace with actual action
                                            //   },
                                            //   style: ElevatedButton.styleFrom(
                                            //     shape: StadiumBorder(),
                                            //     padding: EdgeInsets.all(10),
                                            //     backgroundColor: Colors.grey,
                                            //     shadowColor: Colors.black
                                            //         .withOpacity(0.3),
                                            //     elevation: 5,
                                            //   ),
                                            //   child: Text(
                                            //   _getDisplayText(widget.persons[carouselIndex], carouselIndex),
                                            //     style: TextStyle(
                                            //         color: Colors.white),
                                            //   ),
                                            // ),
                                          ],
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 20,
                                        left: 0,
                                        right: 0,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            ElevatedButton(
                                              onPressed: () {
                                                // Replace with actual favorite logic
                                                profileController
                                                    .favoriteSentReceieved(
                                                  "uid",
                                                  "senderName",
                                                );
                                              },
                                              style: ElevatedButton.styleFrom(
                                                shape: CircleBorder(),
                                                padding: EdgeInsets.all(10),
                                                backgroundColor: Colors.grey
                                                    .withOpacity(0.7),
                                                elevation: 5,
                                              ),
                                              child: Icon(
                                                Icons.favorite,
                                                color: Colors.white,
                                                size: 30,
                                              ),
                                            ),
                                            SizedBox(width: 8),
                                            ElevatedButton(
                                              onPressed: () {
                                                // Replace with actual close action
                                              },
                                              style: ElevatedButton.styleFrom(
                                                shape: CircleBorder(),
                                                padding: EdgeInsets.all(10),
                                                backgroundColor: Colors.red,
                                                elevation: 5,
                                              ),
                                              child: Icon(
                                                Icons.close,
                                                color: Colors.white,
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
                        // Button to switch to next profile
                        ElevatedButton(
                          onPressed: () {
                            // Switch to the next profile (wrap around if necessary)
                            if (currentProfileIndex <
                                profileController.allUserProfileList.length -
                                    1) {
                              _switchProfile(currentProfileIndex +
                                  1); // Switch to next profile
                            }
                          },
                          child: Text('Next Profile'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  // Add your popup function here (e.g., _showPopup)
  void _showPopup(BuildContext context) {
    // Implement the popup functionality
  }
}
