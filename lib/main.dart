import 'package:carappsl/Screens/feed_screen.dart';
import 'package:carappsl/Screens/login_screen.dart';
import 'package:carappsl/Screens/signup_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  Widget _getScreenId() {

    return StreamBuilder<FirebaseUser>(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData){
          return FeedScreen();
        }
        else{
          return LoginScreen();
        }
      },
    );

  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ZoneGaram',
      debugShowCheckedModeBanner: false,


      home: _getScreenId(),  //Navigator

      routes: {
        LoginScreen.id: (context) => LoginScreen(),
        SignupScreen.id: (context) => SignupScreen(),
        FeedScreen.id: (context) => FeedScreen()
      },
    );
  }
}
