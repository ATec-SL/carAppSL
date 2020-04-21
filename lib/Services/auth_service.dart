import 'package:carappsl/Screens/feed_screen.dart';
import 'package:carappsl/Screens/login_screen.dart';
import 'package:carappsl/models/user_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class AuthService {
  static final _auth = FirebaseAuth.instance;
  static final _firestore = Firestore.instance;
  static String logingError = 'aa';

  static void signUpUser(
      BuildContext context,
      String name,
      String email,
      String password,
      String contactNo,
      String VRegistrationNo,
      String BrandModel,
      String Year,
      String fueltt,
      String tranmissiont,
      String currentBrand,
      String currentModel) async {
    try {
      AuthResult authResult = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      FirebaseUser signedInUser = authResult.user;
      if (signedInUser != null) {
        _firestore.collection('/users').document(signedInUser.uid).setData({
          'name': name,
          'email': email,
          'contactNo': contactNo,
          'vehiceRegNo': VRegistrationNo,
          'brandModel': BrandModel,
          'year': Year,
          'profileImageUrl': '',
          'fuelType': fueltt,
          'transmission': tranmissiont,
          'carBrand': currentBrand,
          'model': currentModel
        });

        Provider.of<userData>(context).currentUserId = signedInUser.uid;
        Navigator.pop(context);
      }
    } catch (e) {
      print(e);
    }
  }

  static void logout() async {
    _auth.signOut();
  }

  static void login(String name, String password) async {
    String uEmail = 'temp@gmail.com';

    final QuerySnapshot snapshot =
        await Firestore.instance.collection('users').getDocuments();

    List<DocumentSnapshot> list = List<DocumentSnapshot>();

    for (int i = 0; i < snapshot.documents.length; i++) {
      if (snapshot.documents[i].data['name'] == name) {
        uEmail = snapshot.documents[i].data['email'];
      }
    }

    try {
      await _auth.signInWithEmailAndPassword(email: uEmail, password: password);
    } catch (e) {
      print(e);
      logingError = 'Enter valid details';
    }
  }
}
