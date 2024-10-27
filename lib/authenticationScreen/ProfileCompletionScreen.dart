import 'dart:io';

import 'package:redline/authenticationScreen/birthdaycal.dart';
import 'package:redline/controller/authenticationController.dart';
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

    return Scaffold(
      appBar: AppBar(title: const Text('Complete Your Profile')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
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
                  ),
            Row(
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
              ],
            ),
            const SizedBox(height: 20),
            CustomTextFieldWidget(
              editingController: nameController,
              labelText: "Name",
              iconData: Icons.person,
              borderRadius: 20.0,
            ),
            const SizedBox(height: 20),
            CustomTextFieldWidget(
              editingController: emailController,
              labelText: "Email",
              iconData: Icons.email_outlined,
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
              onTap: () => BirthdayCal.selectTime(context, birthdayController),
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
              // onTap: _getCurrentLocation,
              onTap: () {},
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
                final emailExists = await _checkIfEmailExists(
                    emailController.text.trim(), userID);
                if (emailExists) {
                  Get.snackbar(
                    "Email Already Exists",
                    "The email you entered is already in use.",
                    snackPosition: SnackPosition.BOTTOM,
                  );
                } else {
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(userID)
                      .set({
                    'name': nameController.text.trim(),
                    'email': emailController.text.trim(),
                    'birthday': birthdayController.text.trim(),
                    'location': locationController.text.trim(),
                    'imageProfile': widget.user.photoURL ?? '',
                  }, SetOptions(merge: true));
                  Get.back();
                }
              },
              child: const Text("Complete Profile"),
            ),
          ],
        ),
      ),
    );
  }

  // Method to select a date using date picker
  // void selectDate(BuildContext context) async {
  //   DateTime? selectedDate = await showDatePicker(
  //     context: context,
  //     initialDate: DateTime.now(),
  //     firstDate: DateTime(1900),
  //     lastDate: DateTime(2100),
  //   );

  //   if (selectedDate != null) {
  //     setState(() {
  //       birthdayController.text = DateFormat('yyyy-MM-dd').format(selectedDate);
  //     });
  //   }
  // }

  // void selectTime(BuildContext context) async {
  //   TimeOfDay? selectedTime = await showTimePicker(
  //     context: context,
  //     initialTime: TimeOfDay.now(),
  //   );

  //   if (selectedTime != null) {
  //     setState(() {
  //       timeController.text =
  //           selectedTime.format(context); // Formatting selected time
  //     });
  //   }
  // }

  // Method to check if an email exists for another user
  Future<bool> _checkIfEmailExists(String email, String currentUserId) async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get();
    return result.docs.isNotEmpty && result.docs.first.id != currentUserId;
  }
}
