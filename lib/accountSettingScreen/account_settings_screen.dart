import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:redline/global.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AccountSettingsScreen extends StatefulWidget {
  const AccountSettingsScreen({super.key});

  @override
  State<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  bool uploading = false, next = false;

  final List<File> _image = [];

  List<String> urlsList = [];

  // personal info
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordlTextEditingController =
      TextEditingController();
  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController ageTextEditingController = TextEditingController();
  TextEditingController phoneNoTextEditingController = TextEditingController();
  TextEditingController cityTextEditingController = TextEditingController();
  TextEditingController countryTextEditingController = TextEditingController();
  TextEditingController profileHeadingTextEditingController =
      TextEditingController();
  TextEditingController lookingForInaPartnerTextEditingController =
      TextEditingController();

  //Appearance
  TextEditingController heightTextEditingController = TextEditingController();
  TextEditingController weighteTextEditingController = TextEditingController();
  TextEditingController bodyTypeForInaPartnerTextEditingController =
      TextEditingController();

  // LifyStyle
  TextEditingController drinkTextEditingController = TextEditingController();
  TextEditingController smokeTextEditingController = TextEditingController();
  TextEditingController martialStatusTextEditingController =
      TextEditingController();
  TextEditingController haveChildrenTextEditingController =
      TextEditingController();
  TextEditingController noOfChildrenNoTextEditingController =
      TextEditingController();
  TextEditingController employmentStatusTextEditingController =
      TextEditingController();
  TextEditingController professionTextEditingController =
      TextEditingController();
  TextEditingController incomeTextEditingController = TextEditingController();
  TextEditingController livingSituationTextEditingController =
      TextEditingController();
  TextEditingController willingtoRelocateTextEditingController =
      TextEditingController();
  TextEditingController relationshipYouAreLookingForTextEditingController =
      TextEditingController();

  // LifyStyle
  TextEditingController nationalityTextEditingController =
      TextEditingController();
  TextEditingController educationTextEditingController =
      TextEditingController();
  TextEditingController lanaguageStatusTextEditingController =
      TextEditingController();
  TextEditingController religionTextEditingController = TextEditingController();
  TextEditingController ethnicityChildrenNoTextEditingController =
      TextEditingController();

  String email = "";
  String password = "";
  String name = "";
  String age = "";
  String photoNo = "";
  String city = "";
  String country = "";
  String profileHeading = "";
  String lookingforInaPartner = "";

// appearance
  String height = "";
  String weight =
      ""; // Changed from "Weight" to "weight" to follow camelCase convention
  String bodyType = "";
  String drink = "";
  String smoke = "";
  String maritalStatus =
      ""; // Corrected spelling from "martialStatus" to "maritalStatus"
  String haveChildren = "";
  String noChildren = "";
  String profession = "";
  String employmentStatus = "";
  String income = "";
  String livingSituation = "";
  String willingtoRelocate = "";
  String relationshipYouAreLookingFor = "";

// background
  String nationality = "";
  String education = "";
  String language = "";
  String religion = "";
  String ethnicity = "";

  double val = 8;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    retrieveUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          next ? "Profile Information" : "Choose 5 Images",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
          ),
        ),
        actions: [
          next
              ? Container()
              : IconButton(
                  onPressed: () {
                    // Trigger upload when user presses next button
                    if (_image.isNotEmpty && !uploading) {
                      _showUploadDialog();
                      uploadImage().then((_) {
                        setState(() {
                          next = true;
                        });
                      });
                    }
                  },
                  icon: Icon(Icons.navigate_next_outlined, size: 36),
                ),
        ],
      ),
      body: next
          ? SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Column(),
              ),
            )
          : Stack(
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  child: GridView.builder(
                    itemCount: _image.length + 1,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                    ),
                    itemBuilder: (context, Index) {
                      return Index == 0
                          ? Container(
                              color: Colors.white30,
                              child: Center(
                                child: IconButton(
                                  onPressed: () {
                                    !uploading ? chooseImage() : null;
                                  },
                                  icon: const Icon(Icons.add),
                                ),
                              ),
                            )
                          : Container(
                              margin: const EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: FileImage(_image[Index - 1]),
                                      fit: BoxFit.cover)),
                            );
                    },
                  ),
                ),
              ],
            ),
    );
  }

  chooseImage() async {
    XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      _image.add(File(pickedFile!.path));
    });
  }

  uploadImage() async {
    int i = 1;
    for (var img in _image) {
      setState(() {
        val = i / _image.length;
      });
      var refImages = FirebaseStorage.instance.ref().child(
          "images/${DateTime.now().millisecondsSinceEpoch.toString()}.jpg");

      await refImages.putFile(img).whenComplete(() async {
        await refImages.getDownloadURL().then((urlImage) {
          urlsList.add(urlImage);
        });
      });
    }
  }

  _showUploadDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              CircularProgressIndicator(),
              SizedBox(height: 20),
              Text("Uploading. . ."),
            ],
          ),
        );
      },
    );
  }

  retrieveUserData() async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(currentUserID)
        .get()
        .then((snapshot) {
      if (snapshot.exists) {
        setState(() {
          email = snapshot.data()?["email"] ?? "";
          password = snapshot.data()?["password"] ?? "";
          name = snapshot.data()?["name"] ?? "";
          age = snapshot.data()?["age"] ?? "";
          photoNo = snapshot.data()?["photoNo"] ?? "";
          city = snapshot.data()?["city"] ?? "";
          country = snapshot.data()?["country"] ?? "";
          profileHeading = snapshot.data()?["profileHeading"] ?? "";
          lookingforInaPartner = snapshot.data()?["lookingforInaPartner"] ?? "";

// appearance
          height = snapshot.data()?["height"] ?? "";
          weight = snapshot.data()?["weight"] ??
              ""; // Changed from "Weight" to "weight"
          bodyType = snapshot.data()?["bodyType"] ?? "";
          drink = snapshot.data()?["drink"] ?? "";
          smoke = snapshot.data()?["smoke"] ?? "";
          maritalStatus =
              snapshot.data()?["maritalStatus"] ?? ""; // Corrected spelling
          haveChildren = snapshot.data()?["haveChildren"] ?? "";
          noChildren = snapshot.data()?["noChildren"] ?? "";
          profession = snapshot.data()?["profession"] ?? "";
          employmentStatus = snapshot.data()?["employmentStatus"] ?? "";
          income = snapshot.data()?["income"] ?? "";
          livingSituation = snapshot.data()?["livingSituation"] ?? "";
          willingtoRelocate = snapshot.data()?["willingtoRelocate"] ?? "";
          relationshipYouAreLookingFor =
              snapshot.data()?["relationshipYouAreLookingFor"] ?? "";

// background
          nationality = snapshot.data()?["nationality"] ?? "";
          education = snapshot.data()?["education"] ?? "";
          language = snapshot.data()?["language"] ?? "";
          religion = snapshot.data()?["religion"] ?? "";
          ethnicity = snapshot.data()?["ethnicity"] ?? "";
        });
      }
    });
  }
}
