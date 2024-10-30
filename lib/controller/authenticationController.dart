import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:redline/authenticationScreen/login_screen.dart';
import 'package:redline/controller/codeEntryScreen.dart';
import 'package:redline/homeScreen/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:redline/models/person.dart' as personModel;

class Authenticationcontroller extends GetxController {
  static Authenticationcontroller authenticationcontroller = Get.find();

  Rx<User?> firebaseCurrentUser = Rx<User?>(null);
  late Rx<File?> pickedFile = Rx<File?>(null);
  File? get profileImage => pickedFile.value;
  XFile? imageFile;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  String? verificationId; // Store verification ID
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

  pickImageFileFromGallery() async {
    imageFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (imageFile != null) {
      Get.snackbar(
          "Profile Image", "You have successfully picked your profile image.");
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

  creatNewUserAccount(
    File imageProfile,
    String email,
    String password,
    String name,
    String age,
    String photoNo,
    String city,
    String country,
    String profileHeading,
    String lookingforInaPartner,
    int publishedDateTime,
    String height,
    String
        weight, // Changed from "Weight" to "weight" to follow camelCase convention
    String bodyType,
    String drink,
    String smoke,
    String
        maritalStatus, // Corrected spelling from "martialStatus" to "maritalStatus"
    String haveChildren,
    String noChildren,
    String profession,
    String employmentStatus,
    String income,
    String livingSituation,
    String willingtoRelocate,
    String relationshipYouAreLookingFor,
    String nationality,
    String education,
    String language,
    String religion,
    String ethnicity,
  ) async {
    try {
      UserCredential credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      String urlOfDownloadImage = await uploadImageToStorage(imageProfile);
      personModel.Person personInstance = personModel.Person(
        uid: FirebaseAuth.instance.currentUser!.uid,
        imageProfile: urlOfDownloadImage,
        email: email,
        password: password,
        name: name,
        photoNo: photoNo, // Assuming `photoNo` is already available
        age: age,
        city: city,
        country: country,
        profileHeading: profileHeading,
        lookingforInaPartner: lookingforInaPartner,
        publishedDateTime:
            DateTime.now().millisecondsSinceEpoch, // Save current timestamp
        height: height,
        weight: weight,
        bodyType: bodyType,
        drink: drink,
        smoke: smoke,
        maritalStatus: maritalStatus,
        haveChildren: haveChildren,
        noChildren: noChildren,
        profession: profession,
        employmentStatus: employmentStatus,
        income: income,
        livingSituation: livingSituation,
        willingtoRelocate: willingtoRelocate,
        relationshipYouAreLookingFor: relationshipYouAreLookingFor,
        nationality: nationality,
        education: education,
        language: language,
        religion: religion,
        ethnicity: ethnicity,
      );
      // await FirebaseFirestore.instance
      //   .collection('users')
      //   .doc(credential.user!.uid)
      //   .set(personInstance.toJson());
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set(personInstance.toJson());
    } catch (errorMsg) {
      Get.snackbar("title", ":$errorMsg");
    }
  }

  loginUser(String emailUser, String password) async {
    try {
      // Attempt to sign in with the provided email and password
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: emailUser, password: password);

      // If login is successful, navigate to HomeScreen
      if (userCredential.user != null) {
        Get.to(HomeScreen());
      }
    } catch (errorMsg) {
      // Show an error message if login fails
      Get.snackbar(
          "Login Unsuccessful", "Error Occurred: ${errorMsg.toString()}");
    }
  }

  checkIfUserIsLoggedIn(User? currentUser) {
    if (currentUser != null) {
      // If the user is logged in, navigate to HomeScreen
      Get.offAll(HomeScreen());
    } else {
      // If no user is logged in, navigate to LoginScreen
      Get.offAll(LoginScreen());
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

// Helper function to handle navigation based on user auth state
}
