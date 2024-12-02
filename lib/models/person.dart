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
  int? age;

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
    this.bdTime,
    this.birthday,
    this.sure,
    this.age,
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
      bdTime: dataSnapshot["bdTime"],
      birthday: dataSnapshot["birthday"],
      sure: dataSnapshot["sure"],
      age: dataSnapshot["age"],
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
        "bdTime": bdTime,
        "birthday": birthday,
        "sure": sure,
        "age": age,
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
      bdTime: json["bdTime"],
      birthday: json["birthday"],
      sure: json["sure"],
      age: json["age"],
    );
  }
}
