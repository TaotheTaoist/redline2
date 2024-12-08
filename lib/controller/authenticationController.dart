// ignore_for_file: unused_import

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:redline/authenticationScreen/login_screen.dart';
import 'package:redline/constants/interests.dart';

import 'package:redline/homeScreen/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:redline/models/person.dart' as personModel;
import 'package:redline/tabScreens/favorite_sent_receieved_screen.dart';
import 'package:redline/tabScreens/like_sent_like_recieved_screen.dart';
import 'package:redline/tabScreens/swipping_screen.dart';
import 'package:redline/tabScreens/user_details_screen.dart';
import 'package:redline/tabScreens/view_sent_view_received_screen.dart';

class Authenticationcontroller extends GetxController {
  static Authenticationcontroller authenticationcontroller = Get.find();

  Rx<User?> firebaseCurrentUser = Rx<User?>(null);
  late Rx<File?> pickedFile = Rx<File?>(null);
  File? get profileImage => pickedFile.value;
  XFile? imageFile;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  String? verificationId; // Store verification ID

  void listenToUserBaxiDetails(
      Function(String birthday, String bdTime) callback) {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      print("User is not logged in.");
      return;
    }

    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .snapshots()
        .listen((userDoc) {
      if (userDoc.exists) {
        final data = userDoc.data();
        final birthday = data?['birthday'] as String? ?? 'Unknown';
        final bdTime = data?['bdTime'] as String? ?? 'Unknown';

        // Notify listener
        callback(birthday, bdTime);
      } else {
        print("User data does not exist.");
      }
    });
  }

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
      return userCredential.user;
    } catch (e) {
      Get.snackbar("Error", "Google login failed. Please try again.");
      print("Google sign-in error: $e");
      return null;
    }
  }

  Future<Map<String, String>> fetchUserBirthdayAndTime() async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        throw Exception("User is not logged in.");
      }

      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        final data = userDoc.data();
        return {
          'birthday': data?['birthday'] as String? ?? '',
          'bdTime': data?['bdTime'] as String? ?? '',
          'sex': data?['sex'] as String? ?? '',
        };
      } else {
        throw Exception("User data does not exist.");
      }
    } catch (e) {
      print("Error fetching user birthday and time: $e");
      return {'birthday': '', 'bdTime': ''};
    }
  }

  pickImageFileFromGallery() async {
    imageFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (imageFile != null) {
      Get.snackbar(
        "Profile Image",
        "You have successfully picked your profile image.",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        borderRadius: 12,
        margin: const EdgeInsets.all(10),
        icon: const Icon(Icons.check_circle, color: Colors.white),
        duration: const Duration(seconds: 3),
        isDismissible: true,
        forwardAnimationCurve: Curves.easeInOut,
      );
    }
    pickedFile = Rx<File?>(File(imageFile!.path));
  }

  captureImageromPhoneCamera() async {
    imageFile = await ImagePicker().pickImage(source: ImageSource.camera);

    if (imageFile != null) {
      Get.snackbar(
          "Profile Image", "You have successfully picked your profile image.");
    }
    pickedFile = Rx<File?>(File(imageFile!.path));
  }
// original version

  Future<String> uploadImageToStorage(File imageFile) async {
    Reference referenceStorage = FirebaseStorage.instance
        .ref()
        .child("Profile Images")
        .child(FirebaseAuth.instance.currentUser!.uid);

    UploadTask task = referenceStorage.putFile(imageFile);
    TaskSnapshot snapshot = await task;

    String downloadUrlImage = await snapshot.ref.getDownloadURL();

    return downloadUrlImage;
  }

  // creatNewUserAccount(
  //   File imageProfile,
  //   String email,
  //   String password,
  //   String name,
  //   List<String> interests,
  //   List<String> imageUrls,
  //   String sex,
  //   String bdTime,
  //   String birthday,
  //   String sure,
  //   int age,
  //   List<String> selectedoccu,
  //   List<String> selectmbti,
  // ) async {
  //   try {
  //     // is this code being used? Yes, it need for usercreation
  //     UserCredential credential = await FirebaseAuth.instance
  //         .createUserWithEmailAndPassword(email: email, password: password);

  //     //changed String to String? but original was String, to fit a new version of uploadImageToStorage
  //     String urlOfDownloadImage = await uploadImageToStorage(imageProfile);
  //     personModel.Person personInstance = personModel.Person(
  //         uid: FirebaseAuth.instance.currentUser!.uid,
  //         imageProfile: urlOfDownloadImage,
  //         email: email,
  //         password: password,
  //         name: name,
  //         interests: interests,
  //         imageUrls: imageUrls,
  //         sex: sex,
  //         bdTime: bdTime,
  //         birthday: birthday,
  //         sure: sure,
  //         age: age,
  //         occupation: selectedoccu,
  //         mbti: selectmbti);

  //     await FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(FirebaseAuth.instance.currentUser!.uid)
  //         .set(personInstance.toJson());
  //   } catch (errorMsg) {
  //     Get.snackbar("title", ":$errorMsg");
  //   }
  // }

  Future<void> creatNewUserAccount(
    String email,
    String password,
    String name,
    List<String> interests,
    List<String> imageUrls,
    String sex,
    String bdTime,
    String birthday,
    String sure,
    String age,
    List<String> selectedoccu,
    List<String> selectmbti,
    List<String> language,
    List<String> religion,
    List<String> education,
    List<String> bloodtype,
    List<String> lookingfor,
    List<String> exercise,
    List<String> selectdiet,
  ) async {
    try {
      // Attempt to create a new user
      UserCredential credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      // Upload the profile image
      // String urlOfDownloadImage = await uploadImageToStorage(imageProfile);

      // Create a Person object
      personModel.Person personInstance = personModel.Person(
        uid: FirebaseAuth.instance.currentUser!.uid,
        email: email,
        password: password,
        name: name,
        interests: interests,
        imageUrls: imageUrls,
        sex: sex,
        bdTime: bdTime,
        birthday: birthday,
        sure: sure,
        age: age,
        occupation: selectedoccu,
        mbti: selectmbti,
        language: language,
        religion: religion,
        education: education,
        bloodtype: bloodtype,
        lookingfor: lookingfor,
        exercise: exercise,
        diet: selectdiet,
      );

      // Save the user data to Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set(personInstance.toJson());

      // Success message (optional)
      Get.snackbar(
        "Success",
        "User account created successfully!",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        borderRadius: 12,
        margin: const EdgeInsets.all(10),
        icon: const Icon(Icons.check_circle, color: Colors.white),
        duration: const Duration(seconds: 3),
        isDismissible: true,
        forwardAnimationCurve: Curves.easeInOut,
      );
    } on FirebaseAuthException catch (e) {
      // Handle Firebase-specific errors
      String errorMessage;
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = "This email is already in use.";
          break;
        case 'invalid-email':
          errorMessage = "The email address is badly formatted.";
          break;
        case 'weak-password':
          errorMessage = "The password is too weak.";
          break;
        default:
          errorMessage =
              "An error occurred: ${e.message} authentication controller";
      }
      Get.snackbar(
        "Error authentication controller",
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
        titleText: const Text(
          "Error authentication controller",
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
        ),
        messageText: const Text(
          "Email already registered authentication controller",
          style: TextStyle(color: Colors.red),
        ),
      );
    } on FirebaseException catch (e) {
      // Handle Firestore or Storage errors
      Get.snackbar(
        "Error",
        "Firebase error: ${e.message} authentication controller",
      );
    } catch (e) {
      // Handle unexpected errors
      Get.snackbar("Error",
          "An unexpected error occurred: $e authentication controller");
    }
  }

  Future<void> loginUser(String emailUser, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: emailUser, password: password);

      // If login is successful, navigate to HomeScreen
      if (userCredential.user != null) {
        Get.to(() => HomeScreen());
      }
    } catch (error) {
      // Show an error message if login fails
      Get.snackbar("Login Unsuccessful", "Error Occurred: ${error.toString()}");
    }
  }

  checkIfUserIsLoggedIn(User? currentUser) {
    if (currentUser != null) {
      // If the user is logged in, navigate to HomeScreen
      // Get.offAll(HomeScreen());
      Get.offAll(() => HomeScreen());
    } else {
      // If no user is logged in, navigate to LoginScreen
      // Get.offAll(LoginScreen());
      Get.offAll(() => LoginScreen());
    }
  }

  @override
  void onReady() {
    super.onReady();

    // Listen for auth state changes and update firebaseCurrentUser
    firebaseCurrentUser.bindStream(FirebaseAuth.instance.authStateChanges());

    // Set up a listener that reacts to auth state changes
    ever(firebaseCurrentUser, (user) {
      // Cast user to User?
      final currentUser = user as User?;

      // Check if the user is logged in and print the result
      if (currentUser != null) {
        print("User is already logged in: ${currentUser.email}");
      } else {
        print("No user is logged in");
      }

      // Call your method to handle screen changes, etc.
      checkIfUserIsLoggedIn(currentUser);
    });
  }
}


// import 'dart:io';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:redline/authenticationScreen/login_screen.dart';
// import 'package:redline/homeScreen/home_screen.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:get/get.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:redline/models/person.dart' as personModel;

// class Authenticationcontroller extends GetxController {
//   static Authenticationcontroller authenticationcontroller = Get.find();

//   Rx<User?> firebaseCurrentUser = Rx<User?>(null);
//   late Rx<File?> pickedFile = Rx<File?>(null);
//   File? get profileImage => pickedFile.value;
//   XFile? imageFile;
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final GoogleSignIn _googleSignIn = GoogleSignIn();
//   String? verificationId; // Store verification ID
//   Future<User?> loginWithGoogle() async {
//     try {
//       // Trigger the Google Sign-In flow
//       final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
//       if (googleUser == null) {
//         return null; // If the user cancels the login
//       }

//       // Obtain the Google auth details
//       final GoogleSignInAuthentication googleAuth =
//           await googleUser.authentication;

//       // Create a new credential
//       final OAuthCredential credential = GoogleAuthProvider.credential(
//         accessToken: googleAuth.accessToken,
//         idToken: googleAuth.idToken,
//       );

//       // Sign in to Firebase with the Google credentials
//       UserCredential userCredential =
//           await _auth.signInWithCredential(credential);
//       return userCredential.user;
//     } catch (e) {
//       Get.snackbar("Error", "Google login failed. Please try again.");
//       print("Google sign-in error: $e");
//       return null;
//     }
//   }

//   pickImageFileFromGallery() async {
//     imageFile = await ImagePicker().pickImage(source: ImageSource.gallery);

//     if (imageFile != null) {
//       Get.snackbar(
//           "Profile Image", "You have successfully picked your profile image.");
//     }
//     pickedFile = Rx<File?>(File(imageFile!.path));
//   }

//   captureImageromPhoneCamera() async {
//     imageFile = await ImagePicker().pickImage(source: ImageSource.camera);

//     if (imageFile != null) {
//       Get.snackbar(
//           "Profile Image", "You have successfully picked your profile image.");
//     }
//     pickedFile = Rx<File?>(File(imageFile!.path));
//   }
// // original version

//   Future<String> uploadImageToStorage(File imageFile) async {
//     Reference referenceStorage = FirebaseStorage.instance
//         .ref()
//         .child("Profile Images")
//         .child(FirebaseAuth.instance.currentUser!.uid);

//     UploadTask task = referenceStorage.putFile(imageFile);
//     TaskSnapshot snapshot = await task;

//     String downloadUrlImage = await snapshot.ref.getDownloadURL();

//     return downloadUrlImage;
//   }

//   creatNewUserAccount(
//     File imageProfile,
//     String email,
//     String password,
//     String name,
//     List<String> interests,
//     List<String> imageUrls,
//   ) async {
//     try {
//       // is this code being used? Yes, it need for usercreation
//       UserCredential credential = await FirebaseAuth.instance
//           .createUserWithEmailAndPassword(email: email, password: password);

//       //changed String to String? but original was String, to fit a new version of uploadImageToStorage
//       String urlOfDownloadImage = await uploadImageToStorage(imageProfile);
//       personModel.Person personInstance = personModel.Person(
//         uid: FirebaseAuth.instance.currentUser!.uid,
//         imageProfile: urlOfDownloadImage,
//         email: email,
//         password: password,
//         name: name,
//         interests: interests,
//         imageUrls: imageUrls,
//       );

//       await FirebaseFirestore.instance
//           .collection('users')
//           .doc(FirebaseAuth.instance.currentUser!.uid)
//           .set(personInstance.toJson());
//     } catch (errorMsg) {
//       Get.snackbar("title", ":$errorMsg");
//     }
//   }

//   loginUser(String emailUser, String password) async {
//     try {
//       // Attempt to sign in with the provided email and password
//       UserCredential userCredential = await FirebaseAuth.instance
//           .signInWithEmailAndPassword(email: emailUser, password: password);

//       // If login is successful, navigate to HomeScreen
//       if (userCredential.user != null) {
//         Get.to(HomeScreen());
//       }
//     } catch (errorMsg) {
//       // Show an error message if login fails
//       Get.snackbar(
//           "Login Unsuccessful", "Error Occurred: ${errorMsg.toString()}");
//     }
//   }

//   checkIfUserIsLoggedIn(User? currentUser) {
//     if (currentUser != null) {
//       // If the user is logged in, navigate to HomeScreen
//       // Get.offAll(HomeScreen());
//       Get.offAll(() => HomeScreen());
//     } else {
//       // If no user is logged in, navigate to LoginScreen
//       // Get.offAll(LoginScreen());
//       Get.offAll(() => LoginScreen());
//     }
//   }

//   @override
//   void onReady() {
//     super.onReady();

//     // Listen for auth state changes and update firebaseCurrentUser
//     firebaseCurrentUser.bindStream(FirebaseAuth.instance.authStateChanges());

//     // Set up a listener that reacts to auth state changes
//     ever(firebaseCurrentUser, (user) {
//       // Cast user to User?
//       final currentUser = user as User?;

//       // Check if the user is logged in and print the result
//       if (currentUser != null) {
//         print("User is already logged in: ${currentUser.email}");
//       } else {
//         print("No user is logged in");
//       }

//       // Call your method to handle screen changes, etc.
//       checkIfUserIsLoggedIn(currentUser);
//     });
//   }
// }
