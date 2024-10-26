import 'package:cloud_firestore/cloud_firestore.dart';

class Person {
  String? uid;
  String? imageProfile;
  String? email;
  String? password;
  String? name;
  String? age;
  String? photoNo;
  String? city;
  String? country;
  String? profileHeading;
  String? lookingforInaPartner;

  int? publishedDateTime;

  // appearance
  String? height;
  String?
      weight; // Changed from "Weight" to "weight" to follow camelCase convention
  String? bodyType;
  String? drink;
  String? smoke;
  String?
      maritalStatus; // Corrected spelling from "martialStatus" to "maritalStatus"
  String? haveChildren;
  String? noChildren;
  String? profession;
  String? employmentStatus;
  String? income;
  String? livingSituation;
  String? willingtoRelocate;
  String? relationshipYouAreLookingFor;

  // background
  String? nationality;
  String? education;
  String? language;
  String? religion;
  String? ethnicity;

  Person({
    this.uid,
    this.imageProfile,
    this.email,
    this.password,
    this.name,
    this.age,
    this.photoNo,
    this.city,
    this.country,
    this.profileHeading,
    this.lookingforInaPartner,
    this.publishedDateTime,
    this.height,
    this.weight, // Corrected here too
    this.bodyType,
    this.drink,
    this.smoke,
    this.maritalStatus, // Corrected spelling here
    this.haveChildren,
    this.noChildren,
    this.profession,
    this.employmentStatus,
    this.income,
    this.livingSituation,
    this.willingtoRelocate,
    this.relationshipYouAreLookingFor,
    this.nationality,
    this.education,
    this.language,
    this.religion,
    this.ethnicity,
  });

  static Person fromDataSnapshot(DocumentSnapshot snapshot) {
    var dataSnapshot = snapshot.data() as Map<String, dynamic>;
    return Person(
      uid: dataSnapshot["uid"],
      name: dataSnapshot["name"],
      email: dataSnapshot["email"],
      password: dataSnapshot["password"],
      imageProfile: dataSnapshot["imageProfile"],
      age: dataSnapshot["age"],
      photoNo: dataSnapshot["photoNo"],
      city: dataSnapshot["city"],
      country: dataSnapshot["country"],
      profileHeading: dataSnapshot["profileHeading"],
      lookingforInaPartner: dataSnapshot["lookingforInaPartner"],
      publishedDateTime: dataSnapshot["publishedDateTime"],
      height: dataSnapshot["height"],
      weight: dataSnapshot["weight"], // Corrected spelling
      bodyType: dataSnapshot["bodyType"],
      drink: dataSnapshot["drink"],
      smoke: dataSnapshot["smoke"],
      maritalStatus: dataSnapshot["maritalStatus"], // Corrected spelling
      haveChildren: dataSnapshot["haveChildren"],
      noChildren: dataSnapshot["noChildren"],
      profession: dataSnapshot["profession"],
      employmentStatus: dataSnapshot["employmentStatus"],
      income: dataSnapshot["income"],
      livingSituation: dataSnapshot["livingSituation"],
      willingtoRelocate: dataSnapshot["willingtoRelocate"],
      relationshipYouAreLookingFor:
          dataSnapshot["relationshipYouAreLookingFor"],
      nationality: dataSnapshot["nationality"],
      education: dataSnapshot["education"],
      language: dataSnapshot["language"],
      religion: dataSnapshot["religion"],
      ethnicity: dataSnapshot["ethnicity"],
    );
  }

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "imageProfile": imageProfile,
        "email": email,
        "password": password,
        "name": name,
        "age": age,
        "photoNo": photoNo,
        "city": city,
        "country": country,
        "profileHeading": profileHeading,
        "lookingforInaPartner": lookingforInaPartner,
        "publishedDateTime": publishedDateTime,
        "height": height,
        "weight": weight, // Corrected spelling
        "bodyType": bodyType,
        "drink": drink,
        "smoke": smoke,
        "maritalStatus": maritalStatus, // Corrected spelling
        "haveChildren": haveChildren,
        "noChildren": noChildren,
        "profession": profession,
        "employmentStatus": employmentStatus,
        "income": income,
        "livingSituation": livingSituation,
        "willingtoRelocate": willingtoRelocate,
        "relationshipYouAreLookingFor": relationshipYouAreLookingFor,
        "nationality": nationality,
        "education": education,
        "language": language,
        "religion": religion,
        "ethnicity": ethnicity,
      };
}
