// import 'package:datingapp/tabScreens/swipping_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class CodeEntryScreen extends StatelessWidget {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final String verificationId;
//   final TextEditingController otpController = TextEditingController();

//   CodeEntryScreen({required this.verificationId});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Enter OTP'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: otpController,
//               keyboardType: TextInputType.number,
//               decoration: InputDecoration(
//                 labelText: 'OTP',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 String otp = otpController.text.trim();

//                 if (otp.isNotEmpty) {
//                   // Call the function to verify the OTP
//                   _verifyOTP(otp);
//                 } else {
//                   Get.snackbar('Error', 'Please enter the OTP');
//                 }
//               },
//               child: Text('Verify OTP'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // Function to verify OTP
//   void _verifyOTP(String otp) async {
//     try {
//       PhoneAuthCredential credential = PhoneAuthProvider.credential(
//         verificationId: verificationId,
//         smsCode: otp,
//       );

//       // Sign in with the credential
//       await _auth.signInWithCredential(credential);
//       Get.to(
//           SwippingScreen()); // Navigate to Home Screen after successful sign-in
//     } catch (e) {
//       Get.snackbar('Error', 'Failed to verify OTP. ${e.toString()}');
//     }
//   }
// }
