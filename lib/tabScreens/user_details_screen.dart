import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
  // }

  String uid = "";
  String imageProfile = "";
  String email = "";
  String password = "";
  String name = "";
  // String age = "";
  String photoNo = "";
  // String city = "";
  // String country = "";
  // String profileHeading = "";
  // String lookingforInaPartner = "";

  int publishedDateTime = 0;

  String urlImage1 =
      "https://firebasestorage.googleapis.com/v0/b/dating-app-18f5d.appspot.com/o/placeholder%2FprofileAvatar.png?alt=media&token=a1fb4ae4-c16a-44fe-8ac7-858c0be0f5b3";
  String urlImage2 =
      "https://firebasestorage.googleapis.com/v0/b/dating-app-18f5d.appspot.com/o/placeholder%2FprofileAvatar.png?alt=media&token=a1fb4ae4-c16a-44fe-8ac7-858c0be0f5b3";
  String urlImage3 =
      "https://firebasestorage.googleapis.com/v0/b/dating-app-18f5d.appspot.com/o/placeholder%2FprofileAvatar.png?alt=media&token=a1fb4ae4-c16a-44fe-8ac7-858c0be0f5b3";
  String urlImage4 =
      "https://firebasestorage.googleapis.com/v0/b/dating-app-18f5d.appspot.com/o/placeholder%2FprofileAvatar.png?alt=media&token=a1fb4ae4-c16a-44fe-8ac7-858c0be0f5b3";
  String urlImage5 =
      "https://firebasestorage.googleapis.com/v0/b/dating-app-18f5d.appspot.com/o/placeholder%2FprofileAvatar.png?alt=media&token=a1fb4ae4-c16a-44fe-8ac7-858c0be0f5b3";
  String urlImage6 =
      "https://firebasestorage.googleapis.com/v0/b/dating-app-18f5d.appspot.com/o/placeholder%2FprofileAvatar.png?alt=media&token=a1fb4ae4-c16a-44fe-8ac7-858c0be0f5b3";
  List<String> urlsList = [];
  final List<String> placeholderUrls = [
    'https://firebasestorage.googleapis.com/v0/b/dating-app-18f5d.appspot.com/o/placeholder%2FprofileAvatar.png?alt=media&token=a1fb4ae4-c16a-44fe-8ac7-858c0be0f5b3',
    'https://firebasestorage.googleapis.com/v0/b/dating-app-18f5d.appspot.com/o/placeholder%2FprofileAvatar.png?alt=media&token=a1fb4ae4-c16a-44fe-8ac7-858c0be0f5b3',
    'https://firebasestorage.googleapis.com/v0/b/dating-app-18f5d.appspot.com/o/placeholder%2FprofileAvatar.png?alt=media&token=a1fb4ae4-c16a-44fe-8ac7-858c0be0f5b3',
    'https://firebasestorage.googleapis.com/v0/b/dating-app-18f5d.appspot.com/o/placeholder%2FprofileAvatar.png?alt=media&token=a1fb4ae4-c16a-44fe-8ac7-858c0be0f5b3',
    'https://firebasestorage.googleapis.com/v0/b/dating-app-18f5d.appspot.com/o/placeholder%2FprofileAvatar.png?alt=media&token=a1fb4ae4-c16a-44fe-8ac7-858c0be0f5b3',
    'https://firebasestorage.googleapis.com/v0/b/dating-app-18f5d.appspot.com/o/placeholder%2FprofileAvatar.png?alt=media&token=a1fb4ae4-c16a-44fe-8ac7-858c0be0f5b3',
  ];
  @override
  void initState() {
    super.initState();
    print('User UID widget.userID: ${widget.userID}');
    print('currentUserId:${FirebaseAuth.instance.currentUser!.uid}');

    retrieveUserInfo().then((_) {
      retrieveUserImages(); // Load images after user info is retrieved
    }).catchError((e) {
      print("Error during user info retrieval: $e");
    });
  }

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
          email = data["email"];
          uid = data["uid"];
        });
      } else {
        print("No such document!");
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  retrieveUserImages() async {
    print("Starting to fetch user images..."); // Add this line

    try {
      print("Fetching user images for user ID: ${widget.userID}");
      var snapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(widget.userID)
          .get();

      if (snapshot.exists) {
        print("Snapshot exists for user ID: ${widget.userID}");
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        List<String> imageUrls = List<String>.from(data["imageUrls"] ?? []);

        print("Fetched image URLs: $imageUrls");

        setState(() {
          // Add placeholders if less than 6 images
          urlsList = imageUrls.length >= 6 ? imageUrls : List.from(imageUrls)
            ..addAll(placeholderUrls.sublist(0, 6 - imageUrls.length));

          print("Updated urlsList: $urlsList");
        });
      } else {
        print("No document found for user ID: ${widget.userID}");
        // Use placeholders if no images available
        setState(() {
          urlsList = placeholderUrls;
          print("Using placeholder URLs: $urlsList");
        });
      }
    } catch (e) {
      print("Error fetching images: $e");
      // Use placeholders in case of error
      setState(() {
        urlsList = placeholderUrls;
        print("Using placeholder URLs due to error: $urlsList");
      });
    }
  }

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
                _deleteAccount(); // Call the delete account function
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  } // End of confirmation dialog function

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

    // Step 2: Show password dialog for re-authentication
    String? password = await showDialog<String>(
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

    // Step 3: Show a loading indicator while processing
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(child: CircularProgressIndicator());
      },
    );

    try {
      // Step 4: Re-authenticate user with the entered password
      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!,
        password: password,
      );
      await user.reauthenticateWithCredential(credential);

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
            size: 40,
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
                  size: 40,
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        controller: ScrollController(),
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
                  child: CarouselSlider(
                    options: CarouselOptions(
                      height: MediaQuery.of(context).size.height * 0.4,
                      autoPlay: false,
                      enlargeCenterPage: true,
                      aspectRatio: 16 / 9,
                      onPageChanged: (index, reason) {
                        // Optionally handle page change if needed
                      },
                    ),
                    items: urlsList.map((url) {
                      // Filter out any empty URLs
                      return url.isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: Image.network(
                                url,
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            )
                          : Container(); // Placeholder for empty URL
                    }).toList(),
                  ),
                ),
              ),
              SizedBox(height: 30),

              // Section: Appearance
              _buildSectionTitle("Section 1"),
              _buildTable([
                _buildTableRow("name", name),
                _buildTableRow("uid", widget.userID!),
                _buildTableRow("email", email),
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
                        widget.userID = "";
                        name = "";
                        uid = "";
                        imageProfile = "";
                        email = "";
                        password = "";

                        // String age = "";
                      });
                      // await FirebaseFirestore.instance.clearPersistence();
                      await FirebaseFirestore.instance.terminate();
                      // After sign out, navigate to a different page (optional)
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LoginScreen()), // Example
                      );

                      // Navigator.pushReplacement(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (BuildContext context) => LoginScreen()));
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
              fontSize: 15, // Smaller font for row labels
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            value.isNotEmpty ? value : "N/A",
            style: const TextStyle(
              color: Colors.white, // White for values
              fontSize: 15, // Smaller font for row values
            ),
          ),
        ),
      ],
    );
  }
}
