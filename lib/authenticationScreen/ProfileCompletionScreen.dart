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
  final TextEditingController nameTextEditingController =
      TextEditingController();

  final TextEditingController birthdayController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  // final TextEditingController emailController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();

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
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () => _selectDate(context),
              child: AbsorbPointer(
                child: TextField(
                  controller: birthdayController,
                  decoration: InputDecoration(
                    labelText: "Birthday",
                    prefixIcon: Icon(Icons.cake),
                    suffixIcon:
                        Icon(Icons.calendar_today), // Added calendar icon
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
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
                    emailTextEditingController.text.trim(), userID);
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
                    'uid': userID,
                    'name': nameTextEditingController.text.trim(),
                    'email': emailTextEditingController.text.trim(),
                    'birthday': birthdayController.text.trim(),
                    'location': locationController.text.trim(),
                    'profilePicture': widget.user.photoURL ?? '',
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
