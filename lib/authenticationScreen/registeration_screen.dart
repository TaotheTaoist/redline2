import 'dart:io';

import 'package:intl/intl.dart';
import 'package:redline/constants/interests.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:redline/authenticationScreen/birthdaycal.dart';
import 'package:redline/controller/authenticationController.dart';
import 'package:redline/homeScreen/home_screen.dart';
import 'package:redline/widgets/custom_text_field_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class RegisterationScreen extends StatefulWidget {
  const RegisterationScreen({super.key});

  @override
  State<RegisterationScreen> createState() => _RegisterationScreenState();
}

class _RegisterationScreenState extends State<RegisterationScreen> {
  // personal info
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordlTextEditingController =
      TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  TextEditingController nameTextEditingController = TextEditingController();

  TextEditingController birthdayController = TextEditingController();

  TextEditingController timeController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  final TextEditingController sexController =
      TextEditingController(text: "Female");

  bool showProgressBar = false;
  bool isMale = false; // Default value, false means "Female", true means "Male"

  var authenticationcontroller =
      Authenticationcontroller.authenticationcontroller;

  final List<String> myInterests = interests;

  final List<String> iExercise = exercise;

  final TextEditingController interestTextEditingController =
      TextEditingController();

  final List<String> selectedInterests = [];

  String labelText = "Time (optional)";

  late int age;

  // Toggle selection on tap
  void toggleInterest(String interest) {
    setState(() {
      if (selectedInterests.contains(interest)) {
        selectedInterests.remove(interest);
      } else {
        selectedInterests.add(interest);
      }
    });
  }

  void addInterest() {
    // Get the interest from the text controller and add it to the list if not empty
    String newInterest = interestTextEditingController.text.trim();
    if (newInterest.isNotEmpty && !interests.contains(newInterest)) {
      interests.add(newInterest);
      interestTextEditingController
          .clear(); // Clear the text field after adding
    }
  }

  Future<bool> _checkIfEmailExists(String email, String currentUserId) async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get();
    return result.docs.isNotEmpty && result.docs.first.id != currentUserId;
  }

  void _showMoreInterests(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Select More Interests",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),

                    // Lifestyle Category
                    _buildInterestSection(
                        "Lifestyle", lifestyleInterests, setState),
                    SizedBox(height: 20),

                    // Toys Category
                    _buildInterestSection("Toys", toysInterests, setState),
                    SizedBox(height: 20),

                    // Done Button
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context); // Close the bottom sheet
                      },
                      child: Text("Done"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue, // Button color
                        padding:
                            EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                        textStyle: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showMoreexercise(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Select More Exercise",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),

                    // Lifestyle Category
                    _buildInterestSection("Exercise", exercise, setState),
                    SizedBox(height: 20),

                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context); // Close the bottom sheet
                      },
                      child: Text("Done"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue, // Button color
                        padding:
                            EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                        textStyle: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildInterestSection(
      String title, List<String> interests, StateSetter setState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 10),
        Wrap(
          spacing: 10,
          children: interests.map((interest) {
            final isSelected = selectedInterests.contains(interest);
            return ElevatedButton(
              onPressed: () {
                setState(() {
                  toggleInterest(
                      interest); // Call toggleInterest and update state
                });
              },
              child: Text(interest),
              style: ElevatedButton.styleFrom(
                backgroundColor: isSelected ? Colors.blue : Colors.grey[700],
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  @override
  void dispose() {
    // Dispose of controllers to free up resources
    emailTextEditingController.dispose();
    passwordlTextEditingController.dispose();
    confirmPasswordController.dispose();
    nameTextEditingController.dispose();
    birthdayController.dispose();
    timeController.dispose();
    emailController.dispose();
    interestTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 100,
              ),
              Text("Create Account",
                  style: TextStyle(
                      fontSize: 22,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold)),
              SizedBox(
                height: 10,
              ),
              Text("to get Started Now.",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(
                height: 10,
              ),

              //choose image circle avatar
              authenticationcontroller.imageFile == null
                  ? CircleAvatar(
                      radius: 80,
                      backgroundImage:
                          AssetImage("lib/image/profileAvatar.png"),
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
                      await authenticationcontroller
                          .captureImageromPhoneCamera();
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

              Container(
                width: MediaQuery.of(context).size.width - 36,
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    CustomTextFieldWidget(
                      editingController: nameTextEditingController,
                      labelText: "Name",
                      iconData: Icons.person,
                      borderRadius: 20.0,
                    ),
                    const SizedBox(height: 20),
                    CustomTextFieldWidget(
                      editingController: emailTextEditingController,
                      labelText: "Email",
                      iconData: Icons.email_outlined,
                      borderRadius: 20.0,
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () async {
                        // Call the selectDate function

                        DateTime? selectedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime(2100),
                        );

                        if (selectedDate != null) {
                          // Calculate the age
                          age = BirthdayCal.calculateAge(selectedDate);

                          print("age: $age");
                          String formattedDate =
                              DateFormat('yyyy-MM-dd').format(selectedDate);

                          // Update the TextEditingController with both birthday and age
                          birthdayController.text =
                              '$formattedDate (Age: $age)';
                        }
                      },
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
                        await BirthdayCal.selectTime(context, timeController);
                        setState(() {
                          labelText = timeController.text.isEmpty
                              ? "Time (optional)"
                              : timeController
                                  .text; // Update label text based on selection
                        });
                      },
                      child: AbsorbPointer(
                        child: CustomTextFieldWidget(
                          editingController: timeController,
                          labelText: labelText, // Use the updated label text
                          iconData: Icons.access_time,
                          borderRadius: 20.0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    CustomTextFieldWidget(
                      editingController: passwordlTextEditingController,
                      labelText: "Password",
                      iconData: Icons.lock_outline,
                      isObscure: true,
                      borderRadius: 20.0,
                    ),
                    const SizedBox(height: 20),
                    CustomTextFieldWidget(
                      editingController: confirmPasswordController,
                      labelText: "Confirm your Password",
                      iconData: Icons.lock_outline,
                      isObscure: true,
                      borderRadius: 20.0,
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),

              Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start, // Align title to the start
                children: [
                  // Title for the container
                  Padding(
                    padding: const EdgeInsets.only(
                        bottom: 8.0), // Space between title and container
                    child: Text(
                      "Your Interests", // Change this to your desired title
                      style: TextStyle(
                        fontSize: 18, // Font size of the title
                        fontWeight: FontWeight.bold, // Bold font style
                        color: Colors.white, // Title color
                      ),
                    ),
                  ),

                  // Container for interests
                  Container(
                    width: MediaQuery.of(context).size.width - 36,
                    decoration: BoxDecoration(
                      color: Colors.grey[900], // Dark gray background
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
                    child: Column(
                      children: [
                        Wrap(
                          spacing: 10,
                          children: interests.take(5).map((interest) {
                            final isSelected =
                                selectedInterests.contains(interest);
                            return GestureDetector(
                              onTap: () {
                                toggleInterest(
                                    interest); // Call the function to toggle interest
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? Colors.blue
                                      : Colors.grey[
                                          300], // Change color based on selection
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  interest,
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        TextButton(
                          onPressed: () => _showMoreInterests(
                              context), // Call the function to show more interests
                          child: Text(
                            "Show More",
                            style: TextStyle(
                                color: Colors.blue), // Style for the button
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start, // Align title to the start
                children: [
                  // Title for the container
                  Padding(
                    padding: const EdgeInsets.only(
                        bottom: 8.0), // Space between title and container
                    child: Text(
                      "Exercise", // Change this to your desired title
                      style: TextStyle(
                        fontSize: 18, // Font size of the title
                        fontWeight: FontWeight.bold, // Bold font style
                        color: Colors.white, // Title color
                      ),
                    ),
                  ),

                  // Container for interests
                  Container(
                    width: MediaQuery.of(context).size.width - 36,
                    decoration: BoxDecoration(
                      color: Colors.grey[900], // Dark gray background
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
                    child: Column(
                      children: [
                        Wrap(
                          spacing: 10,
                          children: exercise.take(5).map((exercise) {
                            final isSelected =
                                selectedInterests.contains(exercise);
                            return GestureDetector(
                              onTap: () {
                                toggleInterest(
                                    exercise); // Call the function to toggle interest
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? Colors.blue
                                      : Colors.grey[
                                          300], // Change color based on selection
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  exercise,
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        TextButton(
                          onPressed: () => _showMoreexercise(
                              context), // Call the function to show more interests
                          child: Text(
                            "Show More",
                            style: TextStyle(
                                color: Colors.blue), // Style for the button
                          ),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: isMale, // Boolean value controlling the switch state
                    onChanged: (bool value) {
                      setState(() {
                        isMale = value; // Update the boolean value
                        sexController.text = isMale ? "Female" : "Male";
                      });
                    },
                    activeColor: Colors.blue, // Color of the toggle when active
                    inactiveThumbColor:
                        Colors.grey, // Color of the toggle when inactive
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                width: MediaQuery.of(context).size.width - 36,
                height: 55,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(12),
                  ),
                ),
                child: InkWell(
                  onTap: () async {
                    if (authenticationcontroller.profileImage != null) {
                      String missingFields =
                          ''; // Variable to collect missing field names

                      // Check for missing fields
                      if (nameTextEditingController.text.trim().isEmpty) {
                        missingFields += 'Name, ';
                      }
                      if (emailTextEditingController.text.trim().isEmpty) {
                        missingFields += 'Email, ';
                      }
                      if (passwordlTextEditingController.text.trim().isEmpty) {
                        missingFields += 'Password, ';
                      }

                      if (missingFields.isNotEmpty) {
                        // Remove trailing comma and space
                        missingFields = missingFields.substring(
                            0, missingFields.length - 2);

                        // Show snackbar with the list of missing fields
                        Get.snackbar("Error",
                            "Please fill in the following fields: $missingFields");
                      } else {
                        // All fields are filled, proceed to create new user
                        setState(() {
                          showProgressBar = true; // Show progress bar
                        });

                        try {
                          await authenticationcontroller.creatNewUserAccount(
                              authenticationcontroller
                                  .profileImage!, // Image file
                              emailTextEditingController.text.trim(), // Email
                              passwordlTextEditingController.text
                                  .trim(), // Password
                              nameTextEditingController.text.trim(), // Name

                              selectedInterests,
                              [],
                              sexController.text.trim(),
                              birthdayController.text.trim(),
                              timeController.text.trim(),
                              timeController.text.isEmpty ? "false" : "true",
                              age);

                          print(
                              "sure: ${timeController.text.isEmpty ? "false" : "true"}");

                          // On success, hide progress bar and navigate to HomeScreen
                          if (mounted) {
                            // Check if widget is still mounted
                            setState(() {
                              showProgressBar = false; // Hide progress bar
                            });

                            // Show success message and navigate
                            Get.snackbar(
                                "Success", "Account created successfully");
                            // Get.to(HomeScreen());
                            Get.offAll(() => HomeScreen());
                          }
                        } catch (e) {
                          // Handle the error (e.g., display error message)
                          if (mounted) {
                            // Check if widget is still mounted
                            setState(() {
                              showProgressBar = false; // Hide progress bar
                            });
                            Get.snackbar(
                                "Error", "Failed to create account: $e");
                          }
                        }
                      }
                    } else {
                      Get.snackbar("Error", "Please select a profile image");
                    }
                  },
                  child: const Center(
                    child: Text(
                      "Register",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "D",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.green,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      print(Get.routing.current);

                      print("Tapped!");
                      Get.back();
                    },
                    child: const Text(
                      "已經有帳號",
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              showProgressBar == true
                  ? const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.pink),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
