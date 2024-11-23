import 'package:cloud_firestore/cloud_firestore.dart';

class Person {
  String? uid;
  String? imageProfile;
  String? email;
  String? password;
  String? name;
  String? photoNo;
  int? publishedDateTime;
  List<String>? interests;
  List<String>? imageUrls;
  String? sex;

  // New fields
  String? bdTime;
  String? birthday;
  String? sure;

  Person({
    this.uid,
    this.imageProfile,
    this.email,
    this.password,
    this.name,
    this.photoNo,
    this.publishedDateTime,
    this.interests,
    this.imageUrls,
    this.sex,
    this.bdTime, // New field
    this.birthday, // New field
    this.sure, // New field
  });

  static Person fromDataSnapshot(DocumentSnapshot snapshot) {
    var dataSnapshot = snapshot.data() as Map<String, dynamic>;
    return Person(
      uid: dataSnapshot["uid"],
      name: dataSnapshot["name"],
      email: dataSnapshot["email"],
      password: dataSnapshot["password"],
      imageProfile: dataSnapshot["imageProfile"],
      photoNo: dataSnapshot["photoNo"],
      publishedDateTime: dataSnapshot["publishedDateTime"],
      interests: List<String>.from(dataSnapshot["interests"] ?? []),
      imageUrls: List<String>.from(dataSnapshot["imageUrls"] ?? []),
      sex: dataSnapshot["sex"],
      bdTime: dataSnapshot["bdTime"], // New field
      birthday: dataSnapshot["birthday"], // New field
      sure: dataSnapshot["sure"], // New field
    );
  }

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "imageProfile": imageProfile,
        "email": email,
        "password": password,
        "name": name,
        "photoNo": photoNo,
        "publishedDateTime": publishedDateTime,
        "interests": interests,
        "imageUrls": imageUrls,
        "sex": sex,
        "bdTime": bdTime, // New field
        "birthday": birthday, // New field
        "sure": sure, // New field
      };

  // Convert a map to a Person object
  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      uid: json["uid"],
      name: json["name"],
      email: json["email"],
      password: json["password"],
      imageProfile: json["imageProfile"],
      photoNo: json["photoNo"],
      publishedDateTime: json["publishedDateTime"],
      interests: List<String>.from(json["interests"] ?? []),
      imageUrls: List<String>.from(json["imageUrls"] ?? []),
      sex: json["sex"],
      bdTime: json["bdTime"], // New field
      birthday: json["birthday"], // New field
      sure: json["sure"], // New field
    );
  }
}
