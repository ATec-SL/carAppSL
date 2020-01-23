import 'package:carappsl/Screens/feed_screen.dart';
import 'package:carappsl/Screens/home_screen.dart';
import 'package:carappsl/Screens/login_screen.dart';
import 'package:carappsl/Screens/signup_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  Widget _getScreenId() {

    return StreamBuilder<FirebaseUser>(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData){
          return HomeScreeen(userId: snapshot.data.uid);
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

      theme: ThemeData(primaryIconTheme: Theme.of(context).primaryIconTheme.copyWith(
        color: Colors.black,
      )),

      home: _getScreenId(), //Navigator
      routes: {
        LoginScreen.id: (context) => LoginScreen(),
        SignupScreen.id: (context) => SignupScreen(),
        FeedScreen.id: (context) => FeedScreen()
      },
    );
  }
}
