// import 'package:datingapp/controller/codeEntryScreen.dart';
// import 'package:datingapp/tabScreens/swipping_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class PhoneNumberInputScreen extends StatefulWidget {
//   @override
//   _PhoneNumberInputScreenState createState() => _PhoneNumberInputScreenState();
// }

// class _PhoneNumberInputScreenState extends State<PhoneNumberInputScreen> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final TextEditingController phoneController = TextEditingController();
//   String selectedCountryCode = '+1'; // Default to US country code

//   final List<String> countryCodes = [
//     '+1 (US)',
//     '+886 (Taiwan)',
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Register with Phone Number'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             // Dropdown for country code selection
//             DropdownButton<String>(
//               value: selectedCountryCode,
//               items: countryCodes.map((String code) {
//                 return DropdownMenuItem<String>(
//                   value: code.split(' ')[0], // Use the country code only
//                   child: Text(code),
//                 );
//               }).toList(),
//               onChanged: (String? newValue) {
//                 setState(() {
//                   selectedCountryCode =
//                       newValue!; // Update selected country code
//                 });
//               },
//             ),
//             const SizedBox(height: 20),
//             TextField(
//               controller: phoneController,
//               keyboardType: TextInputType.phone,
//               decoration: InputDecoration(
//                 labelText: 'Phone Number',
//                 hintText: 'Enter your phone number',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 String phoneNumber =
//                     selectedCountryCode + phoneController.text.trim();

//                 if (phoneController.text.isNotEmpty) {
//                   // Call the Firebase function to send OTP
//                   _verifyPhoneNumber(context, phoneNumber);
//                 } else {
//                   Get.snackbar('Error', 'Please enter a valid phone number');
//                 }
//               },
//               child: Text('Send OTP'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // Function to verify phone number and send OTP
//   void _verifyPhoneNumber(BuildContext context, String phoneNumber) async {
//     await _auth.verifyPhoneNumber(
//       phoneNumber: phoneNumber,
//       verificationCompleted: (PhoneAuthCredential credential) async {
//         // Automatically sign in when verification is completed
//         await _auth.signInWithCredential(credential);
//         Get.to(SwippingScreen()); // Navigate to the home screen after sign-in
//       },
//       verificationFailed: (FirebaseAuthException e) {
//         Get.snackbar('Error', 'Verification failed. ${e.message}');
//       },
//       codeSent: (String verificationId, int? resendToken) {
//         // Navigate to Code Entry Screen after OTP is sent
//         Get.to(() => CodeEntryScreen(
//               verificationId: verificationId,
//             ));
//       },
//       codeAutoRetrievalTimeout: (String verificationId) {
//         Get.snackbar('Timeout', 'Code retrieval timeout');
//       },
//     );
//   }
// }
