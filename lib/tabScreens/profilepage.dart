import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redline/accountSettingScreen/account_settings_screen.dart';
import 'package:redline/authenticationScreen/login_screen.dart';
import 'package:redline/controller/profile-controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:redline/global.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final Profilecontroller profileController = Get.put(Profilecontroller());
  final String currentUserId = currentUserID;

  // @override
  // void dispose() {
  //   profileController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    profileController.setUserId(currentUserId);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "編輯",
          style: TextStyle(color: Colors.pink[900]),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      AccountSettingsScreen(userID: currentUserId),
                ),
              );
            },
            icon: Icon(
              Icons.settings,
              size: 40,
              color: Colors.grey,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        controller: ScrollController(),
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Carousel
            Obx(() {
              return profileController.imageUrls.isEmpty
                  ? Center(
                      child: Text(
                        "No Images Available",
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : CarouselSlider(
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
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            url,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        );
                      }).toList(),
                    );
            }),
            const SizedBox(height: 30),

            // User Details
            Obx(() {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            profileController.name.value,
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '• ${profileController.age.value}',
                            style: TextStyle(fontSize: 20, color: Colors.black),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  // Text(
                  //   "${profileController.sign} ${profileController.xingxuo}",
                  //   style: TextStyle(fontSize: 16, color: Colors.black),
                  // ),
                ],
              );
            }),
            Divider(color: Colors.grey[300], thickness: 1.0),
            const SizedBox(height: 20),

            // About Me
            Obx(() {
              return Section(
                title: "關於我",
                content: profileController.aboutMe.value,
              );
            }),
            const SizedBox(height: 20),
            Obx(() {
              return Section(
                title: "birthday",
                content: profileController.birthday.value,
              );
            }),
            const SizedBox(height: 20),
            // Interests
            Obx(() {
              return Section(
                title: "興趣",
                child: Wrap(
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children: profileController.interests.map((interest) {
                    return ElevatedButton(
                      onPressed: () => print('Pressed: $interest'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[800],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
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
              );
            }),
            const SizedBox(height: 20),
            Obx(() {
              return Section(
                title: "教育",
                child: Wrap(
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children: profileController.education.map((education) {
                    return ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[800],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(
                        education,
                        style: const TextStyle(fontSize: 14),
                      ),
                    );
                  }).toList(),
                ),
              );
            }),
            const SizedBox(height: 20),
            // MBTI Section
            Obx(() {
              return Section(
                title: "MBTI",
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: profileController.mbti.map((mbtiType) {
                    return Text(
                      "- $mbtiType",
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    );
                  }).toList(),
                ),
              );
            }),
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.center, // Align buttons to center
              children: [
                ElevatedButton(
                  onPressed: () async {
                    // await FirebaseAuth.instance.signOut();
                    // Navigator.pushAndRemoveUntil(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => LoginScreen()),
                    //   (route) =>
                    //       false, // This condition removes all previous routes
                    // );

                    FirebaseAuth auth = FirebaseAuth.instance;
                    auth.signOut().then((res) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    }).catchError((error) {
                      // Handle any error during sign-out (optional)
                      print("Error signing out: $error");
                    });
                    // setState(() {
                    // currentUserID =
                    //     ""; // Clear the global or current user ID variable
                    // widget.userID = "";
                    // name = "";
                    // uid = "";
                    // imageProfile = "";
                    // email = "";
                    // password = "";

                    // String age = "";
                    // });

                    // something the app wont complete log out, u need to terminate it
                    await FirebaseFirestore.instance.clearPersistence();
                    await FirebaseFirestore.instance.terminate();

                    // Navigator.pushReplacement(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (BuildContext context) =>
                    //             LoginScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(
                        255, 255, 190, 212), // Background color
                    foregroundColor: const Color.fromARGB(
                        255, 221, 55, 40), // Text (and icon) color
                  ),
                  child: Text(
                    'Log Out',
                    style: TextStyle(
                      fontWeight:
                          FontWeight.bold, // Optional: Customize text further
                    ),
                  ),
                ),
                SizedBox(width: 20), // Spacer between buttons
                ElevatedButton(
                  onPressed: () {
                    // _confirmDeleteAccount(context); // Call confirmation dialog
                    _deleteAccount();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(
                        255, 255, 190, 212), // Background color
                    foregroundColor: const Color.fromARGB(
                        255, 221, 55, 40), // Text (and icon) color
                  ),
                  child: Text(
                    'Delete Account',
                    style: TextStyle(
                      fontWeight:
                          FontWeight.bold, // Optional: Customize text further
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _deleteAccount() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("No user is currently logged in.")),
      );
      return;
    }

    // Step 1: Show confirmation dialog to delete account
    bool confirmed = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete Account"),
          content: Text(
              "Are you sure you want to delete your account? This action cannot be undone."),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel"),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: Text("Delete"),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    String? password = '';

    // Step 2: Determine if the user is logged in with Google or email/password
    if (user.providerData[0].providerId == 'google.com') {
      // If the user is logged in with Google, prompt them to re-enter their email to confirm account deletion
      String? email = await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          String inputEmail = '';
          return AlertDialog(
            title: Text("Confirm Email"),
            content: TextField(
              onChanged: (value) {
                inputEmail = value;
              },
              decoration:
                  InputDecoration(labelText: "Enter your email to confirm"),
            ),
            actions: <Widget>[
              TextButton(
                child: Text("Cancel"),
                onPressed: () => Navigator.of(context).pop(),
              ),
              TextButton(
                child: Text("Confirm"),
                onPressed: () => Navigator.of(context).pop(inputEmail),
              ),
            ],
          );
        },
      );

      if (email == null || email.isEmpty || email != user.email) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Email does not match.")),
        );
        return;
      }
    } else {
      // If the user is logged in via email/password, prompt for password
      password = await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          String inputPassword = '';
          return AlertDialog(
            title: Text("Re-authenticate"),
            content: TextField(
              onChanged: (value) {
                inputPassword = value;
              },
              obscureText: true,
              decoration: InputDecoration(labelText: "Enter your password"),
            ),
            actions: <Widget>[
              TextButton(
                child: Text("Cancel"),
                onPressed: () => Navigator.of(context).pop(),
              ),
              TextButton(
                child: Text("Confirm"),
                onPressed: () => Navigator.of(context).pop(inputPassword),
              ),
            ],
          );
        },
      );

      if (password == null || password.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Password is required to delete account.")),
        );
        return;
      }
    }

    // Step 3: Show a loading indicator while processing
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(child: CircularProgressIndicator());
      },
    );

    try {
      // Step 4: Re-authenticate the user based on the authentication method
      if (user.providerData[0].providerId == 'google.com') {
        // Google login does not need password reauthentication
        // Proceed directly with account deletion
      } else {
        // Re-authenticate user with the entered password (for email/password login)
        AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!,
          password: password!,
        );
        await user.reauthenticateWithCredential(credential);
      }

      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      final FirebaseStorage storage = FirebaseStorage.instance;

      DocumentSnapshot userDoc =
          await firestore.collection("users").doc(user.uid).get();
      final userData = userDoc.data() as Map<String, dynamic>?;

      if (userData != null) {
        if (userData.containsKey('imageProfile')) {
          String profileImageUrl = userData['imageProfile'];
          await _deleteImage(profileImageUrl, storage);
        }
        if (userData.containsKey('imageUrls')) {
          List<dynamic> imageUrls = userData['imageUrls'];
          for (String imageUrl in imageUrls) {
            await _deleteImage(imageUrl, storage);
          }
        }
        await firestore.collection("users").doc(user.uid).delete();
      }

      // Step 5: Delete user account and log out
      await user.delete();
      await FirebaseAuth.instance.signOut();

      Navigator.of(context, rootNavigator: true)
          .pop(); // Close the loading indicator

      // Navigate to LoginScreen and remove all previous routes
      Get.offAll(LoginScreen());

      // Optionally show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Account deleted successfully.")),
      );
    } catch (e) {
      Navigator.of(context, rootNavigator: true)
          .pop(); // Close the loading indicator
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error deleting account: $e")),
      );
      print("Error deleting account: $e");
    }
  }

  Future<void> _deleteImage(String imageUrl, FirebaseStorage storage) async {
    try {
      final ref = storage.refFromURL(imageUrl);
      await ref.delete();
      print("Deleted image: $imageUrl");
    } catch (e) {
      print("Error deleting image: $e");
    }
  }
}

class Section extends StatelessWidget {
  final String title;
  final String? content;
  final Widget? child;

  const Section({
    required this.title,
    this.content,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.pink[900],
          ),
        ),
        const SizedBox(height: 8),
        if (content != null)
          Text(
            content!,
            style: TextStyle(fontSize: 16, color: Colors.black),
          ),
        if (child != null) child!,
      ],
    );
  }
}
