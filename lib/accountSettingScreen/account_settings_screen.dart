import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:redline/global.dart';
import 'package:redline/widgets/custom_text_field_widget.dart';

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
  TextEditingController BDController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController sexController = TextEditingController();

  String sex = "Male";
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
              const SizedBox(height: 20),
              _buildImagePicker(),
              ElevatedButton(
                onPressed: saveProfileImage,
                child: const Text("Save Image"),
              ),
              const SizedBox(height: 20),
              _buildTextField(nameTextEditingController, "Name"),
              _buildTextField(emailTextEditingController, "Email"),
              _buildTextField(passwordTextEditingController, "Password"),
              _buildbdField(context, BDController, "Birthday"),
              _buildTimeTextField(
                context,
                timeController,
                "Select Time",
              ),
              _buildSwitchField(
                sexController, // TextEditingController for sex
                "Sex",
                sex, // String value ("Male" or "Female")
                (bool newValue) {
                  setState(() {
                    sex = newValue ? "Male" : "Female"; // Update the sex value
                  });
                },
              ),
              SizedBox(height: 20),
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

  Widget _buildSwitchField(TextEditingController controller, String label,
      String value, Function(bool) onChanged) {
    // Convert the String value to a bool (true for "Male", false for "Female")
    bool isMale = value == "Male";

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Switch(
            value: isMale, // use bool value for switch state
            onChanged: (bool newValue) {
              // Update the boolean value and the controller text
              onChanged(newValue);
              sexController.text = newValue ? "Male" : "Female";
            },
          ),
        ],
      ),
    );
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

  Widget _buildbdField(BuildContext context,
      TextEditingController dateController, String label) {
    return GestureDetector(
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900), // Earliest selectable date
          lastDate: DateTime(2100), // Latest selectable date
        );
        if (pickedDate != null) {
          // Format the selected date and update the controller
          final String formattedDate =
              "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
          dateController.text = formattedDate;
        }
      },
      child: AbsorbPointer(
        child: CustomTextFieldWidget(
          editingController: dateController,
          labelText: label,
          iconData: Icons.calendar_today,
          borderRadius: 20.0, // Adjust as needed
        ),
      ),
    );
  }

  Widget _buildTimeTextField(BuildContext context,
      TextEditingController timeController, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: GestureDetector(
        onTap: () async {
          TimeOfDay? pickedTime = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.now(),
            builder: (context, child) {
              return MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(alwaysUse24HourFormat: true),
                child: child!,
              );
            },
          );
          if (pickedTime != null) {
            // Format the selected time in 24-hour format and update the controller
            final String formattedTime =
                pickedTime.hour.toString().padLeft(2, '0') +
                    ":" +
                    pickedTime.minute.toString().padLeft(2, '0');
            timeController.text = formattedTime;
          }
        },
        child: AbsorbPointer(
          child: TextField(
            controller: timeController,
            decoration: InputDecoration(
              labelText: label,
              border: OutlineInputBorder(),
              suffixIcon: const Icon(Icons.access_time),
            ),
          ),
        ),
      ),
    );
  }

  // Widget _buildTimeTextField(BuildContext context,
  //     TextEditingController timeController, String label) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 8.0),
  //     child: GestureDetector(
  //       onTap: () async {
  //         TimeOfDay? pickedTime = await showTimePicker(
  //           context: context,
  //           initialTime: TimeOfDay.now(),
  //         );
  //         if (pickedTime != null) {
  //           // Format the selected time and update the controller
  //           final String formattedTime = pickedTime.format(context);
  //           timeController.text = formattedTime;
  //         }
  //       },
  //       child: AbsorbPointer(
  //         child: TextField(
  //           controller: timeController,
  //           decoration: InputDecoration(
  //             labelText: label,
  //             border: OutlineInputBorder(),
  //             suffixIcon: const Icon(Icons.access_time),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

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

  // _showUploadDialog() {
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       double val = 0.0; // This will hold the current progress

  //       // Simulate the progress from 0 to 100% over 2 seconds
  //       Future.delayed(Duration(milliseconds: 500), () {
  //         // Update the progress incrementally
  //         Timer.periodic(Duration(milliseconds: 100), (timer) {
  //           if (val < 1.0) {
  //             val += 0.05; // Increment the progress
  //             setState(() {});
  //           } else {
  //             timer.cancel(); // Stop the timer once it reaches 100%
  //             Navigator.of(context)
  //                 .pop(); // Close the dialog after the progress completes
  //           }
  //         });
  //       });

  //       return StatefulBuilder(
  //         builder: (context, setState) {
  //           return AlertDialog(
  //             content: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 CircularProgressIndicator(value: val),
  //                 const SizedBox(height: 20),
  //                 Text("Uploading... ${(val * 100).toStringAsFixed(0)}%"),
  //               ],
  //             ),
  //           );
  //         },
  //       );
  //     },
  //   );
  // }

  // Future<void> saveProfileData() async {
  //   try {
  //     // Show the upload dialog
  //     _showUploadDialog();
  //     await Future.delayed(Duration(seconds: 2));
  //     // Prepare the data to be updated
  //     Map<String, dynamic> updateData = {};

  //     if (emailTextEditingController.text.isNotEmpty) {
  //       updateData["email"] = emailTextEditingController.text;
  //     }

  //     if (nameTextEditingController.text.isNotEmpty) {
  //       updateData["name"] = nameTextEditingController.text;
  //     }

  //     if (passwordTextEditingController.text.isNotEmpty) {
  //       updateData["password"] = passwordTextEditingController.text;
  //     }

  //     if (timeController.text.isNotEmpty) {
  //       updateData["bdTime"] = timeController.text;
  //     }

  //     if (BDController.text.isNotEmpty) {
  //       updateData["birthday"] = BDController.text;
  //     }

  //     // Proceed only if there's any data to update
  //     if (updateData.isNotEmpty) {
  //       final userDoc =
  //           FirebaseFirestore.instance.collection("users").doc(currentUserID);
  //       await userDoc.update(updateData);

  //       // Close the dialog after successful operation
  //       // Navigator.of(context).pop();

  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text("Profile fields updated successfully!")),
  //       );
  //     } else {
  //       // If no fields are provided, you can show a message or skip the operation
  //       // Navigator.of(context).pop();
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text("No fields to update.")),
  //       );
  //     }
  //   } catch (error) {
  //     // Close the dialog in case of error
  //     // Navigator.of(context).pop();

  //     print("Error updating fields: $error");
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text("Failed to update profile fields.")),
  //     );
  //   }
  // }
  // void _showUploadDialog() {
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       double val = 0.0; // Progress value

  //       // Start the timer to simulate the progress from 0 to 100%
  //       Timer.periodic(Duration(milliseconds: 100), (timer) {
  //         if (val < 1.0) {
  //           val += 0.05; // Increment progress by 5%
  //           setState(() {}); // Trigger a rebuild to update the progress
  //         } else {
  //           timer.cancel(); // Stop the timer once progress reaches 100%
  //           Navigator.of(context).pop(); // Close the dialog when done
  //         }
  //       });

  //       return StatefulBuilder(
  //         builder: (context, setState) {
  //           return AlertDialog(
  //             content: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 CircularProgressIndicator(value: val),
  //                 const SizedBox(height: 20),
  //                 Text("Uploading... ${(val * 100).toStringAsFixed(0)}%"),
  //               ],
  //             ),
  //           );
  //         },
  //       );
  //     },
  //   );
  // }
  // _showUploadDialog() {
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       // Declare val inside the builder so it can be updated
  //       double val = 0.0;

  //       // Use StatefulBuilder to trigger updates to the dialog UI
  //       return StatefulBuilder(
  //         builder: (context, setState) {
  //           // Simulate the progress from 0 to 100% over 2 seconds
  //           Future.delayed(Duration(milliseconds: 500), () {
  //             // Update the progress incrementally
  //             Timer.periodic(Duration(milliseconds: 100), (timer) {
  //               if (val < 1.0) {
  //                 val += 0.05; // Increment the progress
  //                 setState(() {}); // Trigger UI update
  //               } else {
  //                 timer.cancel(); // Stop the timer once it reaches 100%
  //                 // Navigator.of(context)
  //                 //     .pop(); // Close the dialog after the progress completes
  //               }
  //             });
  //           });

  //           return AlertDialog(
  //             content: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 CircularProgressIndicator(value: val),
  //                 const SizedBox(height: 20),
  //                 Text("Uploading... ${(val * 100).toStringAsFixed(0)}%"),
  //               ],
  //             ),
  //           );
  //         },
  //       );
  //     },
  //   );
  // }
  void _showUploadDialog() async {
    // Show the dialog
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(), // Indeterminate progress
              const SizedBox(height: 20),
              Text("Uploading... Please wait"),
            ],
          ),
        );
      },
    );

    // Simulate upload process
    await Future.delayed(Duration(seconds: 2));

    // Close the dialog after upload is complete
    if (context.mounted) {
      Navigator.of(context).pop();
    }
  }

  // void _showUploadDialog() {
  //   double val = 0.0; // Progress value

  //   // Show the dialog and start the progress
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       // Use StatefulBuilder to trigger updates to the dialog UI
  //       return StatefulBuilder(
  //         builder: (context, setState) {
  //           // Start the progress increment
  //           Future.delayed(Duration(milliseconds: 500), () {
  //             // Use Timer to increment progress every 100ms
  //             Timer.periodic(Duration(milliseconds: 100), (timer) {
  //               if (val < 1.0) {
  //                 val += 0.05; // Increment progress by 5% every 100ms
  //                 setState(() {}); // Trigger a rebuild to update the progress
  //               } else {
  //                 timer.cancel(); // Stop the timer once 100% is reached
  //                 // Close the dialog after progress is complete
  //                 if (context.mounted) {
  //                   Navigator.of(context).pop();
  //                 }
  //               }
  //             });
  //           });

  //           return AlertDialog(
  //             content: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 CircularProgressIndicator(value: val),
  //                 const SizedBox(height: 20),
  //                 Text("Uploading... ${(val * 100).toStringAsFixed(0)}%"),
  //               ],
  //             ),
  //           );
  //         },
  //       );
  //     },
  //   );
  // }

  Future<void> saveProfileData() async {
    try {
      // Show the upload dialog

      _showUploadDialog();

      // Simulate the upload process
      await Future.delayed(Duration(seconds: 2));

      // Prepare the data to be updated
      Map<String, dynamic> updateData = {};

      if (emailTextEditingController.text.isNotEmpty) {
        updateData["email"] = emailTextEditingController.text;
      }

      if (nameTextEditingController.text.isNotEmpty) {
        updateData["name"] = nameTextEditingController.text;
      }

      if (passwordTextEditingController.text.isNotEmpty) {
        updateData["password"] = passwordTextEditingController.text;
      }

      if (timeController.text.isNotEmpty) {
        updateData["bdTime"] = timeController.text;
        updateData["sure"] = "sure";
      }

      if (BDController.text.isNotEmpty) {
        updateData["birthday"] = BDController.text;
      }

      if (sexController.text.isNotEmpty) {
        updateData["sex"] = sexController.text;
      }

      // Proceed only if there's any data to update
      if (updateData.isNotEmpty) {
        final userDoc =
            FirebaseFirestore.instance.collection("users").doc(currentUserID);
        await userDoc.update(updateData);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profile fields updated successfully!")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No fields to update.")),
        );
      }
    } catch (error) {
      print("Error updating fields: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to update profile fields.")),
      );
    }
  }

  Future<void> saveProfileImage() async {
    setState(() {
      uploading = true;
      val = 0;
    });
    _showUploadDialog();
    // Show loading dialog

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

    // Close loading dialog
    Navigator.of(context).pop(); // This will dismiss the loading dialog

    setState(() {
      // _showUploadDialog();
      uploading = false;
    });

    // Save profile data to Firestore, including new image URLs
    userDoc.update({
      // "email": emailTextEditingController.text,
      // "name": nameTextEditingController.text,
      // "password": passwordTextEditingController.text,
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

  // Future<void> saveProfileData() async {
  //   setState(() {
  //     uploading = true;
  //     val = 0;
  //   });

  //   // Show loading dialog

  //   // Retrieve and delete previous images
  //   final userDoc =
  //       FirebaseFirestore.instance.collection("users").doc(currentUserID);
  //   // final docSnapshot = await userDoc.get();

  //   // if (docSnapshot.exists) {
  //   //   List<String> previousUrls =
  //   //       List<String>.from(docSnapshot.data()?["imageUrls"] ?? []);

  //   //   for (String url in previousUrls) {
  //   //     try {
  //   //       // Get the reference from the URL
  //   //       await FirebaseStorage.instance.refFromURL(url).delete();
  //   //     } catch (e) {
  //   //       print("Error deleting previous image: $e");
  //   //     }
  //   //   }
  //   // }

  //   // // Upload new images and collect URLs
  //   // urlsList = []; // Start with an empty list

  //   // for (int i = 0; i < _images.length; i++) {
  //   //   if (_images[i] != null) {
  //   //     setState(() {
  //   //       val = (i + 1) / _images.length;
  //   //     });

  //   //     var ref = FirebaseStorage.instance
  //   //         .ref()
  //   //         .child("images/${DateTime.now().millisecondsSinceEpoch}_$i.jpg");

  //   //     await ref.putFile(_images[i]!).whenComplete(() async {
  //   //       String downloadUrl = await ref.getDownloadURL();
  //   //       urlsList.add(downloadUrl); // Add each new image URL directly
  //   //     });
  //   //   }
  //   // }

  //   // Close loading dialog
  //   Navigator.of(context).pop(); // This will dismiss the loading dialog

  //   setState(() {
  //     uploading = false;
  //   });

  //   // Save profile data to Firestore, including new image URLs
  //   userDoc.update({
  //     "email": emailTextEditingController.text,
  //     "name": nameTextEditingController.text,
  //     "password": passwordTextEditingController.text,
  //     "bdTime": timeController,
  //     // "imageUrls": urlsList, // Store only the new image URLs in Firestore
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
}
