import 'package:cloud_firestore/cloud_firestore.dart';

class Person {
  String? uid;

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
  String? age;
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

  @override
  String toString() {
    return 'Person(uid: $uid, name: $name, email: $email,  interests: ${interests?.join(", ")}, imageUrls: ${imageUrls?.join(", ")}, sex: $sex)';
  }

  // static Person fromDataSnapshot(DocumentSnapshot snapshot) {
  //   var dataSnapshot = snapshot.data() as Map<String, dynamic>;
  //   return Person(
  //     uid: dataSnapshot["uid"],
  //     name: dataSnapshot["name"],
  //     email: dataSnapshot["email"],
  //     password: dataSnapshot["password"],
  //     imageProfile: dataSnapshot["imageProfile"],
  //     photoNo: dataSnapshot["photoNo"],
  //     publishedDateTime: dataSnapshot["publishedDateTime"],
  //     interests: List<String>.from(dataSnapshot["interests"] ?? []),
  //     imageUrls: List<String>.from(dataSnapshot["imageUrls"] ?? []),
  //     sex: dataSnapshot["sex"],
  //     bdTime: dataSnapshot["bdTime"],
  //     birthday: dataSnapshot["birthday"],
  //     sure: dataSnapshot["sure"],
  //     age: dataSnapshot["age"],
  //     occupation: dataSnapshot["occupation"],
  //     mbti: dataSnapshot["mbti"],
  //     language: dataSnapshot["language"],
  //     religion: dataSnapshot["religion"],
  //     education: dataSnapshot["education"],
  //     bloodtype: dataSnapshot["bloodtype"],
  //     lookingfor: dataSnapshot["lookingfor"],
  //     exercise: dataSnapshot["exercise"],
  //   );
  // }
  static Person fromDataSnapshot(DocumentSnapshot snapshot) {
    var dataSnapshot = snapshot.data() as Map<String, dynamic>;

    return Person(
      uid: dataSnapshot["uid"] as String?,
      name: dataSnapshot["name"] as String?,
      email: dataSnapshot["email"] as String?,
      password: dataSnapshot["password"] as String?,
      photoNo: dataSnapshot["photoNo"] as String?,
      publishedDateTime: dataSnapshot["publishedDateTime"] as int?,
      interests: dataSnapshot["interests"] != null
          ? List<String>.from(dataSnapshot["interests"] as List)
          : [],
      imageUrls: dataSnapshot["imageUrls"] != null
          ? List<String>.from(dataSnapshot["imageUrls"] as List)
          : [],
      sex: dataSnapshot["sex"] as String?,
      bdTime: dataSnapshot["bdTime"] as String?,
      birthday: dataSnapshot["birthday"] as String?,
      sure: dataSnapshot["sure"] as String?,
      age: dataSnapshot["age"] as String?,
      occupation: dataSnapshot["occupation"] != null
          ? List<String>.from(dataSnapshot["occupation"] as List)
          : [],
      mbti: dataSnapshot["mbti"] != null
          ? List<String>.from(dataSnapshot["mbti"] as List)
          : [],
      language: dataSnapshot["language"] != null
          ? List<String>.from(dataSnapshot["language"] as List)
          : [],
      religion: dataSnapshot["religion"] != null
          ? List<String>.from(dataSnapshot["religion"] as List)
          : [],
      education: dataSnapshot["education"] != null
          ? List<String>.from(dataSnapshot["education"] as List)
          : [],
      bloodtype: dataSnapshot["bloodtype"] != null
          ? List<String>.from(dataSnapshot["bloodtype"] as List)
          : [],
      lookingfor: dataSnapshot["lookingfor"] != null
          ? List<String>.from(dataSnapshot["lookingfor"] as List)
          : [],
      exercise: dataSnapshot["exercise"] != null
          ? List<String>.from(dataSnapshot["exercise"] as List)
          : [],
      diet: dataSnapshot["diet"] != null
          ? List<String>.from(dataSnapshot["diet"] as List)
          : [],
    );
  }

  Map<String, dynamic> toJson() => {
        "uid": uid,
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
  // factory Person.fromJson(Map<String, dynamic> json) {
  //   return Person(
  //       uid: json["uid"],
  //       name: json["name"],
  //       email: json["email"],
  //       password: json["password"],
  //       photoNo: json["photoNo"],
  //       publishedDateTime: json["publishedDateTime"],
  //       interests: List<String>.from(json["interests"] ?? []),
  //       imageUrls: List<String>.from(json["imageUrls"] ?? []),
  //       sex: json["sex"],
  //       bdTime: json["bdTime"],
  //       birthday: json["birthday"],
  //       sure: json["sure"],
  //       age: json["age"],
  //       occupation: json["occupation"],
  //       mbti: json["mbti"],
  //       language: json["language"],
  //       religion: json["religion"],
  //       education: json["education"],
  //       bloodtype: json["bloodtype"],
  //       lookingfor: json["lookingfor"],
  //       exercise: json["exercise"],
  //       diet: json["diet"]);
  // }

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      uid: json["uid"] as String?,
      name: json["name"] as String?,
      email: json["email"] as String?,
      password: json["password"] as String?,
      photoNo: json["photoNo"] as String?,
      publishedDateTime: json["publishedDateTime"] as int?,
      // Check for the presence of interests and cast it as List<String> if valid
      interests: json["interests"] != null
          ? List<String>.from(json["interests"] as List)
          : [],
      // Check for the presence of imageUrls and cast it as List<String> if valid
      imageUrls: json["imageUrls"] != null
          ? List<String>.from(json["imageUrls"] as List)
          : [],
      sex: json["sex"] as String?,
      bdTime: json["bdTime"] as String?,
      birthday: json["birthday"] as String?,
      sure: json["sure"] as String?,
      age: json["age"] as String?,
      occupation: json["occupation"] != null
          ? List<String>.from(json["occupation"] as List)
          : [],
      mbti: json["mbti"] != null ? List<String>.from(json["mbti"] as List) : [],
      language: json["language"] != null
          ? List<String>.from(json["language"] as List)
          : [],
      religion: json["religion"] != null
          ? List<String>.from(json["religion"] as List)
          : [],
      education: json["education"] != null
          ? List<String>.from(json["education"] as List)
          : [],
      bloodtype: json["bloodtype"] != null
          ? List<String>.from(json["bloodtype"] as List)
          : [],
      lookingfor: json["lookingfor"] != null
          ? List<String>.from(json["lookingfor"] as List)
          : [],
      exercise: json["exercise"] != null
          ? List<String>.from(json["exercise"] as List)
          : [],
      diet: json["diet"] != null ? List<String>.from(json["diet"] as List) : [],
    );
  }
}
