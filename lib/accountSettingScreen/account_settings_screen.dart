import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:redline/authenticationScreen/birthdaycal.dart';
import 'package:redline/constants/interests.dart';
import 'package:redline/controller/profile-controller.dart';
import 'package:redline/global.dart';
import 'package:redline/homeScreen/home_screen.dart';
import 'package:redline/models/person.dart';
import 'package:redline/tabScreens/user_details_screen.dart';
import 'package:redline/widgets/custom_text_field_widget.dart';

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
  int age = 0;
  String sex = "Male";
  final storage = GetStorage();
  @override
  void initState() {
    super.initState();
    retrieveUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Account Settings",
          style: TextStyle(color: Colors.white, fontSize: 22),
        ),
        // automaticallyImplyLeading: false,
        actions: [],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              _buildImagePicker(),
              ElevatedButton(
                onPressed: saveProfileImage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(
                      255, 253, 133, 227), // Background color
                  foregroundColor:
                      const Color.fromARGB(255, 252, 47, 47), // Text color
                  // padding: const EdgeInsets.symmetric(
                  //   vertical: 12.0,
                  //   horizontal: 24.0, // Adjust padding as needed
                  // ),
                  textStyle: const TextStyle(
                    fontSize: 16, // Font size
                    fontWeight: FontWeight.bold, // Font weight
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // Rounded corners
                  ),
                ),
                child: const Text("Save Image"),
              ),
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
                    sex = newValue ? "Male" : "Female"; // Update the sex value
                  });
                },
              ),
              SizedBox(height: 20),
              Container(
                width: MediaQuery.of(context).size.width - 36,
                decoration: BoxDecoration(
                  color: Colors.grey[300], // Dark gray background
                  borderRadius: BorderRadius.circular(34),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black54,
                      blurRadius: 8,
                      offset: Offset(6, 6),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Wrap(
                      spacing: 10,
                      children: interests.take(5).map((interest) {
                        final isSelected = selectedInterests.contains(interest);
                        return GestureDetector(
                          onTap: () {
                            toggleInterest(
                                interest); // Call the function to toggle interest
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors
                                      .blueAccent // Background color for selected state
                                  : Colors.grey[
                                      300], // Background color for unselected state
                              borderRadius:
                                  BorderRadius.circular(20), // Rounded corners
                              border: Border.all(
                                color: isSelected
                                    ? Colors
                                        .blue // Border color for selected state
                                    : Colors
                                        .grey, // Border color for unselected state
                                width: 1.5,
                              ),
                            ),
                            child: Text(
                              interest,
                              style: TextStyle(
                                color: isSelected
                                    ? Colors
                                        .white // Text color for selected state
                                    : Colors
                                        .black, // Text color for unselected state
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    // Wrap(
                    //   spacing: 10,
                    //   children: interests.take(5).map((interest) {
                    //     final isSelected = selectedInterests.contains(interest);
                    //     return GestureDetector(
                    //       onTap: () {
                    //         toggleInterest(
                    //             interest); // Call the function to toggle interest
                    //       },
                    //       child: Container(
                    //         padding: EdgeInsets.symmetric(
                    //             horizontal: 8, vertical: 4),
                    //         decoration: BoxDecoration(
                    //           color: isSelected
                    //               ? Colors.blue
                    //               : Colors.grey[
                    //                   300], // Change color based on selection
                    //           borderRadius: BorderRadius.circular(34),
                    //         ),
                    //         child: Text(
                    //           interest,
                    //           style: TextStyle(
                    //             color: isSelected ? Colors.white : Colors.black,
                    //           ),
                    //         ),
                    //       ),
                    //     );
                    //   }).toList(),
                    // ),
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
              ElevatedButton(
                onPressed: saveProfileImage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(
                      255, 253, 133, 227), // Background color
                  foregroundColor:
                      const Color.fromARGB(255, 252, 47, 47), // Text color
                  // padding: const EdgeInsets.symmetric(
                  //   vertical: 12.0,
                  //   horizontal: 24.0, // Adjust padding as needed
                  // ),
                  textStyle: const TextStyle(
                    fontSize: 16, // Font size
                    fontWeight: FontWeight.bold, // Font weight
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // Rounded corners
                  ),
                ),
                child: const Text("Save Image"),
              ),
            ],
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

  Widget _buildSwitchField(TextEditingController controller, String label,
      String value, Function(bool) onChanged) {
    // Convert the String value to a bool (true for "Male", false for "Female")
    bool isMale = value == "Male";

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Switch(
            value: isMale, // use bool value for switch state
            onChanged: (bool newValue) {
              // Update the boolean value and the controller text
              onChanged(newValue);
              sexController.text = newValue ? "Male" : "Female";
            },
          ),
        ],
      ),
    );
  }

  // Widget _buildTextField(TextEditingController controller, String label) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 8.0),
  //     child: TextField(
  //       controller: controller,
  //       style: TextStyle(
  //         color: const Color.fromARGB(255, 80, 80, 80), // Text color
  //         fontSize: 16, // Font size for input text
  //         fontWeight: FontWeight.w500, // Font weight
  //       ),
  //       decoration: InputDecoration(
  //         labelText: label,
  //         labelStyle: TextStyle(
  //           color: Colors.grey[800], // Label text color
  //           fontSize: 14, // Font size for label
  //         ),
  //         hintText: "Enter $label", // Placeholder text
  //         hintStyle: TextStyle(
  //           color: Colors.grey[600], // Placeholder text color
  //           fontSize: 14, // Font size for placeholder
  //         ),
  //         fillColor: Colors.grey[300], // Background color inside the TextField
  //         filled: true, // Enables the fillColor property
  //         border: OutlineInputBorder(
  //           borderRadius: BorderRadius.only(
  //             topLeft: Radius.circular(34),
  //             topRight: Radius.circular(18),
  //             bottomLeft: Radius.circular(18),
  //             bottomRight: Radius.circular(18),
  //           ),
  //           borderSide: BorderSide(
  //             color: Colors.grey, // Outline border color
  //             width: 2, // Outline border width
  //           ),
  //         ),
  //         enabledBorder: OutlineInputBorder(
  //           borderRadius: BorderRadius.only(
  //             topLeft: Radius.circular(34),
  //             topRight: Radius.circular(18),
  //             bottomLeft: Radius.circular(18),
  //             bottomRight: Radius.circular(18),
  //           ), // Border radius for enabled state
  //           borderSide: BorderSide(
  //             color: Colors.grey, // Outline border color
  //             width: 2, // Outline border width
  //           ),
  //         ),
  //         focusedBorder: OutlineInputBorder(
  //           borderRadius: BorderRadius.only(
  //             topLeft: Radius.circular(34),
  //             topRight: Radius.circular(34),
  //             bottomLeft: Radius.circular(34),
  //             bottomRight: Radius.circular(34),
  //           ), // Border radius for focused state
  //           borderSide: BorderSide(
  //             color: const Color.fromARGB(
  //                 255, 238, 80, 159), // Border color when focused
  //             width: 2, // Border width when focused
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }
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

  // Widget _buildTextField(TextEditingController controller, String label) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 8.0),
  //     child: TextField(
  //       controller: controller,
  //       decoration: InputDecoration(
  //         labelText: label,
  //         border: OutlineInputBorder(),
  //       ),
  //     ),
  //   );
  // }

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

  retrieveUserData() async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(currentUserID) // Assuming currentUserID is defined
        .get()
        .then((snapshot) {
      if (snapshot.exists) {
        setState(() {
          emailTextEditingController.text = snapshot.data()?["email"] ?? "";
          nameTextEditingController.text = snapshot.data()?["name"] ?? "";
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

  // Future<void> saveProfileData() async {
  //   try {
  //     // Show the upload dialog
  //     _showUploadDialog();

  //     // Simulate the upload process
  //     await Future.delayed(Duration(seconds: 2));

  //     // Prepare the data to be updated
  //     Map<String, dynamic> updateData = {};

  //     if (emailTextEditingController.text.isNotEmpty) {
  //       updateData["email"] = emailTextEditingController.text;
  //     }

  //     if (nameTextEditingController.text.isNotEmpty) {
  //       updateData["name"] = nameTextEditingController.text;
  //     }

  //     if (passwordTextEditingController.text.isNotEmpty) {
  //       updateData["password"] = passwordTextEditingController.text;
  //     }

  //     if (timeController.text.isNotEmpty) {
  //       updateData["bdTime"] = timeController.text;
  //       updateData["sure"] = "sure";
  //     }

  //     if (BDController.text.isNotEmpty) {
  //       updateData["birthday"] = BDController.text;
  //     }

  //     if (sexController.text.isNotEmpty) {
  //       updateData["sex"] = sexController.text;
  //       updateData["age"] = age;
  //     }

  //     // Proceed only if there's any data to update
  //     if (updateData.isNotEmpty) {
  //       final userDoc =
  //           FirebaseFirestore.instance.collection("users").doc(currentUserID);
  //       await userDoc.update(updateData);

  //       // Fetch the updated user data after saving
  //       String currentUserUid = FirebaseAuth.instance.currentUser!.uid;
  //       DocumentSnapshot currentUserSnapshot = await FirebaseFirestore.instance
  //           .collection("users")
  //           .doc(currentUserUid)
  //           .get();

  //       if (currentUserSnapshot.exists) {
  //         Map<String, dynamic> currentUserData =
  //             currentUserSnapshot.data() as Map<String, dynamic>;

  //         // Assuming Person.fromJson() can handle the structure of the current user data
  //         Person currentUser = Person.fromDataSnapshot(currentUserSnapshot);

  //         // Cache the updated current user data
  //         await storage.write('currentUserData', currentUser.toJson());
  //         print("Current user data saved to cache: $currentUserData");

  //         ScaffoldMessenger.of(context).showSnackBar(
  //           const SnackBar(
  //               content: Text("Profile fields updated and saved to cache!")),
  //         );
  //       } else {
  //         print("Current user document does not exist.");
  //       }
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text("No fields to update.")),
  //       );
  //     }
  //   } catch (error) {
  //     print("Error updating fields: $error");
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text("Failed to update profile fields.")),
  //     );
  //   }
  // }

  Future<void> saveProfileData() async {
    try {
      // Show the upload dialog

      _showUploadDialog();

      // Simulate the upload process
      await Future.delayed(Duration(seconds: 2));

      // Prepare the data to be updated
      Map<String, dynamic> updateData = {};

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
        updateData["age"] = age;
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
    Navigator.of(context).pop(); // This will dismiss the loading dialog

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

  // Future<void> saveProfileData() async {
  //   setState(() {
  //     uploading = true;
  //     val = 0;
  //   });

  //   // Show loading dialog

  //   // Retrieve and delete previous images
  //   final userDoc =
  //       FirebaseFirestore.instance.collection("users").doc(currentUserID);
  //   // final docSnapshot = await userDoc.get();

  //   // if (docSnapshot.exists) {
  //   //   List<String> previousUrls =
  //   //       List<String>.from(docSnapshot.data()?["imageUrls"] ?? []);

  //   //   for (String url in previousUrls) {
  //   //     try {
  //   //       // Get the reference from the URL
  //   //       await FirebaseStorage.instance.refFromURL(url).delete();
  //   //     } catch (e) {
  //   //       print("Error deleting previous image: $e");
  //   //     }
  //   //   }
  //   // }

  //   // // Upload new images and collect URLs
  //   // urlsList = []; // Start with an empty list

  //   // for (int i = 0; i < _images.length; i++) {
  //   //   if (_images[i] != null) {
  //   //     setState(() {
  //   //       val = (i + 1) / _images.length;
  //   //     });

  //   //     var ref = FirebaseStorage.instance
  //   //         .ref()
  //   //         .child("images/${DateTime.now().millisecondsSinceEpoch}_$i.jpg");

  //   //     await ref.putFile(_images[i]!).whenComplete(() async {
  //   //       String downloadUrl = await ref.getDownloadURL();
  //   //       urlsList.add(downloadUrl); // Add each new image URL directly
  //   //     });
  //   //   }
  //   // }

  //   // Close loading dialog
  //   Navigator.of(context).pop(); // This will dismiss the loading dialog

  //   setState(() {
  //     uploading = false;
  //   });

  //   // Save profile data to Firestore, including new image URLs
  //   userDoc.update({
  //     "email": emailTextEditingController.text,
  //     "name": nameTextEditingController.text,
  //     "password": passwordTextEditingController.text,
  //     "bdTime": timeController,
  //     // "imageUrls": urlsList, // Store only the new image URLs in Firestore
  //   }).then((_) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text("Profile updated successfully!")),
  //     );
  //   }).catchError((error) {
  //     print("Error updating profile: $error");
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text("Failed to update profile.")),
  //     );
  //   });
  // }
}
