// import 'package:datingapp/authenticationScreen/registeration_screen.dart';
// import 'package:datingapp/controller/authenticationController.dart';
// import 'package:datingapp/widgets/custom_text_field_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   TextEditingController emailTextEditingController = TextEditingController();
//   TextEditingController passwordTextEditingController = TextEditingController();

//   bool obscureText = true; // Controls whether to obscure the password text
//   bool showProgressBar = false; // Controls the display of the progress bar
//   var controllerAuth = Authenticationcontroller.authenticationcontroller;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Center(
//           child: Column(
//             children: [
//               const SizedBox(height: 120),
//               Image.asset(
//                 "lib/image/logo.png",
//                 width: 180,
//               ),
//               const Text(
//                 "Welcome",
//                 style: TextStyle(
//                   fontSize: 22,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const Text(
//                 "Login",
//                 style: TextStyle(
//                   fontSize: 22,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 20),
//               // Email Input Field
//               Container(
//                 width: MediaQuery.of(context).size.width - 36,
//                 child: CustomTextFieldWidget(
//                   editingController: emailTextEditingController,
//                   labelText: "Email",
//                   iconData: Icons.email_outlined,
//                   isObscure: false,
//                 ),
//               ),
//               const SizedBox(height: 20),
//               // Password Input Field with Toggle Visibility
//               Container(
//                 width: MediaQuery.of(context).size.width - 36,
//                 child: TextField(
//                   controller: passwordTextEditingController,
//                   obscureText: obscureText, // Toggles password visibility
//                   decoration: InputDecoration(
//                     labelText: 'Password',
//                     prefixIcon: Icon(Icons.lock_outline),
//                     suffixIcon: IconButton(
//                       icon: Icon(
//                         obscureText ? Icons.visibility_off : Icons.visibility,
//                       ),
//                       onPressed: () {
//                         setState(() {
//                           obscureText = !obscureText; // Toggle visibility
//                         });
//                       },
//                     ),
//                     border: const OutlineInputBorder(),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               // Login Button
//               Container(
//                 width: MediaQuery.of(context).size.width - 36,
//                 height: 55,
//                 decoration: const BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.all(
//                     Radius.circular(12),
//                   ),
//                 ),
//                 child: InkWell(
//                   onTap: () async {
//                     String email = emailTextEditingController.text.trim();
//                     String password = passwordTextEditingController.text.trim();

//                     if (email.isNotEmpty && password.isNotEmpty) {
//                       setState(() {
//                         showProgressBar = true; // Show progress bar
//                       });

//                       try {
//                         // Call the login function
//                         await controllerAuth.loginUser(email, password);

//                         setState(() {
//                           showProgressBar =
//                               false; // Hide progress bar after success
//                         });
//                       } catch (e) {
//                         setState(() {
//                           showProgressBar =
//                               false; // Hide progress bar after error
//                         });
//                         Get.snackbar(
//                             "Error", "Login failed. Please try again.");
//                       }
//                     } else {
//                       Get.snackbar(
//                           "Error", "Please enter both email and password");
//                     }
//                   },
//                   child: const Center(
//                     child: Text(
//                       "Login",
//                       style: TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.black,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 10),
//               // Display the progress bar if showProgressBar is true
//               showProgressBar
//                   ? const CircularProgressIndicator(
//                       valueColor: AlwaysStoppedAnimation<Color>(Colors.pink),
//                     )
//                   : Container(), // Empty container when progress bar is hidden
//               const SizedBox(height: 10),
//               // Sign-up link
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     "Don't have an account?",
//                     style: TextStyle(
//                       fontSize: 16,
//                       color: Colors.green,
//                     ),
//                   ),
//                   InkWell(
//                     onTap: () {
//                       Get.to(RegisterationScreen());
//                     },
//                     child: const Text(
//                       "Create an account",
//                       style: TextStyle(
//                         fontSize: 18,
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:redline/authenticationScreen/ProfileCompletionScreen.dart';
import 'package:redline/authenticationScreen/registeration_screen.dart';
import 'package:redline/controller/authenticationController.dart';
import 'package:redline/controller/phoneNumberScreen.dart';
import 'package:redline/widgets/custom_text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  // Function for Google Sign-In
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
  //     return userCredential.user;
  //   } catch (e) {
  //     Get.snackbar("Error", "Google login failed. Please try again.");
  //     print("Google sign-in error: $e");
  //     return null;
  //   }
  // }

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
          // Redirect to profile completion screen if profile is incomplete
          Get.to(ProfileCompletionScreen(user: user));
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
    // Here, assume you've stored user information in Firestore
    final userRef =
        FirebaseFirestore.instance.collection('users').doc(user.uid);
    final userSnapshot = await userRef.get();

    if (userSnapshot.exists) {
      // Check if required fields are present
      final userData = userSnapshot.data()!;
      bool hasName =
          userData.containsKey('name') && userData['name'].isNotEmpty;
      bool hasBirthday =
          userData.containsKey('birthday') && userData['birthday'].isNotEmpty;
      bool hasLocation =
          userData.containsKey('location') && userData['location'].isNotEmpty;
      bool hasProfilePicture = userData.containsKey('profilePicture') &&
          userData['profilePicture'].isNotEmpty;

      return hasName && hasBirthday && hasLocation && hasProfilePicture;
    } else {
      // If no profile exists, return false, meaning profile is incomplete
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 120),
              Image.asset(
                "lib/image/logo.png",
                width: 180,
              ),
              const Text(
                "Welcome",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
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
                ),
              ),
              const SizedBox(height: 20),
              // Password Input Field with Toggle Visibility
              Container(
                width: MediaQuery.of(context).size.width - 36,
                child: TextField(
                  controller: passwordTextEditingController,
                  obscureText: obscureText, // Toggles password visibility
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscureText ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          obscureText = !obscureText; // Toggle visibility
                        });
                      },
                    ),
                    border: const OutlineInputBorder(),
                  ),
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
                    String password = passwordTextEditingController.text.trim();

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
                          "Success", "Logged in successfully with Google!");
                    } else {
                      Get.snackbar("Error", "Google login failed.");
                    }

                    setState(() {
                      showProgressBar = false; // Hide progress bar after login
                    });
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
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.pink),
                    )
                  : Container(), // Empty container when progress bar is hidden
              const SizedBox(height: 10),
              // Sign-up link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account?",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.green,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Get.to(RegisterationScreen());
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

              const SizedBox(height: 10),

// **Phone Login Button** (Add this section)
            ],
          ),
        ),
      ),
    );
  }
}
