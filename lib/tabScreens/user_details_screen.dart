import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:redline/accountSettingScreen/account_settings_screen.dart';
import 'package:redline/authenticationScreen/login_screen.dart';
import 'package:redline/global.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slider/carousel.dart';
import 'package:get/get.dart';

class UserDetailsScreen extends StatefulWidget {
  String? userID;
  UserDetailsScreen({
    super.key,
    this.userID,
  });

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  @override
  void initState() {
    super.initState();
    // Print userID to ensure it's available
    print('User UID widget.userID: ${widget.userID}');
    print('currentUserId:${FirebaseAuth.instance.currentUser!.uid}');

    // Fetch user information when the screen is initialized
    retrieveUserInfo();
  }

  // String uid = "";
  // String imageProfile = "";
  // String email = "";
  // String password = "";
  String name = "";
  String age = "";
  String photoNo = "";
  String city = "";
  String country = "";
  String profileHeading = "";
  String lookingforInaPartner = "";

  int publishedDateTime = 0;

// appearance
  String height = "";
  String weight =
      ""; // Changed from "Weight" to "weight" to follow camelCase convention
  String bodyType = "";
  String drink = "";
  String smoke = "";
  String maritalStatus =
      ""; // Corrected spelling from "martialStatus" to "maritalStatus"
  String haveChildren = "";
  String noChildren = "";
  String profession = "";
  String employmentStatus = "";
  String income = "";
  String livingSituation = "";
  String willingtoRelocate = "";
  String relationshipYouAreLookingFor = "";

// background
  String nationality = "";
  String education = "";
  String language = "";
  String religion = "";
  String ethnicity = "";

  String urlImage1 =
      "https://firebasestorage.googleapis.com/v0/b/datingapp-f1d4d.appspot.com/o/Profile%20Images%2FPlace%20Holder%2FprofileAvatar.png?alt=media&token=f5977e15-f648-454e-9e6b-b3e94e75fdc8";
  String urlImage2 =
      "https://firebasestorage.googleapis.com/v0/b/datingapp-f1d4d.appspot.com/o/Profile%20Images%2FPlace%20Holder%2FprofileAvatar.png?alt=media&token=f5977e15-f648-454e-9e6b-b3e94e75fdc8";
  String urlImage3 =
      "https://firebasestorage.googleapis.com/v0/b/datingapp-f1d4d.appspot.com/o/Profile%20Images%2FPlace%20Holder%2FprofileAvatar.png?alt=media&token=f5977e15-f648-454e-9e6b-b3e94e75fdc8";
  String urlImage4 =
      "https://firebasestorage.googleapis.com/v0/b/datingapp-f1d4d.appspot.com/o/Profile%20Images%2FPlace%20Holder%2FprofileAvatar.png?alt=media&token=f5977e15-f648-454e-9e6b-b3e94e75fdc8";
  String urlImage5 =
      "https://firebasestorage.googleapis.com/v0/b/datingapp-f1d4d.appspot.com/o/Profile%20Images%2FPlace%20Holder%2FprofileAvatar.png?alt=media&token=f5977e15-f648-454e-9e6b-b3e94e75fdc8";
  String urlImage6 =
      "https://firebasestorage.googleapis.com/v0/b/datingapp-f1d4d.appspot.com/o/Profile%20Images%2FPlace%20Holder%2FprofileAvatar.png?alt=media&token=f5977e15-f648-454e-9e6b-b3e94e75fdc8";

  // retrieveUserInfo() async {
  //   FirebaseFirestore.instance
  //       .collection("users")
  //       .doc(widget.userID)
  //       .get()
  //       .then((snapshot) {
  //     if (snapshot.exists) {
  //       if (snapshot.data()!["urlImage1"] != null) {
  //         urlImage1 = snapshot.data()!["urlImage1"];
  //         urlImage2 = snapshot.data()!["urlImage2"];
  //         urlImage3 = snapshot.data()!["urlImage3"];
  //         urlImage4 = snapshot.data()!["urlImage4"];
  //         urlImage5 = snapshot.data()!["urlImage5"];
  //         urlImage6 = snapshot.data()!["urlImage6"];
  //       }

  //       setState(() {
  //         name = snapshot.data()!["name"];

  //         age = snapshot.data()!["age"];
  //         photoNo = snapshot.data()!["photoNo"];
  //         city = snapshot.data()!["city"];
  //         country = snapshot.data()!["country"];
  //         profileHeading = snapshot.data()!["profileHeading"];
  //         lookingforInaPartner = snapshot.data()!["lookingforInaPartner"];
  //         height = snapshot.data()!["height"];
  //         weight = snapshot.data()!["weight"];
  //         bodyType = snapshot.data()!["bodyType"];
  //         drink = snapshot.data()!["drink"];
  //         smoke = snapshot.data()!["smoke"];
  //         maritalStatus = snapshot.data()!["maritalStatus"];
  //         haveChildren = snapshot.data()!["haveChildren"];
  //         noChildren = snapshot.data()!["noChildren"];
  //         profession = snapshot.data()!["profession"];
  //         employmentStatus = snapshot.data()!["employmentStatus"];
  //         income = snapshot.data()!["income"];
  //         livingSituation = snapshot.data()!["livingSituation"];
  //         willingtoRelocate = snapshot.data()!["willingtoRelocate"];
  //         relationshipYouAreLookingFor =
  //             snapshot.data()!["relationshipYouAreLookingFor"];
  //         nationality = snapshot.data()!["nationality"];
  //         education = snapshot.data()!["education"];
  //         language = snapshot.data()!["language"];
  //         religion = snapshot.data()!["religion"];
  //         ethnicity = snapshot.data()!["ethnicity"];
  //       });
  //     }
  //   });
  // }
  // Start of confirmation dialog function

  // Start of delete account function
  // Function to prompt the user for confirmation before deletion
  void _confirmDeleteAccount(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text(
              'Are you sure you want to delete your account? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _deleteAccount(context); // Call the delete account function
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  } // End of confirmation dialog function

  void _deleteAccount(BuildContext context) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        // Step 1: Delete user data from Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .delete();
        print('User data deleted successfully');

        // Step 2: Delete the user account from Firebase Authentication
        await user.delete();
        print('Account deleted successfully');

        // Navigate to the login screen after deletion
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      } catch (e) {
        print('Error deleting account: $e');

        // Handle specific errors if needed
        if (e is FirebaseAuthException) {
          switch (e.code) {
            case 'requires-recent-login':
              // Inform the user to reauthenticate
              print('User needs to reauthenticate.');
              // Optionally prompt the user to re-enter their credentials here.
              break;
            default:
              print('An unknown error occurred: ${e.message}');
          }
        } else if (e is FirebaseException) {
          // Handle Firestore deletion errors if needed
          print('Error deleting user data from Firestore: ${e.message}');
        }
      }
    } else {
      print('No user is currently signed in.');
    }
  } // End of delete account function

  retrieveUserInfo() async {
    try {
      var snapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(widget.userID)
          .get();

      if (snapshot.exists) {
        // Cast snapshot.data() to Map<String, dynamic>
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        setState(() {
          name = data["name"]; // Now you can access "name"
          // ... other data retrieval
        });
      } else {
        print("No such document!");
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name.isNotEmpty ? name : "User Details"),
        centerTitle: true,
        automaticallyImplyLeading: true, // This will show the back button
        leading: IconButton(
          onPressed: () {
            Get.back(); // Navigate back when the back button is pressed
          },
          icon: const Icon(
            Icons.arrow_back_outlined,
            size: 30,
          ),
        ),
        actions: [
          Row(
            children: [
              IconButton(
                onPressed: () {
                  Get.to(
                      AccountSettingsScreen()); // Navigate to account settings
                },
                icon: const Icon(
                  Icons.settings,
                  size: 30,
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Carousel
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.4,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: Carousel(
                    indicatorBarColor: Colors.black.withOpacity(0.3),
                    autoScrollDuration: Duration(seconds: 3),
                    animationPageDuration: Duration(milliseconds: 500),
                    activateIndicatorColor: Colors.black,
                    animationPageCurve: Curves.easeIn,
                    indicatorBarHeight: 30,
                    indicatorHeight: 10,
                    indicatorWidth: 10,
                    unActivatedIndicatorColor: Colors.grey,
                    stopAtEnd: false,
                    autoScroll: true,
                    items: [
                      Image.network(urlImage1, fit: BoxFit.cover),
                      Image.network(urlImage2, fit: BoxFit.cover),
                      Image.network(urlImage3, fit: BoxFit.cover),
                      Image.network(urlImage4, fit: BoxFit.cover),
                      Image.network(urlImage5, fit: BoxFit.cover),
                      Image.network(urlImage6, fit: BoxFit.cover),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30),

              // Section: Appearance
              _buildSectionTitle("Appearance"),
              _buildTable([
                _buildTableRow("name", name),
                _buildTableRow("Height", height),
                _buildTableRow("Weight", weight),
                _buildTableRow("Body Type", bodyType),
                _buildTableRow("Drink", drink),
                _buildTableRow("Smoke", smoke),
                _buildTableRow("Marital Status", maritalStatus),
                _buildTableRow("Have Children", haveChildren),
              ]),

              // Section: Background
              _buildSectionTitle("Background"),
              _buildTable([
                _buildTableRow("Nationality", nationality),
                _buildTableRow("Education", education),
                _buildTableRow("Language", language),
                _buildTableRow("Religion", religion),
                _buildTableRow("Ethnicity", ethnicity),
              ]),

              // Section: Lifestyle
              _buildSectionTitle("Lifestyle"),
              _buildTable([
                _buildTableRow("Profession", profession),
                _buildTableRow("Employment Status", employmentStatus),
                _buildTableRow("Income", income),
                _buildTableRow("Living Situation", livingSituation),
                _buildTableRow("Willing to Relocate", willingtoRelocate),
                _buildTableRow(
                    "Relationship Looking For", relationshipYouAreLookingFor),
              ]),
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.center, // Align buttons to center
                children: [
                  ElevatedButton(
                    // Start of Log Out Button
                    onPressed: () async {
                      await FirebaseAuth.instance
                          .signOut(); // Sign out the user

                      setState(() {
                        currentUserID =
                            ""; // Clear the global or current user ID variable
                      });

                      // After sign out, navigate to a different page (optional)
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LoginScreen()), // Example
                      );
                    },
                    child: Text("Log Out"),
                  ), // End of Log Out Button

                  SizedBox(width: 20), // Spacer between buttons

                  ElevatedButton(
                    // Start of Delete Account Button
                    onPressed: () {
                      _confirmDeleteAccount(
                          context); // Call confirmation dialog
                    },
                    child: Text('Delete Account'),
                  ), // End of Delete Account Button
                ], // End of children in Row
              ), // End of Row for buttons
            ],
          ),
        ),
      ),
    );
  }

// Helper function to build a section title
  Widget _buildSectionTitle(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white, // White text
              fontSize: 22, // Font size 22 for section titles
              fontWeight: FontWeight.bold, // Bold font weight
            ),
          ),
        ),
        const Divider(
          color: Colors.white, // White divider
          thickness: 2, // Divider thickness of 2 for section titles
        ),
      ],
    );
  }

// Helper function to build categorized table rows
  Widget _buildTable(List<TableRow> rows) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[900], // Dark background for the table
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black54,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20.0),
      child: Table(
        columnWidths: const {
          0: FlexColumnWidth(3),
          1: FlexColumnWidth(5),
        },
        children: rows,
      ),
    );
  }

// Helper function to build individual table rows
  TableRow _buildTableRow(String label, String value) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold, // Bold for row labels
              color: Colors.white70, // Slightly off-white color
              fontSize: 12, // Smaller font for row labels
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            value.isNotEmpty ? value : "N/A",
            style: const TextStyle(
              color: Colors.white, // White for values
              fontSize: 12, // Smaller font for row values
            ),
          ),
        ),
      ],
    );
  }
}
