import 'dart:io';

import 'package:redline/authenticationScreen/birthdaycal.dart';
import 'package:redline/controller/authenticationController.dart';
import 'package:redline/homeScreen/home_screen.dart';
import 'package:redline/tabScreens/swipping_screen.dart';
import 'package:redline/widgets/custom_text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // For date formatting

class ProfileCompletionScreen extends StatefulWidget {
  final User user;

  const ProfileCompletionScreen({Key? key, required this.user})
      : super(key: key);

  @override
  _ProfileCompletionScreenState createState() =>
      _ProfileCompletionScreenState();
}

class _ProfileCompletionScreenState extends State<ProfileCompletionScreen> {
  final TextEditingController nameController = TextEditingController();

  final TextEditingController locationController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController birthdayController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  var authenticationcontroller =
      Authenticationcontroller.authenticationcontroller;

  @override
  Widget build(BuildContext context) {
    final String userID = widget.user.uid;
    final String userEmail = widget.user.email ?? "";

    Future<void> checkProfileCompletion() async {
      try {
        var snapshot = await FirebaseFirestore.instance
            .collection("users")
            .doc(widget.user.uid)
            .get();

        if (snapshot.exists) {
          Map<String, dynamic>? data = snapshot.data();
          if (data != null &&
              data['name'] != null &&
              data['email'] != null &&
              data['uid'] != null &&
              data['birthday'] != null) {
            // All required fields are filled
            if (mounted) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
            }
          } else {
            print("Some fields are missing.");
            // You could show a Snackbar here for testing
          }
        } else {
          print("No such document!");
        }
      } catch (e) {
        print("Error checking profile completion: $e");
      }
    }

    @override
    void initState() {
      super.initState();
      // checkProfileCompletion();
    }

    @override
    void dispose() {
      nameController.dispose();
      locationController.dispose();
      timeController.dispose();
      birthdayController.dispose();
      emailController.dispose();
      super.dispose();
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Complete Your Profile')),
      body: SingleChildScrollView(
        // Start of SingleChildScrollView
        padding: const EdgeInsets.all(20.0),
        child: Column(
          // Start of Column
          children: [
            Text("Logged in as: $userEmail"),
            Text(
              "User ID: $userID",
              style: const TextStyle(fontSize: 16),
            ),
            authenticationcontroller.imageFile == null
                ? CircleAvatar(
                    radius: 80,
                    backgroundImage: AssetImage("lib/image/profileAvatar.png"),
                    backgroundColor: Colors.black,
                  )
                : Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey,
                      image: DecorationImage(
                          fit: BoxFit.fitHeight,
                          image: FileImage(
                            File(
                              authenticationcontroller.imageFile!.path,
                            ),
                          )),
                    ),
                  ), // End of Container
            Row(
              // Start of Row
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () async {
                    await authenticationcontroller.pickImageFileFromGallery();
                    setState(() {
                      authenticationcontroller.imageFile;
                    });
                  },
                  icon: Icon(
                    Icons.image_outlined,
                    color: Colors.grey,
                    size: 30,
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    await authenticationcontroller.captureImageromPhoneCamera();
                    setState(() {
                      authenticationcontroller.imageFile;
                    });
                  },
                  icon: Icon(
                    Icons.camera_alt_outlined,
                    color: Colors.grey,
                    size: 30,
                  ),
                )
              ], // End of children in Row
            ), // End of Row
            const SizedBox(height: 20),
            CustomTextFieldWidget(
              editingController: nameController,
              labelText: "Name",
              iconData: Icons.person,
              borderRadius: 20.0,
            ),

            const SizedBox(height: 20),
            GestureDetector(
              onTap: () => BirthdayCal.selectDate(context, birthdayController),
              child: AbsorbPointer(
                child: CustomTextFieldWidget(
                  editingController: birthdayController,
                  labelText: "Birthday",
                  iconData: Icons.cake,
                  borderRadius: 20.0,
                ),
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () async {
                TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (pickedTime != null) {
                  final String formattedTime =
                      pickedTime.format(context); // Format the time
                  timeController.text = formattedTime; // Update the controller
                }
              },
              child: AbsorbPointer(
                child: CustomTextFieldWidget(
                  editingController: timeController,
                  labelText: "Time (optional)",
                  iconData: Icons.access_time,
                  borderRadius: 20.0,
                ),
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {}, // Implement location function
              child: AbsorbPointer(
                child: CustomTextFieldWidget(
                  editingController: locationController,
                  labelText: "Location",
                  iconData: Icons.location_on,
                  borderRadius: 20.0,
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(userID)
                    .set({
                  'name': nameController.text.trim(),
                  'email': widget.user.email,
                  'uid': userID,
                  'birthday': birthdayController.text.trim(),
                  // 'location': locationController.text.trim(),
                  'imageProfile': widget.user.photoURL ?? '',
                }, SetOptions(merge: true));
                await checkProfileCompletion();
                // }
              },
              child: const Text("Complete Profile"),
            ),
          ], // End of children in Column
        ), // End of Column
      ), // End of SingleChildScrollView
    );
  }
}
