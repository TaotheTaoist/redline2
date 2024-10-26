// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:get/get.dart'; // For navigation with GetX
// import 'package:datingapp/widgets/custom_text_field_widget.dart'; // Import your custom text field widget
// import 'package:firebase_auth/firebase_auth.dart'; // To get the current user

// class ProfileCompletionScreen extends StatelessWidget {
//   final User user;

//   ProfileCompletionScreen({required this.user});

//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController birthdayController = TextEditingController();
//   final TextEditingController locationController = TextEditingController();
//   // Additional fields as needed...

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Complete Your Profile')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [f
//             CustomTextFieldWidget(
//               editingController: nameController,
//               labelText: "Name",
//               iconData: Icons.person,
//             ),
//             CustomTextFieldWidget(
//               editingController: birthdayController,
//               labelText: "Birthday",
//               iconData: Icons.cake,
//             ),
//             CustomTextFieldWidget(
//               editingController: locationController,
//               labelText: "Location",
//               iconData: Icons.location_on,
//             ),
//             ElevatedButton(
//               onPressed: () async {
//                 // Save data to Firestore
//                 await FirebaseFirestore.instance
//                     .collection('users')
//                     .doc(user.uid)
//                     .set({
//                   'name': nameController.text.trim(),
//                   'birthday': birthdayController.text.trim(),
//                   'location': locationController.text.trim(),
//                   'profilePicture': user.photoURL ??
//                       '', // Use existing profile picture if available
//                 }, SetOptions(merge: true));

//                 // Navigate back or to home screen
//                 Get.back();
//               },
//               child: Text("Complete Profile"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// import 'package:datingapp/widgets/custom_text_field_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart'; // Import for date formatting
// import 'package:geolocator/geolocator.dart';

// class ProfileCompletionScreen extends StatelessWidget {
//   final User user; // Accept User object in constructor

//   ProfileCompletionScreen({super.key, required this.user});

//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController birthdayController = TextEditingController();
//   final TextEditingController locationController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     final String userID = user.uid; // Get the user ID from the User object
//     final String userEmail = user.email ?? ""; // Get user's email

//     return Scaffold(
//       appBar: AppBar(title: Text('Complete Your Profile')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             Text("Logged in as: $userEmail"), // Print the user's email
//             Text(
//               "User ID: $userID",
//               style: TextStyle(fontSize: 16),
//             ),
//             SizedBox(
//               height: 20,
//             ),
//             CustomTextFieldWidget(
//               editingController: nameController,
//               labelText: "Name",
//               iconData: Icons.person,
//               borderRadius: 20.0,
//             ),
//             SizedBox(
//               height: 20,
//             ),
//             CustomTextFieldWidget(
//               editingController: emailController,
//               labelText: "Email",
//               iconData: Icons.email_outlined,
//               borderRadius: 20.0,
//             ),
//             SizedBox(
//               height: 20,
//             ),
//             CustomTextFieldWidget(
//               editingController: birthdayController,
//               labelText: "Birthday",
//               iconData: Icons.cake,
//               borderRadius: 20.0,
//             ),
//             SizedBox(
//               height: 20,
//             ),
//             CustomTextFieldWidget(
//               editingController: locationController,
//               labelText: "Location",
//               iconData: Icons.location_on,
//               borderRadius: 20.0,
//             ),

//             SizedBox(
//               height: 20,
//             ),
//             ElevatedButton(
//               onPressed: () async {
//                 final emailExists = await _checkIfEmailExists(
//                     emailController.text.trim(), userID);

//                 if (emailExists) {
//                   Get.snackbar(
//                     "Email Already Exists",
//                     "The email you entered is already in use.",
//                     snackPosition: SnackPosition.BOTTOM,
//                   );
//                 } else {
//                   await FirebaseFirestore.instance
//                       .collection('users')
//                       .doc(userID)
//                       .set({
//                     'name': nameController.text.trim(),
//                     'email': emailController.text.trim(),
//                     'birthday': birthdayController.text.trim(),
//                     'location': locationController.text.trim(),
//                     'profilePicture': user.photoURL ?? '',
//                   }, SetOptions(merge: true));

//                   Get.back();
//                 }
//               },
//               child: Text("Complete Profile"),
//             ),
//           ],
//         ),
//       ),
//     );

//   }

//   // Future<bool> _checkIfEmailExists(String email) async {
//   //   final QuerySnapshot result = await FirebaseFirestore.instance
//   //       .collection('users')
//   //       .where('email', isEqualTo: email)
//   //       .get();

//   //   return result.docs.isNotEmpty;
//   // }

//   Future<bool> _checkIfEmailExists(String email, String currentUserId) async {
//     final QuerySnapshot result = await FirebaseFirestore.instance
//         .collection('users')
//         .where('email', isEqualTo: email)
//         .get();

//     // Check if the email exists and is not associated with the current user
//     return result.docs.isNotEmpty && result.docs.first.id != currentUserId;
//   }

// }
import 'package:redline/widgets/custom_text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // For date formatting
// import 'package:geolocator/geolocator.dart';

// import 'package:location/location.dart';

// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';

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
  final TextEditingController birthdayController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final String userID = widget.user.uid;
    final String userEmail = widget.user.email ?? "";

    // String? _currentAddress;
    // Position? _currentPosition;

    return Scaffold(
      appBar: AppBar(title: const Text('Complete Your Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text("Logged in as: $userEmail"),
            Text(
              "User ID: $userID",
              style: const TextStyle(fontSize: 16),
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
              onTap: () => _selectDate(context),
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
                    'profilePicture': widget.user.photoURL ?? '',
                  }, SetOptions(merge: true));
                  Get.back();
                }
              },
              child: const Text("Complete Profile"),
            ),
            // ElevatedButton(
            //   onPressed: () async {
            //     _currentPosition = await LocationHandler.getCurrentPosition();
            //     _currentAddress = await LocationHandler.getAddressFromLatLng(
            //         _currentPosition!);
            //     setState(() {});
            //   },
            //   child: const Text("Get Current Location"),
            // ),
          ],
        ),
      ),
    );
  }

  // Method to select a date using date picker
  void _selectDate(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      setState(() {
        birthdayController.text = DateFormat('yyyy-MM-dd').format(selectedDate);
      });
    }
  }

  // Update this method to use the location package
  // Future<void> _getCurrentLocation() async {
  //   Location location = Location();

  //   // Check permission status and request if necessary
  //   bool _serviceEnabled = await location.serviceEnabled();
  //   if (!_serviceEnabled) {
  //     _serviceEnabled = await location.requestService();
  //     if (!_serviceEnabled) {
  //       print("Location service not enabled.");
  //       return; // Exit if service is not enabled
  //     }
  //   }

  //   PermissionStatus permission =
  //       await location.hasPermission(); // Change to PermissionStatus
  //   if (permission == PermissionStatus.denied) {
  //     permission = await location.requestPermission();
  //     if (permission != PermissionStatus.granted) {
  //       print("Location permission denied.");
  //       return; // Exit if permission is still not granted
  //     }
  //   }

  //   // Fetch the location
  //   LocationData currentLocation;
  //   try {
  //     currentLocation = await location.getLocation();
  //     print(
  //         "Current location: ${currentLocation.latitude}, ${currentLocation.longitude}");

  //     // Optional: Update the text field with the fetched location coordinates
  //     locationController.text =
  //         "${currentLocation.latitude}, ${currentLocation.longitude}";
  //   } catch (e) {
  //     print("Could not get the location: $e");
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

// abstract class LocationHandler {
//   static Future<bool> handleLocationPermission() async {
//     bool serviceEnabled;
//     LocationPermission permission;

//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       // Location services are disabled. Please enable the services
//       return false;
//     }
//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         // Location permissions are denied
//         return false;
//       }
//     }
//     if (permission == LocationPermission.deniedForever) {
//       // Location permissions are permanently denied, we cannot request permissions.

//       return false;
//     }
//     return true;
//   }

//   static Future<Position?> getCurrentPosition() async {
//     try {
//       final hasPermission = await handleLocationPermission();
//       if (!hasPermission) return null;
//       return await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high,
//       );
//     } catch (e) {
//       return null;
//     }
//   }

//   static Future<String?> getAddressFromLatLng(Position position) async {
//     try {
//       List<Placemark> placeMarks =
//           await placemarkFromCoordinates(position.latitude, position.longitude);
//       Placemark place = placeMarks[0];
//       return "${place.street}, ${place.subLocality},${place.subAdministrativeArea}, ${place.postalCode}";
//     } catch (e) {
//       return null;
//     }
//   }
// }
