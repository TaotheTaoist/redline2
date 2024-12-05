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

  String selectedCategory = "Lifestyle";

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

  // void addInterest() {
  //   // Get the interest from the text controller and add it to the list if not empty
  //   String newInterest = interestTextEditingController.text.trim();
  //   if (newInterest.isNotEmpty && !interests.contains(newInterest)) {
  //     interests.add(newInterest);
  //     interestTextEditingController
  //         .clear(); // Clear the text field after adding
  //   }
  // }

  Future<bool> _checkIfEmailExists(String email, String currentUserId) async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get();
    return result.docs.isNotEmpty && result.docs.first.id != currentUserId;
  }

  // void _showMoreInterests(BuildContext context) {
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(
  //         top: Radius.circular(12),
  //       ),
  //     ),
  //     builder: (context) {
  //       return StatefulBuilder(
  //         builder: (BuildContext context, StateSetter setState) {
  //           return SingleChildScrollView(
  //             child: Container(
  //               padding: const EdgeInsets.fromLTRB(
  //                   20, 40, 20, 20), // Top padding added here
  //               decoration: BoxDecoration(
  //                 color: Colors.white,
  //                 borderRadius: BorderRadius.only(
  //                   topLeft: Radius.circular(12),
  //                   topRight: Radius.circular(12),
  //                 ),
  //               ),
  //               child: Column(
  //                 mainAxisSize: MainAxisSize.min,
  //                 children: [
  //                   // Back Button and Title Row
  //                   Row(
  //                     children: [
  //                       IconButton(
  //                         color: Colors.black,
  //                         icon: Icon(Icons.arrow_back),
  //                         onPressed: () {
  //                           Navigator.pop(
  //                               context); // Pop the modal bottom sheet
  //                         },
  //                       ),
  //                       Expanded(
  //                         child: Text(
  //                           "興趣",
  //                           style: TextStyle(
  //                             color: Colors.black,
  //                             fontSize: 20,
  //                             fontWeight: FontWeight.bold,
  //                           ),
  //                           textAlign: TextAlign.center,
  //                         ),
  //                       ),
  //                       SizedBox(
  //                           width:
  //                               48), // Placeholder for spacing (to balance the back button)
  //                     ],
  //                   ),
  //                   SizedBox(height: 20),

  //                   // Horizontal Category Selector
  //                   SingleChildScrollView(
  //                     scrollDirection: Axis.horizontal,
  //                     child: Row(
  //                       children: [
  //                         // Lifestyle Interests
  //                         GestureDetector(
  //                           onTap: () {
  //                             setState(() {
  //                               selectedCategory =
  //                                   "Lifestyle"; // Correct category key
  //                             });
  //                           },
  //                           child: Container(
  //                             padding: const EdgeInsets.symmetric(
  //                                 horizontal: 20, vertical: 10),
  //                             decoration: BoxDecoration(
  //                               color: selectedCategory == "Lifestyle"
  //                                   ? Colors.blue
  //                                   : Colors.grey.shade300,
  //                               borderRadius: BorderRadius.circular(8),
  //                             ),
  //                             child: Text(
  //                               "Lifestyle Interests",
  //                               style: TextStyle(
  //                                 color: selectedCategory == "Lifestyle"
  //                                     ? Colors.white
  //                                     : Colors.black,
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                         SizedBox(width: 10),
  //                         // Toys Interests
  //                         GestureDetector(
  //                           onTap: () {
  //                             setState(() {
  //                               selectedCategory =
  //                                   "Toys"; // Correct category key
  //                             });
  //                           },
  //                           child: Container(
  //                             padding: const EdgeInsets.symmetric(
  //                                 horizontal: 20, vertical: 10),
  //                             decoration: BoxDecoration(
  //                               color: selectedCategory == "Toys"
  //                                   ? Colors.blue
  //                                   : Colors.grey.shade300,
  //                               borderRadius: BorderRadius.circular(8),
  //                             ),
  //                             child: Text(
  //                               "Toys Interests",
  //                               style: TextStyle(
  //                                 color: selectedCategory == "Toys"
  //                                     ? Colors.white
  //                                     : Colors.black,
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                         GestureDetector(
  //                           onTap: () {
  //                             setState(() {
  //                               selectedCategory =
  //                                   "Toys"; // Correct category key
  //                             });
  //                           },
  //                           child: Container(
  //                             padding: const EdgeInsets.symmetric(
  //                                 horizontal: 20, vertical: 10),
  //                             decoration: BoxDecoration(
  //                               color: selectedCategory == "occ"
  //                                   ? Colors.blue
  //                                   : Colors.grey.shade300,
  //                               borderRadius: BorderRadius.circular(8),
  //                             ),
  //                             child: Text(
  //                               "職業",
  //                               style: TextStyle(
  //                                 color: selectedCategory == "occ"
  //                                     ? Colors.white
  //                                     : Colors.black,
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                   SizedBox(height: 20),

  //                   // Category Items
  //                   if (selectedCategory == "Lifestyle")
  //                     _buildInterestSection(
  //                         "Lifestyle Interests", lifestyleInterests, setState),
  //                   if (selectedCategory == "Toys")
  //                     _buildInterestSection(
  //                         "Toys Interests", toysInterests, setState),
  //                   if (selectedCategory == "occ")
  //                     _buildInterestSection("職業", occupations, setState),

  //                   SizedBox(height: 20),

  //                   // Done Button
  //                   ElevatedButton(
  //                     onPressed: () {
  //                       Navigator.pop(context); // Close the bottom sheet
  //                     },
  //                     child: Text("Done"),
  //                     style: ElevatedButton.styleFrom(
  //                       backgroundColor: Colors.blue, // Button color
  //                       padding:
  //                           EdgeInsets.symmetric(horizontal: 40, vertical: 10),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           );
  //         },
  //       );
  //     },
  //   );
  // }

  // Widget _buildInterestSection(
  //     String title, List<String> interests, StateSetter setState) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text(
  //         title,
  //         style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  //       ),
  //       SizedBox(height: 10),
  //       Wrap(
  //         spacing: 10,
  //         children: interests.map((interest) {
  //           final isSelected = selectedInterests.contains(interest);
  //           return ElevatedButton(
  //             onPressed: () {
  //               setState(() {
  //                 toggleInterest(
  //                     interest); // Call toggleInterest and update state
  //               });
  //             },
  //             child: Text(
  //               interest,
  //               style: TextStyle(
  //                 color: isSelected ? Colors.white : Colors.black,
  //               ),
  //             ),
  //             style: ElevatedButton.styleFrom(
  //               backgroundColor:
  //                   isSelected ? Colors.blue : Colors.grey.shade300,
  //               padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
  //             ),
  //           );
  //         }).toList(),
  //       ),
  //     ],
  //   );
  // }
  void _showMoreInterests(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(12),
        ),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Back Button and Title Row
                    Row(
                      children: [
                        IconButton(
                          color: Colors.black,
                          icon: Icon(Icons.arrow_back),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        Expanded(
                          child: Text(
                            "興趣",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(width: 48), // Placeholder for spacing
                      ],
                    ),
                    SizedBox(height: 20),

                    // Horizontal Category Selector
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildCategorySelector(
                            setState,
                            "Lifestyle",
                            "Lifestyle Interests",
                          ),
                          SizedBox(width: 10),
                          _buildCategorySelector(
                            setState,
                            "Toys",
                            "Toys Interests",
                          ),
                          SizedBox(width: 10),
                          _buildCategorySelector(
                            setState,
                            "occ",
                            "職業",
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),

                    // Category Items
                    if (selectedCategory == "Lifestyle")
                      _buildInterestSection(
                          "Lifestyle Interests", lifestyleInterests, setState),
                    if (selectedCategory == "Toys")
                      _buildInterestSection(
                          "Toys Interests", toysInterests, setState),
                    if (selectedCategory == "occ")
                      _buildInterestSection("職業", occupations, setState),

                    SizedBox(height: 20),

                    // Done Button
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context); // Close the bottom sheet
                      },
                      child: Text("Done"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding:
                            EdgeInsets.symmetric(horizontal: 40, vertical: 10),
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

  // Method to build category selector buttons
  Widget _buildCategorySelector(
      StateSetter setState, String categoryKey, String label) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = categoryKey;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: selectedCategory == categoryKey
              ? Colors.blue
              : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            color:
                selectedCategory == categoryKey ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  // Method to build interest sections dynamically
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
          ),
        ),
        SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: interests.map((interest) {
            bool isSelected = selectedInterests.contains(interest);
            return GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    selectedInterests.remove(interest);
                  } else {
                    selectedInterests.add(interest);
                  }
                });
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.blue : Colors.grey.shade300,
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
      ],
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
      appBar: AppBar(
        backgroundColor: Colors.pink[300],
        iconTheme: const IconThemeData(
          color: Colors.black, // Change the back arrow color
        ),
        title: const Text(
          "Create Account",
          style: TextStyle(
              color: Color.fromARGB(255, 252, 252, 252), fontSize: 22),
        ),
        // automaticallyImplyLeading: false,
        actions: [],
      ),
      backgroundColor: Colors.grey[350],
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
            child: Center(
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
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
                          await authenticationcontroller
                              .pickImageFileFromGallery();
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
                        CustomTextFieldWidget.buildTextField(
                            nameTextEditingController, "Name",
                            icon: Icons.person),
                        const SizedBox(height: 20),
                        // CustomTextFieldWidget(
                        //   editingController: nameTextEditingController,
                        //   labelText: "Name",
                        //   iconData: Icons.person,
                        //   borderRadius: 20.0,
                        // ),

                        CustomTextFieldWidget.buildTextField(
                          emailTextEditingController,
                          "Email",
                          icon: Icons.email_outlined,
                        ),
                        // CustomTextFieldWidget(
                        //   editingController: emailTextEditingController,
                        //   labelText: "Email",
                        //   iconData: Icons.email_outlined,
                        //   borderRadius: 20.0,
                        // ),
                        const SizedBox(height: 20),
                        // buildbdField(
                        //   context,
                        //   birthdayController,
                        //   "Birthday",
                        // ),

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

                              // Update the TextEditingController with the selected date
                              birthdayController.text = formattedDate;
                            }
                          },
                          child: AbsorbPointer(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                border: Border.all(color: Colors.grey),
                                color: Colors.white,
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.cake,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      birthdayController.text.isEmpty
                                          ? "Select Birthday"
                                          : birthdayController.text,
                                      style: TextStyle(
                                        color: birthdayController.text.isEmpty
                                            ? Colors.grey
                                            : Colors.black,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  Icon(
                                    Icons.calendar_today,
                                    color: Colors.blue,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        GestureDetector(
                          onTap: () async {
                            await BirthdayCal.selectTime(
                                context, timeController);
                            setState(() {
                              labelText = timeController.text.isEmpty
                                  ? "Time (optional)"
                                  : timeController
                                      .text; // Update label text based on selection
                            });
                          },
                          child: AbsorbPointer(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                border: Border.all(color: Colors.grey),
                                color: Colors.white,
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.access_time,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      timeController.text.isEmpty
                                          ? "Select Time (optional)"
                                          : timeController.text,
                                      style: TextStyle(
                                        color: timeController.text.isEmpty
                                            ? Colors.grey
                                            : Colors.black,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  Icon(
                                    Icons.access_time,
                                    color: Colors.blue,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        // GestureDetector(
                        //   onTap: () async {
                        //     // Call the selectDate function

                        //     DateTime? selectedDate = await showDatePicker(
                        //       context: context,
                        //       initialDate: DateTime.now(),
                        //       firstDate: DateTime(1900),
                        //       lastDate: DateTime(2100),
                        //     );

                        //     if (selectedDate != null) {
                        //       // Calculate the age
                        //       age = BirthdayCal.calculateAge(selectedDate);

                        //       print("age: $age");
                        //       String formattedDate =
                        //           DateFormat('yyyy-MM-dd').format(selectedDate);

                        //       // Update the TextEditingController with both birthday and age
                        //       birthdayController.text = '$formattedDate';
                        //     }
                        //   },
                        //   child: AbsorbPointer(
                        //     child: CustomTextFieldWidget(
                        //       editingController: birthdayController,
                        //       labelText: "Birthday",
                        //       iconData: Icons.cake,
                        //       borderRadius: 20.0,
                        //     ),
                        //   ),
                        // ),

                        // GestureDetector(
                        //   onTap: () async {
                        //     await BirthdayCal.selectTime(
                        //         context, timeController);
                        //     setState(() {
                        //       labelText = timeController.text.isEmpty
                        //           ? "Time (optional)"
                        //           : timeController
                        //               .text; // Update label text based on selection
                        //     });
                        //   },
                        //   child: AbsorbPointer(
                        //     child: CustomTextFieldWidget(
                        //       editingController: timeController,
                        //       labelText:
                        //           labelText, // Use the updated label text
                        //       iconData: Icons.access_time,
                        //       borderRadius: 20.0,
                        //     ),
                        //   ),
                        // ),
                        const SizedBox(height: 20),
                        CustomTextFieldWidget.buildTextField(
                          passwordlTextEditingController,
                          "密碼",
                          icon: Icons.lock_outline,
                        ),
                        // CustomTextFieldWidget(
                        //   editingController: passwordlTextEditingController,
                        //   labelText: "Password",
                        //   iconData: Icons.lock_outline,
                        //   isObscure: true,
                        //   borderRadius: 20.0,
                        // ),
                        const SizedBox(height: 20),
                        CustomTextFieldWidget.buildTextField(
                          confirmPasswordController,
                          "密碼",
                          icon: Icons.lock_outline_sharp,
                        ),
                        // CustomTextFieldWidget(
                        //   editingController: confirmPasswordController,
                        //   labelText: "Confirm your Password",
                        //   iconData: Icons.lock_outline,
                        //   isObscure: true,
                        //   borderRadius: 20.0,
                        // ),
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
                            color: const Color.fromARGB(
                                255, 0, 0, 0), // Title color
                          ),
                        ),
                      ),

                      // Container for interests
                      Container(
                        width: MediaQuery.of(context).size.width - 36,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(
                              255, 255, 255, 255), // Dark gray background
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
                          color: Color.fromARGB(
                              255, 255, 255, 255), // Dark gray background
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
                        value:
                            isMale, // Boolean value controlling the switch state
                        onChanged: (bool value) {
                          setState(() {
                            isMale = value; // Update the boolean value
                            sexController.text = isMale ? "Female" : "Male";
                          });
                        },
                        activeColor:
                            Colors.blue, // Color of the toggle when active
                        inactiveThumbColor:
                            Colors.grey, // Color of the toggle when inactive
                      ),
                    ],
                  ),
                  // const SizedBox(height: 10),
                  Container(
                    width: MediaQuery.of(context).size.width - 36,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(2, 52, 109, 156),
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
                          if (passwordlTextEditingController.text
                              .trim()
                              .isEmpty) {
                            missingFields += 'Password, ';
                          }

                          if (missingFields.isNotEmpty) {
                            // Remove trailing comma and space
                            missingFields = missingFields.substring(
                                0, missingFields.length - 2);

                            // Show snackbar with the list of missing fields
                            Get.snackbar(
                              "Error", // Title of the Snackbar
                              "Please fill in the following fields: $missingFields", // Message of the Snackbar
                              snackPosition: SnackPosition
                                  .BOTTOM, // Position of the Snackbar
                              backgroundColor: Colors
                                  .white, // Background color of the Snackbar
                              titleText: Text(
                                "Error",
                                style: TextStyle(
                                  color: Colors
                                      .red, // Red color for the title text
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              messageText: Text(
                                "Please fill in the following fields: $missingFields",
                                style: TextStyle(
                                  color: Colors
                                      .red, // Red color for the message text
                                ),
                              ),
                            );
                          } else {
                            // All fields are filled, proceed to create new user
                            setState(() {
                              showProgressBar = true; // Show progress bar
                            });

                            try {
                              await authenticationcontroller
                                  .creatNewUserAccount(
                                      authenticationcontroller
                                          .profileImage!, // Image file
                                      emailTextEditingController.text
                                          .trim(), // Email
                                      passwordlTextEditingController.text
                                          .trim(), // Password
                                      nameTextEditingController.text
                                          .trim(), // Name

                                      selectedInterests,
                                      [],
                                      sexController.text.trim(),
                                      timeController.text.trim(),
                                      birthdayController.text.trim(),
                                      timeController.text.isEmpty
                                          ? "false"
                                          : "true",
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
                                  "Error", // Title of the Snackbar
                                  "Failed to create account: $e", // Message of the Snackbar
                                  snackPosition: SnackPosition
                                      .BOTTOM, // Position of the Snackbar
                                  backgroundColor: Colors
                                      .white, // Background color of the Snackbar
                                  titleText: Text(
                                    "Error",
                                    style: TextStyle(
                                      color: Colors
                                          .red, // Red color for the title text
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  messageText: Text(
                                    "Failed to create account: $e",
                                    style: TextStyle(
                                      color: Colors
                                          .red, // Red color for the message text
                                      fontSize: 14,
                                    ),
                                  ),
                                );
                              }
                            }
                          }
                        } else {
                          Get.snackbar(
                              "Error", "Please select a profile image");
                        }
                      },
                      child: const Center(
                        child: Text(
                          "申請帳號",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                  // SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Text(
                      //   "D",
                      //   style: TextStyle(
                      //     fontSize: 14,
                      //     color: Colors.green,
                      //   ),
                      // ),
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
                              color: Color.fromARGB(255, 0, 0, 0),
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  showProgressBar == true
                      ? const CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.pink),
                        )
                      : Container(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  buildbdField(
      BuildContext context, TextEditingController dateController, String label,
      {IconData? icon}) {
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

          // Assuming `age` is a global or state variable
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
              prefixIcon: icon != null
                  ? Icon(
                      icon,
                      color:
                          const Color.fromARGB(255, 238, 80, 159), // Icon color
                    )
                  : null, // If no icon is provided, no prefix icon is displayed
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
  // buildbdField(BuildContext context, TextEditingController dateController,
  //     String label) {
  //   final FocusNode focusNode = FocusNode();

  //   return GestureDetector(
  //     onTap: () async {
  //       // Trigger focus for visual feedback
  //       focusNode.requestFocus();

  //       DateTime? pickedDate = await showDatePicker(
  //         context: context,
  //         initialDate: DateTime.now(),
  //         firstDate: DateTime(1900), // Earliest selectable date
  //         lastDate: DateTime(2100), // Latest selectable date
  //       );

  //       // Remove focus after date selection
  //       focusNode.unfocus();

  //       if (pickedDate != null) {
  //         final String formattedDate =
  //             "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
  //         dateController.text = formattedDate;

  //         age = BirthdayCal.calculateAge(pickedDate);
  //       }
  //     },
  //     child: Padding(
  //       padding: const EdgeInsets.symmetric(vertical: 8.0),
  //       child: AbsorbPointer(
  //         child: TextField(
  //           controller: dateController,
  //           focusNode: focusNode,
  //           style: const TextStyle(
  //             color: Color.fromARGB(255, 80, 80, 80), // Text color
  //             fontSize: 16, // Font size for input text
  //             fontWeight: FontWeight.w500, // Font weight
  //           ),
  //           decoration: InputDecoration(
  //             labelText: label,
  //             labelStyle: TextStyle(
  //               color: Colors.grey[800], // Label text color
  //               fontSize: 14, // Font size for label
  //             ),
  //             hintText: "Enter $label", // Placeholder text
  //             hintStyle: TextStyle(
  //               color: Colors.grey[600], // Placeholder text color
  //               fontSize: 14, // Font size for placeholder
  //             ),
  //             fillColor:
  //                 Colors.grey[300], // Background color inside the TextField
  //             filled: true, // Enables the fillColor property
  //             border: OutlineInputBorder(
  //               borderRadius: const BorderRadius.only(
  //                 topLeft: Radius.circular(34),
  //                 topRight: Radius.circular(18),
  //                 bottomLeft: Radius.circular(18),
  //                 bottomRight: Radius.circular(18),
  //               ), // Apply custom border radius
  //               borderSide: const BorderSide(
  //                 color: Colors.grey, // Outline border color
  //                 width: 2, // Outline border width
  //               ),
  //             ),
  //             enabledBorder: OutlineInputBorder(
  //               borderRadius: const BorderRadius.only(
  //                 topLeft: Radius.circular(34),
  //                 topRight: Radius.circular(18),
  //                 bottomLeft: Radius.circular(18),
  //                 bottomRight: Radius.circular(18),
  //               ), // Border radius for enabled state
  //               borderSide: const BorderSide(
  //                 color: Colors.grey, // Outline border color
  //                 width: 2, // Outline border
  //               ),
  //             ),
  //             focusedBorder: OutlineInputBorder(
  //               borderRadius: const BorderRadius.only(
  //                 topLeft: Radius.circular(34),
  //                 topRight: Radius.circular(34),
  //                 bottomLeft: Radius.circular(34),
  //                 bottomRight: Radius.circular(34),
  //               ), // Border radius for focused state
  //               borderSide: const BorderSide(
  //                 color: Color.fromARGB(
  //                     255, 238, 80, 159), // Border color when focused
  //                 width: 2, // Border width when focused
  //               ),
  //             ),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
