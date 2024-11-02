// import 'dart:io';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:redline/global.dart';

// class AccountSettingsScreen extends StatefulWidget {
//   const AccountSettingsScreen({super.key});

//   @override
//   State<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
// }

// class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
//   bool uploading = false;
//   double val = 8;
//   final List<File> _image = [];
//   List<String> urlsList = [];
//   final List<File?> _images =
//       List<File?>.filled(6, null); // List to hold images

//   // Personal info
//   TextEditingController emailTextEditingController = TextEditingController();
//   TextEditingController nameTextEditingController = TextEditingController();
//   TextEditingController passwordTextEditingController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     retrieveUserData();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           "Account Settings",
//           style: TextStyle(color: Colors.white, fontSize: 22),
//         ),
//         actions: [
//           if (_image.isNotEmpty && !uploading)
//             IconButton(
//               onPressed: () {
//                 _showUploadDialog();
//                 uploadImage().then((_) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(
//                         content: Text("Images uploaded successfully!")),
//                   );
//                 });
//               },
//               icon: const Icon(Icons.upload_file, size: 36),
//             ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         // Wrap everything in a ScrollView
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Column(
//             children: [
//               // Image Picker Section
//               _buildImagePicker(),
//               const SizedBox(
//                   height: 20), // Space between image picker and text fields
//               // Display text fields
//               _buildTextField(nameTextEditingController, "Name"),
//               _buildTextField(emailTextEditingController, "Email"),
//               _buildTextField(passwordTextEditingController, "Password"),
//               const SizedBox(height: 20), // Space before the save button
//               ElevatedButton(
//                 onPressed: () {
//                   saveProfileData();
//                 },
//                 child: const Text("Save"),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildImagePicker() {
//     return GridView.builder(
//       shrinkWrap: true, // Allow the grid to take the height of the items
//       physics: const NeverScrollableScrollPhysics(), // Disable scrolling
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 3, // Show 3 images per row
//         childAspectRatio: 1, // Make each item square
//       ),
//       itemCount: _images.length,
//       itemBuilder: (context, index) {
//         return GestureDetector(
//           onTap: () => _chooseImage(index),
//           child: Container(
//             margin: const EdgeInsets.all(5),
//             decoration: BoxDecoration(
//               border: Border.all(color: Colors.grey),
//               borderRadius: BorderRadius.circular(8),
//               image: _images[index] != null
//                   ? DecorationImage(
//                       image: FileImage(_images[index]!),
//                       fit: BoxFit.cover,
//                     )
//                   : null,
//             ),
//             child: _images[index] == null
//                 ? const Center(
//                     child: Icon(
//                       Icons.help,
//                       size: 40,
//                       color: Colors.grey,
//                     ),
//                   )
//                 : null, // Show the image instead of icon if selected
//           ),
//         );
//       },
//     );
//   }

//   _chooseImage(int index) async {
//     XFile? pickedFile =
//         await ImagePicker().pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       setState(() {
//         _images[index] = File(pickedFile.path);
//       });
//     }
//   }

//   Widget _buildTextField(TextEditingController controller, String label) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: TextField(
//         controller: controller,
//         decoration: InputDecoration(
//           labelText: label,
//           border: OutlineInputBorder(),
//         ),
//       ),
//     );
//   }

//   chooseImage() async {
//     XFile? pickedFile =
//         await ImagePicker().pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       setState(() {
//         _image.add(File(pickedFile.path));
//       });
//     }
//   }

//   uploadImage() async {
//     int i = 1;
//     for (var img in _image) {
//       setState(() {
//         val = i / _image.length;
//       });
//       var refImages = FirebaseStorage.instance
//           .ref()
//           .child("images/${DateTime.now().millisecondsSinceEpoch}.jpg");

//       await refImages.putFile(img).whenComplete(() async {
//         await refImages.getDownloadURL().then((urlImage) {
//           urlsList.add(urlImage);
//         });
//       });
//       i++;
//     }
//   }

//   _showUploadDialog() {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: const [
//               CircularProgressIndicator(),
//               SizedBox(height: 20),
//               Text("Uploading..."),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   retrieveUserData() async {
//     await FirebaseFirestore.instance
//         .collection("users")
//         .doc(currentUserID) // Assuming currentUserID is defined
//         .get()
//         .then((snapshot) {
//       if (snapshot.exists) {
//         setState(() {
//           emailTextEditingController.text = snapshot.data()?["email"] ?? "";
//           nameTextEditingController.text = snapshot.data()?["name"] ?? "";
//         });
//       }
//     });
//   }

//   saveProfileData() {
//     // Logic to save updated profile data to Firestore
//     FirebaseFirestore.instance.collection("users").doc(currentUserID).update({
//       "email": emailTextEditingController.text,
//       "name": nameTextEditingController.text,
//       "password": passwordTextEditingController.text,
//     }).then((_) {
//       ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Profile updated successfully!")));
//     }).catchError((error) {
//       print("Error updating profile: $error");
//       ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Failed to update profile.")));
//     });
//   }
// }

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:redline/global.dart';

class AccountSettingsScreen extends StatefulWidget {
  const AccountSettingsScreen({super.key});

  @override
  State<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  bool uploading = false;
  double val = 0;
  final List<File?> _images =
      List<File?>.filled(6, null); // List to hold images
  List<String> urlsList =
      List<String>.filled(6, ""); // Store URLs for each image

  // Personal info
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    retrieveUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Account Settings",
          style: TextStyle(color: Colors.white, fontSize: 22),
        ),
        actions: [
          if (_images.any((image) => image != null) && !uploading)
            IconButton(
              onPressed: () {
                _showUploadDialog();
                uploadImages().then((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("Images uploaded successfully!")),
                  );
                });
              },
              icon: const Icon(Icons.upload_file, size: 36),
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              _buildImagePicker(),
              const SizedBox(height: 20),
              _buildTextField(nameTextEditingController, "Name"),
              _buildTextField(emailTextEditingController, "Email"),
              _buildTextField(passwordTextEditingController, "Password"),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: saveProfileData,
                child: const Text("Save"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1,
      ),
      itemCount: _images.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => _chooseImage(index),
          child: Container(
            margin: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
              image: _images[index] != null
                  ? DecorationImage(
                      image: FileImage(_images[index]!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: _images[index] == null
                ? const Center(
                    child: Icon(
                      Icons.add_photo_alternate,
                      size: 40,
                      color: Colors.grey,
                    ),
                  )
                : null,
          ),
        );
      },
    );
  }

  _chooseImage(int index) async {
    XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _images[index] = File(pickedFile.path);
      });
    }
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  uploadImages() async {
    setState(() {
      uploading = true;
      val = 0;
    });

    int uploadedCount = 0;

    for (int i = 0; i < _images.length; i++) {
      if (_images[i] != null) {
        // Update progress
        setState(() {
          val = (uploadedCount + 1) / _images.length;
        });

        var ref = FirebaseStorage.instance
            .ref()
            .child("images/${DateTime.now().millisecondsSinceEpoch}_$i.jpg");

        await ref.putFile(_images[i]!).whenComplete(() async {
          String downloadUrl = await ref.getDownloadURL();
          urlsList[i] = downloadUrl;
        });

        uploadedCount++;
      }
    }

    setState(() {
      uploading = false;
    });

    Navigator.pop(context, true);
  }

  _showUploadDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(value: val),
              const SizedBox(height: 20),
              Text("Uploading... ${((val) * 100).toStringAsFixed(0)}%"),
            ],
          ),
        );
      },
    );
  }

  retrieveUserData() async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(currentUserID) // Assuming currentUserID is defined
        .get()
        .then((snapshot) {
      if (snapshot.exists) {
        setState(() {
          emailTextEditingController.text = snapshot.data()?["email"] ?? "";
          nameTextEditingController.text = snapshot.data()?["name"] ?? "";
        });
      }
    });
  }

  // saveProfileData() async {
  //   setState(() {
  //     uploading = true;
  //     val = 0;
  //   });

  //   // Retrieve and delete previous images
  //   final userDoc =
  //       FirebaseFirestore.instance.collection("users").doc(currentUserID);
  //   final docSnapshot = await userDoc.get();

  //   if (docSnapshot.exists) {
  //     List<String> previousUrls =
  //         List<String>.from(docSnapshot.data()?["imageUrls"] ?? []);

  //     for (String url in previousUrls) {
  //       try {
  //         // Get the reference from the URL
  //         await FirebaseStorage.instance.refFromURL(url).delete();
  //       } catch (e) {
  //         print("Error deleting previous image: $e");
  //       }
  //     }
  //   }

  //   // Upload new images and collect URLs
  //   int uploadedCount = 0;
  //   urlsList = List<String>.filled(_images.length, ""); // Reset urlsList

  //   for (int i = 0; i < _images.length; i++) {
  //     if (_images[i] != null) {
  //       setState(() {
  //         val = (uploadedCount + 1) / _images.length;
  //       });

  //       var ref = FirebaseStorage.instance
  //           .ref()
  //           .child("images/${DateTime.now().millisecondsSinceEpoch}_$i.jpg");

  //       await ref.putFile(_images[i]!).whenComplete(() async {
  //         String downloadUrl = await ref.getDownloadURL();
  //         urlsList[i] = downloadUrl; // Save each new image URL
  //       });

  //       uploadedCount++;
  //     }
  //   }

  //   setState(() {
  //     uploading = false;
  //   });

  //   // Remove empty entries from urlsList before saving to Firestore
  //   urlsList = urlsList.where((url) => url.isNotEmpty).toList();

  //   // Save profile data to Firestore, including new image URLs
  //   userDoc.update({
  //     "email": emailTextEditingController.text,
  //     "name": nameTextEditingController.text,
  //     "password": passwordTextEditingController.text,
  //     "imageUrls": urlsList, // Store new image URLs in Firestore
  //   }).then((_) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text("Profile updated successfully!")),
  //     );
  //   }).catchError((error) {
  //     print("Error updating profile: $error");
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text("Failed to update profile.")),
  //     );
  //   });
  // }
  saveProfileData() async {
    setState(() {
      uploading = true;
      val = 0;
    });

    // Retrieve and delete previous images
    final userDoc =
        FirebaseFirestore.instance.collection("users").doc(currentUserID);
    final docSnapshot = await userDoc.get();

    if (docSnapshot.exists) {
      List<String> previousUrls =
          List<String>.from(docSnapshot.data()?["imageUrls"] ?? []);

      for (String url in previousUrls) {
        try {
          // Get the reference from the URL
          await FirebaseStorage.instance.refFromURL(url).delete();
        } catch (e) {
          print("Error deleting previous image: $e");
        }
      }
    }

    // Upload new images and collect URLs
    urlsList = []; // Start with an empty list

    for (int i = 0; i < _images.length; i++) {
      if (_images[i] != null) {
        setState(() {
          val = (i + 1) / _images.length;
        });

        var ref = FirebaseStorage.instance
            .ref()
            .child("images/${DateTime.now().millisecondsSinceEpoch}_$i.jpg");

        await ref.putFile(_images[i]!).whenComplete(() async {
          String downloadUrl = await ref.getDownloadURL();
          urlsList.add(downloadUrl); // Add each new image URL directly
        });
      }
    }

    setState(() {
      uploading = false;
    });

    // Save profile data to Firestore, including new image URLs
    userDoc.update({
      "email": emailTextEditingController.text,
      "name": nameTextEditingController.text,
      "password": passwordTextEditingController.text,
      "imageUrls": urlsList, // Store only the new image URLs in Firestore
    }).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile updated successfully!")),
      );
    }).catchError((error) {
      print("Error updating profile: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to update profile.")),
      );
    });
  }
}
