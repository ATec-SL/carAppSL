import 'package:carappsl/Screens/feed_screen.dart';
import 'package:carappsl/Screens/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class AuthService{

  static final _auth = FirebaseAuth.instance;
  static final _firestore = Firestore.instance;


  static void signUpUser( BuildContext context, String name, String email, String password,String contactNo, String VRegistrationNo,  String BrandModel, String Year) async{

    try{
      AuthResult authResult = await _auth.createUserWithEmailAndPassword(
          email: email, password: password
      );

      FirebaseUser signedInUser = authResult.user;
      if(signedInUser != null) {
        _firestore.collection('/users').document(signedInUser.uid).setData({
          'name': name,
          'email': email,
          'contactNo': contactNo,
          'vehiceRegNo': VRegistrationNo,
          'brandModel': BrandModel,
          'year': Year,
          'profileImageUrl': '',

        });

        Navigator.pop(context);
      }
    }
    catch(e) {
      print(e);
    }
  }

  static void logout() async{
    _auth.signOut();
  }

  static void login(String email, String password) async {

    try{
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    }
    catch (e){
      print(e);
    }
  }
}