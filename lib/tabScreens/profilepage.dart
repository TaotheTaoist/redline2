import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redline/accountSettingScreen/account_settings_screen.dart';
import 'package:redline/controller/profile-controller.dart';
import 'package:redline/global.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ProfilePage extends StatelessWidget {
  final Profilecontroller profileController = Get.put(Profilecontroller());
  final String currentUserId = currentUserID; // Replace with your actual UID

  @override
  Widget build(BuildContext context) {
    profileController.setUserId(currentUserId);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Profile Page",
          style: TextStyle(color: Colors.red), // White text for AppBar title
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      AccountSettingsScreen(userID: currentUserID),
                ),
              );
            },
            icon: const Icon(
              Icons.settings,
              size: 40,
              color: Colors.grey,
            ),
          ),
        ],
      ),
      backgroundColor: const Color.fromARGB(
          255, 255, 255, 255), // Black background for Scaffold
      body: SingleChildScrollView(
        controller: ScrollController(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Carousel
              Obx(() {
                return profileController.imageUrls.isEmpty
                    ? Text(
                        "No Images Available",
                        style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                      )
                    : SizedBox(
                        height: MediaQuery.of(context).size.height * 0.4,
                        width: MediaQuery.of(context).size.width,
                        child: CarouselSlider(
                          options: CarouselOptions(
                            height: MediaQuery.of(context).size.height * 0.4,
                            autoPlay: false,
                            enlargeCenterPage: true,
                            aspectRatio: 16 / 9,
                            enableInfiniteScroll:
                                profileController.imageUrls.length > 1,
                          ),
                          items: profileController.imageUrls.map((url) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: Image.network(
                                url,
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            );
                          }).toList(),
                        ),
                      );
              }),
              const SizedBox(height: 30),

              // Profile Name and Age
              Obx(() {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          profileController.name.value,
                          style: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '• ${profileController.age.value}',
                          style: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }),
              const SizedBox(height: 20),

              // Email
              Obx(() {
                return Text(
                  "Email: ${profileController.email.value}",
                  style: TextStyle(
                      fontSize: 18, color: Color.fromARGB(255, 0, 0, 0)),
                );
              }),
              const SizedBox(height: 10),

              // Birthday
              Obx(() {
                return Text(
                  "Birthday: ${profileController.birthday.value}",
                  style: TextStyle(
                      fontSize: 18, color: Color.fromARGB(255, 0, 0, 0)),
                );
              }),
              const SizedBox(height: 10),

              // Sex
              Obx(() {
                return Text(
                  "Sex: ${profileController.sex.value}",
                  style: TextStyle(
                      fontSize: 18, color: Color.fromARGB(255, 0, 0, 0)),
                );
              }),
              const SizedBox(height: 20),

              // Interests Section
              Obx(() {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Interests:",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                    SizedBox(height: 8),
                    // Assuming 'interestsfromfb' is the list of interests from Firebase
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 4.0,
                      children: profileController.interests.map((interest) {
                        return ElevatedButton(
                          onPressed: () {
                            print('Pressed: $interest');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 88, 88, 88),
                            foregroundColor:
                                const Color.fromARGB(255, 255, 255, 255),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text(
                            interest,
                            style: const TextStyle(fontSize: 14),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                );
              }),

              const SizedBox(height: 20),

              // Occupation Section
              Obx(() {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Occupation:",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    ...profileController.occupation.map(
                      (job) => Text(
                        "- $job",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ],
                );
              }),
              const SizedBox(height: 20),

              // MBTI Section
              Obx(() {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "MBTI:",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    ...profileController.mbti.map(
                      (mbtiType) => Text(
                        "- $mbtiType",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
