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
  List<String>? occupation;
  List<String>? mbti;
  List<String>? language;
  List<String>? religion;
  List<String>? education;
  List<String>? bloodtype;
  List<String>? lookingfor;
  List<String>? exercise;
  List<String>? diet;

  Person(
      {this.uid,
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
      this.occupation,
      this.mbti,
      this.language,
      this.religion,
      this.education,
      this.bloodtype,
      this.lookingfor,
      this.exercise,
      this.diet});

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
      occupation: dataSnapshot["occupation"],
      mbti: dataSnapshot["mbti"],
      language: dataSnapshot["language"],
      religion: dataSnapshot["religion"],
      education: dataSnapshot["education"],
      bloodtype: dataSnapshot["bloodtype"],
      lookingfor: dataSnapshot["lookingfor"],
      exercise: dataSnapshot["exercise"],
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
        "occupation": occupation,
        "mbti": mbti,
        "language": language,
        "religion": religion,
        "education": education,
        "bloodtype": bloodtype,
        "lookingfor": lookingfor,
        "exercise": exercise,
        "diet": diet,
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
        occupation: json["occupation"],
        mbti: json["mbti"],
        language: json["language"],
        religion: json["religion"],
        education: json["education"],
        bloodtype: json["bloodtype"],
        lookingfor: json["lookingfor"],
        exercise: json["exercise"],
        diet: json["diet"]);
  }
}
