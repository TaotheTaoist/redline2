// import 'package:datingapp/authenticationScreen/login_screen.dart';
// import 'package:datingapp/controller/authenticationController.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'firebase_options.dart';

// void main() async {
//   // Ensures that widget binding is initialized
//   WidgetsFlutterBinding.ensureInitialized();

//   // Initialize Firebase
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );

//   // Put your AuthenticationController into the GetX controller hierarchy
//   Get.put(Authenticationcontroller());

//   // Start the Flutter app
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       title: 'Dating app',
//       theme: ThemeData.dark().copyWith(
//         scaffoldBackgroundColor: Colors.black,
//       ),
//       home: const LoginScreen(),
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }
import 'package:get_storage/get_storage.dart';
import 'package:redline/authenticationScreen/login_screen.dart';
import 'package:redline/controller/authenticationController.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'firebase_options.dart';

void main() async {
  // Ensures that widget binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Put your AuthenticationController into the GetX controller hierarchy
  Get.put(Authenticationcontroller());

  await GetStorage.init();

  // Start the Flutter app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Dating App',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color.fromARGB(255, 255, 177, 177),
      ),
      home:
          const LoginScreen(), // Make sure this screen is correctly implemented
      debugShowCheckedModeBanner: false,
    );
  }
}
