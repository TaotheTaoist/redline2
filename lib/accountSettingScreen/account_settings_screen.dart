import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';

import 'package:redline/authenticationScreen/birthdaycal.dart';
import 'package:redline/constants/interests.dart';

class AccountSettingsScreen extends StatefulWidget {
  String? userID;
  AccountSettingsScreen({
    super.key,
    this.userID,
  });

  @override
  State<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  bool uploading = false;
  double val = 0;
  final List<File?> _images =
      List<File?>.filled(6, null); // List to hold images
  List<String> urlsList =
      List<String>.filled(6, ""); // Store URLs for each image

  final List<String> selectedInterests = [];
  final List<String> myInterests = interests;

  final List<String> iExercise = exercise;

  // Personal info
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  TextEditingController BDController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController sexController = TextEditingController();
  TextEditingController aboutmeController = TextEditingController();

  int age = 0;
  String sex = "Male";

  String? currentUserID;
  final storage = GetStorage();
  @override
  void initState() {
    super.initState();
    getCurrentUserID();
    retrieveUserData();
    retrieveUserImages();
    // print(urlsList);
  }

  // 一定要確定是現在的UID
  void getCurrentUserID() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      currentUserID = user.uid;
      print("Current user ID: $currentUserID AccountSettingsScreen");
    } else {
      print("No user is logged in. AccountSettingsScreen");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 177, 177),
        title: const Text(
          "Account Settings",
          style: TextStyle(color: Colors.white, fontSize: 22),
        ),
        // automaticallyImplyLeading: false,
        actions: [],
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 255, 177, 177),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white, // Background color for the rounded container
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(0),
              topRight: Radius.circular(50),
            ),
            boxShadow: [
              // BoxShadow(
              //   color: Colors.black.withOpacity(0.1), // Shadow color
              //   blurRadius: 10, // Shadow blur radius
              //   offset: Offset(0, -5), // Shadow offset (above)
              // ),
            ],
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  _buildImagePicker(),
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: saveProfileImage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(
                          255, 252, 179, 236), // Background color
                      foregroundColor:
                          const Color.fromARGB(255, 252, 47, 47), // Text color
                      textStyle: const TextStyle(
                        fontSize: 16, // Font size
                        fontWeight: FontWeight.bold, // Font weight
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(20), // Rounded corners
                      ),
                      shadowColor: const Color.fromARGB(137, 63, 63,
                          63), // Shadow color (applied to button shadow)
                      elevation: 6, // Elevation defines the size of the shadow
                    ),
                    child: const Text("Save Image"),
                  ),
                  const SizedBox(height: 20),
                  _aboutmeTextField(aboutmeController, "關於我"),
                  const SizedBox(height: 20),
                  _buildTextField(nameTextEditingController, "Name"),
                  _buildTextField(emailTextEditingController, "Email"),
                  _buildTextField(passwordTextEditingController, "Password"),
                  _buildbdField(context, BDController, "Birthday"),
                  _buildTimeTextField(
                    context,
                    timeController,
                    "Select Time",
                  ),
                  _buildSwitchField(
                    sexController, // TextEditingController for sex
                    "Sex",
                    sex, // String value ("Male" or "Female")
                    (bool newValue) {
                      setState(() {
                        sex = newValue
                            ? "Male"
                            : "Female"; // Update the sex value
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: MediaQuery.of(context).size.width - 36,
                    decoration: BoxDecoration(
                      color: Colors
                          .transparent, // Keep the outer container transparent
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(34),
                        topRight: Radius.circular(34),
                        bottomLeft: Radius.circular(34),
                        bottomRight: Radius.circular(34),
                      ),
                      border: Border.all(
                        color: Colors.grey.withOpacity(0.8), // Outline color
                        width: 2.0, // Outline width
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(
                              137, 63, 63, 63), // Shadow color
                          blurRadius: 6,
                          offset: const Offset(8, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey[
                                200], // Customize inner gray area background
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(48),
                              topRight: Radius.circular(34),
                              bottomLeft: Radius.circular(34),
                              bottomRight: Radius.circular(34),
                            ),
                          ),
                          padding: const EdgeInsets.all(
                              20), // Padding for the inner content
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
                                          interest); // Toggle interest state
                                    },
                                    child: AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 300),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 8),
                                      decoration: BoxDecoration(
                                        borderRadius: isSelected
                                            ? const BorderRadius.all(
                                                Radius.circular(
                                                    34), // Fully rounded for selected state
                                              )
                                            : const BorderRadius.only(
                                                topLeft: Radius.circular(34),
                                                topRight: Radius.circular(18),
                                                bottomLeft: Radius.circular(18),
                                                bottomRight:
                                                    Radius.circular(18),
                                              ),
                                        border: Border.all(
                                          color: isSelected
                                              ? const Color.fromARGB(
                                                  255,
                                                  238,
                                                  80,
                                                  159) // Focused border color
                                              : Colors
                                                  .grey, // Enabled border color
                                          width: 2,
                                        ),
                                        color: isSelected
                                            ? const Color.fromARGB(
                                                255,
                                                231,
                                                255,
                                                19) // Background for selected state
                                            : Colors.grey[
                                                300], // Background for unselected state
                                      ),
                                      child: Text(
                                        interest,
                                        style: TextStyle(
                                          color: isSelected
                                              ? const Color.fromARGB(
                                                  255, 236, 116, 116)
                                              : Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                              const SizedBox(
                                  height:
                                      10), // Space between interests and button
                              TextButton(
                                onPressed: () => _showMoreInterests(
                                    context), // Show more interests
                                child: const Text(
                                  "Show More",
                                  style: TextStyle(
                                    color: Colors.blue, // Button text color
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: saveProfileData,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(
                          255, 253, 157, 232), // Background color
                      foregroundColor:
                          const Color.fromARGB(255, 243, 91, 91), // Text color

                      textStyle: const TextStyle(
                        fontSize: 16, // Font size
                        fontWeight: FontWeight.bold, // Font weight
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(20), // Rounded corners
                      ),
                    ),
                    child: const Text("Save Profile"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void toggleInterest(String interest) {
    setState(() {
      if (selectedInterests.contains(interest)) {
        selectedInterests.remove(interest);
      } else {
        selectedInterests.add(interest);
      }
    });
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
                color: Colors.grey,
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
                backgroundColor: isSelected
                    ? Colors.blue
                    : const Color.fromARGB(255, 236, 130, 130),
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildImagePicker() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1,
      ),
      itemCount: _images.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => _chooseImage(index),
          child: Container(
            margin: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.8), // Shadow color
                  spreadRadius: 1, // Spread radius
                  blurRadius: 6, // Blur radius
                  offset: const Offset(6, 6), // Shadow position (x, y)
                ),
              ],
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(
                  18), // Rounded corners for the image container
            ),
            child: Stack(
              clipBehavior: Clip
                  .none, // Allow cancel button to be outside the image bounds
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(34),
                    topRight: Radius.circular(18),
                    bottomLeft: Radius.circular(18),
                    bottomRight: Radius.circular(18),
                  ),
                  child: _images[index] != null
                      ? Image.file(
                          _images[index]!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        )
                      : Container(
                          color:
                              Colors.grey[300], // Placeholder for null images
                          child: const Center(
                            child: Icon(
                              Icons.add_photo_alternate,
                              size: 40,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                ),
                if (_images[index] !=
                    null) // Show cancel button only if the image is selected
                  Positioned(
                    top: 5,
                    right: 5,
                    child: IconButton(
                      icon:
                          const Icon(Icons.cancel, color: Colors.red, size: 20),
                      onPressed: () => _removeImage(index),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _removeImage(int index) {
    setState(() {
      _images[index] = null; // Remove the image at the specified index
    });
  }

  _chooseImage(int index) async {
    XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _images[index] = File(pickedFile.path);
      });
    }
  }

  Widget _buildSwitchField(
    TextEditingController controller,
    String label,
    String value,
    Function(bool) onChanged,
  ) {
    // Convert the String value to a bool (true for "Male", false for "Female")
    bool isMale = value == "Male";

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Row(
            children: [
              Text(
                isMale ? "Male" : "Female", // Display Male or Female
                style: TextStyle(
                  color: isMale ? Colors.blue : Colors.pink, // Dynamic color
                  fontWeight: FontWeight.bold, // Optional: Bold text
                ),
              ),
              Switch(
                value: isMale, // Use bool value for switch state
                onChanged: (bool newValue) {
                  // Update the boolean value and the controller text
                  onChanged(newValue);
                  controller.text = newValue ? "Male" : "Female";
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.8), // Shadow color
              spreadRadius: 1, // Spread radius
              blurRadius: 6, // Blur radius
              offset: const Offset(6, 6), // Shadow position (x, y)
            ),
          ],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(34),
            topRight: Radius.circular(18),
            bottomLeft: Radius.circular(18),
            bottomRight: Radius.circular(18),
          ),
        ),
        child: TextField(
          controller: controller,
          style: const TextStyle(
            color: Color.fromARGB(255, 80, 80, 80), // Text color
            fontSize: 16, // Font size for input text
            fontWeight: FontWeight.w500, // Font weight
          ),
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(
              color: Color.fromARGB(255, 255, 140, 140), // Label text color
              fontSize: 14, // Font size for label
            ),
            hintText: "Enter $label", // Placeholder text
            hintStyle: TextStyle(
              color: Colors.grey[600], // Placeholder text color
              fontSize: 14, // Font size for placeholder
            ),
            fillColor:
                Colors.grey[300], // Background color inside the TextField
            filled: true, // Enables the fillColor property
            border: OutlineInputBorder(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(34),
                topRight: Radius.circular(18),
                bottomLeft: Radius.circular(18),
                bottomRight: Radius.circular(18),
              ),
              borderSide: const BorderSide(
                color: Colors.grey, // Outline border color
                width: 2, // Outline border width
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(34),
                topRight: Radius.circular(18),
                bottomLeft: Radius.circular(18),
                bottomRight: Radius.circular(18),
              ),
              borderSide: const BorderSide(
                color: Colors.grey, // Outline border color
                width: 2, // Outline border width
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(34),
                topRight: Radius.circular(34),
                bottomLeft: Radius.circular(34),
                bottomRight: Radius.circular(34),
              ),
              borderSide: const BorderSide(
                color: Color.fromARGB(
                    255, 238, 80, 159), // Border color when focused
                width: 2, // Border width when focused
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _aboutmeTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.8), // Shadow color
              spreadRadius: 1, // Spread radius
              blurRadius: 6, // Blur radius
              offset: const Offset(6, 6), // Shadow position (x, y)
            ),
          ],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(18),
            topRight: Radius.circular(18),
            bottomLeft: Radius.circular(18),
            bottomRight: Radius.circular(18),
          ),
        ),
        child: TextField(
          controller: controller,
          maxLines: null, // Allows unlimited lines
          keyboardType: TextInputType.multiline, // Enables multi-line input
          style: const TextStyle(
            color: Color.fromARGB(255, 80, 80, 80), // Text color
            fontSize: 16, // Font size for input text
            fontWeight: FontWeight.w500, // Font weight
          ),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 20, // Adjust vertical padding as needed
            ),
            labelText: label,
            labelStyle: const TextStyle(
              color: Color.fromARGB(255, 30, 45, 255), // Label text color
              fontSize: 14, // Font size for label
            ),
            hintText: "Enter $label", // Placeholder text
            hintStyle: TextStyle(
              color: Colors.grey[600], // Placeholder text color
              fontSize: 14, // Font size for placeholder
            ),
            fillColor:
                Colors.grey[300], // Background color inside the TextField
            filled: true, // Enables the fillColor property
            border: OutlineInputBorder(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
                bottomLeft: Radius.circular(18),
                bottomRight: Radius.circular(18),
              ),
              borderSide: const BorderSide(
                color: Colors.grey, // Outline border color
                width: 2, // Outline border width
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
                bottomLeft: Radius.circular(18),
                bottomRight: Radius.circular(18),
              ),
              borderSide: const BorderSide(
                color: Colors.grey, // Outline border color
                width: 2, // Outline border width
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(34),
                topRight: Radius.circular(34),
                bottomLeft: Radius.circular(34),
                bottomRight: Radius.circular(34),
              ),
              borderSide: const BorderSide(
                color: Color.fromARGB(
                    255, 238, 80, 159), // Border color when focused
                width: 2, // Border width when focused
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Widget _buildbdField(BuildContext context,
  //     TextEditingController dateController, String label) {
  //   return GestureDetector(
  //     onTap: () async {
  //       DateTime? pickedDate = await showDatePicker(
  //         context: context,
  //         initialDate: DateTime.now(),
  //         firstDate: DateTime(1900), // Earliest selectable date
  //         lastDate: DateTime(2100), // Latest selectable date
  //       );
  //       if (pickedDate != null) {
  //         // Format the selected date and update the controller
  //         final String formattedDate =
  //             "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
  //         dateController.text = formattedDate;

  //         age = BirthdayCal.calculateAge(pickedDate);
  //       }
  //     },
  //     child: AbsorbPointer(
  //       child: CustomTextFieldWidget(
  //         editingController: dateController,
  //         labelText: label,
  //         iconData: Icons.calendar_today,
  //         borderRadius: 20.0, // Adjust as needed
  //       ),
  //     ),
  //   );
  // }
  Widget _buildbdField(BuildContext context,
      TextEditingController dateController, String label) {
    final FocusNode focusNode = FocusNode();

    return GestureDetector(
      onTap: () async {
        // Trigger focus for visual feedback
        focusNode.requestFocus();

        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900), // Earliest selectable date
          lastDate: DateTime(2100), // Latest selectable date
        );

        // Remove focus after date selection
        focusNode.unfocus();

        if (pickedDate != null) {
          final String formattedDate =
              "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
          dateController.text = formattedDate;

          age = BirthdayCal.calculateAge(pickedDate);
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: AbsorbPointer(
          child: TextField(
            controller: dateController,
            focusNode: focusNode,
            style: const TextStyle(
              color: Color.fromARGB(255, 80, 80, 80), // Text color
              fontSize: 16, // Font size for input text
              fontWeight: FontWeight.w500, // Font weight
            ),
            decoration: InputDecoration(
              labelText: label,
              labelStyle: TextStyle(
                color: Colors.grey[800], // Label text color
                fontSize: 14, // Font size for label
              ),
              hintText: "Enter $label", // Placeholder text
              hintStyle: TextStyle(
                color: Colors.grey[600], // Placeholder text color
                fontSize: 14, // Font size for placeholder
              ),
              fillColor:
                  Colors.grey[300], // Background color inside the TextField
              filled: true, // Enables the fillColor property
              border: OutlineInputBorder(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(34),
                  topRight: Radius.circular(18),
                  bottomLeft: Radius.circular(18),
                  bottomRight: Radius.circular(18),
                ), // Apply custom border radius
                borderSide: const BorderSide(
                  color: Colors.grey, // Outline border color
                  width: 2, // Outline border width
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(34),
                  topRight: Radius.circular(18),
                  bottomLeft: Radius.circular(18),
                  bottomRight: Radius.circular(18),
                ), // Border radius for enabled state
                borderSide: const BorderSide(
                  color: Colors.grey, // Outline border color
                  width: 2, // Outline border
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(34),
                  topRight: Radius.circular(34),
                  bottomLeft: Radius.circular(34),
                  bottomRight: Radius.circular(34),
                ), // Border radius for focused state
                borderSide: const BorderSide(
                  color: Color.fromARGB(
                      255, 238, 80, 159), // Border color when focused
                  width: 2, // Border width when focused
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimeTextField(BuildContext context,
      TextEditingController timeController, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: GestureDetector(
        onTap: () async {
          TimeOfDay? pickedTime = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.now(),
            builder: (context, child) {
              return MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(alwaysUse24HourFormat: true),
                child: child!,
              );
            },
          );
          if (pickedTime != null) {
            // Format the selected time in 24-hour format and update the controller
            final String formattedTime =
                pickedTime.hour.toString().padLeft(2, '0') +
                    ":" +
                    pickedTime.minute.toString().padLeft(2, '0');
            timeController.text = formattedTime;
          }
        },
        child: AbsorbPointer(
          child: TextField(
            controller: timeController,
            decoration: InputDecoration(
              labelText: label,
              border: OutlineInputBorder(),
              suffixIcon: const Icon(Icons.access_time),
            ),
          ),
        ),
      ),
    );
  }

  uploadImages() async {
    setState(() {
      uploading = true;
      val = 0;
    });

    int uploadedCount = 0;

    for (int i = 0; i < _images.length; i++) {
      if (_images[i] != null) {
        // Update progress
        setState(() {
          val = (uploadedCount + 1) / _images.length;
        });

        var ref = FirebaseStorage.instance
            .ref()
            .child("images/${DateTime.now().millisecondsSinceEpoch}_$i.jpg");

        await ref.putFile(_images[i]!).whenComplete(() async {
          String downloadUrl = await ref.getDownloadURL();
          urlsList[i] = downloadUrl;
        });

        uploadedCount++;
      }
    }

    setState(() {
      uploading = false;
    });

    Navigator.pop(context, true);
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

        setState(() {
          // Directly assign the fetched image URLs without adding placeholders
          urlsList =
              List.from(imageUrls); // Keep it as is, without placeholders
          print("Updated urlsList: $urlsList");
        });
      } else {
        print("No document found for user ID: ${widget.userID}");
        // Use placeholders if no images available
        setState(() {
          print("Using placeholder URLs: $urlsList");
        });
      }
    } catch (e) {
      print("Error fetching images: $e");
      // Use placeholders in case of error
      setState(() {
        print("Using placeholder URLs due to error: $urlsList");
      });
    }
  }

  retrieveUserData() async {
    print("retrieving currentUserID : $currentUserID");
    await FirebaseFirestore.instance
        .collection("users")
        .doc(currentUserID)
        .get()
        .then((snapshot) {
      if (snapshot.exists) {
        setState(() {
          emailTextEditingController.text = snapshot.data()?["email"] ?? "";
          nameTextEditingController.text = snapshot.data()?["name"] ?? "";
          aboutmeController.text = snapshot.data()?["aboutme"] ?? "";
        });
      }
    });
  }

  void _showUploadDialog() async {
    // Show the dialog
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(), // Indeterminate progress
              const SizedBox(height: 20),
              Text("Uploading... Please wait"),
            ],
          ),
        );
      },
    );

    // Simulate upload process
    await Future.delayed(Duration(seconds: 2));

    // Close the dialog after upload is complete
    if (context.mounted) {
      Navigator.of(context).pop();
    }
  }

  Future<void> saveProfileData() async {
    try {
      // Show the upload dialog

      _showUploadDialog();

      // Simulate the upload process
      await Future.delayed(Duration(seconds: 2));

      // Prepare the data to be updated
      Map<String, dynamic> updateData = {};
      if (aboutmeController.text.isNotEmpty) {
        updateData["aboutme"] = aboutmeController.text;
      }
      if (emailTextEditingController.text.isNotEmpty) {
        updateData["email"] = emailTextEditingController.text;
      }

      if (nameTextEditingController.text.isNotEmpty) {
        updateData["name"] = nameTextEditingController.text;
      }

      if (passwordTextEditingController.text.isNotEmpty) {
        updateData["password"] = passwordTextEditingController.text;
      }

      if (timeController.text.isNotEmpty) {
        updateData["bdTime"] = timeController.text;
        updateData["sure"] = "sure";
      }

      if (BDController.text.isNotEmpty) {
        updateData["birthday"] = BDController.text;
      }

      if (sexController.text.isNotEmpty) {
        updateData["sex"] = sexController.text;
        updateData["age"] = age.toString();
      }

      // Proceed only if there's any data to update
      if (updateData.isNotEmpty) {
        final userDoc =
            FirebaseFirestore.instance.collection("users").doc(currentUserID);
        await userDoc.update(updateData);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profile fields updated successfully!")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No fields to update.")),
        );
      }
    } catch (error) {
      print("Error updating fields: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to update profile fields.")),
      );
    }
  }

  Future<void> saveProfileImage() async {
    setState(() {
      uploading = true;
      val = 0;
    });
    _showUploadDialog();
    // Show loading dialog

    // Retrieve and delete previous images
    final userDoc =
        FirebaseFirestore.instance.collection("users").doc(currentUserID);
    final docSnapshot = await userDoc.get();

    if (docSnapshot.exists) {
      List<String> previousUrls =
          List<String>.from(docSnapshot.data()?["imageUrls"] ?? []);

      for (String url in previousUrls) {
        try {
          // Get the reference from the URL
          await FirebaseStorage.instance.refFromURL(url).delete();
        } catch (e) {
          print("Error deleting previous image: $e");
        }
      }
    }

    // Upload new images and collect URLs
    urlsList = []; // Start with an empty list

    for (int i = 0; i < _images.length; i++) {
      if (_images[i] != null) {
        setState(() {
          val = (i + 1) / _images.length;
        });

        var ref = FirebaseStorage.instance
            .ref()
            .child("images/${DateTime.now().millisecondsSinceEpoch}_$i.jpg");

        await ref.putFile(_images[i]!).whenComplete(() async {
          String downloadUrl = await ref.getDownloadURL();
          urlsList.add(downloadUrl); // Add each new image URL directly
        });
      }
    }

    // Close loading dialog
    // Navigator.of(context).pop(); // This will dismiss the loading dialog

    setState(() {
      // _showUploadDialog();
      uploading = false;
    });

    // Save profile data to Firestore, including new image URLs
    userDoc.update({
      // "email": emailTextEditingController.text,
      // "name": nameTextEditingController.text,
      // "password": passwordTextEditingController.text,
      "imageUrls": urlsList, // Store only the new image URLs in Firestore
    }).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile updated successfully!")),
      );
    }).catchError((error) {
      print("Error updating profile: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to update profile.")),
      );
    });
  }
}
