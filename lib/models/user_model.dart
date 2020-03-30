import 'package:cloud_firestore/cloud_firestore.dart';

class User{
   String id;
   String name;
   String profileImageUrl;
   String email;
   String bio, brandModel,vehiceRegNo, year, transmission, fuelType;

  User({
    this.id,
    this.name,
    this.profileImageUrl,
    this.email,
    this.bio,
    this.brandModel,
    this.vehiceRegNo,
    this.year,
    this.transmission,
    this.fuelType,
  });

  factory User.fromDoc(DocumentSnapshot doc){

    return User(
      id: doc.documentID,
      name: doc['name'],
      profileImageUrl: doc['profileImageUrl'],
      email: doc['email'],
      bio: doc['bio'] ?? '', //return empty string
      brandModel: doc['brandModel'],
      vehiceRegNo: doc['vehiceRegNo'],
      year: doc['year'],
      transmission: doc['transmission'],
      fuelType: doc['fuelType'],


    );
  }

}