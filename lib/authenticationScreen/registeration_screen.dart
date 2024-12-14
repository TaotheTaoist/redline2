import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
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
  TextEditingController sexController = TextEditingController(text: "Female");
  TextEditingController locationController = TextEditingController();

  bool showProgressBar = false;
  bool isMale = false; // Default value, false means "Female", true means "Male"

  var authenticationcontroller =
      Authenticationcontroller.authenticationcontroller;

  final TextEditingController interestTextEditingController =
      TextEditingController();

  final List<String> selectedInterests = [];
  final List<String> selectedoccu = [];
  final List<String> selectmbti = [];
  final List<String> selectlanguage = [];

  final List<String> selectbloodtype = [];
  final List<String> selectexercise = [];
  final List<String> selectreligion = [];
  final List<String> selectdiet = [];
  final List<String> selectlooking = [];
  final List<String> selectblood = [];

  final List<String> selecteducation = [];

  final List<String> selectedpersonality = [];

  String selectedCategory = "Lifestyle";

  String labelText = "Time (optional)";

  final List<File?> _images = List<File?>.filled(6, null);

  late String age;

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

  Future<bool> _checkIfEmailExistsInAuthAndFirestore(String email) async {
    try {
      // Check if email exists in Firestore
      final firestoreResult = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      bool existsInFirestore = firestoreResult.docs.isNotEmpty;

      // Check if email exists in Firebase Authentication
      final signInMethods =
          await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);

      bool existsInAuth = signInMethods.isNotEmpty;

      return existsInFirestore || existsInAuth;
    } catch (e) {
      // Handle potential errors gracefully
      print('Error checking email existence: $e');
      return false;
    }
  }

  void _showMoreInterests(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allows the modal to take full height
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(12),
        ),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return DraggableScrollableSheet(
              initialChildSize: 1.0, // Full-screen modal
              minChildSize: 0.5, // Minimum size of the sheet
              maxChildSize: 1.0, // Maximum size of the sheet
              builder: (context, scrollController) {
                return SingleChildScrollView(
                  controller: scrollController,
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
                                "生活",
                              ),
                              SizedBox(width: 10),
                              _buildCategorySelector(
                                setState,
                                "personality",
                                "個性",
                              ),
                              SizedBox(width: 10),
                              _buildCategorySelector(
                                setState,
                                "occ",
                                "職業",
                              ),
                              SizedBox(width: 10),
                              _buildCategorySelector(
                                setState,
                                "MBTI",
                                "MBTI",
                              ),
                              SizedBox(width: 10),
                              _buildCategorySelector(
                                setState,
                                "language",
                                "語言",
                              ),
                              SizedBox(width: 10),
                              _buildCategorySelector(
                                setState,
                                "religion",
                                "信仰",
                              ),
                              SizedBox(width: 10),
                              _buildCategorySelector(
                                setState,
                                "education",
                                "教育",
                              ),
                              SizedBox(width: 10),
                              _buildCategorySelector(
                                setState,
                                "bloodtype",
                                "血型",
                              ),
                              SizedBox(width: 10),
                              _buildCategorySelector(
                                setState,
                                "lookingfor",
                                "lookingFor",
                              ),
                              SizedBox(width: 10),
                              _buildCategorySelector(
                                setState,
                                "diet",
                                "飲食",
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),

                        // Category Items
                        if (selectedCategory == "Lifestyle") ...[
                          _buildInterestSection(
                              "出門", lifestyleInterests, setState),
                          const SizedBox(height: 20),
                          _buildInterestSection("靈修", innerInterests, setState),
                          const SizedBox(height: 20),
                          _buildInterestSectionGeneric(
                              "exercise", exercise, selectexercise, setState),
                        ],
                        if (selectedCategory == "personality")
                          _buildInterestSectionType(
                              "個性", toysInterests, setState),
                        // if (selectedCategory == "occ")
                        //   _buildInterestSectionType(
                        //       "職業", occupations, setState),

                        if (selectedCategory == "occ")
                          _buildInterestSectionGeneric(
                              "occ", occupations, selectedoccu, setState),
                        if (selectedCategory == "MBTI")
                          _buildInterestSectionGeneric(
                              "MBTI", mbti, selectmbti, setState),
                        if (selectedCategory == "diet")
                          _buildInterestSectionGeneric(
                              "diet", diet, selectdiet, setState),
                        if (selectedCategory == "religion")
                          _buildInterestSectionGeneric(
                              "religion", religions, selectreligion, setState),
                        if (selectedCategory == "language")
                          _buildInterestSectionGeneric(
                              "language", languages, selectlanguage, setState),
                        if (selectedCategory == "education")
                          _buildInterestSectionGeneric("education",
                              educationLevels, selecteducation, setState),
                        if (selectedCategory == "lookingfor")
                          _buildInterestSectionGeneric("lookingfor", lookingfor,
                              selectlooking, setState),
                        if (selectedCategory == "bloodtype")
                          _buildInterestSectionGeneric(
                              "bloodtype", bloodTypes, selectblood, setState),

                        SizedBox(height: 20),

                        // Done Button
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context); // Close the bottom sheet
                          },
                          child: Text("Done"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: EdgeInsets.symmetric(
                                horizontal: 40, vertical: 10),
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
          borderRadius: BorderRadius.circular(30),
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

  Widget _buildInterestSectionGeneric(
    String title,
    List<String> items,
    List<String> selectedItems,
    StateSetter setState, {
    Color selectedColor = Colors.blue,
    Color unselectedColor = const Color.fromARGB(255, 204, 204, 204),
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title Text with Custom Colors
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: (title == "Lifestyle Interests" || title == "職業")
                ? Colors
                    .green // Custom color for "Lifestyle Interests" and "職業"
                : Colors.black, // Default color for other titles
          ),
        ),
        SizedBox(height: 10),

        // Wrap for Displaying the Items
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: items.map((item) {
            bool isSelected = selectedItems.contains(item);
            return GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    selectedItems.remove(item);
                    print("Removed: $item");
                  } else {
                    selectedItems.add(item);
                    print("Added: $item");
                  }
                });
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? selectedColor : unselectedColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  item,
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

  Widget _buildInterestSection(
    String title,
    List<String> interests,
    StateSetter setState,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: (title == "Lifestyle Interests")
                ? Colors.green // Custom color for "Lifestyle Interests"
                : (title == "Inner Lifestyle Interests")
                    ? Colors
                        .blue // Custom color for "Inner Lifestyle Interests"
                    : Colors.black, // Default color for other titles
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

  Widget _buildInterestSectionType(
    String title,
    List<String> occupation,
    StateSetter setState,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: (title == "職業") ? Colors.green : Colors.black,
          ),
        ),
        SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: occupation.map((occu) {
            bool isSelected = selectedoccu.contains(occu);
            return GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    selectedoccu.remove(occu);
                    print("Removed: $occu");
                  } else {
                    selectedoccu.add(occu);
                    print("Added: $occu");
                  }
                  print("Current selectedoccu: $selectedoccu");
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
                  occu,
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
        actions: [],
      ),
      backgroundColor: Colors.grey[350],
      body: Container(
        decoration: BoxDecoration(
          color: Colors.pink[300],
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

                  _buildImagePicker(),

                  Container(
                    width: MediaQuery.of(context).size.width - 36,
                    child: Column(
                      children: [
                        CustomTextFieldWidget.buildTextField(
                            nameTextEditingController, "Name",
                            icon: Icons.person),
                        const SizedBox(height: 10),
                        CustomTextFieldWidget.buildTextField(
                          emailTextEditingController,
                          "Email",
                          icon: Icons.email_outlined,
                        ),
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: () async {
                            DateTime? selectedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime(2100),
                            );

                            if (selectedDate != null) {
                              String formattedDate =
                                  DateFormat('yyyy-MM-dd').format(selectedDate);
                              setState(() {
                                age = BirthdayCal.calculateAge(selectedDate)
                                    .toString();
                                print("age: $age");

                                // Update the TextEditingController with the selected date
                                birthdayController.text = formattedDate;
                              });
                            }
                          },
                          child: AbsorbPointer(
                            child: CustomTextFieldWidget.buildTextField(
                              birthdayController,
                              "Birthday",
                              icon: Icons.cake,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Location Field
                        GestureDetector(
                          onTap: () async {
                            Position position =
                                await Geolocator.getCurrentPosition(
                              desiredAccuracy: LocationAccuracy.high,
                            );

                            double latitude = position.latitude;
                            double longitude = position.longitude;
                            String location = "Lat: $latitude, Lng: $longitude";

                            // Update the TextEditingController with the selected location
                            locationController.text =
                                "Lat: $latitude, Lng: $longitude";

                            // Print values for debugging
                            print(
                                "Selected location - Latitude: $latitude, Longitude: $longitude");

                            setState(() {
                              locationController.text = location;
                            });
                          },
                          child: AbsorbPointer(
                            child: CustomTextFieldWidget.buildTextField(
                              locationController,
                              "Location",
                              icon: Icons.location_on,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Time Field
                        GestureDetector(
                          onTap: () async {
                            TimeOfDay? selectedTime = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );

                            if (selectedTime != null) {
                              String formattedTime =
                                  selectedTime.format(context);
                              setState(() {
                                timeController.text = formattedTime;
                              });
                            }
                          },
                          child: AbsorbPointer(
                            child: CustomTextFieldWidget.buildTextField(
                              timeController,
                              "Time",
                              icon: Icons.access_time,
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
                        //       age = BirthdayCal.calculateAge(selectedDate)
                        //           .toString();
                        //       print("age: $age");

                        //       String formattedDate =
                        //           DateFormat('yyyy-MM-dd').format(selectedDate);

                        //       // Update the TextEditingController with the selected date
                        //       birthdayController.text = formattedDate;
                        //     }
                        //   },
                        //   child: AbsorbPointer(
                        //     child: Container(
                        //       padding: EdgeInsets.symmetric(
                        //           horizontal: 16, vertical: 12),
                        //       decoration: BoxDecoration(
                        //         borderRadius: BorderRadius.circular(20.0),
                        //         color: Colors.white, // Removed the border
                        //       ),
                        //       child: Row(
                        //         children: [
                        //           Icon(
                        //             Icons.cake,
                        //             color: Colors.grey,
                        //           ),
                        //           SizedBox(width: 10),
                        //           Expanded(
                        //             child: Text(
                        //               birthdayController.text.isEmpty
                        //                   ? "生日"
                        //                   : birthdayController.text,
                        //               style: TextStyle(
                        //                 color: birthdayController.text.isEmpty
                        //                     ? Colors.grey
                        //                     : Colors.black,
                        //                 fontSize: 16,
                        //               ),
                        //             ),
                        //           ),
                        //           Icon(
                        //             Icons.calendar_today,
                        //             color: Colors.blue,
                        //           ),
                        //         ],
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        // GestureDetector(
                        //   onTap: () async {
                        //     // Use a location picker or get the user's current location
                        //     Position position =
                        //         await Geolocator.getCurrentPosition(
                        //       desiredAccuracy: LocationAccuracy.high,
                        //     );

                        //     double latitude = position.latitude;
                        //     double longitude = position.longitude;

                        //     // Update the TextEditingController with the selected location
                        //     locationController.text =
                        //         "Lat: $latitude, Lng: $longitude";

                        //     // Print values for debugging
                        //     print(
                        //         "Selected location - Latitude: $latitude, Longitude: $longitude");
                        //   },
                        //   child: AbsorbPointer(
                        //     child: Container(
                        //       padding: EdgeInsets.symmetric(
                        //           horizontal: 16, vertical: 12),
                        //       decoration: BoxDecoration(
                        //         borderRadius: BorderRadius.circular(20.0),
                        //         color: Colors.white,
                        //       ),
                        //       child: Row(
                        //         children: [
                        //           Icon(
                        //             Icons.location_on,
                        //             color: Colors.grey,
                        //           ),
                        //           SizedBox(width: 10),
                        //           Expanded(
                        //             child: Text(
                        //               locationController.text.isEmpty
                        //                   ? "Select Location"
                        //                   : locationController.text,
                        //               style: TextStyle(
                        //                 color: locationController.text.isEmpty
                        //                     ? Colors.grey
                        //                     : Colors.black,
                        //                 fontSize: 16,
                        //               ),
                        //             ),
                        //           ),
                        //           Icon(
                        //             Icons.map,
                        //             color: Colors.blue,
                        //           ),
                        //         ],
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        // GestureDetector(
                        //   onTap: () async {
                        //     await BirthdayCal.selectTime(
                        //         context, timeController);
                        //     setState(() {
                        //       labelText = timeController.text.isEmpty
                        //           ? "出生時間 (不知不用填)"
                        //           : timeController
                        //               .text; // Update label text based on selection
                        //     });
                        //   },
                        //   child: AbsorbPointer(
                        //     child: Container(
                        //       padding: EdgeInsets.symmetric(
                        //           horizontal: 16, vertical: 12),
                        //       decoration: BoxDecoration(
                        //         borderRadius: BorderRadius.circular(20.0),
                        //         color: Colors.white, // Removed the border
                        //       ),
                        //       child: Row(
                        //         children: [
                        //           Icon(
                        //             Icons.access_time,
                        //             color: Colors.grey,
                        //           ),
                        //           SizedBox(width: 10),
                        //           Expanded(
                        //             child: Text(
                        //               timeController.text.isEmpty
                        //                   ? "出生時間 (不知不用填)"
                        //                   : timeController.text,
                        //               style: TextStyle(
                        //                 color: timeController.text.isEmpty
                        //                     ? Colors.grey
                        //                     : Colors.black,
                        //                 fontSize: 16,
                        //               ),
                        //             ),
                        //           ),
                        //           Icon(
                        //             Icons.access_alarm,
                        //             color: Colors.blue,
                        //           ),
                        //         ],
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        const SizedBox(height: 10),
                        CustomTextFieldWidget.buildTextField(
                          passwordlTextEditingController,
                          "密碼",
                          icon: Icons.lock_outline,
                        ),
                        const SizedBox(height: 10),
                        CustomTextFieldWidget.buildTextField(
                          confirmPasswordController,
                          "密碼",
                          icon: Icons.lock_outline_sharp,
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start, // Align title to the start
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            bottom: 8.0), // Space between title and container
                        child: Text(
                          "生活&&興趣", // Change this to your desired title
                          style: TextStyle(
                            fontSize: 18, // Font size of the title
                            fontWeight: FontWeight.bold, // Bold font style
                            color: const Color.fromARGB(
                                255, 0, 0, 0), // Title color
                          ),
                        ),
                      ),
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
                            color:
                                Colors.grey.withOpacity(0.8), // Outline color
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
                                          toggleInterest(interest);
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
                                                    topLeft:
                                                        Radius.circular(34),
                                                    topRight:
                                                        Radius.circular(18),
                                                    bottomLeft:
                                                        Radius.circular(18),
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
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),

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
                        // if (authenticationcontroller.profileImage == null) {
                        String missingFields = '';

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
                            "Error",
                            "Please fill in the following fields: $missingFields",
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.white,
                            titleText: Text(
                              "Error",
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            messageText: Text(
                              "Please fill in the following fields: $missingFields",
                              style: TextStyle(color: Colors.red),
                            ),
                          );
                          return;
                        }

                        // Email format validation
                        final email = emailTextEditingController.text.trim();
                        final emailRegex =
                            RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

                        if (!emailRegex.hasMatch(email)) {
                          Get.snackbar(
                            "Error",
                            "The email address is badly formatted.",
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.white,
                            titleText: const Text(
                              "Error",
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold),
                            ),
                            messageText: const Text(
                              "Please enter a valid email address.",
                              style: TextStyle(color: Colors.red),
                            ),
                          );
                          return;
                        }

                        List<String> imageUrls = await saveProfileImages(_images
                            .where((img) => img != null)
                            .cast<File>()
                            .toList());

                        setState(() {
                          showProgressBar = true; // Show progress bar
                        });

                        try {
                          bool emailExists =
                              await _checkIfEmailExistsInAuthAndFirestore(
                                  email);

                          if (emailExists) {
                            setState(() {
                              showProgressBar = false;
                            });

                            Get.snackbar(
                              "Error",
                              "The email already exists. Please use a different email.",
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.white,
                              titleText: const Text(
                                "Error",
                                style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold),
                              ),
                              messageText: const Text(
                                "Email already registered",
                                style: TextStyle(color: Colors.red),
                              ),
                            );
                            return;
                          }

                          // Attempt to create the account
                          await authenticationcontroller.creatNewUserAccount(
                            email,
                            passwordlTextEditingController.text.trim(),
                            nameTextEditingController.text.trim(),
                            selectedInterests,
                            imageUrls,
                            sexController.text.trim(),
                            timeController.text.trim(),
                            birthdayController.text.trim(),
                            timeController.text.isEmpty ? "false" : "true",
                            age,
                            selectedoccu,
                            selectmbti,
                            selectlanguage,
                            selectreligion,
                            selecteducation,
                            selectbloodtype,
                            selectlooking,
                            selectexercise,
                            selectdiet,
                            double.parse(locationController.text
                                .split(',')[0]
                                .split(':')[1]
                                .trim()), // Latitude
                            double.parse(locationController.text
                                .split(',')[1]
                                .split(':')[1]
                                .trim()),
                            "", 50,

                            ageRange: {'min': 1, 'max': 50},
                          );

                          if (mounted) {
                            setState(() {
                              showProgressBar = false; // Hide progress bar
                            });

                            // Show success message and navigate
                            Get.snackbar(
                              "Success",
                              "Account created successfully",
                              snackPosition: SnackPosition.TOP,
                              backgroundColor: Colors.green,
                              colorText: Colors.white,
                              borderRadius: 12,
                              margin: const EdgeInsets.all(10),
                              icon: const Icon(Icons.check_circle,
                                  color: Colors.white),
                              duration: const Duration(seconds: 3),
                              isDismissible: true,
                              forwardAnimationCurve: Curves.easeInOut,
                            );

                            // Navigate to HomeScreen
                            Get.offAll(() => HomeScreen());
                          }
                        } on FirebaseAuthException catch (e) {
                          // Handle Firebase-specific exceptions
                          setState(() {
                            showProgressBar = false;
                          });

                          String errorMessage;
                          switch (e.code) {
                            case 'email-already-in-use':
                              errorMessage = "This email is already in use.";
                              break;
                            case 'invalid-email':
                              errorMessage =
                                  "The email address is badly formatted.";
                              break;
                            case 'weak-password':
                              errorMessage = "The password is too weak.";
                              break;
                            default:
                              errorMessage = "An error occurred: ${e.message}";
                          }

                          Get.snackbar(
                            "Error",
                            errorMessage,
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.white,
                            titleText: Text(
                              "Error",
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold),
                            ),
                            messageText: Text(
                              errorMessage,
                              style: TextStyle(color: Colors.red),
                            ),
                          );
                        } catch (e) {
                          // Handle unexpected exceptions
                          setState(() {
                            showProgressBar = false;
                          });

                          Get.snackbar(
                            "Error",
                            "An unexpected error occurred: $e",
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.white,
                            titleText: Text(
                              "Error",
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold),
                            ),
                            messageText: Text(
                              "An unexpected error occurred: $e",
                              style: TextStyle(color: Colors.red),
                            ),
                          );
                        }
                        // } else {
                        //   Get.snackbar(
                        //       "Error", "Please select a profile image");
                        // }
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
                      // InkWell(
                      //   onTap: () {
                      //     print(Get.routing.current);

                      //     print("Tapped!");
                      //     Get.back();
                      //   },
                      //   child: const Text(
                      //     "已經有帳號",
                      //     style: TextStyle(
                      //         fontSize: 14,
                      //         color: Color.fromARGB(255, 0, 0, 0),
                      //         fontWeight: FontWeight.bold),
                      //   ),
                      // ),
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

  Future<List<String>> saveProfileImages(List<File> images) async {
    if (images.length > 6) {
      throw Exception("You can only upload up to 6 images.");
    }

    List<String> uploadedUrls = [];

    for (int i = 0; i < images.length; i++) {
      File image = images[i];

      // Generate a unique path for each image in Firebase Storage
      var ref = FirebaseStorage.instance
          .ref()
          .child("images/${DateTime.now().millisecondsSinceEpoch}_$i.jpg");

      // Upload the image to Firebase Storage
      await ref.putFile(image).whenComplete(() async {
        // Get the download URL of the uploaded image
        String downloadUrl = await ref.getDownloadURL();
        uploadedUrls.add(downloadUrl); // Save the URL
      });
    }

    return uploadedUrls; // Return the list of URLs
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
                          const Icon(Icons.cancel, color: Colors.red, size: 40),
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
}
