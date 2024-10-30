import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:redline/authenticationScreen/birthdaycal.dart';
import 'package:redline/authenticationScreen/login_screen.dart';
import 'package:redline/controller/authenticationController.dart';
import 'package:redline/homeScreen/home_screen.dart';
import 'package:redline/widgets/custom_text_field_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  TextEditingController nameTextEditingController = TextEditingController();
  // TextEditingController ageTextEditingController = TextEditingController();
  TextEditingController phoneNoTextEditingController = TextEditingController();
  TextEditingController cityTextEditingController = TextEditingController();
  TextEditingController countryTextEditingController = TextEditingController();
  TextEditingController profileHeadingTextEditingController =
      TextEditingController();
  TextEditingController lookingForInaPartnerTextEditingController =
      TextEditingController();

  TextEditingController birthdayController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  //Appearance
  TextEditingController heightTextEditingController = TextEditingController();
  TextEditingController weighteTextEditingController = TextEditingController();
  TextEditingController bodyTypeForInaPartnerTextEditingController =
      TextEditingController();

  // LifyStyle
  TextEditingController drinkTextEditingController = TextEditingController();
  TextEditingController smokeTextEditingController = TextEditingController();
  TextEditingController martialStatusTextEditingController =
      TextEditingController();
  TextEditingController haveChildrenTextEditingController =
      TextEditingController();
  TextEditingController noOfChildrenNoTextEditingController =
      TextEditingController();
  TextEditingController employmentStatusTextEditingController =
      TextEditingController();
  TextEditingController professionTextEditingController =
      TextEditingController();
  TextEditingController incomeTextEditingController = TextEditingController();
  TextEditingController livingSituationTextEditingController =
      TextEditingController();
  TextEditingController willingtoRelocateTextEditingController =
      TextEditingController();
  TextEditingController relationshipYouAreLookingForTextEditingController =
      TextEditingController();

  // LifyStyle
  TextEditingController nationalityTextEditingController =
      TextEditingController();
  TextEditingController educationTextEditingController =
      TextEditingController();
  TextEditingController lanaguageStatusTextEditingController =
      TextEditingController();
  TextEditingController religionTextEditingController = TextEditingController();
  TextEditingController ethnicityChildrenNoTextEditingController =
      TextEditingController();

  bool showProgressBar = false;

  var authenticationcontroller =
      Authenticationcontroller.authenticationcontroller;

  final List<String> interests = ["Football", "Basketball", "Tennis"];

  final TextEditingController interestTextEditingController =
      TextEditingController();

  final List<String> selectedInterests = [];

  String labelText = "Time (optional)";

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
                      onTap: () =>
                          BirthdayCal.selectDate(context, birthdayController),
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
                      iconData: Icons.person,
                      isObscure: true,
                      borderRadius: 20.0,
                    ),
                    const SizedBox(height: 20),
                    CustomTextFieldWidget(
                      editingController: passwordlTextEditingController,
                      labelText: "Confirm your Password",
                      iconData: Icons.person,
                      isObscure: true,
                      borderRadius: 20.0,
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),

              Wrap(
                spacing: 10,
                children: interests.map((interest) {
                  final isSelected = selectedInterests.contains(interest);
                  return GestureDetector(
                    onTap: () => toggleInterest(interest),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.blue : Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        interest,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              // const SizedBox(height: 20),
              // Container(
              //   width: MediaQuery.of(context).size.width - 36,
              //   child: CustomTextFieldWidget(
              //     editingController: passwordlTextEditingController,
              //     labelText: "Password",
              //     iconData: Icons.lock_outline,
              //     isObscure: false,
              //   ),
              // ),

              // const SizedBox(height: 20),
              // Container(
              //   width: MediaQuery.of(context).size.width - 36,
              //   child: CustomTextFieldWidget(
              //     editingController: ageTextEditingController,
              //     labelText: "Age",
              //     iconData: Icons.numbers,
              //     isObscure: false,
              //   ),
              // ),
              const SizedBox(height: 20),
              Container(
                width: MediaQuery.of(context).size.width - 36,
                child: CustomTextFieldWidget(
                  editingController: phoneNoTextEditingController,
                  labelText: "Phone",
                  iconData: Icons.phone_outlined,
                  isObscure: false,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: MediaQuery.of(context).size.width - 36,
                child: CustomTextFieldWidget(
                  editingController: cityTextEditingController,
                  labelText: "City",
                  iconData: Icons.location_city,
                  isObscure: false,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: MediaQuery.of(context).size.width - 36,
                child: CustomTextFieldWidget(
                  editingController: countryTextEditingController,
                  labelText: "country",
                  iconData: Icons.location_city,
                  isObscure: false,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: MediaQuery.of(context).size.width - 36,
                child: CustomTextFieldWidget(
                  editingController: profileHeadingTextEditingController,
                  labelText: "Profile Heading",
                  iconData: Icons.text_fields,
                  isObscure: false,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: MediaQuery.of(context).size.width - 36,
                child: CustomTextFieldWidget(
                  editingController: lookingForInaPartnerTextEditingController,
                  labelText: "What are your looking for",
                  iconData: Icons.face,
                  isObscure: false,
                ),
              ),
              const Text(
                "Appearance",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: MediaQuery.of(context).size.width - 36,
                height: 55,
                child: CustomTextFieldWidget(
                  editingController: heightTextEditingController,
                  labelText: "Height",
                  iconData: Icons.insert_chart,
                  isObscure: false,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: MediaQuery.of(context).size.width - 36,
                height: 55,
                child: CustomTextFieldWidget(
                  editingController: weighteTextEditingController,
                  labelText: "Weight",
                  iconData: Icons.table_chart,
                  isObscure: false,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: MediaQuery.of(context).size.width - 36,
                height: 55,
                child: CustomTextFieldWidget(
                  editingController: bodyTypeForInaPartnerTextEditingController,
                  labelText: "Body Type",
                  iconData: Icons.type_specimen,
                  isObscure: false,
                ),
              ),
              const Text(
                "Life Style ",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: MediaQuery.of(context).size.width - 36,
                height: 55,
                child: CustomTextFieldWidget(
                  editingController: drinkTextEditingController,
                  labelText: "Drink",
                  iconData: Icons.local_drink,
                  isObscure: false,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: MediaQuery.of(context).size.width - 36,
                height: 55,
                child: CustomTextFieldWidget(
                  editingController: smokeTextEditingController,
                  labelText: "Smoking",
                  iconData: Icons.smoking_rooms,
                  isObscure: false,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: MediaQuery.of(context).size.width - 36,
                height: 55,
                child: CustomTextFieldWidget(
                  editingController: martialStatusTextEditingController,
                  labelText: "Martial Status",
                  iconData: CupertinoIcons.person_2,
                  isObscure: false,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: MediaQuery.of(context).size.width - 36,
                height: 55,
                child: CustomTextFieldWidget(
                  editingController: haveChildrenTextEditingController,
                  labelText: "have children",
                  iconData: CupertinoIcons.person_3_fill,
                  isObscure: false,
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width - 36,
                height: 55,
                child: CustomTextFieldWidget(
                  editingController: noOfChildrenNoTextEditingController,
                  labelText: "No. Children",
                  iconData: CupertinoIcons.person_3_fill,
                  isObscure: false,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: MediaQuery.of(context).size.width - 36,
                height: 55,
                child: CustomTextFieldWidget(
                  editingController: employmentStatusTextEditingController,
                  labelText: "Employment Status",
                  iconData: CupertinoIcons.rectangle_stack_person_crop_fill,
                  isObscure: false,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: MediaQuery.of(context).size.width - 36,
                height: 55,
                child: CustomTextFieldWidget(
                  editingController: professionTextEditingController,
                  labelText: "Profession",
                  iconData: Icons.business_center,
                  isObscure: false,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: MediaQuery.of(context).size.width - 36,
                height: 55,
                child: CustomTextFieldWidget(
                  editingController: incomeTextEditingController,
                  labelText: "Income",
                  iconData: CupertinoIcons.money_dollar_circle,
                  isObscure: false,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: MediaQuery.of(context).size.width - 36,
                height: 55,
                child: CustomTextFieldWidget(
                  editingController: livingSituationTextEditingController,
                  labelText: "living Situation",
                  iconData: CupertinoIcons.person_2_square_stack,
                  isObscure: false,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: MediaQuery.of(context).size.width - 36,
                height: 55,
                child: CustomTextFieldWidget(
                  editingController: willingtoRelocateTextEditingController,
                  labelText: "Willing to Relocate?",
                  iconData: CupertinoIcons.person_2,
                  isObscure: false,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: MediaQuery.of(context).size.width - 36,
                height: 55,
                child: CustomTextFieldWidget(
                  editingController:
                      relationshipYouAreLookingForTextEditingController,
                  labelText: "What relationship you are looking for?",
                  iconData: CupertinoIcons.person_2,
                  isObscure: false,
                ),
              ),

              const Text(
                "Background",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: MediaQuery.of(context).size.width - 36,
                height: 55,
                child: CustomTextFieldWidget(
                  editingController: nationalityTextEditingController,
                  labelText: "Nationality",
                  iconData: Icons.flag_circle_outlined,
                  isObscure: false,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: MediaQuery.of(context).size.width - 36,
                height: 55,
                child: CustomTextFieldWidget(
                  editingController: educationTextEditingController,
                  labelText: "Education",
                  iconData: Icons.history_edu,
                  isObscure: false,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: MediaQuery.of(context).size.width - 36,
                height: 55,
                child: CustomTextFieldWidget(
                  editingController: lanaguageStatusTextEditingController,
                  labelText: "language",
                  iconData: CupertinoIcons.person_badge_plus_fill,
                  isObscure: false,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: MediaQuery.of(context).size.width - 36,
                height: 55,
                child: CustomTextFieldWidget(
                  editingController: religionTextEditingController,
                  labelText: "Religion",
                  iconData: CupertinoIcons.checkmark_seal_fill,
                  isObscure: false,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: MediaQuery.of(context).size.width - 36,
                height: 55,
                child: CustomTextFieldWidget(
                  editingController: ethnicityChildrenNoTextEditingController,
                  labelText: "Ethincity",
                  iconData: CupertinoIcons.eye,
                  isObscure: false,
                ),
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

                      if (nameTextEditingController.text.trim().isEmpty) {
                        missingFields += 'Name, ';
                      }
                      if (emailTextEditingController.text.trim().isEmpty) {
                        missingFields += 'Email, ';
                      }
                      if (passwordlTextEditingController.text.trim().isEmpty) {
                        missingFields += 'Password, ';
                      }
                      // if (ageTextEditingController.text.trim().isEmpty) {
                      //   missingFields += 'Age, ';

                      // if (cityTextEditingController.text.trim().isEmpty) {
                      //   missingFields += 'City, ';
                      // }
                      // if (countryTextEditingController.text.trim().isEmpty) {
                      //   missingFields += 'Country, ';
                      // }

                      // Check if there are missing fields
                      if (missingFields.isNotEmpty) {
                        // Remove trailing comma and space
                        missingFields = missingFields.substring(
                            0, missingFields.length - 2);

                        // Show snackbar with the list of missing fields
                        Get.snackbar("Error",
                            "Please fill in the following fields: $missingFields");
                      } else {
                        // registerUser();
                        // All fields are filled, proceed to create new user
                        setState(() {
                          showProgressBar = true;
                        });

                        try {
                          await authenticationcontroller.creatNewUserAccount(
                            authenticationcontroller
                                .profileImage!, // Image file
                            emailTextEditingController.text.trim(), // Email
                            passwordlTextEditingController.text
                                .trim(), // Password
                            nameTextEditingController.text.trim(), // Name
                            // ageTextEditingController.text.trim(), // Age
                            phoneNoTextEditingController.text
                                .trim(), // Phone number
                            cityTextEditingController.text.trim(), // City
                            countryTextEditingController.text.trim(), // Country
                            profileHeadingTextEditingController.text
                                .trim(), // Profile Heading
                            lookingForInaPartnerTextEditingController.text
                                .trim(), // Looking for in a Partner
                            DateTime.now()
                                .millisecondsSinceEpoch, // Published date and time as an int
                            heightTextEditingController.text.trim(), // Height
                            weighteTextEditingController.text.trim(), // Weight
                            bodyTypeForInaPartnerTextEditingController.text
                                .trim(), // Body Type
                            drinkTextEditingController.text.trim(), // Drink
                            smokeTextEditingController.text.trim(), // Smoke
                            martialStatusTextEditingController.text
                                .trim(), // Marital Status
                            haveChildrenTextEditingController.text
                                .trim(), // Have children
                            noOfChildrenNoTextEditingController.text
                                .trim(), // Number of children
                            professionTextEditingController.text
                                .trim(), // Profession
                            employmentStatusTextEditingController.text
                                .trim(), // Employment status
                            incomeTextEditingController.text.trim(), // Income
                            livingSituationTextEditingController.text
                                .trim(), // Living situation
                            willingtoRelocateTextEditingController.text
                                .trim(), // Willing to relocate
                            relationshipYouAreLookingForTextEditingController
                                .text
                                .trim(), // Relationship you're looking for
                            nationalityTextEditingController.text
                                .trim(), // Nationality
                            educationTextEditingController.text
                                .trim(), // Education
                            lanaguageStatusTextEditingController.text
                                .trim(), // Language
                            religionTextEditingController.text
                                .trim(), // Religion
                            ethnicityChildrenNoTextEditingController.text
                                .trim(), // Ethnicity
                            selectedInterests,
                          );

                          // On success, hide progress bar and navigate to HomeScreen
                          setState(() {
                            showProgressBar = false;
                            Get.to(HomeScreen(
                                // userName:
                                //     nameTextEditingController.text.trim()
                                ));
                          });

                          // Show success message (e.g., navigation to a new screen or Snackbar)
                          Get.snackbar(
                              "Success", "Account created successfully");
                        } catch (e) {
                          // Handle the error (e.g., display error message)
                          setState(() {
                            showProgressBar = false;
                          });

                          Get.snackbar("Error", "Failed to create account: $e");
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
                    "Don't have an account",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.green,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: const Text(
                      "Already have an account",
                      style: TextStyle(
                          fontSize: 18,
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
