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
        bool hasProfilePicture =
            userData['imageUrls'] != null && userData['imageUrls'].isNotEmpty;

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
        // appBar: AppBar(
        //   backgroundColor: Color.fromARGB(255, 231, 94, 94),
        // ),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        body: Stack(children: [
          // Background image
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              "lib/image/loginbackground.png",
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
              height: 540,
              width: 300,
            ),
          ),

          SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  const SizedBox(height: 150),
                  ClipOval(
                    child: Image.asset(
                      "lib/image/logo.png",
                      width: 88,
                      height: 88,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    "來",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 180),

                  CustomTextFieldWidget.buildTextField(
                      emailTextEditingController, "Email",
                      icon: Icons.email_outlined,
                      width: MediaQuery.of(context).size.width - 36),

                  const SizedBox(height: 20),
                  CustomTextFieldWidget.buildTextField(
                      passwordTextEditingController, "密碼",
                      icon: Icons.lock_outline,
                      width: MediaQuery.of(context).size.width - 36),

                  const SizedBox(height: 20),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment
                        .start, // Align all children to the left
                    children: [
                      Align(
                        alignment:
                            Alignment.centerLeft, // Align container to the left
                        child: Container(
                          width: MediaQuery.of(context).size.width - 36,
                          height: 55,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey
                                    .withOpacity(0.8), // Shadow color
                                spreadRadius: 1, // Spread radius
                                blurRadius: 6, // Blur radius
                                offset: const Offset(
                                    6, 6), // Shadow position (x, y)
                              ),
                            ],
                            color: Color.fromARGB(255, 255, 187, 178),
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(30),
                              bottomRight: Radius.circular(30),
                            ),
                          ),
                          child: InkWell(
                            onTap: () async {
                              String email =
                                  emailTextEditingController.text.trim();
                              String password =
                                  passwordTextEditingController.text.trim();

                              if (email.isNotEmpty && password.isNotEmpty) {
                                if (mounted) {
                                  setState(() {
                                    showProgressBar = true; // Show progress bar
                                  });
                                }
                                try {
                                  // Call the login function
                                  await controllerAuth.loginUser(
                                      email, password);

                                  setState(() {
                                    showProgressBar = false;
                                    print(
                                        "setState called at loggin screen 190 ");
                                  });
                                } catch (e) {
                                  setState(() {
                                    showProgressBar = false;
                                    print(
                                        "error setState called at loggin screen 196 ");
                                    print("Login error: $e line 196");
                                  });
                                  Get.snackbar(
                                    "Error",
                                    "Login failed. Please try again.",
                                    snackPosition: SnackPosition.TOP,
                                    backgroundColor:
                                        const Color.fromARGB(255, 243, 159, 2),
                                    colorText: Colors.white,
                                    borderRadius: 12,
                                    margin: const EdgeInsets.all(10),
                                    icon: const Icon(Icons.check_circle,
                                        color: Colors.white),
                                    duration: const Duration(seconds: 3),
                                    isDismissible: true,
                                    forwardAnimationCurve: Curves.easeInOut,
                                  );
                                }
                              } else {
                                Get.snackbar(
                                  "Error",
                                  "Please enter both email and password",
                                  snackPosition: SnackPosition.TOP,
                                  backgroundColor:
                                      const Color.fromARGB(255, 255, 187, 0),
                                  colorText: const Color.fromARGB(255, 0, 0, 0),
                                  borderRadius: 12,
                                  margin: const EdgeInsets.all(10),
                                  icon: const Icon(Icons.check_circle,
                                      color: Color.fromARGB(255, 0, 0, 0)),
                                  duration: const Duration(seconds: 3),
                                  isDismissible: true,
                                  forwardAnimationCurve: Curves.easeInOut,
                                );
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
                      ),
                      const SizedBox(height: 10), // Add vertical spacing
                      Align(
                        alignment:
                            Alignment.centerLeft, // Align container to the left
                        child: Container(
                          width: MediaQuery.of(context).size.width - 36,
                          height: 55,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey
                                    .withOpacity(0.8), // Shadow color
                                spreadRadius: 1, // Spread radius
                                blurRadius: 6, // Blur radius
                                offset: const Offset(
                                    6, 6), // Shadow position (x, y)
                              ),
                            ],
                            color: Colors.blue,
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(30),
                              bottomRight: Radius.circular(30),
                            ),
                          ),
                          child: InkWell(
                            onTap: () async {
                              try {
                                // setState(() {
                                //   showProgressBar = true;
                                //   print("setState called at loggin screen 272");
                                // });
                                if (mounted) {
                                  setState(() {
                                    showProgressBar = true;
                                    print(
                                        "setState called at loggin screen 272");
                                  });
                                }

                                // Print to indicate the start of the login process
                                print("Starting Google login...");

                                // Call the Google login function
                                User? user = await loginWithGoogle();

                                // Check if user login was successful and show the corresponding message
                                if (user != null) {
                                  print(
                                      "Google login successful: ${user.email}");

                                  Get.snackbar(
                                    "Success",
                                    "Logged in successfully with Google!",
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
                                } else {
                                  print("Google login failed: User is null");

                                  Get.snackbar(
                                    "Error",
                                    "Google login failed",
                                    snackPosition: SnackPosition.TOP,
                                    backgroundColor: Colors.red,
                                    colorText: Colors.white,
                                    borderRadius: 12,
                                    margin: const EdgeInsets.all(10),
                                    icon: const Icon(Icons.error,
                                        color: Colors.white),
                                    duration: const Duration(seconds: 3),
                                    isDismissible: true,
                                    forwardAnimationCurve: Curves.easeInOut,
                                  );
                                }
                              } catch (e) {
                                // Catch and log any error during the login process
                                print("Google login failed with error: $e");

                                Get.snackbar(
                                  "Error",
                                  "An error occurred during Google login.",
                                  snackPosition: SnackPosition.TOP,
                                  backgroundColor: Colors.red,
                                  colorText: Colors.white,
                                  borderRadius: 12,
                                  margin: const EdgeInsets.all(10),
                                  icon: const Icon(Icons.error,
                                      color: Colors.white),
                                  duration: const Duration(seconds: 3),
                                  isDismissible: true,
                                  forwardAnimationCurve: Curves.easeInOut,
                                );
                              } finally {
                                // Hide the progress bar, regardless of success or failure
                                if (mounted) {
                                  setState(() {
                                    showProgressBar =
                                        false; // Hide progress bar

                                    print("setState called at loggin screen");
                                  });
                                }

                                // Print to indicate that the process has finished
                                print("Google login process finished.");
                              }
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
                      ),
                    ],
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
                      InkWell(
                        onTap: () {
                          Get.to(RegisterationScreen());
                          // Get.offAll(() => RegisterationScreen());
                        },
                        child: const Text(
                          "Create an account",
                          style: TextStyle(
                            fontSize: 18,
                            color: Color.fromARGB(255, 28, 222, 76),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ]));
  }

  Future<User?> loginWithGoogle() async {
    try {
      // Trigger the Google Sign-In flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return null; // User canceled the login
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
        // Check if the user already exists in Firestore
        final userDocRef =
            FirebaseFirestore.instance.collection('users').doc(user.uid);
        final docSnapshot = await userDocRef.get();

        if (docSnapshot.exists) {
          // If user exists, check if the profile fields are filled
          Map<String, dynamic> userData = docSnapshot.data()!;

          String? password = userData['password'];
          String? email = userData['email'];
          String? name = userData['name'];
          String? birthday = userData['birthday'];
          List<dynamic> imageUrls = userData['imageUrls'] ?? [];

          // Check if any required field is missing or empty
          if (password == "" ||
              email == "" ||
              name == "" ||
              birthday == "" ||
              imageUrls.isEmpty) {
            // If any of the fields are missing, redirect to profile completion screen
            Get.off(() => ProfileCompletionScreen(user: user));
          } else {
            // If all required fields are filled, redirect to home screen
            Get.off(() => HomeScreen());
          }
        } else {
          // User does not exist in Firestore, so redirect to profile completion screen
          Get.off(() => ProfileCompletionScreen(user: user));
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

  // Future<User?> loginWithGoogle() async {
  //   try {
  //     // Trigger the Google Sign-In flow
  //     final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
  //     if (googleUser == null) {
  //       return null; // User canceled the login
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
  //       // Check if the user already exists in Firestore
  //       final userDocRef =
  //           FirebaseFirestore.instance.collection('users').doc(user.uid);
  //       final docSnapshot = await userDocRef.get();

  //       if (!docSnapshot.exists) {
  //         // If user does not exist, create default fields in Firestore
  //         Map<String, dynamic> defaultUserData = {
  //           "age": "-1",
  //           "bdTime": "",
  //           "birthday": "",
  //           "bloodtype": [],
  //           "diet": [],
  //           "education": [],
  //           "email": user.email ?? "",

  //           "imageUrls": [
  //             user.photoURL ?? "https://example.com/default-profile-image.jpg"
  //           ],
  //           "interests": [],
  //           "language": [],
  //           "lookingfor": [],
  //           "mbti": [],
  //           "name": user.displayName ?? user.email ?? "Unknown User",
  //           "occupation": [],
  //           "password": "", // Placeholder
  //           "photoNo": null,
  //           "publishedDateTime": null,
  //           "religion": [],
  //           "sex": "",
  //           "sure": "false",
  //           "uid": user.uid,
  //         };

  //         await userDocRef.set(defaultUserData);

  //         // Redirect to profile completion screen
  //         Get.off(() => ProfileCompletionScreen(user: user));
  //       } else {
  //         // If user exists, check if the profile is complete
  //         bool isProfileComplete = await checkUserProfile(user);

  //         if (!isProfileComplete) {
  //           // Redirect to profile completion screen if profile is incomplete
  //           Get.off(() => ProfileCompletionScreen(user: user));
  //         } else {
  //           // Redirect to main/home screen if profile is complete
  //           Get.off(() => HomeScreen());
  //         }
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
}
