import 'package:carappsl/models/user_model.dart';
import 'package:carappsl/utilties/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DatabaseService {
  static void updateUser(User user){
    usersRef.document(user.id).updateData({
      'name': user.name,
      'profileImageUrl': user.profileImageUrl,
      'bio': user.bio,

    });
  }
  
  
  static Future<QuerySnapshot> searchUser (String name) {
    Future<QuerySnapshot> users = usersRef.where('name', isGreaterThanOrEqualTo: name).getDocuments();
    return users;
  }
}