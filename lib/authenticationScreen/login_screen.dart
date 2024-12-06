import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:redline/authenticationScreen/ProfileCompletionScreen.dart';
import 'package:redline/authenticationScreen/registeration_screen.dart';
import 'package:redline/controller/authenticationController.dart';
import 'package:redline/widgets/custom_text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../homeScreen/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  bool obscureText = true; // Controls whether to obscure the password text
  bool showProgressBar = false; // Controls the display of the progress bar

  var controllerAuth = Authenticationcontroller.authenticationcontroller;

  // Firebase Authentication instance
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // Google Sign-In instance
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Future<User?> loginWithGoogle() async {
  //   try {
  //     // Trigger the Google Sign-In flow
  //     final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
  //     if (googleUser == null) {
  //       return null; // If the user cancels the login
  //     }

  //     // Obtain the Google auth details
  //     final GoogleSignInAuthentication googleAuth =
  //         await googleUser.authentication;

  //     // Create a new credential
  //     final OAuthCredential credential = GoogleAuthProvider.credential(
  //       accessToken: googleAuth.accessToken,
  //       idToken: googleAuth.idToken,
  //     );

  //     // Sign in to Firebase with the Google credentials
  //     UserCredential userCredential =
  //         await _auth.signInWithCredential(credential);
  //     User? user = userCredential.user;

  //     if (user != null) {
  //       // Check if profile is complete
  //       bool isProfileComplete = await checkUserProfile(user);

  //       if (!isProfileComplete) {
  //         // Redirect to profile completion screen if profile is incomplete
  //         // Get.to(ProfileCompletionScreen(user: user));
  //         Get.to(() => ProfileCompletionScreen(user: user));
  //       }
  //       return user;
  //     }
  //     return null;
  //   } catch (e) {
  //     Get.snackbar("Error", "Google login failed. Please try again.");
  //     print("Google sign-in error: $e");
  //     return null;
  //   }
  // }

  // v2
  Future<User?> loginWithGoogle() async {
    try {
      // Trigger the Google Sign-In flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return null; // If the user cancels the login
      }

      // Obtain the Google auth details
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credentials
      UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      User? user = userCredential.user;

      if (user != null) {
        // Check if profile is complete
        bool isProfileComplete = await checkUserProfile(user);

        if (!isProfileComplete) {
          // Replace current screen with profile completion screen if profile is incomplete
          Get.off(() => ProfileCompletionScreen(user: user));
        } else {
          // Replace current screen with the main/home screen if profile is complete
          Get.off(() => HomeScreen());
        }
        return user;
      }
      return null;
    } catch (e) {
      Get.snackbar("Error", "Google login failed. Please try again.");
      print("Google sign-in error: $e");
      return null;
    }
  }

  Future<bool> checkUserProfile(User user) async {
    try {
      // Reference the user's Firestore document
      final userRef =
          FirebaseFirestore.instance.collection('users').doc(user.uid);
      final userSnapshot = await userRef.get();

      if (userSnapshot.exists) {
        final userData = userSnapshot.data()!;

        // Print each field to debug
        print("User Data: $userData");

        bool hasName = userData['name'] != null && userData['name'].isNotEmpty;
        bool hasBirthday =
            userData['birthday'] != null && userData['birthday'].isNotEmpty;
        bool hasUid = userData['uid'] != null && userData['uid'].isNotEmpty;
        bool hasEmail =
            userData['email'] != null && userData['email'].isNotEmpty;
        bool hasProfilePicture = userData['imageProfile'] != null &&
            userData['imageProfile'].isNotEmpty;

        // Print statements to verify each condition
        print(
            "hasName: $hasName, hasBirthday: $hasBirthday, hasUid: $hasUid, hasEmail: $hasEmail, hasProfilePicture: $hasProfilePicture");

        // Return true only if all fields are present and non-empty
        return hasName &&
            hasBirthday &&
            hasUid &&
            hasProfilePicture &&
            hasEmail;
      } else {
        print("User document does not exist.");
        return false;
      }
    } catch (e) {
      print("Error checking user profile: $e");
      return false;
    }
  }

  @override
  void dispose() {
    // Dispose controllers to avoid memory leaks
    emailTextEditingController.dispose();
    passwordTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 255, 177, 177),
        body: Stack(children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              "lib/image/loginbackground.png",
              fit: BoxFit.cover, // Ensures the image covers the entire screen
            ),
          ),

          SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  const SizedBox(height: 100),
                  ClipOval(
                    child: Image.asset(
                      "lib/image/logo.png",
                      width: 70,
                      height: 70,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const Text(
                    "Welcome",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 200),
                  const Text(
                    "Login",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Email Input Field
                  Container(
                    width: MediaQuery.of(context).size.width - 36,
                    child: CustomTextFieldWidget(
                      editingController: emailTextEditingController,
                      labelText: "Email",
                      iconData: Icons.email_outlined,
                      isObscure: false,
                      borderRadius: 20.0,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: MediaQuery.of(context).size.width - 36,
                    child: CustomTextFieldWidget(
                      editingController:
                          passwordTextEditingController, // Your password field controller
                      labelText: "Password", // Field label
                      iconData: Icons.lock_outline, // Lock icon for password
                      isObscure: true, // Hides the input for password
                      borderRadius: 20.0, // Set to 20 for more rounded borders
                    ),
                  ),

                  const SizedBox(height: 20),
                  // Login Button
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
                        String email = emailTextEditingController.text.trim();
                        String password =
                            passwordTextEditingController.text.trim();

                        if (email.isNotEmpty && password.isNotEmpty) {
                          setState(() {
                            showProgressBar = true; // Show progress bar
                          });

                          try {
                            // Call the login function
                            await controllerAuth.loginUser(email, password);

                            setState(() {
                              showProgressBar =
                                  false; // Hide progress bar after success
                            });
                          } catch (e) {
                            setState(() {
                              showProgressBar =
                                  false; // Hide progress bar after error
                            });
                            Get.snackbar(
                                "Error", "Login failed. Please try again.");
                          }
                        } else {
                          Get.snackbar(
                              "Error", "Please enter both email and password");
                        }
                      },
                      child: const Center(
                        child: Text(
                          "Login",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Google Sign-In Button
                  Container(
                    width: MediaQuery.of(context).size.width - 36,
                    height: 55,
                    decoration: BoxDecoration(
                      color: Colors.blue, // Google button background color
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: InkWell(
                      onTap: () async {
                        setState(() {
                          showProgressBar = true; // Show progress bar
                        });

                        // Call the Google login function
                        User? user = await loginWithGoogle();

                        if (user != null) {
                          Get.snackbar(
                            "Success",
                            "Logged in successfully with Google!",
                            snackPosition: SnackPosition
                                .TOP, // Position of the snackbar (TOP or BOTTOM)
                            backgroundColor: Colors.green, // Background color
                            colorText: Colors.white, // Text color
                            borderRadius: 12, // Rounded corners
                            margin: const EdgeInsets.all(
                                10), // Margin around the snackbar
                            icon: const Icon(Icons.check_circle,
                                color: Colors.white), // Add an icon
                            duration: const Duration(
                                seconds:
                                    3), // Duration the snackbar is displayed
                            isDismissible: true, // Allow manual dismissal
                            forwardAnimationCurve:
                                Curves.easeInOut, // Animation curve
                          );
                        } else {
                          Get.snackbar(
                            "Success",
                            "Failed",
                            snackPosition: SnackPosition
                                .TOP, // Position of the snackbar (TOP or BOTTOM)
                            backgroundColor: const Color.fromARGB(
                                255, 250, 142, 0), // Background color
                            colorText: Colors.white, // Text color
                            borderRadius: 12, // Rounded corners
                            margin: const EdgeInsets.all(
                                10), // Margin around the snackbar
                            icon: const Icon(Icons.check_circle,
                                color: Colors.white), // Add an icon
                            duration: const Duration(
                                seconds:
                                    3), // Duration the snackbar is displayed
                            isDismissible: true, // Allow manual dismissal
                            forwardAnimationCurve:
                                Curves.easeInOut, // Animation curve
                          );
                        }
                        if (mounted) {
                          setState(() {
                            showProgressBar = false; // Hide progress bar af
                          });
                        }
                        // setState(() {
                        //   showProgressBar = false; // Hide progress bar after login
                        // });
                      },
                      child: const Center(
                        child: Text(
                          "Login with Google",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Display the progress bar if showProgressBar is true
                  showProgressBar
                      ? const CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.pink),
                        )
                      : Container(), // Empty container when progress bar is hidden
                  const SizedBox(height: 10),
                  // Sign-up link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Text(
                      //   "Don't have an account?",
                      //   style: TextStyle(
                      //     fontSize: 16,
                      //     color: Colors.green,
                      //   ),
                      // ),
                      InkWell(
                        onTap: () {
                          Get.to(RegisterationScreen());
                          // Get.offAll(() => RegisterationScreen());
                        },
                        child: const Text(
                          "Create an account",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Add the following lines at the end of your build method

                  const SizedBox(height: 10),

                  // **Phone Login Button** (Add this section)
                ],
              ),
            ),
          ),
        ]));
  }
}
